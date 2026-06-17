Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799803C1F;
	Wed, 17 Jun 2026 11:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781694993; cv=none; b=hbRhRUW1rZ7VASrLXJ+6jEKwLfxpAVNzXBeuz2ZBLMqpf+ruHatcHpP6tA88DU32RGqF/tB4e4/6BsUpG1GxD8RAGpeAVbKp9STP12Zbv7Tawf0s5MtQnZnsq+d8rmgz4lM5mFfXa/QZULLD0WJzagiqt7mZWX4ap6vMaSyXAuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781694993; c=relaxed/simple;
	bh=2rnPd2MSt1vwOoN5rRd8/PQGwWGmqtToaNtSJ9AESsw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=an7++ub9SEPyGmzFKl7FHaXuQeVakMjk9iciA1VFxzNcgA1PbfXnLiRZKpdQmynxyusSTDEh3qTGhrpiaAwnG2QPtPrssJgW0+BSws6DqJozCCDP6zkO/Mr31DRsyRNihWPr8OFzkQm8u0c+hzcnZOdTQb4UWLAXvN3kNzyTChM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gOoZArdh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gOoZArdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF641F000E9;
	Wed, 17 Jun 2026 11:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781694992;
	bh=2rnPd2MSt1vwOoN5rRd8/PQGwWGmqtToaNtSJ9AESsw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gOoZArdhBL5WquhQUqQhY90uMk+cX0ytq2vILPFsG04Kcu7pbgM+rJlgZGYKmAV+Z
	 EeDMupv5/vAOrRL6BHCjH/aZiBD4lwt8Fywe4QNYbU38ljKy/62HpEdz4L2uhDw+He
	 oPedq2y1GqHboyOLFSU8/J+FznBem5XaepHdcIF0u1uk1dG4cOAokcIeY9pfcOyqee
	 J6PtH9dOvJPxNZT61rXHn9IPaXYdsEtZpighL7/LkZyd5pukIsJZSBTN39pVwOy2zB
	 yT3f9aw3wxyKNmPccs60UW1AminTZTAhbuH3yiD6FsSDgfZfI+PHFzyyPx1TTRZNkO
	 FkAzeejkhaf+Q==
Message-ID: <22d6cf47-b8cd-4495-8b33-2e9d645fac3d@kernel.org>
Date: Wed, 17 Jun 2026 20:16:23 +0900
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/15] mm/slab: introduce kmalloc_flags()
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
 <20260615-slab_alloc_flags-v3-13-ce1146d140fb@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-13-ce1146d140fb@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------h0Nqf9c0wfHouf0LoBxkrjqk"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------h0Nqf9c0wfHouf0LoBxkrjqk
Content-Type: multipart/mixed; boundary="------------2QCMyJtDnYVZ8sn4T36zDC4w";
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
Message-ID: <22d6cf47-b8cd-4495-8b33-2e9d645fac3d@kernel.org>
Subject: Re: [PATCH v3 13/15] mm/slab: introduce kmalloc_flags()
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-13-ce1146d140fb@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-13-ce1146d140fb@kernel.org>

--------------2QCMyJtDnYVZ8sn4T36zDC4w
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/15/26 8:54 PM, Vlastimil Babka (SUSE) wrote:
> With alloc_flags usage in slab, we can replace __GFP_NO_OBJ_EXT with an=

> alloc flag that prevents kmalloc recursion. For that we need a version
> of kmalloc() that takes alloc_flags and use it in places that perform
> these potentially recursive kmalloc allocations (of sheaves or obj_ext
> arrays).
>=20
> Add this function, named kmalloc_flags(). Right now it's only useful fo=
r
> these nested allocations, so it doesn't need to optimize build-time
> constant sizes like kmalloc() or kmalloc_buckets.
>=20
> Since we need it to support both normal and non-spinning
> kmalloc_nolock() context through the SLAB_ALLOC_NOLOCK flag, split out
> most of the special _kmalloc_nolock_noprof() implementation to
> __kmalloc_nolock_noprof() that takes a slab_alloc_context, and make
> _kmalloc_nolock_noprof() a simple tail calling wrapper with the proper
> context.
>=20
> kmalloc_flags() can thus determine whether to call
> __kmalloc_nolock_noprof() or __do_kmalloc_node(), based on the
> given alloc_flags.
>=20
> Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-14-7190909d=
b118@kernel.org
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------2QCMyJtDnYVZ8sn4T36zDC4w--

--------------h0Nqf9c0wfHouf0LoBxkrjqk
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajKCBwAKCRCGXBN6rc5S
1iFIAP0XkxFaf0DXeb833MFb+xoznKV7cfz9DIc3UD2ItuB5IwD9Gh1fUPp8WVuw
KG12x0NvvlNEQNDeaqbaj9R9mbmYCgg=
=04dK
-----END PGP SIGNATURE-----

--------------h0Nqf9c0wfHouf0LoBxkrjqk--
