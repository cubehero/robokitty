# Compiles the scad to stl
def compile(filename)
 `cd src; openscad -o ../print/#{filename}.stl #{filename}.scad`
end

task :default => :compile

desc "Compile the coffeecup"
task :compile do
  compile("robokitty")
end

