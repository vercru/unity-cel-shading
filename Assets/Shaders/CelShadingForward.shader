Shader "Custom/CelShadingForward"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}

	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Cel
		#pragma target 3.0

		half4 LightingCel(SurfaceOutput so, half3 lDir, half attn)
		{
			half nl = dot(so.Normal, lDir);
			nl = clamp(ceil(nl), 0, 1);
			//nl = smoothstep(0, .025f, nl);

			fixed4 c;
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

		void surf (Input IN, inout SurfaceOutput o)
		{
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
