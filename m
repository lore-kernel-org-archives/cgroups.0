Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC6734CFD3;
	Tue, 21 Jul 2026 05:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784613099; cv=none; b=K/RubXzFrSmeJkXuA0x1r+Hm/4hV0OAhHupNr+jWMaxYAu/HW2jH7ttM+WRHVfguMcg+/e+aG7dn9yY+skV7niwK/WL0To8ealePr9uLjWDnoRzcEGcdGoHhv0n/lCIf6vyKQfD02naO3OjhkpICzQC5f2VUXJwhX0lgPDLBdgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784613099; c=relaxed/simple;
	bh=CtofKgCYb/43FGUhhL4KhfGui54F6jcM8+FbeYi41UY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CucAqRKlm4Bf9W/EuG2SlLCZRRGF+9Cj1TQaUcKErVFtcDmuMGjRt2aqfQGFhXk003sQs9S+PoWIFRuV2NoSRkxEawHecsj/aWcNtIgBRm5PXcOUe97qcg0SvC0K8TLTiPSToEsqc+zN1k7sN0m+UFk3vdT7eMrCGHIT7XDKeK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZFbDSuA3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZFbDSuA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E971F000E9;
	Tue, 21 Jul 2026 05:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784613098;
	bh=DwulcQRBgE2x5+Ge7Rrj6k72618TpplVq03VxdALErs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZFbDSuA3uaYk3uYbZWB+iAEDwQbDjcdPa/SlQkVuZ41E3QHDPUT80k5y3Lqmsu6d/
	 /78ZNYUTTA0fOD3wV8WVbTSjDGMsPEj7h6kOSFv29l3S32Y6VxegVUX9G6Q6FQpIpH
	 0+iNL3Pfh8CuDF5EGoCIBj2DaHMi4VAngQhJIfUkd+ps5WK5Nza+4V0qKPwlnGtTZc
	 vY9mqSk9TooZ4efIgGygHZqgrRhYWWNdFtt4ak2/F8DPBUCNr7V1SLZa4fd/b8otaB
	 3PMJbW4R99lwWbpxx01wOCkiR1ZneY8viBwVy50CuvU3sa00Pcn2RtvpBCD8DCASAz
	 3vN+Gb6SUeXgw==
Message-ID: <d76d5e96-ccf7-44b1-9dc8-3246466f9640@kernel.org>
Date: Tue, 21 Jul 2026 14:51:31 +0900
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/13] mm/slub: skip handle_failed_objexts_alloc() with
 profiling disabled
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-2-2fa7c6f60dbe@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-2-2fa7c6f60dbe@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------ol5zVscvDvmD5WVK7eNs0OQn"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------ol5zVscvDvmD5WVK7eNs0OQn
Content-Type: multipart/mixed; boundary="------------fP0ryuo4CzHsyjK4XS0b9LHe";
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
Message-ID: <d76d5e96-ccf7-44b1-9dc8-3246466f9640@kernel.org>
Subject: Re: [PATCH v2 02/13] mm/slub: skip handle_failed_objexts_alloc() with
 profiling disabled
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-2-2fa7c6f60dbe@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-2-2fa7c6f60dbe@kernel.org>

--------------fP0ryuo4CzHsyjK4XS0b9LHe
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/20/26 11:16 PM, Vlastimil Babka (SUSE) wrote:
> The function might get called with memory allocation profiling disabled=
,
> when the obj_ext array is allocated for objcg pointers only. The
> handling is however unnecessary in that case, so skip it.
>=20
> This would otherwise become a real bug later, as pointed out by sashiko=
=2E
> For now it's just an optimization.
>=20
> Link: https://sashiko.dev/#/patchset/20260715-b4-objext_split-v1-0-9a49=
c4ccf4c3@kernel.org?part=3D10
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/slub.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/mm/slub.c b/mm/slub.c
> index 76acb78f2655..95fa6fbad11a 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2101,15 +2101,16 @@ static inline bool mark_failed_objexts_alloc(st=
ruct slab *slab)
>  static inline void handle_failed_objexts_alloc(unsigned long obj_exts,=

>  			struct slabobj_ext *vec, unsigned int objects)
>  {
> +	if (!mem_alloc_profiling_enabled())
> +		return;

This looks racy.

Can we instead do this later in the series depending on
slab_obj_ext_has_codetag_key's value?

>  	/*
>  	 * If vector previously failed to allocate then we have live
>  	 * objects with no tag reference. Mark all references in this
>  	 * vector as empty to avoid warnings later on.
>  	 */
>  	if (obj_exts =3D=3D OBJEXTS_ALLOC_FAIL) {
> -		unsigned int i;
> -
> -		for (i =3D 0; i < objects; i++)
> +		for (unsigned int i =3D 0; i < objects; i++)
>  			set_codetag_empty(&vec[i].ref);
>  	}
>  }
>=20

--=20
Cheers,
Harry / Hyeonggon


--------------fP0ryuo4CzHsyjK4XS0b9LHe--

--------------ol5zVscvDvmD5WVK7eNs0OQn
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCal8I4wAKCRCGXBN6rc5S
1uOkAP9JyWOEjPrnydpu0m5kMCD3Jg/w8yVhPqbOK9JF7RPdDAD+IA96fpIdRg7l
Iwl53sgc1cby3TLJcQjYVOaHX6xsSQY=
=FTDG
-----END PGP SIGNATURE-----

--------------ol5zVscvDvmD5WVK7eNs0OQn--
