Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B313B813D;
	Fri, 28 Aug 2026 20:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.67.55.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787947309; cv=none; b=uhtTFQEJZLVKxG1VSSz/3lgCD//C/cmjMJKLhbDUuslvU3j6K+q6ZpqBzrAW+4rQCBwmkfllHHXd5NQDdNEsMLFQiAcrtZu0TwycNZmc3iR9ng26HgZNkepiiFFCnvQ1m17iCbxs/AM7T0zoYgb/sTM0d2Z+C6d1XisuYHzChz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787947309; c=relaxed/simple;
	bh=razbEjG7v/vD2MHf2Nl4LqxEc42lTPrbwDbu0D1xjpk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=icDxy0y8/NsPvB4m0Tt07zIScOmAkFqmqSeMKU5AQ46Zur8rKIAZ+z7R84Uo2laUtgR2g3d/4CoO13+tdefRl00zR/KAZ1YDLZXzGbhuQfXm+cNhk4BG/2E0tSIZW+Cj25NRRgkv5zXk5KiZxzMHNv1tJrsF7iNV2+QJfuxbnck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com; spf=pass smtp.mailfrom=surriel.com; dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b=catOVLyk; arc=none smtp.client-ip=96.67.55.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=surriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b="catOVLyk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=razbEjG7v/vD2MHf2Nl4LqxEc42lTPrbwDbu0D1xjpk=; b=catOVL
	ykWz8eTaecnMjoIwEXNOk8AP4KT3M27FLQ5wFnaret64xgZKxQzMo7F6s0QVhW+OBy9Lv9Zk0UYxa
	F8MFlVgaBXL9p4fpC+ihSTBCCDYoxDjeNG1tYhUKpPe1eXntG72pbpUaltBuL+d2gkWkg8hXR4ODR
	XgShWAy6W4TRJ/YXwRWK/ahuiy3x6Zo5giUIJ8n5l6Nine6RXNOOa4G7b69n0pMOHhyjCwW3cQFlg
	x5g1nG3+InZdwndZvImTdUJdAC8Zjjp1JxH8QF7Hq53+OBIT2U+qrnQhYxe+D2/CI+/TO3Trj5D55
	NtMMtkvMpGyM62Pl90qMoN/l4nQw==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x02lg-00000009622-1Ell;
	Fri, 28 Aug 2026 20:01:40 +0000
Message-ID: <58177d60a0d6842aa40104d16021829468205d3b.camel@surriel.com>
Subject: Re: [PATCH v2] mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit
 on isolated cpus
From: Rik van Riel <riel@surriel.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt
	 <shakeel.butt@linux.dev>
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Muchun Song	 <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, 	kernel-team@meta.com
Date: Fri, 28 Aug 2026 16:01:40 -0400
In-Reply-To: <20260828125509.83d2e242534c2209ca253504@linux-foundation.org>
References: <20260828135036.7d44361f@fangorn>
		<20260828122018.1a3b3be204212837fcda8e50@linux-foundation.org>
		<apHgs2ZAxAdy8WIH@linux.dev>
	 <20260828125509.83d2e242534c2209ca253504@linux-foundation.org>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-08-28 at 12:55 -0700, Andrew Morton wrote:
>=20
> Cool.
>=20
> And... guess what?
> =09
> https://sashiko.dev/#/patchset/20260828192419.3057939-1-shakeel.butt@
> linux.dev

That one should be fixed by this patch you merged earlier:

mm-memcontrol-fix-stuck-flushing_cached_charge-bit-on-isolated-
cpus.patch

--=20
All Rights Reversed.
