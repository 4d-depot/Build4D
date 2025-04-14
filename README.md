
# Build4D

Welcome to Build4D! This 4D project allows you to compile, build, and sign:
* compiled projects
* components
* standalone applications
* server applications
* client applications

For more details, read this series of blog posts:
* https://blog.4d.com/build-your-compiled-structure-or-component-with-build4d/
* https://blog.4d.com/create-a-standalone-application-with-the-build4d-component/
* https://blog.4d.com/create-a-client-server-application-with-build4d-tool/

## Description

Several classes are available. For more details, please refer to the class documentation:
* [CompiledProject](./Build4D/Documentation/Classes/CompiledProject.md)
* [Component](./Build4D/Documentation/Classes/Component.md)
* [Standalone](./Build4D/Documentation/Classes/Standalone.md)
* [Server](./Build4D/Documentation/Classes/Server.md)
* [Client](./Build4D/Documentation/Classes/Client.md)


## Installation

* Create a “Components” folder in your project.

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
