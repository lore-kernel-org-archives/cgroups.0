Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D81E343884;
	Thu, 11 Jun 2026 04:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781153397; cv=none; b=MtIzCY1BAXxEn8qJDXHJ7DeYWRIBiF3qDlm3yto6Q4PZUtTL+31ATYc8Sw3DtbxuiCr4fwssvVwlgcuPCi011VdOdrxJrOqd2OV+Zdg+89kWoyRZCfpHdNhhcN3sSBYsrlePivtAj1HNYPFE+nHcm169iYygorWBWW5Z1wP+vBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781153397; c=relaxed/simple;
	bh=WNQdVwOEOxeCyvRTasmqrIIyEOikW/27X0E0Tz9+AWY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JnJtRpyBrezAaDSuqLtjwUPpIVPqVRfpSb7S6YRyfvGXUENZAY8uxMFvG5MWH9chzSL++SQFiC8EUh+KEG2nH4iUjBMH9PmHwS8cnCPWyzaALKYZXwszlnsa1mVbmmDhDevyy6cjHY8md2iSSgQAVL9cac+n2nubeGeRNP79sEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N5CpSLPp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N5CpSLPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509F11F00893;
	Thu, 11 Jun 2026 04:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781153395;
	bh=WNQdVwOEOxeCyvRTasmqrIIyEOikW/27X0E0Tz9+AWY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=N5CpSLPpw35rjgyCRj5g3Idik/9lkQPRLsBBrkJdY+yNG8r6KCnB+VtI4cGHIVw9F
	 q+4fhjsda4gJuPbp5UJsyriDv9ESO62GadS2+MRzVYfD1/eKJuOApBaB0lnDoHziMv
	 rlCUbWTXIMqDyiRWIf2tCuq4TXZuIiGSAADu5K+M1SJhWpGOEHKGRz4nj47U1Sl50P
	 tWsWIn2b92e/EYQChSyuRCScQ6VlgrzXMett2OdUvxz90gfqpeNk5SU8VkEUSrz9vB
	 jybrIjxn6fGlGdoCAt9YvXjm2BEWxhEbn4cTGeIBs6PEnffTwsleFuQj+rtKkLIG0e
	 H3XFaAsHfYtOg==
Message-ID: <81e13eed-2029-42a3-8e1c-4e92249a26d4@kernel.org>
Date: Thu, 11 Jun 2026 13:49:50 +0900
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/16] mm/slab: introduce slab_alloc_context
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
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-4-7190909db118@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260610-slab_alloc_flags-v2-4-7190909db118@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------c4VlE0FE0HgTrGzQd9oZjEzB"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------c4VlE0FE0HgTrGzQd9oZjEzB
Content-Type: multipart/mixed; boundary="------------YSxo34ALkfgVy406qadRCbTw";
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
Message-ID: <81e13eed-2029-42a3-8e1c-4e92249a26d4@kernel.org>
Subject: Re: [PATCH v2 04/16] mm/slab: introduce slab_alloc_context
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-4-7190909db118@kernel.org>
In-Reply-To: <20260610-slab_alloc_flags-v2-4-7190909db118@kernel.org>

--------------YSxo34ALkfgVy406qadRCbTw
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/11/26 12:40 AM, Vlastimil Babka (SUSE) wrote:
> Similarly to page allocator's struct alloc_context, introduce a helper
> struct to hold a part of the allocation arguments. This will allow
> reducing the number of parameters in many functions of the
> implementation, and extend them easily if needed.
>=20
> For now, make it hold the caller address and the originally requested
> allocation size.
>=20
> Convert alloc_single_from_new_slab(), __slab_alloc_node() and
> ___slab_alloc(). No functional change intended.
>=20
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------YSxo34ALkfgVy406qadRCbTw--

--------------c4VlE0FE0HgTrGzQd9oZjEzB
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaio+bgAKCRCGXBN6rc5S
1oRGAQD1EG3lihk4VxLBIfWhXMef3vycxH4hVNES5+D1LcnTRQD+K6suBBuTPviO
6IhThfc/STOwiw4VJWaHaH39OQDDxAA=
=ZBkf
-----END PGP SIGNATURE-----

--------------c4VlE0FE0HgTrGzQd9oZjEzB--
