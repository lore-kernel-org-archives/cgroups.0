Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFECF3D1AAA;
	Wed, 17 Jun 2026 09:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781688996; cv=none; b=egbwG2RzvNVsYUyF2XwTNPAyUcuhOaPoAzdA0/vaWAWskZCju5StSQXaTEoCHF8BLFGZt2RsrPaN14EFQO4nxKTN9d8R0MY/eptsae9cfSMVOiw4zDe8/vveu7g/grXIjgFYEMqBOejbL6v5etK3YcBcPY2b2WTfqtkoDZx62lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781688996; c=relaxed/simple;
	bh=apFpL1e7Ohu0dfTLu6wmaybdl1sf57ZeY/cr6ue447Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k/7bUxmWrGV3XPY1vLnI7t3djaxcP3T+i+pgv7xMQ5ZOT2cx3/rZ4/mVBhRL8vqYm4cFbLBttreVg1MR5AXL4T7x7J20pt94hvM9GzMhCoBnHBarS2arC8aONm6iFyngjnjdZMON2jVdfqv3/hjwl8738+sEr6ZB1OhMfC84Q3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iUcZfZx2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iUcZfZx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F6E1F000E9;
	Wed, 17 Jun 2026 09:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781688995;
	bh=apFpL1e7Ohu0dfTLu6wmaybdl1sf57ZeY/cr6ue447Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iUcZfZx2htTGVUMnfQK3FveqDTIDwSfOiCNAFKqjTunLhJAA4LbCoZksU57JMWqhb
	 E7zKfLx+KjxB/1F3hRN7ld03Xnd4OOAYpHLxu2GuD0GMG8AmH1LJKd9bS62vKpMj4Z
	 RkdTlxSlkMR+rNu/1d3sQxLXUtfrLURsDYHfDaJ+DlBTcYmit5UP7bkPzmaCU1gn3r
	 O7UY29DgPoZVyu3QpP93j0KtDKpgFGCEEPQFzPVDtEFbA9MRSZfi9rnx1I8KjtN4GQ
	 cNATgsxQvnSC3Fdg+eLYYLKEJcB0OO4RwHDKdAKT0x0/GbdHjjSPFo0U36HtaTIqeM
	 6R6aTf5QR+47A==
Message-ID: <e499bab7-9217-4bac-848c-fb1472cd2c00@kernel.org>
Date: Wed, 17 Jun 2026 18:36:26 +0900
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/15] mm/slab: pass slab_alloc_context to
 __do_kmalloc_node()
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-11-ce1146d140fb@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-11-ce1146d140fb@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------rWUE760itSiMGFZhE7U2S0m0"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------rWUE760itSiMGFZhE7U2S0m0
Content-Type: multipart/mixed; boundary="------------0cKAcwBqd61rxD70lkQiPDmz";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Message-ID: <e499bab7-9217-4bac-848c-fb1472cd2c00@kernel.org>
Subject: Re: [PATCH v3 11/15] mm/slab: pass slab_alloc_context to
 __do_kmalloc_node()
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-11-ce1146d140fb@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-11-ce1146d140fb@kernel.org>

--------------0cKAcwBqd61rxD70lkQiPDmz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/15/26 8:54 PM, Vlastimil Babka (SUSE) wrote:
> With alloc_flags usage in slab, we can replace __GFP_NO_OBJ_EXT with an=

> alloc flag that prevents kmalloc recursion. For that we need a version
> of kmalloc() that takes alloc_flags and use it in places that perform
> these potentially recursive kmalloc allocations (of sheaves or obj_ext
> arrays).
>=20
> As a preparatory step, make __do_kmalloc_node() take a pointer to
> slab_alloc_context. This replaces the 'size' and 'caller' parameters an=
d
> includes alloc_flags which we'll make use of.
>=20
> Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-12-7190909d=
b118@kernel.org
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------0cKAcwBqd61rxD70lkQiPDmz--

--------------rWUE760itSiMGFZhE7U2S0m0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajJqmgAKCRCGXBN6rc5S
1iS4AQCLRD76+3wcnQ2tKc8Sv5vzWltn/HT63SdLAQZxDEZHtQEA6UR3K29HgeQQ
r9k7dPVVOUsWaYdcnknjgAp4TiM9dw4=
=zxWP
-----END PGP SIGNATURE-----

--------------rWUE760itSiMGFZhE7U2S0m0--
