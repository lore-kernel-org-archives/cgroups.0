Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD84F342173;
	Tue, 21 Jul 2026 15:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648478; cv=none; b=U6gjborrSltKjYx7+OF9hgAih73ham7VmeoytTVs6LmIQ7GLUG3sBbRq5L9p36hatpzhoCUKOcKu6Zd9AoKh8xAG6kWNFJoLSZA+6PNLobCrC+bH7u7RrmhLotCT6Vn4YarHjQ1cQiHncfzpoHws0m3Kta9h0S6bqn7Z8h+35BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648478; c=relaxed/simple;
	bh=AI9xw2VxbQp7jX/B5YduqGMEsi6H2MQYTvtbRLDj+lQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pjpz+DkM5NISiZKrtrkKRQGITe9hjSMyjPqtgxw27vcadscZxKFf18CiqCwP6G/lByayntKJrDCyMeROv7rgHLfnNyYGo5cKUwgTe/ALlhBVlIxASpm5Ldqe1LqgZAHeTYUlk7FoyT6g7u8T/uHkQYLHQz0rfDtGrGgd2SceAdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NtrX8Fj7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NtrX8Fj7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1312E1F000E9;
	Tue, 21 Jul 2026 15:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784648477;
	bh=AI9xw2VxbQp7jX/B5YduqGMEsi6H2MQYTvtbRLDj+lQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NtrX8Fj7MU5zwfg83ZUMZfEGaN6yiGQFBNo9V9EorL498LCl6y+uUXPMaew6uQ814
	 xtTYLI8WOBNCHHVSqPhwBh2fXbW3bE/a5lkOiNrco9fge8qyNJ/VnnyS7pkKM1k2xe
	 onZdI0uZk+PMrMcuhJ3A4cf9UaWO+L0m+imJ06ogOSUYiyczDvWgioLzgTt56qzPVN
	 zKTOPa8GJTEhkGtqjT+gbZLyme5ItgNld/9LEJEFa6Q04EuUZcNGxFoxtTQOkVqg/p
	 eOtSLf+4IVFD3piDBW8rTs+31ExAcMsWX003NIwQ+J9+Wl20w+NVI5P46zlnBc7E8w
	 wC+1cblY0O4qQ==
Message-ID: <31e637da-1ef2-412f-9c4a-26b720d7c74a@kernel.org>
Date: Wed, 22 Jul 2026 00:41:10 +0900
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
 <da6ca31c-f97c-4cd1-9380-4fe50d797a7d@kernel.org>
 <96468090-6b31-4f78-a813-c5729b53aa3d@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <96468090-6b31-4f78-a813-c5729b53aa3d@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------lihAPi6O8DUJyauCGzEd0pPf"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------lihAPi6O8DUJyauCGzEd0pPf
Content-Type: multipart/mixed; boundary="------------DI7QtXXAQSwUVNu604OE0Y40";
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
Message-ID: <31e637da-1ef2-412f-9c4a-26b720d7c74a@kernel.org>
Subject: Re: [PATCH v2 01/13] mm/slab: skip kfence objects in allocation
 profiling
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-1-2fa7c6f60dbe@kernel.org>
 <da6ca31c-f97c-4cd1-9380-4fe50d797a7d@kernel.org>
 <96468090-6b31-4f78-a813-c5729b53aa3d@kernel.org>
In-Reply-To: <96468090-6b31-4f78-a813-c5729b53aa3d@kernel.org>

--------------DI7QtXXAQSwUVNu604OE0Y40
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/21/26 6:20 PM, Vlastimil Babka (SUSE) wrote:
> On 7/21/26 07:43, Harry Yoo wrote:
>> On 7/20/26 11:16 PM, Vlastimil Babka (SUSE) wrote:
>>> struct kfence_metadata only contains struct slabobj_ext with
>>> CONFIG_MEMCG, which is then used for the "fake" slab's obj_exts field=
=2E
>>> If CONFIG_MEMCG is enabled, the struct can also end up used for memor=
y
>>> allocation profiling. If CONFIG_MEMCG is disabled but profiling is
>>> enabled, it will end up allocating its obj_exts via
>>> prepare_slab_obj_exts_hook() and assigning them to the fake struct sl=
ab.
>>> These will probably then never be freed.
>>>
>>> So things sorta work, but not always in the intended and optimal way.=

>>> The upcoming changes to slabobj_ext layout would additionally need a
>>> proper refactoring to keep working.
>>>
>>> However, there's little benefit in accounting KFENCE objects. KFENCE
>>> allocations are rare and there can be only CONFIG_KFENCE_NUM_OBJECTS
>>> (default to 255) outstanding ones at any time. For any callsite
>>> prominent enough in the memory allocation profiling stats, allocation=
s
>>> served from KFENCE will be lost in the noise.
>>
>> For a similar reason I wonder if we can drop obj_exts completely.

=2E..for kfence objects!

> To make it clear, you mean kfence objects wouldn't have objcg accountin=
g and
> would essentially behave as if obj_exts for them could not be allocated=
=2E

Haha, right. Thanks for clarifying.

>> The idea that kfence objects might have different slabobj_ext layout
>> isn't really worth the extra complexity if we have very limited amount=

>> of kfence objects. The amount of objects that escape memcg accounting
>> will be quite limited.
>=20
> Indeed. I think the main point wasn't to have everything accounted, but=
 to
> avoid specially cased kfence paths.

> But I think this would probably just require adding is_kfence checks to=

> objext allocation paths to fail them, so that's manageable.

Agreed.

> Should perhaps
> allow moving some of the checks added by this patch to more generic sha=
red
> places.

Which places did you mean by 'more generic shared places'?

--=20
Cheers,
Harry / Hyeonggon

--------------DI7QtXXAQSwUVNu604OE0Y40--

--------------lihAPi6O8DUJyauCGzEd0pPf
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCal+TFgAKCRCGXBN6rc5S
1p1pAP0XU9L5CZnX3R1WlPuTzkAElnqLx3SBYNykv6t/dWnyMAD9HX2ksCXwGe4N
oQmhmLj0qHcHsgUqb1WXUMWF6EyZBwE=
=EJeX
-----END PGP SIGNATURE-----

--------------lihAPi6O8DUJyauCGzEd0pPf--
