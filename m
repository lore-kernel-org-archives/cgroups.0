Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9553AB498;
	Tue, 21 Jul 2026 05:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784613363; cv=none; b=YjWaUNLj7nnsTRpGAhumlfO3g0IldLcN1CHyZMDD2JoV2GO05VOU6Ijv1MD9iEvHAJm0w0iS0z0FufLgSgXsUM7Dp1GPsYr2x/4Zcwu4N7h2IZ7x79wFli2RA+YauoJ6lsLUh5u8q1lIwjEo6VX8VwsJQckUMP4WWEUS1grCJk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784613363; c=relaxed/simple;
	bh=ry9nwKcjc3En+95aLTmNvR9XfBv8Y48g5ZHbR8RfbM8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z2iCRxHKxH1dGTIRq2+RPNyj6URMDmJAg7yxZ1i29AMkyN4IAP7Vdq0BxcADt/gtM3dxzRhW6ZDwwhKvg3JvCbJJKJUNirnkyzbP3qsEb9MiSoETfnuvSkVFw2rmlDO4535uY5VMSPOFZQImV1teqZewuHMdzFbYd2ubwrpt/lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I16JXFNt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I16JXFNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD061F000E9;
	Tue, 21 Jul 2026 05:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784613362;
	bh=ry9nwKcjc3En+95aLTmNvR9XfBv8Y48g5ZHbR8RfbM8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=I16JXFNtmsTyrr4HzilKeW3iZg11ZNKOg3eqllU7CcyIMceJfGOPOPCk7H9utG0cR
	 Sz9b6CB1IG504z5qQnsJ2IBQgMRQYxoNVl759xA8IE9RSDkzCb8YFU0bJ3xRaZ1m3F
	 x3Fv5aaotN7BFn/KP/89wM4H6s38hK7wASbmhGztas2Bfwcl0yAIIbIpIvoiLkcx2B
	 HreNYgWmb1OgjAmplrA02qCzKE4oWhAFBZq2aF+55eZov7o7wg/RLlGMtULhxVKV9i
	 cIGUM+cpN6aWyVQwXpXWjriA4U2lHE6Bn4+IfrYajlSKltXG9e3WANUMjBsu08ApGa
	 kMAhh32IvJoog==
Message-ID: <10634acc-f45b-475e-a2df-2d7efc880b68@kernel.org>
Date: Tue, 21 Jul 2026 14:55:56 +0900
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/13] mm: move struct slabobj_ext to mm/slab.h
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-4-2fa7c6f60dbe@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-4-2fa7c6f60dbe@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------erUdOoVxhVjluo2iVkSPasJs"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------erUdOoVxhVjluo2iVkSPasJs
Content-Type: multipart/mixed; boundary="------------GcZskzVFCTVPbbHA49fLBI3E";
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
Message-ID: <10634acc-f45b-475e-a2df-2d7efc880b68@kernel.org>
Subject: Re: [PATCH v2 04/13] mm: move struct slabobj_ext to mm/slab.h
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-4-2fa7c6f60dbe@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-4-2fa7c6f60dbe@kernel.org>

--------------GcZskzVFCTVPbbHA49fLBI3E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/20/26 11:16 PM, Vlastimil Babka (SUSE) wrote:
> Users of include/linux/memcontrol.h don't need to see this internal
> structure. Further changes to the struct will reduce recompiling.
>=20
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------GcZskzVFCTVPbbHA49fLBI3E--

--------------erUdOoVxhVjluo2iVkSPasJs
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCal8J7AAKCRCGXBN6rc5S
1lgLAP4su2fsXdwSFi7bi0OfSRrrqacuZyGdHgCgzBgFKtrMlwD/Tuz/xDlfjgkk
JIJBgYri4MiQpJ48eeEMBBVzDmcBlAE=
=mB45
-----END PGP SIGNATURE-----

--------------erUdOoVxhVjluo2iVkSPasJs--
