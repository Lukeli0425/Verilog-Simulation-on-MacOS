echo "开始编译"
iverilog -o Backpack.vvp Backpack_tb.v
echo "编译完成"

echo "生成波形文件"
vvp -n Backpack.vvp

echo "打开波形文件"
gtkwave Backpack.vcd
