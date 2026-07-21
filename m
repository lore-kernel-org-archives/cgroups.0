Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187F525B0B5;
	Tue, 21 Jul 2026 06:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784613761; cv=none; b=B5sXe4ztF3/ussCIM0UouIGwCPFrZx3VjxmOSoGJr2CJeuy5hE9Z0K5XZtoQb2r0YiFoXSBW5xfm0p/JYEmhH21wZt0ZCKL293MqBIBW/SSkszP4/5KvUyt8CurTbPbEbv0Dw9CCdjre+JtsOvd5GpJpqScuagH+DE72GhePR0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784613761; c=relaxed/simple;
	bh=RLbT5goX1y5STYArX4GWOJyoBMEyMKHl4AnYityumOc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I2VkoF/CwkN132ngxlip07kFyp/yzqYDuP2IZ0Xin26VBocKHi+XWxLFkiHyGhyw9bFQg4wv9Vd05kDj45/CY/FlJH4Ch0RinGRINHhfWnLxT7FZHkoQKJpbEMCpcXLFk+7Ha/xFweZL8xvDzUDc8xSwSWDfSFTT/ntuxk8s7q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ngrGxcDE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ngrGxcDE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CD51F000E9;
	Tue, 21 Jul 2026 06:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784613759;
	bh=kKkyegtZ304R/489xlRr5sH+Tyjz2ix8bm7f3RxMqJA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ngrGxcDEWmEPJC38OogpEeDM5ZcSy3kpbV/3+jpc20LHmFeBsssiuJOTK4Gvh1Is2
	 X9JR1JO6le4pUSGQXyyO2a7n+rwdoW5Vf4OfrrpMLK+Ix1WXPp1NlT76zQiW3jWRr4
	 5JB5xhmtU2txrqkvdCPPQIXTbE2xsINojTc5Hn//Fp8VeS4m18TjWcQ4NKjvkLyD2I
	 tY+QuxZY/mvkirqrs3vByaOQ2IFCOl+az+8RatTTf21fkkz2VjZ5Q7kk4FyUzeyklK
	 /zxAAScY84BY+aU2+4hrINVxEUnd/vuylmZg4MilqS+ZS8Xm3DflwQxji1KCS+th8m
	 orZsxscdWE47w==
Message-ID: <c6c64baa-9752-44c8-993b-20c9f9efe6fe@kernel.org>
Date: Tue, 21 Jul 2026 15:02:31 +0900
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/13] mm/slab: make slab_obj_ext() determine object
 index
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-5-2fa7c6f60dbe@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-5-2fa7c6f60dbe@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------KASFJLXWn905HKRADjHgEPsb"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------KASFJLXWn905HKRADjHgEPsb
Content-Type: multipart/mixed; boundary="------------njQytaQwmIPUB4zfsP886UIB";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Message-ID: <c6c64baa-9752-44c8-993b-20c9f9efe6fe@kernel.org>
Subject: Re: [PATCH v2 05/13] mm/slab: make slab_obj_ext() determine object
 index
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-5-2fa7c6f60dbe@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-5-2fa7c6f60dbe@kernel.org>

--------------njQytaQwmIPUB4zfsP886UIB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


On 7/20/26 11:16 PM, Vlastimil Babka (SUSE) wrote:
> All callers perform the same obj_to_index() calculation to pass the
> index. Simplify by passing object pointer instead and determining the
> index by slab_obj_ext().

Nice!

> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

with a nit on typo below

>  mm/memcontrol.c | 12 +++---------
>  mm/slab.h       | 19 +++++++++++--------
>  mm/slub.c       | 22 +++++++---------------
>  3 files changed, 21 insertions(+), 32 deletions(-)
> diff --git a/mm/slab.h b/mm/slab.h
> index 7bd361447c54..64cec02b5016 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -579,7 +579,7 @@ struct slabobj_ext {
>   * obj_exts =3D slab_obj_exts(slab);
>   * if (obj_exts) {
>   *         get_slab_obj_exts(obj_exts);
> - *         obj_ext =3D slab_obj_ext(slab, obj_exts, obj_to_index(s, sl=
ab, obj));
> + *         obj_ext =3D slab_obj_ext(s, slab, obj_exts, obj);
>   *         // do something with obj_ext
>   *         put_slab_obj_exts(obj_exts);
>   * }
> @@ -639,21 +639,24 @@ static inline unsigned int slab_get_stride(struct=
 slab *slab)
>  /*
>   * slab_obj_ext - get the pointer to the slab object extension metadat=
a
>   * associated with an object in a slab.
> + * @s: cache that the slab blongs to

nit: blongs -> belongs

>   * @slab: a pointer to the slab struct
>   * @obj_exts: a pointer to the object extension vector
> - * @index: an index of the object
> + * @obj: a pointer to the object
>   *
>   * Returns a pointer to the object extension associated with the objec=
t.
>   * Must be called within a section covered by get/put_slab_obj_exts().=

>   */
> -static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
> -					       unsigned long obj_exts,
> -					       unsigned int index)




--=20
Cheers,
Harry / Hyeonggon

--------------njQytaQwmIPUB4zfsP886UIB--

--------------KASFJLXWn905HKRADjHgEPsb
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCal8LdwAKCRCGXBN6rc5S
1saKAP0QWmanMNtSWcitc46wO43ObEN6jNyOb66yd+fWn/XwLgEAiqItNg9zJves
jTKoV6pgZPlag6PNzqn5WPPHs+gXrw8=
=GF5b
-----END PGP SIGNATURE-----

--------------KASFJLXWn905HKRADjHgEPsb--
