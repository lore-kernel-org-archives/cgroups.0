Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEB339EB47;
	Wed, 17 Jun 2026 09:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781689296; cv=none; b=RFfQggAwM31ZOAHO7KTIK13bt9HEBLAzZcaE7CCvH3vNH8oprDjs6sWEqhPfQYG2nlunwfSdZyjn5jncollivvA9+/FZG0yl3ACpxIOHiL8aT35QsBkVANUK7ica0La73CfQRL/F6q1emCD8InDGebOUc9u+qWoCOB9ijHpEXhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781689296; c=relaxed/simple;
	bh=EhVnlaeWy51i332FkkRSnATGu/gcTTZDhA4Pju0BgpY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ag6RzbnoU44VonATXzkzU/i18gugiW/Z1FWtNlfeauiUHV4k9P9gW6TLA9Ux3dHIRW2HB1336B2Hvv3JieeLYX+H4sgBdGLUx+8ELOHvdzvdCIezhLlxrG2zbTEnbNT0sQ4+bepo3wRELXv1C0dxChtSVZYnOw6wW0z99g3w3QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PLoQt4z7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PLoQt4z7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD4F1F000E9;
	Wed, 17 Jun 2026 09:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781689295;
	bh=EhVnlaeWy51i332FkkRSnATGu/gcTTZDhA4Pju0BgpY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PLoQt4z72cDxJHgYQ0yqHHgNPRO+zqtWA+o3dYvlIDiHzKxz8ciYXxJ8fKjyVbfns
	 VVS5cMC3hM5cLM02sTcXPTAwQMWL+zgUG7oxDsT6v9sVZFs53d+Exl/pibM5+96jZ/
	 bP4cR5Mr6uD1diNymHyW6Mc//IvG5OSRVOUrc02J5S6hiYp1shvGLVjtGCVnMixMyl
	 6l8E3ZuIaBM0LIOF5E9xIt1G8KOCTS0kA1rDFHcUCWzC1cB6AwHapfg4aRd8JIypld
	 nUlLpC/VxojHdhDtyORQb/Hy86jQsUxCFATqCkYAj/mxD1+TRFujIFpK6PPGIRFKS+
	 N4GNUb6sNBzVQ==
Message-ID: <1d316e8a-ef76-4648-8b89-387abcc5aa9b@kernel.org>
Date: Wed, 17 Jun 2026 18:41:26 +0900
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/15] mm/slab: allow __GFP_NOMEMALLOC and __GFP_NOWARN
 for kmalloc_nolock()
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
 <20260615-slab_alloc_flags-v3-12-ce1146d140fb@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-12-ce1146d140fb@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------peA90eEEkmps0M3XHjD0gcDF"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------peA90eEEkmps0M3XHjD0gcDF
Content-Type: multipart/mixed; boundary="------------q0l0JaIkWSVOLvsG2IexwP2d";
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
Message-ID: <1d316e8a-ef76-4648-8b89-387abcc5aa9b@kernel.org>
Subject: Re: [PATCH v3 12/15] mm/slab: allow __GFP_NOMEMALLOC and __GFP_NOWARN
 for kmalloc_nolock()
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-12-ce1146d140fb@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-12-ce1146d140fb@kernel.org>

--------------q0l0JaIkWSVOLvsG2IexwP2d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/15/26 8:54 PM, Vlastimil Babka (SUSE) wrote:
> The two flags are added internally so there's no point for warning if
> they are passed by the caller as well, so allow them. This will allow
> simplifying obj_ext allocation under kmalloc_nolock().
>=20
> Also it's not necessary to have the extra alloc_gfp variable for adding=

> the two flags. The original gfp_flags parameter is not used anywhere
> except for the warning. So remove alloc_gfp and directly modify and use=

> gfp_flags everywhere.
>=20
> Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-13-7190909d=
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

--------------q0l0JaIkWSVOLvsG2IexwP2d--

--------------peA90eEEkmps0M3XHjD0gcDF
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajJrxgAKCRCGXBN6rc5S
1hGmAP4or0hJp7BdgqqdydN0Yg1bEOvqzn/BMhkyTo9925/d5gD+Pt2WkRSPEHY8
2zHVmYiz9qd1DYIFZfHEq97ffG2dWgQ=
=TNIQ
-----END PGP SIGNATURE-----

--------------peA90eEEkmps0M3XHjD0gcDF--
