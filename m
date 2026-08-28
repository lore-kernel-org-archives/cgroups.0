Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED69F4562A9;
	Fri, 28 Aug 2026 14:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.67.55.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787928985; cv=none; b=dCCYtCWdapDPzy11C0wEraYM5yBYaHEqDxAbfzHHHT/WY0ezHQicH5NsxxDMaQotb+6SIyCjKAqEbkX0OM+eKYPcf+L8yhD6oVekOQ8VjyDCaVHB5tQLBQqzUyl6aCmqG2GCsviB9k25mbaENuWLW4+n17hTaISCaHEKo6bL/SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787928985; c=relaxed/simple;
	bh=QNN1FbraT595Q11XA02C0sYLaM9WhKZgaK9e6slIEqQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=phjIj53pj27xX8B9QbMBG/HfZz3iQu2uUerR+hk/KU+bvANvqcajVzPHn9jEdJEdiLGQLS3k7tTY2KjLNVjWybF2nDgPTxg6KKsIm//0iypraiMa2u7ZUljGLlC8If7CyeOXkheBbSSuZTlabHEcuOPRA6ZYnDSlYCjgYTAWLzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com; spf=pass smtp.mailfrom=surriel.com; dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b=Z9+c10CH; arc=none smtp.client-ip=96.67.55.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=surriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b="Z9+c10CH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=QNN1FbraT595Q11XA02C0sYLaM9WhKZgaK9e6slIEqQ=; b=Z9+c10
	CHQsAIKPsu5BTOt4bT7Ut38E38KJiwuY6T/cR9LP2p40WiLdIpCOR26xZFl1I7f2p/SkgQ9lHcWai
	INvQZJLMwANHdk4tDfu6MyXTAMJOssfXST8+fCGAtTbiD/RCqp9yuRlPwpIdE7yidzm/PYCxj0v/l
	W1ZtAa0K9iS6sS+uFmylrTojppcwNpQ8f/jn1Z6w8Aqohdn1/ll8feeITbwi4X4lxYe7o8ws4TICk
	fIsZ8qFYRpOFVUfTQjqj4qBvp9N/cEwWYySyCkr0ZqS8xNyDWTVeTru4W7Z0DDkmQbDDdNGHGnOP3
	2HgMI/nS3sQDYFiiyfYweZjivRsg==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wzy0A-000000090vY-2pUQ;
	Fri, 28 Aug 2026 14:56:18 +0000
Message-ID: <34c252862494db8432c702efec4543daa11ff392.camel@surriel.com>
Subject: Re: [PATCH] mm/memcontrol: avoid stuck FLUSHING_CACHED_CHARGE bit
 on isolated cpus
From: Rik van Riel <riel@surriel.com>
To: Michal Hocko <mhocko@suse.com>
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song	 <muchun.song@linux.dev>, Andrew
 Morton <akpm@linux-foundation.org>, 	cgroups@vger.kernel.org,
 linux-mm@kvack.org, kernel-team@meta.com, 	stable@vger.kernel.org
Date: Fri, 28 Aug 2026 10:56:17 -0400
In-Reply-To: <apGaZdxAPH68kkCc@tiehlicka>
References: <cover.1787890328.git.riel@surriel.com>
	 <a611f2bc40d30f9c14a6f41b173185975c46a203.1787890328.git.riel@surriel.com>
	 <apGaZdxAPH68kkCc@tiehlicka>
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

On Fri, 2026-08-28 at 16:25 +0200, Michal Hocko wrote:
> On Fri 28-08-26 09:46:21, Rik van Riel wrote:
> > drain_all_stock() can leave FLUSHING_CACHED_CHARGE set after the
> > work is dropped.=C2=A0 It sets the bit before checking isolation and
> > schedule_drain_work() checks isolation and queues in a separate RCU
> > critical section, so housekeeping_update()'s synchronize_rcu() can
> > race the second check.
> >=20
> > drain_local_stock() only clears the bit for work that ran, so the
> > bit
> > remains set and the stock is never drained again.
> >=20
> > Reorganize the drain_all_stock() loop, reducing nesting, splitting
> > out local vs remote cpu handling, and skipping everything on
> > isolated
> > cpus, which solves the stuck FLUSHING_CACHED_CHARGE flag.
>=20
> Is there any reason why we cannot simply clear the flag if the work
> is
> not scheduled?
>=20
That should work, too.

I'm fine with whatever variant people prefer.

--=20
All Rights Reversed.
