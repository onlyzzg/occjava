/*
 * Project Info:  http://jcae.sourceforge.net
 * 
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software Foundation, Inc.,
 * 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.
 *
 * (C) Copyright 2005, by EADS CRC
 * (C) Copyright 2009, by EADS France
 */

SWIG_JAVABODY_PROXY(public, public, SWIGTYPE)
SWIG_JAVABODY_TYPEWRAPPER(public, public, public, SWIGTYPE)

%{
#include <TopoDS_CompSolid.hxx>
#include <TopoDS_Solid.hxx>
#include <TopoDS_Shell.hxx>
#include <TopoDS_Compound.hxx>
#include <TopoDS_Wire.hxx>
#include <TopoDS_Iterator.hxx>
#include <TopoDS_Builder.hxx>
%}

/** 
 * TopoDS_Shape
 */
// Ensure that the Java class will always be the good one, so we can use
// instanceof operator.
// Problem: Returning a shape require 2 initialisation (the TopoDS_Shape
// and after the real TopoDS_XXXXX. It may reduce performance comparing
// to libOccJava.

%typemap(out) TopoDS_Shape
{
	if($1.IsNull())
	{
		$result=0L; //NULL
	}
	else
	{
		TopoDS_Shape * tsp=new TopoDS_Shape();
		tsp->TShape($1.TShape());
		tsp->Location($1.Location());
		tsp->Orientation($1.Orientation());
		$result=(jlong)tsp;
	}
}

%typemap(out) const TopoDS_Shape &, const TopoDS_Compound &
{
	if($1->IsNull())
	{
		$result=0L; //NULL
	}
	else
	{
		$1_basetype * tsp=new $1_basetype();
		tsp->TShape($1->TShape());
		tsp->Location($1->Location());
		tsp->Orientation($1->Orientation());
		$result=(jlong)tsp;
	}
}

%typemap(javaout) TopoDS_Shape*, TopoDS_Shape, const TopoDS_Shape&, const TopoDS_Compound &
{
    long cPtr = $jnicall;
    return ($javaclassname)TopoDS_Shape.create(cPtr);
}

%typemap(javacode) TopoDS_Shape
%{
	private long myTShape;
	protected static TopoDS_Shape downcast(TopoDS_Shape in)
	{
		TopoDS_Shape toReturn = create(getCPtr(in));
		in.swigCMemOwn=false;
		return toReturn;
	}

	protected static TopoDS_Shape create(long in)
	{
		if(in==0)
			return null;
		//second argument is not use in swig
		TopAbs_ShapeEnum type = TopAbs_ShapeEnum.swigToEnum(OccJavaJNI.TopoDS_Shape_shapeType(in, null));
		return create(in, type);
	}

	protected static TopoDS_Shape create(long in, TopAbs_ShapeEnum type)
	{
		TopoDS_Shape toReturn=null;
		if(in==0)
			return null;
		switch(type)
		{
			case COMPOUND:
				toReturn=new TopoDS_Compound(in, true);
				break;
			case COMPSOLID:
				toReturn=new TopoDS_CompSolid(in, true);
				break;
			case SOLID:
				toReturn=new TopoDS_Solid(in, true);
				break;
			case SHELL:
				toReturn=new TopoDS_Shell(in, true);
				break;
			case FACE:
				toReturn=new TopoDS_Face(in, true);
				break;
			case WIRE:
				toReturn=new TopoDS_Wire(in, true);
				break;
			case EDGE:
				toReturn=new TopoDS_Edge(in, true);
				break;
			case VERTEX:
				toReturn=new TopoDS_Vertex(in, true);
				break;
		}
		toReturn.myTShape=toReturn.getTShape();
		return toReturn;
    }
    public boolean isSame(TopoDS_Shape s)
    {
        /*if(myTShape==0)
			myTShape=getTShape();
		
		if(s.myTShape==0)
			s.myTShape=s.getTShape();
		
		if(myTShape==s.myTShape)
        {
            return nativeIsSame(s);
        }
        else return false;*/
		return nativeIsSame(s);
    }
	
    /**
     * Alias on the isSame method for an easy use of this class in java
     * collections
     */
    public boolean equals(Object o)
    {
        if (o instanceof TopoDS_Shape)
        {
            return nativeIsEqual((TopoDS_Shape)o);
        }
        else return false;
    }

	public int hashCode()
	{
		return hashCode(Integer.MAX_VALUE);
	}

	protected static TopoDS_Shape[] cArrayWrap(long[] ptrs)
	{
		TopoDS_Shape[] toReturn = new TopoDS_Shape[ptrs.length/2];
		long ptr;
		int type;
		for (int i=0, j=0; i<toReturn.length; i++)
		{  
			ptr = ptrs[j++];
			type = (int)ptrs[j++];
			toReturn[i] = create(ptr, TopAbs_ShapeEnum.swigToEnum(type));
		}
		return toReturn;
	}

	protected static long[] cArrayUnwrap(TopoDS_Shape[] arrayWrapper)
	{
		long[] cArray = new long[arrayWrapper.length];
		for (int i=0; i<arrayWrapper.length; i++)
		cArray[i] = TopoDS_Shape.getCPtr(arrayWrapper[i]);
		return cArray;
	}
%}

// Note that TopoDS_Shape is no longer abstract (it was in libOccJava)
class TopoDS_Shape
{
	public:
	%rename(free) Free;
	%rename(shapeType) ShapeType;
	%rename(nativeIsSame) IsSame;
	%rename(nativeIsEqual) IsEqual;
	%rename(orientation) Orientation;
	%rename(reverse) Reverse;
	%rename(reversed) Reversed;
	%rename(hashCode) HashCode;
	TopAbs_ShapeEnum ShapeType();
	Standard_Boolean IsSame (const TopoDS_Shape& other) const ;
	Standard_Boolean IsPartner (const TopoDS_Shape &other) const ;
	Standard_Boolean IsEqual (const TopoDS_Shape &other) const ;
	const TopLoc_Location& Location () const ;
	void Location (const TopLoc_Location& Loc) ;
	TopAbs_Orientation Orientation() const ;
	void Orientation (const TopAbs_Orientation Orient) ;
	void Reverse() ;
	TopoDS_Shape Reversed() const;
	Standard_Integer HashCode(const Standard_Integer Upper) const;
	Standard_Boolean Free() const;
	void Free(const Standard_Boolean F) ;
	Standard_Boolean Locked () const ;
	void Locked (const Standard_Boolean F);
	Standard_Boolean Modified () const ;
	void Modified (const Standard_Boolean M);
	Standard_Boolean Checked () const ;
	void Checked (const Standard_Boolean C);
	Standard_Boolean Orientable () const ;
	void Orientable (const Standard_Boolean C);
	Standard_Boolean Closed () const ;
	void Closed (const Standard_Boolean C);
	Standard_Boolean Infinite () const ;
	void Infinite (const Standard_Boolean C);
	Standard_Boolean Convex () const ;
	void Convex (const Standard_Boolean C);
	
};

%extend TopoDS_Shape
{
	public:
	//This will be used to speedup the equal operator as in libOccJava
	jlong getTShape()
	{
		return (jlong)&*self->TShape();
	}	
}

class TopoDS_Compound: public TopoDS_Shape
{
};

class TopoDS_CompSolid: public TopoDS_Shape
{
};

class TopoDS_Solid: public TopoDS_Shape
{
};

class TopoDS_Shell: public TopoDS_Shape
{
};

class TopoDS_Face: public TopoDS_Shape
{
};

class TopoDS_Wire: public TopoDS_Shape
{
};

class TopoDS_Edge: public TopoDS_Shape
{
};

class TopoDS_Vertex: public TopoDS_Shape
{
};

class TopoDS_Iterator
{
	%rename(initialize) Initialize;
	%rename(more) More;
	%rename(next) Next;
	%rename(value) Value;
	public:
	TopoDS_Iterator();
	TopoDS_Iterator(const TopoDS_Shape& S,
		const Standard_Boolean cumOri = Standard_True,
		const Standard_Boolean cumLoc = Standard_True);
	void Initialize(const TopoDS_Shape& S,
		const Standard_Boolean cumOri = Standard_True,
		const Standard_Boolean cumLoc = Standard_True) ;
	Standard_Boolean More() const;
	void Next() ;
	const TopoDS_Shape& Value() const;
};

class TopoDS_Builder
{
	%rename(makeWire) MakeWire;
	%rename(makeCompound) MakeCompound;
	%rename(add) Add;
	%rename(remove) Remove;
	
	TopoDS_Builder()=0;
	public:
	void MakeWire(TopoDS_Wire& W) const;
	void MakeShell(TopoDS_Shell& S) const;
	void MakeSolid(TopoDS_Solid& S) const;
	void MakeCompSolid(TopoDS_CompSolid& C) const;
	void MakeCompound(TopoDS_Compound& C) const;
	void Add(TopoDS_Shape& S,const TopoDS_Shape& C) const;
	void Remove(TopoDS_Shape& S,const TopoDS_Shape& C) const;	
};

