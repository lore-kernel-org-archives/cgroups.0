Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C38386550;
	Tue, 21 Jul 2026 05:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784612629; cv=none; b=nS5l4gq2382w7I3IAp/Qopg2kA1zcThDpUohYt/P2iNWe7ae0Waern5tdPwzTssxKd6/KWvQcESczyK+Jlf6Zr1r38aWVUm3u9pux922y+ipbyUby4sjtet+3nuXBNbz5YNaEvR8KnxvdfpZNi/RwXdXoajS1ipaUuf4rTHsyuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784612629; c=relaxed/simple;
	bh=1E5hrC0GLOtnEChmCYRZDrDcV/YPnPASbnuVNu1+9EU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ng3isEsYC9VTSK2qDqJ5zNn9Y+N76JpMkCkwPZNYIYwXRjSm819+ezkQIi41EzrlNlQXmyL1Le3ZjToK5gRfFjWTaxXgRpzMBJ4AeAMBqFAoc9q2m43DSbqcysjq/ysvZd+wxkKFeobOcHJMTAw4eB2dMzs/kkCBiyXA1yFajsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Foq28WPh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Foq28WPh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7678B1F000E9;
	Tue, 21 Jul 2026 05:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784612627;
	bh=meJhmwUfnjOSp8m4k+erl7xb2QjuGv1a7LosgCLMC3w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Foq28WPh8couwfB2Ljzyrr9Kv43HLtbC9JwcBZVDRIySK6OhX2CW8yIrUTFl0eomd
	 TKAbM0LDTW45qhdiUR5wblr62ZILUSI2rPc2ZROEnG1ep8GfXwd6d0+BQYwSpyksLt
	 b3GqPqfZZRA9eIjUDAX7m2uWCuTDZwNLGe5OB37hAkqKP5pBHstDkI/Mq8jY/ULPtz
	 2B84OsXGn5IbZ5XaRXR2islFFPAK6K5v6J5Lk7MMkMSvFOP+FkpBVYghJStorOGDgq
	 vot39Me7Gxt8+ZqY45mqWEDNAXQ2v1EnYgxNi/Vp9iwecX9YYYiHNrWPxgkoLBX6yb
	 M4L1mGMGOoI7A==
Message-ID: <da6ca31c-f97c-4cd1-9380-4fe50d797a7d@kernel.org>
Date: Tue, 21 Jul 2026 14:43:40 +0900
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/13] mm/slab: skip kfence objects in allocation
 profiling
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-1-2fa7c6f60dbe@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-1-2fa7c6f60dbe@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------BcYzxlX3VPSEK1j5AEJfPS35"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------BcYzxlX3VPSEK1j5AEJfPS35
Content-Type: multipart/mixed; boundary="------------2Fwu9gZK7PiMF1w25tWuNnKl";
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
Message-ID: <da6ca31c-f97c-4cd1-9380-4fe50d797a7d@kernel.org>
Subject: Re: [PATCH v2 01/13] mm/slab: skip kfence objects in allocation
 profiling
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-1-2fa7c6f60dbe@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-1-2fa7c6f60dbe@kernel.org>

--------------2Fwu9gZK7PiMF1w25tWuNnKl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/20/26 11:16 PM, Vlastimil Babka (SUSE) wrote:
> struct kfence_metadata only contains struct slabobj_ext with
> CONFIG_MEMCG, which is then used for the "fake" slab's obj_exts field.
> If CONFIG_MEMCG is enabled, the struct can also end up used for memory
> allocation profiling. If CONFIG_MEMCG is disabled but profiling is
> enabled, it will end up allocating its obj_exts via
> prepare_slab_obj_exts_hook() and assigning them to the fake struct slab=
=2E
> These will probably then never be freed.
>=20
> So things sorta work, but not always in the intended and optimal way.
> The upcoming changes to slabobj_ext layout would additionally need a
> proper refactoring to keep working.
>=20
> However, there's little benefit in accounting KFENCE objects. KFENCE
> allocations are rare and there can be only CONFIG_KFENCE_NUM_OBJECTS
> (default to 255) outstanding ones at any time. For any callsite
> prominent enough in the memory allocation profiling stats, allocations
> served from KFENCE will be lost in the noise.

For a similar reason I wonder if we can drop obj_exts completely.
The idea that kfence objects might have different slabobj_ext layout
isn't really worth the extra complexity if we have very limited amount
of kfence objects. The amount of objects that escape memcg accounting
will be quite limited.

Any thoughts from KFENCE & MEMCG folks?

> Thus let's not complicate things and simply stop accounting KFENCE
> objects in allocation profiling and skip them in the related slab hooks=
=2E
>=20
> We also need to skip kfence objects in mark_obj_codetag_empty() in case=

> a sheaf is allocated from kfence, per earlier sashiko review.
>=20
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  Documentation/mm/allocation-profiling.rst |  7 +++++++
>  mm/slub.c                                 | 11 +++++++++++
>  2 files changed, 18 insertions(+)
>=20
> diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/=
mm/allocation-profiling.rst
> index 5389d241176a..d02eb54ee8f2 100644
> --- a/Documentation/mm/allocation-profiling.rst
> +++ b/Documentation/mm/allocation-profiling.rst
> @@ -112,3 +112,10 @@ break it out by rhashtable type.
> =20
>  - Then, use the following form for your allocations:
>    alloc_hooks_tag(ht->your_saved_tag, kmalloc_noprof(...))
> +
> +Notes
> +=3D=3D=3D=3D=3D
> +
> +- When a slab object is allocated from KFENCE, its accounting is skipp=
ed.
> +  KFENCE allocations are rare and limited to a small number, so this o=
mission
> +  is negligible.
> diff --git a/mm/slub.c b/mm/slub.c
> index 0337e60db5ac..76acb78f2655 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2076,6 +2076,11 @@ static inline void mark_obj_codetag_empty(const =
void *obj)
>  		struct slabobj_ext *ext =3D slab_obj_ext(obj_slab,
>  						       slab_exts, offs);
> =20
> +		if (is_kfence_address(obj)) {
> +			put_slab_obj_exts(slab_exts);
> +			return;
> +		}

I think we should check this before get_slab_obj_exts()?

Checking if the object is from kfence after slab_obj_ext_codetag_ref()
looks bit weird.

Otherwise LGTM.

> +
>  		if (unlikely(is_codetag_empty(&ext->ref))) {
>  			put_slab_obj_exts(slab_exts);
>  			return;
> @@ -2352,6 +2357,9 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache=
 *s, void *object, gfp_t flags,
>  	if (alloc_flags & SLAB_ALLOC_NO_RECURSE)
>  		return;
> =20
> +	if (is_kfence_address(object))
> +		return;
> +
>  	slab =3D virt_to_slab(object);
>  	obj_exts =3D prepare_slab_obj_exts_hook(s, slab, flags, alloc_flags, =
object);
>  	/*
> @@ -2399,6 +2407,9 @@ __alloc_tagging_slab_free_hook(struct kmem_cache =
*s, struct slab *slab, void **p
>  	for (i =3D 0; i < objects; i++) {
>  		unsigned int off =3D obj_to_index(s, slab, p[i]);
> =20
> +		if (is_kfence_address(p[i]))
> +			continue;
> +
>  		alloc_tag_sub(&slab_obj_ext(slab, obj_exts, off)->ref, s->size);
>  	}
>  	put_slab_obj_exts(obj_exts);
>=20

--=20
Cheers,
Harry / Hyeonggon

--------------2Fwu9gZK7PiMF1w25tWuNnKl--

--------------BcYzxlX3VPSEK1j5AEJfPS35
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCal8HDAAKCRCGXBN6rc5S
1inqAP9Xf5gpteIoCx+wRMSTfe3rUiOi1kgL0f7l+nIX7MTGvwEAoIuZmbTxNxGc
ptiFK2CT0FBb+0PUFF6oYZruDcKjsA4=
=QTRH
-----END PGP SIGNATURE-----

--------------BcYzxlX3VPSEK1j5AEJfPS35--
