Received: from mta1.migadu.com (out-124.mta1.migadu.com [95.215.58.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C544EBAC9
	for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 13:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792071016; cv=none; b=KrdsxM4WAJe25NRBq2Cc+MabX1O7WqI6qGkOF9iMzNloSQGG+gWJSaZA/vRhdKhtMWt4ocPgK8I31Y571CCa45SIO6Egxh8q4OcuRR/As+XhP+2bLaQEvm6JCIkEbTZv6+Mc2dlqx92bCKZaOK5E5WKnvcPeVjQ1Eyx7ZnN0lbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792071016; c=relaxed/simple;
	bh=IoGIAHnaQYST5KBMu9mjyBm9EH/F3O3WcIGndcQBSbg=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=rttchbdeUdNhjJNNdMh441lKddQ0W0o2wvPyyaDudV83QvBjFyI11TftjaTOKMxgqmOdrl7zVTPHff/UAFyJyvN6clRveGdiy13ASrKzz0O1C3HNmXhd/8X/NiMOfZRFxgvaiRd46qep1KJ4Bam9yc/a4mnuHt/2u1I+6/IlXEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HLlbXrol; arc=none smtp.client-ip=95.215.58.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HLlbXrol"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=IoGIAHnaQYST5KBMu9mjyBm9EH/F3O3WcIGndcQBSbg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792071012; v=1; x=1792675812;
 b=HLlbXrolhzSGq6VTDnJEVL7uridJQRkT8icRjHU8BTGs/g2SEmFCg7MSPl5jdNBv7+nG6w9G
 n41zbw9IcEUlzQ7uYs9+iCfBtyPONW6UeRaStBvlyxk3fINtt/UKo1OS5mFjlNJyR0GufXTqNmW
 6SjO9wBXwSo7Dwwee+nkkMk0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id f4361a04069a03d7;
	Thu, 15 Oct 2026 13:30:10 +0000
X-Mizu-Trace-ID: f4361a04069a03d7
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Muchun Song <muchun.song@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2 0/2] mm/shrinker: make per-memcg shrinker units cheaper
Date: Thu, 15 Oct 2026 21:29:37 +0800
Message-Id: <25784AE4-EE4B-4B15-A436-17F98354C10A@linux.dev>
References: <84c9e97b-67c0-4c9b-bb7d-81811af8a16b@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
In-Reply-To: <84c9e97b-67c0-4c9b-bb7d-81811af8a16b@virtuozzo.com>
To: Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: iPhone Mail (24A446)



> On Oct 15, 2026, at 19:42, Konstantin Khorenko <khorenko@virtuozzo.com> wr=
ote:
>=20
> =EF=BB=BFOn 10/14/26 22:50, Andrew Morton wrote:
>>> On Wed, 14 Oct 2026 16:54:36 +0200 Konstantin Khorenko <khorenko@virtuoz=
zo.com> wrote:
>>>=20
>>> Every memory cgroup allocates, per NUMA node, one shrinker_info_unit
>>> per 64 memcg-aware shrinker ids up to shrinker_nr_max, whether or not it=

>>> ever charges an object to those shrinkers. Every superblock registers
>>> such a shrinker, so the cost is
>>>=20
>>>  memory cgroups x NUMA nodes x shrinker_nr_max / 64 x 1 KiB
>>>=20
>>> because the unit is 520 bytes and comes from kmalloc-1k.
>>=20
>> So we could almost halve this just by using a dedicated kmem_cache?
>=20
> Yeap, a dedicated cache gets approximately the same cost per shrinker id.
> On a 48-CPU box SLUB puts 31 units in an order-2 slab, about 528 bytes eac=
h:
>=20
>                                      ids/unit  bytes/unit  bytes/id
>    today, kmalloc-1k                    64        1024        16
>    patch 1, kmalloc-512                 63         512       ~8.1
>    dedicated cache                      64        ~528       ~8.3
>    dedicated cache, HWCACHE_ALIGN       64         576        9
>=20
> So the two are ~equal on memory, and the choice is about the code.
>=20
> I went with 63 ids per unit because the unit then simply fills the
> kmalloc slot it already comes from.
>=20
> The price is an odd SHRINKER_UNIT_BITS and roundup() instead of round_up()=
,
> plus the static_assert.
>=20
> If you prefer the cache, I'm happy to redo patch 1 that way.
> Patch 2 does not care about the unit size.

Please use a dedicated cache, more straightforward for me. But also give som=
e time to maintainers for reviewing the patch 2 before your update.

Thanks.

>=20
> --
> Best regards,
> Konstantin
>=20
