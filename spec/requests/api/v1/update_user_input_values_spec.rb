require "rails_helper"

RSpec.describe "Update User Input Values", type: :request do
  describe "PATCH /api/v1/users/:id" do
    subject { patch("/api/v1/users/#{user_id}", params: payload, as: :json) }
    let(:user_id) { 9998768 }
    let(:payload) { {} }

    context "when user cannot be found" do 
      it 'returns error' do 
        subject

        expect(response.status).to eq(404)
        expect(JSON.parse(response.body)["code"]).to eq("not_found")
      end
    end

    context "when user can be found" do 
      let!(:user) { create(:user) }
      let(:user_id) { user.id } 

      context "when input type is unknown" do 
        let(:payload) { [{type: :unknown, name: :unknown, value: :known}] }

        it "returns correct error code" do 
          subject

          expect(response.status).to eq(400)
          expect(JSON.parse(response.body)["code"]).to eq("user_inputs_unknown_type")  
        end
      end

      context "when input type is number" do
        let(:payload) { [{type: :number, name: name, value: value}] }
        let!(:user_custom_value_input_number) { create(:user_custom_value_inputs_number, user: user, value: 1) } 

        context "when name is unknown" do 
          let(:name) { "unknown" }
          let(:value) { 123 }

          it "returns 404" do 
            subject

            expect(response.status).to eq(404)
            expect(JSON.parse(response.body)["code"]).to eq("not_found")
          end
        end

        context "when name is correct" do 
          let(:name) { user_custom_value_input_number.name }
          
          context "when input is invalid" do
            let(:value) { "string_value" }

            it "returns 422" do 
              subject

              expect(response.status).to eq(422)
            end
          end
  
          context "when input is valid" do 
            let(:value) { 123 }
            
            it "returns 200" do 
              expect { subject }.to change { user_custom_value_input_number.reload.value.to_i }.from(1).to(123)

              expect(response.status).to eq(200)

              parsed_response = JSON.parse(response.body)

              expect(parsed_response["data"]["id"]).to eq(user.id.to_s)
              expect(parsed_response["included"].first["attributes"]).to match({
                "id" => user_custom_value_input_number.id,
                "name" => user_custom_value_input_number.name,
                "value" => value.to_s
              })
              expect(parsed_response["included"].first["type"]).to eq("number")
            end
          end
        end
      end

      context "when input type is string" do 
        let(:payload) { [{type: :string, name: name, value: value}] }
        let!(:user_custom_value_input_string) { create(:user_custom_value_inputs_string, user: user, value: "asd") } 

        context "when name is unknown" do 
          let(:name) { "unknown" }
          let(:value) { 123 }

          it "returns 404" do 
            subject

            expect(response.status).to eq(404)
            expect(JSON.parse(response.body)["code"]).to eq("not_found")
          end
        end

        context "when name is correct" do 
          let(:name) { user_custom_value_input_string.name }

          context "when input is valid" do 
            let(:value) { "qwe" }
            
            it "returns 200" do 
              expect { subject }.to change { user_custom_value_input_string.reload.value }.from("asd").to("qwe")

              expect(response.status).to eq(200)

              parsed_response = JSON.parse(response.body)

              expect(parsed_response["data"]["id"]).to eq(user.id.to_s)
              expect(parsed_response["included"].first["attributes"]).to match({
                "id" => user_custom_value_input_string.id,
                "name" => user_custom_value_input_string.name,
                "value" => value
              })
              expect(parsed_response["included"].first["type"]).to eq("string")
            end
          end
        end
      end

      context "when input type is single" do 
        let(:payload) { [{type: :single, name: name, value: value}] }
        let!(:user_custom_choice_input_single) { create(:user_custom_choice_inputs_single, user: user) } 

        context "when name is unknown" do 
          let(:name) { "unknown" }
          let(:value) { user_custom_choice_input_single.choices.first }

          it "returns 404" do 
            subject

            expect(response.status).to eq(404)
            expect(JSON.parse(response.body)["code"]).to eq("not_found")
          end
        end

        context "when name is correct" do 
          let(:name) { user_custom_choice_input_single.name }

          context "when not in choices" do 
            let(:value) { "not_in_choices" }

            it "returns 422" do 
              subject

              expect(response.status).to eq(422)
              expect(JSON.parse(response.body)["code"]).to eq("invalid_payload")
            end
          end

          context "when array passed" do 
            let(:value) { [user_custom_choice_input_single.choices.last] }

            it "returns 422" do 
              subject

              expect(response.status).to eq(422)
              expect(JSON.parse(response.body)["code"]).to eq("invalid_payload")
            end
          end

          context "when value is correct" do 
            let(:value) { user_custom_choice_input_single.choices.last }

            it "returns 200" do 
              expect { subject }.to change { user_custom_choice_input_single.reload.selected }.to([value])

              expect(response.status).to eq(200)

              parsed_response = JSON.parse(response.body)

              expect(parsed_response["data"]["id"]).to eq(user.id.to_s)
              expect(parsed_response["included"].first["attributes"]).to match({
                "id" => user_custom_choice_input_single.id,
                "name" => user_custom_choice_input_single.name,
                "choices" => user_custom_choice_input_single.choices,
                "selected" => value
              })
              expect(parsed_response["included"].first["type"]).to eq("single")
            end
          end
        end 
      end

      context "when input type is multiple" do 
        let(:payload) { [{type: :multiple, name: name, value: value}] }
        let!(:user_custom_choice_input_multiple) { create(:user_custom_choice_inputs_multiple, user: user) } 

        context "when name is unknown" do 
          let(:name) { "unknown" }
          let(:value) { [user_custom_choice_input_multiple.choices.first] }

          it "returns 404" do 
            subject

            expect(response.status).to eq(404)
            expect(JSON.parse(response.body)["code"]).to eq("not_found")
          end
        end

        context "when name is correct" do 
          let(:name) { user_custom_choice_input_multiple.name }

          context "when not array is passed" do 
            let(:value) { user_custom_choice_input_multiple.choices.first }

            it "returns 422" do 
              subject

              expect(response.status).to eq(422)
              expect(JSON.parse(response.body)["code"]).to eq("invalid_payload")
            end
          end

          context "when a value out of choices is passed" do 
            let(:value) { [user_custom_choice_input_multiple.choices.first, "not_in_choices"] }

            it "returns 422" do 
              subject

              expect(response.status).to eq(422)
              expect(JSON.parse(response.body)["code"]).to eq("invalid_payload")
            end
          end

          context "when value is valid" do 
            let(:value) { [user_custom_choice_input_multiple.choices.first, user_custom_choice_input_multiple.choices.second] }

            it "returns 200" do 
              subject

              expect(response.status).to eq(200)
              parsed_response = JSON.parse(response.body)

              expect(parsed_response["data"]["id"]).to eq(user.id.to_s)
              expect(parsed_response["included"].first["attributes"]).to match({
                "id" => user_custom_choice_input_multiple.id,
                "name" => user_custom_choice_input_multiple.name,
                "choices" => user_custom_choice_input_multiple.choices,
                "selected" => value
              })
              expect(parsed_response["included"].first["type"]).to eq("multiple")
            end
          end
        end
      end
    end
  end
end
