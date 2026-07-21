Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9AB34CFD3;
	Tue, 21 Jul 2026 05:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784613209; cv=none; b=jYWqbHjsr5BEm/9wNkw1e5drNNOknNeQgEoemzUehnL3MjZIWCbje76NP5pLly7Dz4bBv78RdiTTK3ADjfv6HvelRDOqmHQ0lz/gJqI3zMFrL235HU+GMbSsdGd0ldRd2Qk37yQRfwxPgJ9ska22QMmtrMzQssx+VXjntqx4QAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784613209; c=relaxed/simple;
	bh=X/Ol8r5ArsVuARV2wlyP0lWho5H8ekpzbpXGHH72Syc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=peT+5lSZzoxP2m5kPxV9bc+ohgFSbEuQX9zELaerRm9BgqoecR58WvPsqWWyztqRzKV6R6EfocQ9OhS38/pXzDM3GLytG04iH/AJX9cdWXvWMoQnnozI0YfeBw2unhLKh9sV363S42y5virEmD8VoIJw+Fg5E5VSPxqs3zoRDKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tp53nAes; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tp53nAes"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6682D1F000E9;
	Tue, 21 Jul 2026 05:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784613208;
	bh=X/Ol8r5ArsVuARV2wlyP0lWho5H8ekpzbpXGHH72Syc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Tp53nAesptOxLEw9xI8Bk84IKtKiRYMoIF2tQCNOyAo8uQSEV7Te3XwN3bjbKbyvk
	 tnEep518SyfrjS3HGQIo3OClz0MXXyCJjQckYg1r2RgCAw78sb+h4qgxrJRYOcxipo
	 Yxodf5CE3M5VBfIwmJyP8FzV2bawKFEMwSOR2qTQ9eSzBk8wgd4oYZ5t/dpqY9GQpX
	 YRWFTZF8ahvTNPPPdYgcH1Fw5k/EvTZFSTOVqSx9e03kQ0QgFsimH8+lvcccXL5A25
	 ej7xuAJEgxZ21s3g0BYmgvziySV0d2To+lNwJEr2uNxxU4UvcsFHlpV7vwjBiMatQD
	 CE24mIW2Fd3+w==
Message-ID: <bbbd376f-dd0c-432e-abe3-7ea0e37b1db2@kernel.org>
Date: Tue, 21 Jul 2026 14:53:21 +0900
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/13] mm/slab: remove objs_per_slab()
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-3-2fa7c6f60dbe@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-3-2fa7c6f60dbe@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------QVrUM3rJ2V0pNQ7hep9iO32R"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------QVrUM3rJ2V0pNQ7hep9iO32R
Content-Type: multipart/mixed; boundary="------------0xVRzTOr1DAkrkFmXoKm6is4";
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
Message-ID: <bbbd376f-dd0c-432e-abe3-7ea0e37b1db2@kernel.org>
Subject: Re: [PATCH v2 03/13] mm/slab: remove objs_per_slab()
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-3-2fa7c6f60dbe@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-3-2fa7c6f60dbe@kernel.org>

--------------0xVRzTOr1DAkrkFmXoKm6is4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/20/26 11:16 PM, Vlastimil Babka (SUSE) wrote:
> The function has an unused kmem_cache argument and almost nothing uses
> it anyway; doing slab->objects is simpler. Remove it with the last two
> users. KUNIT_EXPECT_EQ() needs a cast to avoid "error: =E2=80=98typeof=E2=
=80=99 applied
> to a bit-field" but we don't need to keep a wrapper just for that.
>=20
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------0xVRzTOr1DAkrkFmXoKm6is4--

--------------QVrUM3rJ2V0pNQ7hep9iO32R
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCal8JUQAKCRCGXBN6rc5S
1hoIAQC93Of5VVke2ZLR0Ho/ZA+b1qSqrQjT9drL71MUDzG7MgEA7eAu73jtOYlK
17uyJ98yg3Uwhq4QKfO0LVAEru/U/QA=
=NQkt
-----END PGP SIGNATURE-----

--------------QVrUM3rJ2V0pNQ7hep9iO32R--
