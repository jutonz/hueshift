require "json"

module Hueshift
  class Api < Grape::API
    format :json

    helpers do
      def serialize(light)
        {
          id: light.id,
          name: light.name,
          is_on: light.on?,
          hue: light.hue,
          saturation: light.saturation,
          brightness: light.brightness
        }
      end
    end

    before do
      @@client ||= Hue::Client.new
      @client ||= @@client
    end

    resource :lights do
      # GET /lights
      get do
        @client.lights.map { |l| serialize(l) }
      end

      route_param :id do

        before do
          @light = @client.lights.find { |l| l.id == params[:id] }
          error!({ error: true, messages: ["Light not found"] }, 404) unless @light
        end

        # GET /lights/:id
        get do
          serialize @light
        end

        # PUT /lights/:id
        params do
          optional :on, {
            type: Boolean,
            default: true,
            desc: "Whether the light is on or off"
          }
          optional :hue, {
            type: Integer,
            values: {
              value: Hue::Light::HUE_RANGE,
              message: "must be in range #{Hue::Light::HUE_RANGE}" 
            }
          }
          optional :saturation, {
            type: Integer,
            values: {
              value: Hue::Light::SATURATION_RANGE,
              message: "must be in range #{Hue::Light::SATURATION_RANGE}"
            }
          }
          optional :brightness, {
            type: Integer,
            values: {
              value: Hue::Light::BRIGHTNESS_RANGE,
              message: "must be in range #{Hue::Light::BRIGHTNESS_RANGE}"
            }
          }
          optional :color_temperature, {
            type: Integer,
            values: {
              value: Hue::Light::COLOR_TEMPERATURE_RANGE,
              message: "must be in range #{Hue::Light::COLOR_TEMPERATURE_RANGE}"
            }
          }
        end
        put do
          light_params = declared params, include_missing: false

          light_params.delete(:on) ? @light.on! : @light.off!

          light_params.each do |param_name, param_value|
            @light.send "#{param_name}=", param_value
          end

          serialize @light
        end
      end # route_param :id
    end # resource :lights
  end
end
