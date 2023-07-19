# Build4D

Welcome to Build4D! This 4D project allows you to compile, build and sign:
* compiled projects
* components
* standalone applications
* server applications (planned)
* client applications (planned)


## Description

Several classes are available. For more details, please refer to the class documentation:
* [CompiledProject](./Build4D/Documentation/Classes/CompiledProject.md)
* [Component](./Build4D/Documentation/Classes/Component.md)
* [Standalone](./Build4D/Documentation/Classes/Standalone.md)
* [_core](./Build4D/Documentation/Classes/_core.md)

## Installation

* Create a “Components” folder in your projet.

* If you want to use an interpreted component: 
  * copy the “Build4D” folder in the “Components” folder of your project, 
  * add the “.4dbase” extension to the “Build4D” folder.

* If you want to use a compiled component:
  * open the “Build4D” project, 
  * execute the “buildComponent” method,
  * copy the “Build4D_UnitTests/Components/Build4D.4dbase“ folder in the “Components” folder of your project.


For more details about components, please read the official 4D documentation:
* [Components](https://developer.4d.com/docs/Concepts/components/)
* [Developing components](https://developer.4d.com/docs/Extensions/develop-components)
* [Build components](https://developer.4d.com/docs/Desktop/building#build-component)
