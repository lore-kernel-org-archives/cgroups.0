Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339EE2E63C
	for <cgroups@vger.kernel.org>; Mon, 20 Apr 2026 16:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701794; cv=none; b=N2Rekebfq4bo7xFGVoi2kgff5/Eg10aNVA2tyuLGKV3jXibfEyddrcyThx31wBKv/hkxC0iiPqFx0oI6t8Hu3S/qMskVf9WpBFPlg/MMySRuFWEJjljaXLbr3JZXDxRu9OeQcwTZgVGHtBPWr5R15/A8nLNuJ0wlW9HUgH1Xcpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701794; c=relaxed/simple;
	bh=/YI39KJ2yAi4fNqIiMjjCxkb5981wqwFW6FGVOLrb7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QQLcbDO5ggBldLSE3aRxTlFYpuB97BbmqTJqBZw2/r2aLvW7t46RrseKZ/2p3c75dEpsHh5y1h0JOwi9kl2Ks5vIJqtb5HskLGtpPwQqNWc4mwHAPIvjz1ejOFNHvQTGIH4LOizbP9w+ouxyffUXTvGre/homUZuRzcgIHczkr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PkoS9SE5; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PkoS9SE5"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-488b8bc6bc9so22606455e9.3
        for <cgroups@vger.kernel.org>; Mon, 20 Apr 2026 09:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776701790; x=1777306590; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kKz8O8Bg6tLUv4xMMvhQo3UjBvO97yFHrMS0cTqMTEI=;
        b=PkoS9SE5jVFGziaVYPTRBzi2CO8iZ9vkgGNQIPg9y4Rexi3cFv1ztSG8ek8e/ZyK9D
         HCGVmU/69PYJQXb5ZFCAiiuf/8KcyQ4YWzAuc2ZYS498kayFWAJekUHfgNTKLvMKGjM+
         E62rxSF5s373K1ctJ395489kpllCiLgq84qmVJ1U168qghaBxaS2M17iY5EDIGL4HaFN
         G24r8nZPhq6QAwwu962mYPWaEgmKzeKu+HQo0Fwgw93aq8qz1wDYovOUwye8O7Hrn/o3
         fpDH+mzSPuWunVJTSyN5AB5ieZwDxX7f7qHo+oV4s7OGeaYPJLHHRqGyf6jA0P8KSA7K
         0T8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776701790; x=1777306590;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kKz8O8Bg6tLUv4xMMvhQo3UjBvO97yFHrMS0cTqMTEI=;
        b=gq8AdoWXmxA+R6BH9Wfs7hI0nOrDJpFx/cXNp8GhNsUN5GM5x9FLDb6edsYaqMbVBg
         pf2z3ipPnqh/9gEI2WINe+Rtfm14+nqNy688pYtR4iId6Do47+M1HIaWczULr908/np1
         Et/yarEV0z6BeYM3+S193/A0seMuWH/ojpfzxe94/EeUMoWyCv6lomdhIYrNRAy++Vh7
         g1m/mzpUExY9B6qjAJwGA2IDSJANkrgD1WVG2EejxMkcY2aECmpICQjcQn3Eq1Uj2pSE
         wUPL9RVvrJhetiXT5b8ThZNg4bsoJjZE/y4tAUjk8ZgnFFlVtaRBFZ9ohEUocIJHZGNb
         YXfw==
X-Forwarded-Encrypted: i=1; AFNElJ/33NHupdFiA2nXGRqvp9DjODeupOJp24ycZJ9Q5XnT2GZRxTOtvsR9ntycp1Y80J5lpoUZmfTe@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1xxs1ad7JVhI/1zAa3LRKfkcTcUufg4I/BAiPikxFAOJThkZQ
	EmU1CaJCQzyhici6N3nEGDR0r2JgE3whKOyv5mv9Do0IDh4ONURTBULoJfPRE/DQ4Oc=
X-Gm-Gg: AeBDievP5XNs5+zUjbq5cFzVWJdGCKp6JrvNBsLOMXfD43Yw+N3LqY3fOkMUrxHZOwh
	PVJGAH2Eu+t3ttVTdjlD1i6kYFs/KBdyjQNKUXd3ga78gZJwtRp3LtKPvFMd2o8VInlFja62uJ1
	u1iz7TMZHXmRGBU7/CLSL5zl7P/MFoUMM9KuK10ANV5ghEPDN//pzIWY4TelTrlfUXe5q7XmQmz
	GT2n6Cbiws7754RAhFBHh+pLxdUMAR9fRZLHvdhurfFYZhgHASwk2C5RdF7srRplLSBnZ0yPDDf
	1rwWMcvgxszdgzGzK1Nsj+BJLYEHpSDXEZltvDT6XZEvhr7OZ19E7wAdEh8AnkAmNOU95HAiyRN
	09antJkcsnzgRzZoqPATmOrB9H7vG4icjyu6HKByQ91AJHzDma7oSYHeol87qLcA9W5YGFp8P8z
	WP+0daIfL7GMfm7Lr+B4LOSbNTfCfOt12qwrlYhfVnP5WS1L7HSwq1RTN5UtC05464
X-Received: by 2002:a05:600c:705:b0:489:1c09:6c4b with SMTP id 5b1f17b1804b1-4891c096dadmr42584455e9.6.1776701790387;
        Mon, 20 Apr 2026 09:16:30 -0700 (PDT)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc140c82sm272893225e9.12.2026.04.20.09.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 09:16:29 -0700 (PDT)
Date: Mon, 20 Apr 2026 18:16:27 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: Maarten Lankhorst <dev@lankhorst.se>, 
	Maxime Ripard <mripard@kernel.org>, Natalie Vock <natalie.vock@gmx.de>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-kernel@vger.kernel.org, kernel-dev@igalia.com
Subject: Re: [PATCH v3] cgroup/dmem: allow max to be set below current usage
Message-ID: <lgkacelr76hf4yw2wb7tqevt52cakmxjnq4ww5ij5m46fdbufz@sxffiuqv5mze>
References: <20260326-dmem_max_ebusy-v3-1-8e62c06e2767@igalia.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3d3ztmeih5rgjpsw"
Content-Disposition: inline
In-Reply-To: <20260326-dmem_max_ebusy-v3-1-8e62c06e2767@igalia.com>


--3d3ztmeih5rgjpsw
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3] cgroup/dmem: allow max to be set below current usage
MIME-Version: 1.0

On Thu, Mar 26, 2026 at 12:18:17PM -0300, Thadeu Lima de Souza Cascardo <ca=
scardo@igalia.com> wrote:
> page_counter_set_max may return -EBUSY in case the current usage is above
> the new max. When writing to dmem.max, this error is ignored and the new
> max is not set.
>=20
> Instead of using page_counter_set_max when writing to dmem.max, atomically
> update its value irrespective of the current usage.
>=20
> Since there is no current mechanism to evict a given dmemcg pool, this wi=
ll
> at least prevent the current usage from growing any further.
>=20
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
> ---
> When writing to dmem.max, it was noticed that some writes did not take
> effect, even though the write was successful.
>=20
> It turns out that page_counter_set_max checks if the new max value is abo=
ve
> the current usage and returns -EBUSY in case it is, which was being ignor=
ed
> by dmemcg_limit_write.
>=20
> It was also noticed that when setting limits for multiple regions in a
> single write, while setting one region's limit may fail, others might have
> succeeded before. Tejun Heo brought up that this breaks atomicity.
>=20
> Maarten Lankhorst and Michal Koutn=FD have brought up that instead of
> failing, setting max below the current usage should behave like memcg and
> start eviction until usage goes below the new max.
>=20
> However, since there is no current mechanism to evict a given region, they
> suggest that setting the new max will at least prevent further allocation=
s.
>=20
> v1 kept the multiple region support when writing to limit files, while
> returning -EBUSY as soon as setting a region's max was above the usage.
>=20
> v2 only allows setting a single region limit per write, while allowing any
> new max to be set.
>=20
> This version (v3) still allows multiple regions to be set, and explains w=
hy
> page_counter_set_max is not used anymore.
>=20
> I am sending this version dropping the multiple region restriction for no=
w,
> as we continue to discuss whether it should be supported or not.
> ---
> Changes in v3:
> - Dropped first patch as it was already applied.
> - Added comment explaining why page_counter_set_max is not used.
> - Dropped patch restricting multiple regions to be set for now.
> - Link to v2: https://lore.kernel.org/r/20260319-dmem_max_ebusy-v2-0-b5ce=
97205269@igalia.com
>=20
> Changes in v2:
> - Remove support for setting multiple regions' limits.
> - Allow any new max limit to be set.
> - Link to v1: https://lore.kernel.org/r/20260318-dmem_max_ebusy-v1-1-b7e4=
61157b29@igalia.com
> ---
>  kernel/cgroup/dmem.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)

Acked-by: Michal Koutn=FD <mkoutny@suse.com>

--3d3ztmeih5rgjpsw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaeZRVxsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AhzsQEAzPlmclbTBSjout7PKHMK
X2eS3vMMTL5GqvW4QTX4niIBAInu/w6ghv2COtKTh59vIBfVFnygNqm6o/nWsjt6
wDIG
=XmJr
-----END PGP SIGNATURE-----

--3d3ztmeih5rgjpsw--
