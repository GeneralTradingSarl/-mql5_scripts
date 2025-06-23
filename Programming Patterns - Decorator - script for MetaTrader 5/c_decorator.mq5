//+------------------------------------------------------------------+
//| PROGRAMMING PATTERNS                                             |
//|                                                                  |
//| DECORATOR                                                        |
//| A way of sub-classing more functional objects, dynamically.      |
//|                                                                  |
//| RULE                                                             |
//| Open classes for extension and close for changes.                |
//|                                                                  |
//| Inheritance is not always flexible.                              |
//| Composition and delegation is sometimes a good alternative to    |
//|  dynamically add new behavior.                                   |
//| Decorators extend component functionality without changing the   |
//|  existing code.                                                  |
//| Decorator type matches that of the component.                    |
//| Decorators change component behavior.                            |
//| A component may have arbitrary number of decorators.             |
//| Decorators are transparent to the client, unless the client      |
//|  depends on a particular component.                              |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| ABSTRACT COMPONENT (INTERFACE)                                   |
//+------------------------------------------------------------------+
class A_Component
  {
public:
                     A_Component() : m_name("Unknown") {}
   virtual string    Name() { return m_name; }
   virtual double    Mass()=0;

protected:
   string            m_name;
  };
//+------------------------------------------------------------------+
//| ABSTRACT COMPONENT DECORATOR (INTERFACE)                         |
//+------------------------------------------------------------------+
class A_Decorator : public A_Component
  {
public:
                    ~A_Decorator()
     {
      if(CheckPointer(m_component)==POINTER_DYNAMIC) delete m_component;
     }
   virtual string    Name()=0;

protected:
   A_Component      *m_component;
  };
//+------------------------------------------------------------------+
//| REAL COMPONENTS:                                                 |
//| A                                                                |
//+------------------------------------------------------------------+
class C_ComponentA : public A_Component
  {
public:
                     C_ComponentA() { m_name="Component A"; }
   double Mass() { return 1.39; }
  };
//+------------------------------------------------------------------+
//| B                                                                |
//+------------------------------------------------------------------+
class C_ComponentB : public A_Component
  {
public:
                     C_ComponentB() { m_name="Component B"; }
   double Mass() { return 1.51; }
  };
//+------------------------------------------------------------------+
//| C                                                                |
//+------------------------------------------------------------------+
class C_ComponentC : public A_Component
  {
public:
                     C_ComponentC() { m_name="Component C"; }
   double Mass() { return 1.63; }
  };
//+------------------------------------------------------------------+
//| REAL DECORATORS:                                                 |
//| A                                                                |
//+------------------------------------------------------------------+
class C_DecoratorA : public A_Decorator
  {
public:
                     C_DecoratorA(A_Component *component) { m_component=component; }
   string Name() { return m_component.Name() + " + Decorator A"; }
   double Mass() { return .07 + m_component.Mass(); }
  };
//+------------------------------------------------------------------+
//| B                                                                |
//+------------------------------------------------------------------+
class C_DecoratorB : public A_Decorator
  {
public:
                     C_DecoratorB(A_Component *component) { m_component=component; }
   string Name() { return m_component.Name() + " + Decorator B"; }
   double Mass() { return .11 + m_component.Mass(); }
  };
//+------------------------------------------------------------------+
//| C                                                                |
//+------------------------------------------------------------------+
class C_DecoratorC : public A_Decorator
  {
public:
                     C_DecoratorC(A_Component *component) { m_component=component; }
   string Name() { return m_component.Name() + " + Decorator C"; }
   double Mass() { return .13 + m_component.Mass(); }
  };
//+------------------------------------------------------------------+
//| CLIENT                                                           |
//+------------------------------------------------------------------+
void OnStart()
  {
   A_Component *component_a=new C_ComponentA;
   PrintFormat("%s = %g kg",component_a.Name(),component_a.Mass());
//---
   A_Component *component_b=new C_ComponentB;
   component_b             =new C_DecoratorA(component_b);
   component_b             =new C_DecoratorA(component_b);
   PrintFormat("%s = %g kg",component_b.Name(),component_b.Mass());
//---
   A_Component *component_c=new C_ComponentC;
   component_c             =new C_DecoratorA(component_c);
   component_c             =new C_DecoratorB(component_c);
   component_c             =new C_DecoratorC(component_c);
   PrintFormat("%s = %g kg",component_c.Name(),component_c.Mass());
//---
   delete component_a;
   delete component_b;
   delete component_c;
  }
//+------------------------------------------------------------------+
//| OUTPUT:                                                          |
//| Component A = 1.39 kg                                            |
//| Component B + Decorator A + Decorator A = 1.65 kg                |
//| Component C + Decorator A + Decorator B + Decorator C = 1.94 kg  |
//+------------------------------------------------------------------+
