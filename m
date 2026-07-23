Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CD1242D7B;
	Thu, 23 Jul 2026 06:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784788080; cv=none; b=GotOi46UmiDzbIWOtq6UDr2Mt01MTgjP5qezwKcZmMOcAeBIn0FztM1haA683TpuU0EXbopN0ao3eBky379KPkgkbV0OQBNv52tlaFJGbadOH3XNEFBIILhj6ufg8wWgSlq2CUlxs0JrH3dPBA1e+r0Bkmet5Ed5L6Eq7MyzHPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784788080; c=relaxed/simple;
	bh=q85OUQan+Ae0Q5TWBtVxvdxhCPGjznbxSgPKtKiAMfo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QBE4FDpTqWH1p2lUzphh69qTrj01/waC3X2nHfjKxDBuXK4DmMDSE1zDPXCpsOu4pAkZtCbAcFJZSJHdneNuNcFOPYcATZiwCd4IXsC8/wllTpPZwrjv0WdKyAPYE7kYKV/i4QTC9VlOCXDK/9lZhSUxdSVdupyuUIgMpiL/wpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YPjzG0HK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YPjzG0HK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81EFF1F000E9;
	Thu, 23 Jul 2026 06:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784788078;
	bh=BPGIxjg2fvOObq3ApTehOQxmp9hWxXn/JtuKKDwREDg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YPjzG0HKWyOi7d9iOKzBWEMsrwb+6qVAvKGm3yO1k+hH8+8o3eYmS9GJiEkj5h2+A
	 M3BlaNMoNz/bul/F/Pjc+6IFZq+yw2Lg+/Y+v8kpBB4Z7Gt0jxQ/9keLZ9e3535Xlr
	 0TdsgFsM1DxgePRpFkjm1ycO3YNOti6AW9xayvlEJbhsR6Z2zaVn4jhu2N1L7nOsih
	 as0FD4UqccGC0eQ4gzTouCYN9lAb8mYmSpQ0T9W9J+DtL1yIUAONyZJldae6z+OS0P
	 rogcL4PDnA2aky0jiiV0m+nH60U0kONX743S23Gd4+aLFc5Co8M+mPbI79DF5kztY8
	 H3L9TLPIn3SBg==
Message-ID: <9b2dadb7-8e3d-4b9b-a870-969be9a7a432@kernel.org>
Date: Thu, 23 Jul 2026 15:27:51 +0900
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/13] mm/slab: change struct slabobj_ext to a union
To: Hao Li <hao.li@linux.dev>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-9-2fa7c6f60dbe@kernel.org>
 <amGEY5w-cBm4_uhx@fedora>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <amGEY5w-cBm4_uhx@fedora>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------S1stg09klGnjKz70otvyV0jo"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------S1stg09klGnjKz70otvyV0jo
Content-Type: multipart/mixed; boundary="------------7Aat19BJ00A9a69ufvP0WjqI";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Message-ID: <9b2dadb7-8e3d-4b9b-a870-969be9a7a432@kernel.org>
Subject: Re: [PATCH v2 09/13] mm/slab: change struct slabobj_ext to a union
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-9-2fa7c6f60dbe@kernel.org>
 <amGEY5w-cBm4_uhx@fedora>
In-Reply-To: <amGEY5w-cBm4_uhx@fedora>

--------------7Aat19BJ00A9a69ufvP0WjqI
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/23/26 12:05 PM, Hao Li wrote:
> On Mon, Jul 20, 2026 at 04:16:23PM +0200, Vlastimil Babka (SUSE) wrote:=

>> Currently, struct slabobj_ext can hold both objcg pointer and
>> codetag_ref (when both are compile-enabled) and there is an array of a=
s
>> many slabobj_ext instances as there are objects in a slab.
>>
>> This makes the layout fixed so even if codetag_ref is unused (because
>> memory allocation profiling is disabled), the space for them is
>> allocated and wasted. Similarly, some caches (currently kmalloc_normal=
)
>> do not ever need objcg pointers, leading to wasted memory with memory
>> allocation profiling enabled.
>>
>> To make this more flexible, change the layout so that struct slabobj_e=
xt
>> becomes a union of objcg pointer and codetag_ref (to ensure uniform
>> size; in practice both are the same size anyway). The slabobj_ext arra=
y
>> then can have twice as many elements as before. For cache locality
>> purposes, the effective memory layout is unchanged, so objcg and codet=
ag
>> ref for a given object are still adjacent.
>>
>> cache_obj_ext_size() returns the effective size of (0-2) struct
>> slabobj_ext's for a cache, slab_obj_ext_size() for a slab. Currently
>> both return a constant value derived from the config options, but will=

>> be made dynamic later. Replace all sizeof(slabobj_ext) usage with thes=
e.
>>
>> No functional change intended, the layout is still effectively static.=

>>
>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
>>  mm/slab.h | 49 +++++++++++++++++++++++++++++++++++++++----------
>>  mm/slub.c | 19 +++++++++++--------
>>  2 files changed, 50 insertions(+), 18 deletions(-)
>>
>> diff --git a/mm/slab.h b/mm/slab.h
>> index e586798e4f16..f8446167e175 100644
>> --- a/mm/slab.h
>> +++ b/mm/slab.h
>> @@ -550,18 +550,42 @@ static inline bool need_kmalloc_no_objext(void)
>>  }
>> =20
>>  /*
>> - * Extended information for slab objects stored as an array in page->=
memcg_data
>> - * if MEMCG_DATA_OBJEXTS is set.
>> + * Extended information for slab objects stored as a pointer to an ar=
ray in
>> + * slab->obj_exts (aliasing page->memcg_data) if MEMCG_DATA_OBJEXTS i=
s set.
>>   */
>>  struct slabobj_ext {
>> +	/*
>> +	 * All elements of the union should be pointer-sized to avoid memory=

>> +	 * waste
>> +	 */
>> +	union {
>>  #ifdef CONFIG_MEMCG
>> -	struct obj_cgroup *_objcg;
>> +		struct obj_cgroup *_objcg;
>>  #endif
>>  #ifdef CONFIG_MEM_ALLOC_PROFILING
>> -	union codetag_ref _ctref;
>> +		union codetag_ref _ctref;
>>  #endif
>> +	};
>>  } __aligned(8);
>=20
> slabobj_ext is now acting as a generic struct, serving as either _objcg=
 or
> _ctref. However, because it's set to __aligned(8), I'm wondering if thi=
s might
> waste half the memory on 32-bit?

We could loosen the alignment to
max(__NR_OBJEXTS_FLAGS, alignof(void *))

and drop OBJEXT_FLAG_UNUSED.

=2E..not sure how much we care about this on 32bit though.

--=20
Cheers,
Harry / Hyeonggon

--------------7Aat19BJ00A9a69ufvP0WjqI--

--------------S1stg09klGnjKz70otvyV0jo
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCamG0ZwAKCRCGXBN6rc5S
1qvSAQD8ldDgjvd06RRWLX1ZE+QZB780OCmBJqOM3n4si+4IMgEAnr9xvjuton1b
+1ODJQBFyP54dvPyJNUOAoq7Bs43tQY=
=Z9VW
-----END PGP SIGNATURE-----

--------------S1stg09klGnjKz70otvyV0jo--
