Shader "Custom/CutCelShadingForward"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Cuts("Cuts", Int) = 3
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf CutCel
		#pragma target 3.0

		int _Cuts;

		half4 LightingCutCel(SurfaceOutput so, half3 lDir, half attn)
		{
			half nl = dot(so.Normal, lDir);
			nl = clamp(ceil(nl * _Cuts) / _Cuts, 0, 1);

			half4 c;
			c.rgb = so.Albedo * _LightColor0.rgb * (nl * attn);
			c.a = so.Alpha;
			return c;
		}

		struct Input
		{
			float2 uv_MainTex;
		};

		sampler2D _MainTex;
		fixed4 _Color;

		void surf(Input IN, inout SurfaceOutput o)
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
