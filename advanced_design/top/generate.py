import os
from jinja2 import Environment, FileSystemLoader

# 参数定义
params = {
    "WIDTH": 15,
    "FL": 2,
    "BL": 2,
    "ROW": 4,
    "COL": 4,
    "X_HOP_LOC": 4,
    "Y_HOP_LOC": 7
}

# 设置模板环境
template_dir = "templates"
output_dir = "output"
template_file = "mesh.sv"
output_file = f"mesh_{params['ROW']}x{params['COL']}.sv"

# 初始化模板引擎
env = Environment(loader=FileSystemLoader(template_dir), trim_blocks=True, lstrip_blocks=True)
template = env.get_template(template_file)

# 渲染模板
rendered_code = template.render(**params)

# 输出文件
os.makedirs(output_dir, exist_ok=True)
with open(os.path.join(output_dir, output_file), "w") as f:
    f.write(rendered_code)

print(f"✅ Verilog file generated: {os.path.join(output_dir, output_file)}")
