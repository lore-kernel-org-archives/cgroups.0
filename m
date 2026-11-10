Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794354373;
	b=fqHptHE4WlGn5vepJKjknxT/adwwfjZSmBtnaD02lm2i2GZJgX2oOLqffuuSFhyCxs6b
	 nHip/SpKBSV4gj2ZH958Ygvch96imOfQlDILvNgnFNN+tfJR02WJYs6Hs7GiIPi8ASiv6
	 44qUQ8XNPKKQhM5v0stYZUpl9MKEfakLbnZIAC/05ExhX2jkEmkiE7w1eLZPN1IlKee3U
	 PlGAMx8icDnJ/mhE+DVVQ628dMkpQwm/qGRgpu0icUtfviQIO+Loz1GGQ+urGzUSOb9sB
	 Dcf/KosWvLMk8JnIo/tCXz9pcXeWGDNHPDeeNwNteHde+vyM65dqEAyNFZCqfvSRZZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794354373;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=bV6upzA5StR1b1wyNZFKOklGx4ha7k0DQuLrcpokU8o=;
	b=fIbOfTiIrIL5BPXNO3IKRRvMP5Pp02YviP1vzhhdK9EQWPtLvA4l1AEN9P16SUiid4ga
	 0ytEJ32Kxrh19AeZmCjLrfJh+i/cTPiEXQkixpV3NvUBwT0X4+Efs2GNElpyb0EyXgAjz
	 CiXeMR4I2viFwNglZrCf0yuuTQxVBcOkw5JsVZ0glJfc9cNBMn1eEV6ehxfWSNVQ4zRyA
	 acBPSIIIpHCQULL2V3qSA3HdOt5TvEH+iMU+Ss5/XCbmf9XEK+zX0K3GqJshMRo+EDTYf
	 soaIdepA4nuneqvl6Mgy5f51rk61HtDTpHcW/uhdNJoWhUliU1TgVHvVUKJjBQQHuoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iY8KHlhx;
	arc=none smtp.remote-ip=95.215.58.30
Received: from mta1.migadu.com (out-30.mta1.migadu.com [95.215.58.30])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3BE606A31C
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 23:46:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE3BE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iY8KHlhx
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=bV6upzA5StR1b1wyNZFKOklGx4ha7k0DQuLrcpokU8o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794354369; v=1; x=1794959169;
 b=iY8KHlhxHAGrs3qH58ofiN470cF1KdSVutOe7C6fCq4lJChwUZ2UGV6ybT44OovBxCBR8QGD
 wGJH3G17G8JmKCGR4BQpkXJ81F1ldIXm4IXalSaAKAw1suM8hQWFBqQUEugyhCH3cH0kztOpi4r
 P4bXuooTIpIQ4I0IonLP7vkI=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id da08650cc9e97235;
	Tue, 10 Nov 2026 23:46:09 +0000
X-Mizu-Trace-ID: da08650cc9e97235
X-Migadu-Flow: FLOW_OUT
Date: Tue, 10 Nov 2026 15:46:07 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Noah Feldt <noah@feldt.systems>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Karl Erik Hofseth <karl.e.hofseth@opoint.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	regressions@lists.linux.dev
Subject: Re: [REGRESSION] mm/memcg: list_del corruption on memcg LRU on
 7.2.11 despite bf4ade7dbd76 (single NUMA node machines)
Message-ID: <avOsiy7kGWpehKJn@linux.dev>
References: <20261110132853.71228-1-noah@feldt.systems>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110132853.71228-1-noah@feldt.systems>

Hi Noah, thanks for the report. Can you please first test without MGLRU and see
if you are still seeing crashes?

Shakeel
