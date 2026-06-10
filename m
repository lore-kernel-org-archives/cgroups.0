Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE193FD13E;
	Wed, 10 Jun 2026 12:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781093220; cv=none; b=S+s3VcbDbRZwjAVZRcgSK6tHVzCQPRUfuw0Ps+XIZt4woTkxM1fS+lrh9JG61OXBl2Duqr5ylj5bLHcy+7SSp//Ai7pYicr5/GFibyEBUipEaE5Kkt80XE/xH6tRL/qh+dJHzEv9YHTHazKCIFFkZcVOJUBWnJ8XTnmzfQwMBNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781093220; c=relaxed/simple;
	bh=3S5TEHpMOJZU/HfVPLHwrccmgC5OBUEG+pp6rgdD7zo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZKAPiY4shUdOM/f3CmuX++h0OM1iEsyrFmGPs3b0zC6mjP11XAbrC3knKo8cocdolqFYQgs7cpwAMBWPFNEDAEMWm+PWOSIRIS5wq+WW9IQV0BjTfYud1noIHojV9n/fRZlbsH1oTO+N8C7nntnDBgdnOGKoL0224pi3CVHFxNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GeGBmsT3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GeGBmsT3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8BC1F00893;
	Wed, 10 Jun 2026 12:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781093219;
	bh=/lvjM4grmcimakDhjqCbNRnKzubZHkQeH7hKgRM5Kes=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GeGBmsT3+kIwRsklxR1TYcu4DqZ9f5X0qV3yfdqTVZ1RHxYeoHPp7nVT50F9xmJp8
	 SvgyxqCDtgoLHpHMIfy3qi7zMg0I+/ZvihPE4l+DBGZ0+bIPpwYJYWemhdkmgAyfcv
	 KyZeSUMfW120ZPiEt1g26W8BArl6YBtkPQ9kUG8XxhLDcyA+GYY3JtoypalZeDpRnz
	 NpdO7Ms+LsRnii1ytDuw950lQSfwuXs4Jyi0Jr/peEg4/5v8hO6vpaXZ/6ehel5KlP
	 jNNF5uM/RAE99niIFsmrqwHphAZ4npUzWBo8HM3hlS/KQK0G6c7MC/WRTy+gCiL2B+
	 HW2Gm8XlYS23Q==
Message-ID: <d0d7e853-12e2-4db1-8e20-ee66c3006dd0@kernel.org>
Date: Wed, 10 Jun 2026 21:06:50 +0900
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 02/15] mm/slab: stop inlining __slab_alloc_node()
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
References: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
 <20260609-slab_alloc_flags-v1-2-2bf4a4b9b526@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260609-slab_alloc_flags-v1-2-2bf4a4b9b526@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------o7p8tJJhETiZ7lV3nDNGI84L"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------o7p8tJJhETiZ7lV3nDNGI84L
Content-Type: multipart/mixed; boundary="------------8e0X05FoqZgOTYBzGdnEpcJ3";
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
Message-ID: <d0d7e853-12e2-4db1-8e20-ee66c3006dd0@kernel.org>
Subject: Re: [PATCH RFC 02/15] mm/slab: stop inlining __slab_alloc_node()
References: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
 <20260609-slab_alloc_flags-v1-2-2bf4a4b9b526@kernel.org>
In-Reply-To: <20260609-slab_alloc_flags-v1-2-2bf4a4b9b526@kernel.org>

--------------8e0X05FoqZgOTYBzGdnEpcJ3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/9/26 6:17 PM, Vlastimil Babka (SUSE) wrote:
> With sheaves, this is no longer part of the allocation fastpath.  For
> the same reason, also mark the call to it from slab_alloc_node() as
> unlikely().
>=20
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------8e0X05FoqZgOTYBzGdnEpcJ3--

--------------o7p8tJJhETiZ7lV3nDNGI84L
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCailTWgAKCRCGXBN6rc5S
1pPLAQCl0frg9IhgBHxe7oh9laNSSKIorQjoahz5YjcSR7zvLQD8Dn39qHQ/vH8o
K3q/ObZo2YOj/eCIlLKJ0EcvC1VDfAo=
=+15X
-----END PGP SIGNATURE-----

--------------o7p8tJJhETiZ7lV3nDNGI84L--
