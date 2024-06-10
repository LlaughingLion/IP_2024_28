import torch
import torch.onnx
import onnx
from onnx import version_converter, checker


from model import Neural_network

# Create an instance of the model
model = Neural_network()

# Load the trained model
model.load_state_dict(torch.load('Models/10sec.pth'))

# Set the model to evaluation mode
model.eval()

# Create a dummy input
dummy_input = torch.randn(1, 4)

# Export the model to ONNX
torch.onnx.export(model, dummy_input, 'Models/10sec.onnx')

# Convert to IR 7
model = onnx.load("Models/10sec.onnx")

print(model.ir_version)
model.ir_version = 7

target_opset = 14
converted_model = version_converter.convert_version(model, target_opset)

checker.check_model(converted_model)

onnx.save(converted_model, "Models/10sec.onnx")