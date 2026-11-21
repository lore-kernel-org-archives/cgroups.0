Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795230684;
	b=Vdy5zTxkhfFa1Gn5gEXY6gszVJCBDISTaNd93labMUQlLsTRGgFZcL9pLc6ljt5Hjoa/
	 lieJO5InvRAEMOLfIT4RgwN2SUVwgvrYckKg6hE0yJy4T3EXJnLeTPlbJZWSrz1qQeQ05
	 3NG/UZFlVwdTQzZ9bSpXpv4B+8Ph2vpeqnXjRoaKxXiFb16ckr0yrW5qeqA2yUuqkHYyl
	 6VIZL7gxeLlwLZve1LkKykdt612JJie/22mb6mLN1gRf2EtsvCJ8R8R14lKfpQzbjn1xr
	 b/Y6plvFoDnZCM9qcL3I+eajoZPakF8ZEVOGJdJdhCpLxK38kDjE3fkxJJdqMPL0RDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795230684;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=r1VxHdvjTAQqwIi48lBUjfmQrAuXiHwG2H/BM8QNl/s=;
	b=ftWeFuLES/7ijOvTt2Za0qGNV0oWJm7btZ1tpX3P3usgah0Sj2E5VeZHmaLJ5O+JIJdQ
	 gdsgKuZIOmgIa9vBWM98Q1xdpTDsM/M+sjXjlKjaDjpcqCpWpyB5Uu3ubszBgaYpvvjEi
	 nsO6Jdjq24H61Hw2XdqFdmOi1oq4/lJCCIK6h2YUD65cOTPLJe5ArXsPvy+2LDR1rGOlM
	 +qs8/C7zmQWd8NFIuLKpOQYSzmy7jTwvWHsH97PCpJLI7pprWVz8LGDNBGP9xKjlFfTsb
	 wfXrgy0N0GPWZpgG4xS/x1UhsOCmNIJLLlwRgCS7enGTo7XpHZ5Qtt16rvEFkZcysaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="BS/bHeTg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E854606A69F;
	Sat, 21 Nov 2026 03:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BS/bHeTg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367791F000D3;
	Sat, 21 Nov 2026 03:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795230683;
	bh=r1VxHdvjTAQqwIi48lBUjfmQrAuXiHwG2H/BM8QNl/s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=BS/bHeTg3i9yU0iRDPP1R3YfsQF2x6YPJyg+rvwjV5aN7f+0+yUx8P8u9mlS80Oo3
	 BPCIXLXGgacppWIdgofzZFrDrkTqR4JQQFDYA5YxFgLRH4arI9Fwo+StBe/bXn2zuW
	 l+TWeOp7WX0bejBF9sukOBw4cN+yK2Evl673poBs=
Date: Fri, 20 Nov 2026 19:11:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, mkoutny@suse.com,
 david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 usama.arif@linux.dev, david@fromorbit.com, qi.zheng@linux.dev,
 yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev,
 xlpang@linux.alibaba.com, ryncsn@gmail.com, gourry@gourry.net,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 RESEND 0/5] mm: restore per-memcg reclaim for NONSLAB
 shrinkers under nokmem
Message-Id: <20261120191122.f31167fc1c987196e5a0b86b@linux-foundation.org>
In-Reply-To: <565e4075-2788-4310-8309-7739b9ee94ed@linux.alibaba.com>
References: <20261105092233.3558950-1-qinyuntan@linux.alibaba.com>
	<20261109215053.85df5685da951ab47ef858f1@linux-foundation.org>
	<565e4075-2788-4310-8309-7739b9ee94ed@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 20 Nov 2026 15:04:37 +0800 Qinyun Tan <qinyuntan@linux.alibaba.com> wrote:

> 
> >> objects of all cgroups share one list per node: the per-memcg
> >> shrinker bit is only set for whichever memcg happens to repopulate
> >> the empty list, so pressure in other cgroups may not even trigger
> >> the scan, and when it does, the scan walks everyone's objects.
> > 
> > Thanks.  Sashiko still has significant-sounding things to say:
> > 
> > 	https://sashiko.dev/#/patchset/20261105092233.3558950-1-qinyuntan@linux.alibaba.com
> > 
> > It also says "failed" for reasons I don't understand and it doesn't
> > seem to have emailed anyone.  Please check it out?
> 
> 
> Hi Andrew,
> 
> Sorry it's taken me this long to get back to you. I've had a very busy
> couple of weeks.
> 
> Thanks for pointing me to the report. I looked into the two issues
> Sashiko flagged in patch 2/5.
> 
> Sashiko pointed out that mem_cgroup_id() identifies the cgroup
> directory. We reproduced the ID collision on v4: after disabling and
> re-enabling the memory controller on the same cgroup, the old and new
> memcgs had the same mem_cgroup_id(). Once the new memcg has its own
> LRU list, a lookup for the old memcg can therefore find the new list.
> 
> I think memcg->css.id would be a better fit for the list_lru index.
> Each per-memcg list belongs to a particular memory CSS, and its ID can
> only be reused after the last reference to that CSS is dropped and an
> RCU grace period has elapsed. That keeps the indices distinct for as
> long as the old CSS can still be accessed.

Yes, it sounds like ->css.id better matches the lifetime needs.  And
the root memcg list_lru retains index=0?

> The second finding is the same race that Shakeel's patch [1] addresses.
> It predates this series: a folio can move to the root memcg between
> the two lookups in folio_memcg_list_lru_alloc(). Shakeel's patch
> rechecks whether allocation is needed after taking the memcg reference.
> That also prevents the unnecessary allocation at index 0 that Sashiko
> flagged in v4.
> 
> Does using the CSS ID for the list_lru index sound reasonable? I'd be
> happy to incorporate any suggestions and send a v5.

Shakeel has a couple of related fixes in mm-usable ("mm: list_lru: fix
NULL deref when a folio moves to the root memcg" and "mm: list_lru:
don't use a new memcg's lists for an offline memcg") so please base on
that.
