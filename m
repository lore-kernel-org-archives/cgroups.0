Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7F237F304;
	Mon, 27 Jul 2026 05:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785130887; cv=none; b=Iy6PREqXgvF2KghmEGGu2qRE85zevqWqtMZpx74QOHuHBq1FNEw+64gt8rbHYl7F2gL0xTqH/8hoDMaoyPENSfrvZ+v3GDFOkilRNnasMDpUIOtbFf27xrfyJxKufTeKx6cXfRxVOyKq9D6DC1Kb5hFFLu9sm3/ukiD5cubklyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785130887; c=relaxed/simple;
	bh=KBGxVKBVcPUvP2K8Kq2m/WESxz8RXhfqZ6Mnq5IoEO4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qgdtsDcDvcUMtM0DPaKpM3BayqBDg83R3ebSW9z8/v4Qf154TcvPqROsvj0f1NQhS38lUViPyLL6cm+FJ3GnSSd9Sk82/18dk8GLSVIZD+SWWm7DOUXj7YCoaEpxnV74gUo1RFVPwG0yrsmPG83NCn8uuNaZJyU83NR2ktqTcTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CckjAe+u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CckjAe+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3345C1F00A3A;
	Mon, 27 Jul 2026 05:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785130886;
	bh=KBGxVKBVcPUvP2K8Kq2m/WESxz8RXhfqZ6Mnq5IoEO4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CckjAe+u8aiFdiwdleeGwEQnEKVUjrWDcX6k3I3hMQkAvD/E6HfuB18CvzHDfuZzz
	 idU7A9Z7y6qZNj9IWcFBzLD2rMv8kUbRNhhkgkKHcEjx1Bv52UG8RSIVwcTj3IfHPs
	 zEe2fVv0Hv9fuoKUlUr5M8rQ8zqWioNndRBmaL/RQnqXQV06Q1g7MSka9/ljLUYB82
	 6qHZIVFNsJwpAaoRlPiNOFv96kUqkNo9w3aP5h0VcQvwxXka0wP6C0RE57Vd+Iw8Oj
	 Iaqn5NMjKrSxKNEMxBGwTeyOqP1ct0PWxOxwTUrutpaLFo7cFpV/f8g89eogppZ209
	 nlbm5Wdef5Kdg==
Message-ID: <89662cae-b3d9-4aa4-a7fa-cf5931781dbc@kernel.org>
Date: Mon, 27 Jul 2026 14:41:20 +0900
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/13] mm/slab: change struct slabobj_ext to a union
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-9-2fa7c6f60dbe@kernel.org>
 <amGEY5w-cBm4_uhx@fedora> <9b2dadb7-8e3d-4b9b-a870-969be9a7a432@kernel.org>
 <amHkbJsvOjcfUR3D@fedora> <e3f283e3-27a4-4e3e-bc4c-39fafbcfe1ee@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <e3f283e3-27a4-4e3e-bc4c-39fafbcfe1ee@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Mgwd0Ze9mOCZYycSnvRZAlba"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Mgwd0Ze9mOCZYycSnvRZAlba
Content-Type: multipart/mixed; boundary="------------xEDZ3aIuuqtyEFJe6gHUB0km";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Message-ID: <89662cae-b3d9-4aa4-a7fa-cf5931781dbc@kernel.org>
Subject: Re: [PATCH v2 09/13] mm/slab: change struct slabobj_ext to a union
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-9-2fa7c6f60dbe@kernel.org>
 <amGEY5w-cBm4_uhx@fedora> <9b2dadb7-8e3d-4b9b-a870-969be9a7a432@kernel.org>
 <amHkbJsvOjcfUR3D@fedora> <e3f283e3-27a4-4e3e-bc4c-39fafbcfe1ee@kernel.org>
In-Reply-To: <e3f283e3-27a4-4e3e-bc4c-39fafbcfe1ee@kernel.org>

--------------xEDZ3aIuuqtyEFJe6gHUB0km
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/25/26 12:42 AM, Vlastimil Babka (SUSE) wrote:
> On 7/23/26 11:56, Hao Li wrote:
>> On Thu, Jul 23, 2026 at 03:27:51PM +0900, Harry Yoo wrote:
>>>
>>> and drop OBJEXT_FLAG_UNUSED.
>>
>> Yes, this idea is insightful and I think it may need a standalone patc=
h without
>> blocking current patchset.
>>
>>>
>>> ...not sure how much we care about this on 32bit though.
>>
>> Yeah, 32bit is a rare arch today :)
>=20
> Agreed with you both. Let's deal with it later.

Sounds reasonable.

> Also AFAICS the memory was already wasted on 32bit prior this series wh=
en
> e.g. CONFIG_MEM_ALLOC_PROFILING was disabled, so there was just 4-byte =
objcg
> pointer in 8-byte aligned slabobj_ext, right?

Right.

--=20
Cheers,
Harry / Hyeonggon


--------------xEDZ3aIuuqtyEFJe6gHUB0km--

--------------Mgwd0Ze9mOCZYycSnvRZAlba
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCambvgAAKCRCGXBN6rc5S
1i+uAP4zMR6KAfExVASA33SIec4hOe1qPSAA+y6SvbztDbmuwwD+O9oxG/LJahjB
u7CQFZJxg9HPyZTA9A2Q25sRF9mC3QA=
=RYZd
-----END PGP SIGNATURE-----

--------------Mgwd0Ze9mOCZYycSnvRZAlba--
