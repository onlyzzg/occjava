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
 */

%module OccJava

%{
#ifndef WNT
//config.h generated by autotools from config.h.in (see an example in Opencascade).
#include "config.h"
#endif
#include <Adaptor3d_Curve.hxx>
#include <TopExp.hxx>
#include <Poly_Triangulation.hxx>
#include <BRep_Builder.hxx>
#include <TopoDS_Builder.hxx>
%}

// Handle enums with int
%javaconst(1);
%include "enumtypeunsafe.swg";

// Handle C arrays as Java arrays
%include "arrays_java.i";
%apply double[] {double *};
%apply double[] {double &};

// load the native library
%pragma(java) jniclasscode=%{
  static
  {
	  System.loadLibrary("OccJava");
  }
%}

%include "Standard.i"
%include "gp.i"
%include "TopAbs.i"
%include "TopoDS.i"
%include "GeomAbs.i"
%include "TopTools.i"
%include "BRep_Tool.i"
%include "GeomLProp_SLProps.i"
%include "BRepTools.i"
%include "BRepBuilderAPI.i"
%include "BRepPrimAPI.i"
%include "BRepAlgoAPI.i"
%include "BRepOffsetAPI_Sewing.i"
%include "Poly.i"
%include "Geom.i"
%include "BRepLib.i"

class TopoDS_Builder
{
	%rename(makeWire) MakeWire;
	%rename(makeCompound) MakeCompound;
	%rename(add) Add;
	%rename(remove) Remove;
	
	TopoDS_Builder()=0;
	public:
	void MakeWire(TopoDS_Wire& W) const;
	void MakeCompound(TopoDS_Compound& C) const;
	void Add(TopoDS_Shape& S,const TopoDS_Shape& C) const;
	void Remove(TopoDS_Shape& S,const TopoDS_Shape& C) const;	
};

class BRep_Builder: public TopoDS_Builder
{
	public:
	BRep_Builder();
};


%typemap(javacode) TopExp
%{
	public static TopoDS_Vertex[] vertices(TopoDS_Edge edge)
	{
		TopoDS_Vertex first=new TopoDS_Vertex();
		TopoDS_Vertex second=new TopoDS_Vertex();
		vertices(edge, first, second);
		return new TopoDS_Vertex[]{first, second};
	}
%}

class TopLoc_Location
{
	%rename(isIdentity) IsIdentity;
	%rename(transformation) Transformation;
	public:
	Standard_Boolean IsIdentity();
	const gp_Trsf& Transformation();
};

class TopExp
{
	public:
	%rename(vertices) Vertices;
	static void Vertices(const TopoDS_Edge& E,TopoDS_Vertex& Vfirst,TopoDS_Vertex& Vlast,const Standard_Boolean CumOri = Standard_False) ;
};

/**
 * TopExp_Explorer
 */
%{#include "TopExp_Explorer.hxx"%}
class TopExp_Explorer
{
	public:
	TopExp_Explorer();
	TopExp_Explorer(const TopoDS_Shape& S,const TopAbs_ShapeEnum ToFind,
		const TopAbs_ShapeEnum ToAvoid = TopAbs_SHAPE);
	%rename(init) Init;
	%rename(more) More;
	%rename(next) Next;
	%rename(current) Current;
	void Init(const TopoDS_Shape& S, const TopAbs_ShapeEnum ToFind, 
		const TopAbs_ShapeEnum ToAvoid = TopAbs_SHAPE) ;
	Standard_Boolean More() const;
	void Next() ;
	const TopoDS_Shape & Current();
};

/**
 * Bnd_Box
 */
%{#include "Bnd_Box.hxx"%}
%typemap(javacode) Bnd_Box
%{
	public double[] get()
	{
		double[] toReturn=new double[6];
		get(toReturn);
		return toReturn;
	}	
%}

class Bnd_Box
{
	public:	
	Bnd_Box();	
};

%extend Bnd_Box
{
	void get(double box[6])
	{
		self->Get(box[0], box[1], box[2], box[3], box[4], box[5]);
	}
};

/**
 * BRepBndLib
 */
%{#include "BRepBndLib.hxx"%}
class BRepBndLib
{
	public:
	%rename(add) Add;
	static void Add(const TopoDS_Shape& S,Bnd_Box& B) ;	
};

/**
 * Adaptor2d_Curve2d
 */
%{#include "Adaptor2d_Curve2d.hxx"%}

class Adaptor2d_Curve2d
{		
	Adaptor2d_Curve2d()=0;
	public:
	%rename(value) Value;
	virtual gp_Pnt2d Value(const Standard_Real U) const;
};

/**
 * Geom2dAdaptor_Curve
 */
%{#include "Geom2dAdaptor_Curve.hxx"%}
class Geom2dAdaptor_Curve: public Adaptor2d_Curve2d
{
	%rename(load) Load;
	public:
	Geom2dAdaptor_Curve();
	Geom2dAdaptor_Curve(const Handle_Geom2d_Curve & C);
	Geom2dAdaptor_Curve(const Handle_Geom2d_Curve & C,const Standard_Real UFirst,const Standard_Real ULast);
	void Load(const Handle_Geom2d_Curve & C) ;
	void Load(const Handle_Geom2d_Curve & C,const Standard_Real UFirst,const Standard_Real ULast) ;
};

/**
 * Adaptor3d_Curve
 */
%{#include "Adaptor3d_Curve.hxx"%}

class Adaptor3d_Curve
{		
	Adaptor3d_Curve()=0;
	public:
	%rename(value) Value;
	const gp_Pnt & Value(const Standard_Real U) const;
};

//extends the Adaptor3d_Curve class to reduce the JNI overhead when
//calling a lot of Adaptor3d_Curve.Value
%extend Adaptor3d_Curve
{
	public:
	void arrayValues(int size, double u[])
	{
		for (int i = 0; i < size; i++)
		{
			gp_Pnt gp=self->Value(u[3*i]);
			u[3*i]   = gp.X();
			u[3*i+1] = gp.Y();
			u[3*i+2] = gp.Z();
		}	
	}
};

/**
 * GeomAdaptor_Curve
 */
%{#include "GeomAdaptor_Curve.hxx"%}

class GeomAdaptor_Curve: public Adaptor3d_Curve
{
	%rename(load) Load;
	public:
	GeomAdaptor_Curve();
	GeomAdaptor_Curve(const Handle_Geom_Curve & C);
	GeomAdaptor_Curve(const Handle_Geom_Curve & C,
		const Standard_Real UFirst,const Standard_Real ULast);
	void Load(const Handle_Geom_Curve & C) ;
	void Load(const Handle_Geom_Curve & C,
		const Standard_Real UFirst,const Standard_Real ULast) ;

};


/**
 * GProp_GProps
 */
 %{#include "GProp_GProps.hxx"%}
 class GProp_GProps
 {
	 public:
	 %rename(mass) Mass;
	 GProp_GProps();
	 Standard_Real Mass() const;
 };
 
/**
 * BRepGProp
 */
%{#include "BRepGProp.hxx"%}
class BRepGProp
{
	public:
	%rename(linearProperties) LinearProperties;
	static void LinearProperties(const TopoDS_Shape& S,GProp_GProps& LProps);
};

/**
 *
 */
%rename(VOID) IFSelect_RetVoid;
%rename(DONE) IFSelect_RetDone;
%rename(ERROR) IFSelect_RetError;
%rename(FAIL) IFSelect_RetFail;
%rename(STOP) IFSelect_RetStop;
enum IFSelect_ReturnStatus {
 IFSelect_RetVoid,
 IFSelect_RetDone,
 IFSelect_RetError,
 IFSelect_RetFail,
 IFSelect_RetStop
};
 
/**
 * XSControl_Reader
 */
 %{
#include <STEPControl_Reader.hxx>
#include <IGESControl_Reader.hxx>
 %}
class XSControl_Reader
{
	XSControl_Reader()=0;
	%rename(readFile) ReadFile;
	%rename(transferRoots) TransferRoots;
	%rename(clearShapes) ClearShapes;
	%rename(nbRootsForTransfer) NbRootsForTransfer;
	%rename(oneShape) OneShape;
	public:
	IFSelect_ReturnStatus ReadFile(const Standard_CString filename);
	Standard_Integer TransferRoots() ;
	void ClearShapes();
	Standard_Integer NbRootsForTransfer();
	TopoDS_Shape OneShape() const;
};

class STEPControl_Reader: public XSControl_Reader
{
	public:
	STEPControl_Reader();
};

class IGESControl_Reader: public XSControl_Reader
{
	public:
	IGESControl_Reader();
};

%{#include <ShapeAnalysis_FreeBounds.hxx>%}
class ShapeAnalysis_FreeBounds
{
	%rename(getClosedWires) GetClosedWires;
	%rename(getOpenWires) GetOpenWires;
	public:
	ShapeAnalysis_FreeBounds(const TopoDS_Shape& shape,
		const Standard_Boolean splitclosed = Standard_False,
		const Standard_Boolean splitopen = Standard_True);
	const TopoDS_Compound& GetClosedWires() const;
	const TopoDS_Compound& GetOpenWires() const;
};

%{#include <GCPnts_UniformDeflection.hxx>%}
class GCPnts_UniformDeflection
{
	%rename(initialize) Initialize;
	%rename(nbPoints) NbPoints;
	%rename(parameter) Parameter;
	public:
	GCPnts_UniformDeflection();
	void Initialize(Adaptor3d_Curve& C,const Standard_Real Deflection,
		const Standard_Real U1,const Standard_Real U2,
		const Standard_Boolean WithControl = Standard_True) ;
	Standard_Integer NbPoints() const;
	Standard_Real Parameter(const Standard_Integer Index) const;
};

%{#include <BRepMesh_IncrementalMesh.hxx>%}
class BRepMesh_IncrementalMesh
{
	%rename(setDeflection) SetDeflection;
	%rename(setAngle) SetAngle;
	%rename(setRatio) SetRatio;
	%rename(update) Update;
	%rename(isModified) IsModified;
	
	public:
	BRepMesh_IncrementalMesh();
	BRepMesh_IncrementalMesh(const TopoDS_Shape& S,const Standard_Real D,
		const Standard_Boolean Relatif = Standard_False,
		const Standard_Real Ang = 0.5);
		
	void SetDeflection(const Standard_Real D) ;
	void SetAngle(const Standard_Real Ang) ;
	void SetRatio(const Standard_Real R) ;
	void Update(const TopoDS_Shape& S) ;
	Standard_Boolean IsModified() const;
};

%{#include <GeomAPI_ProjectPointOnSurf.hxx>%}

%typemap(javacode) GeomAPI_ProjectPointOnSurf
%{
	public void lowerDistanceParameters(double[] uv)
	{
		double[] d2=new double[1];
		lowerDistanceParameters(uv, d2);
		uv[1]=d2[0];
	}
%}

class GeomAPI_ProjectPointOnSurf
{
	%rename(init) Init;
	%rename(nbPoints) NbPoints;
	%rename(lowerDistanceParameters) LowerDistanceParameters;
	%rename(lowerDistance) LowerDistance;
	%rename(point) Point;
	%rename(parameters) Parameters;
	public:
	GeomAPI_ProjectPointOnSurf(const gp_Pnt& P,
		const Handle_Geom_Surface & Surface);
	void Init(const gp_Pnt& P,const Handle_Geom_Surface & surface);
	Standard_Integer NbPoints() const;	
	Quantity_Length LowerDistance() const;
	const gp_Pnt & Point(const Standard_Integer Index) const;	
	void LowerDistanceParameters(Quantity_Parameter& U,Quantity_Parameter& V) const;
	void Parameters(const Standard_Integer Index,Quantity_Parameter& U,Quantity_Parameter& V) const;	
};

/**
 * BRepAlgo
 */
%{#include <BRepAlgo.hxx>%}
class BRepAlgo
{
	%rename(isValid) IsValid;
	%rename(isTopologicallyValid) IsTopologicallyValid;
	public:	
	static Standard_Boolean IsValid(const TopoDS_Shape& S);
	static Standard_Boolean IsTopologicallyValid(const TopoDS_Shape& S);
};
