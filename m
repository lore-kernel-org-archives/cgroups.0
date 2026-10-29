Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793237720;
	b=HZ9mr7qS/ezahFyQLmDiPif6rVY7F2zHHFLVVnaf7QqcdbKNSLEkliWG+19TbAh4Zecm
	 Cfe6+osva73Vh3oVBZmmM4CZhvEp3j/j4xghRwhcgWBeuvVNqIfkR4ULVIz5EH755d5u8
	 Vjp9kP/+xqE7KAbTelG07+NLfysUYoJiWAkAuUk75R7yFARIvQRD8m5iqHPEV+HFdcypf
	 sBxBphyxXAt5am9DfJdXj2RX06HYBXyHbzkDI8P44+MeGeiR57V882gbocySVEg+pNfxa
	 cImUZwFOa+hJ7h8dA54HyzYHEYQ/ZqiadLjn0Xhtr3XI9lxGLtaSXAO7l3DRM0UwqwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793237720;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=JEH1NfbaYrwZPx3ay7Pd4dSyZn96eHDpie+yn6sEgao=;
	b=p/gEBh+ZAAEmMcHJ4/ZRC0yD/Q+0cEqhWQ++cs6l58hsCdUawm9xXBuLJxI9gJ76/U+I
	 XhnzEi/5yi10xvUJ75dLGPqw7sAqWqV+Dvk367+mbfD7Vyqgddlc5OqglbKv74cgNu5pJ
	 qx8XGNxazYnlkSimyA/zQw5zDzK6QYKtwtLkI6G4Bhs8KCtFtZp4333l1H1cRWJQqjgNi
	 fIwusfUCn5bFz/6sfkMnv3Z2rQZVHzIGFMM/fx8oBetz2mO6OX0gL1KfRSTqOVrIqczGb
	 ltgeOCZlohLIr8vEvJq/XltnbSYBfYv4lZ9c3q1IJE3NUF+yZiwSnUFLr+5PlajqZBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=CGPmRrHP;
	arc=none smtp.remote-ip=209.85.210.199
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C00606A31A
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 01:35:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8C00606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=CGPmRrHP
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8a06da65d92so1069130b3a.0
        for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 18:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793237719; x=1793842519; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JEH1NfbaYrwZPx3ay7Pd4dSyZn96eHDpie+yn6sEgao=;
        b=CGPmRrHP7ETgpZl7OG7FiXEAhpiKufI8JrXDYaBanwKKO4gvFsrhZ/XiDqGlLHy57N
         bPfzx6HbIgW+WTBVEL6PNxB0MeeMct/yp3h29/Fi0QwlTqogzmoPQMkFzBD5U6fHYSMK
         YGrxDbflD+XtWi9q7T5ItGFZrTS4PEPFuAWZpnfaxa4kUmBA7okFTEWd0mIdthXCl5Vr
         J3JWgqPODYYlaaaxhlYQEBzZD+PgzPqe4Gv5lXoOyCX4TLyyKKIcN4NxLtNR/zlOonBh
         3Cg7r96HnG0DX7u333tuG+ElO6FeKRHKVVkwyLc7QJT4SjlVvkbhiPKd9hJggxyBpMcF
         ceUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793237719; x=1793842519;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JEH1NfbaYrwZPx3ay7Pd4dSyZn96eHDpie+yn6sEgao=;
        b=DsaUcKLv3f4qlA+yOS61EDubkZDhpv9VJ8xodhh6/m1UiW3rprbRZcFtJsaj3kBo7Z
         0UaXOIG+mSAbv3jJ6wH35NNU4f1VRnaWDlh7ZOB/0PGYPi49G3N2ChrqnyraieXfFDb2
         vqtz+K8ehrlcToOo6cdczr0S7fVqmYgFjzJvz56W9wlQ/PuQmkmnZud1CB35fdNJiYl9
         dcoSCggpYfWyC0NmbdrXpUf/6egh05zMXDfEzYD22EAUC3r9G2Ki3pah2IN32z30DKUg
         gZjXHiwvdgpLjkHQ72ZmxPrQBUBW1Zo5q7BPKWGL27lO5E26OEZfCZs6ZJDk7U90/FMs
         A4gw==
X-Forwarded-Encrypted: i=1; AKwUvBwGMPx+4VqgCMY+mN7KsfX7MkLhXz81fFFAWjTV46/tTDRrAqkdoE24sYA8LmoprI8KM3N5pxzU@vger.kernel.org
X-Gm-Message-State: AFq9FYKIoiIed+DhUU8iG5L8IYy81ovKplX4mcmoOgZKXkEDz1LCwggK
	Yi9xOkA/MXNAyYvpYVHxmaHyclID7OOUzrl3CDz5hLXKGcl0Q2n4k06M7h4C0VUhZLQ0iQmU0sQ
	8PDBvIQ==
X-Received: from pfbft10.prod.google.com ([2002:a05:6a00:81ca:b0:887:8dda:c9e4])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1d99:b0:89f:fc75:6d99
 with SMTP id d2e1a72fcca58-8a6e869953emr3363442b3a.60.1793237718994; Wed, 28
 Oct 2026 18:35:18 -0700 (PDT)
Date: Thu, 29 Oct 2026 01:35:18 +0000
In-Reply-To: <auKYs_ucslI-tdar@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261028185034.3607746-1-kuniyu@google.com> <auKSeCFvsWzP-XYy@linux.dev>
 <auKYs_ucslI-tdar@linux.dev>
Message-ID: <auKcNvAizn-B92xB@google.com>
Subject: Re: [PATCH v2 0/6] memcg: Batch mod_memcg_state() for MEMCG_SOCK.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, yosry@kernel.org, joannelkoong@gmail.com
Content-Type: text/plain; charset="us-ascii"

On Wed, 28 Oct 2026 17:52:32 -0700, Shakeel Butt wrote:
> On Wed, Oct 28, 2026 at 05:41:04PM -0700, Shakeel Butt wrote:
> > On Wed, Oct 28, 2026 at 06:50:12PM +0000, Kuniyuki Iwashima wrote:
> > > On our production fleet, we saw mem_cgroup_sk_charge() spent over
> > > 3x the cycles of try_charge_memcg() although the former should be
> > > a thin wrapper of the latter.
> > > 
> > > Looking at perf during tcp_rr, most of the cycles were spent in
> > > mod_memcg_state(MEMCG_SOCK), which incurred two heavy memory stalls
> > > due to cache line misses. (see patch 4)
> > > 
> > > Also, tcp_rr w/ 20000 flows throughput often degrades by ~50% on
> > > many core machine. (see patch 5)
> > > 
> > > This series adds nr_sock[] to struct memcg_stock_pcp to batch
> > > mod_memcg_state() for MEMCG_SOCK and move heavy operations to
> > > out of local_lock(&memcg_stock.lock).
> > > 
> > > With this series, tcp_rr w/ 10000 flows achieves 31% more
> > > throughput with lower latency on machine w/ AMD EPYC 7B12 64-Core
> > > Processor (Zen 2 Rome, 2 sockets, 256 vCPU)
> > > 
> > >   tcp_rr (10000 flows, 128 threads, 60s, average of 3 runs):
> > > 
> > >   Metric                     |       Baseline |        Patched |    Diff
> > >   ---------------------------+----------------+----------------+--------
> > >   Throughput (RPS)           |     20,884,499 |     27,466,490 | +31.52%
> > >   Latency Mean (us)          |         478.46 |         363.71 | -23.98%
> > >   Latency p50 (us)           |         453.96 |         356.68 | -21.43%
> > >   Latency p90 (us)           |         669.00 |         479.56 | -28.32%
> > >   Latency p99 (us)           |         969.38 |         617.80 | -36.27%
> > > 
> > > 
> > > Changes:
> > >   v2:
> > >     * Rebased on mm.git/mm-new
> > >     * Add patch 5 for flaky throughput issue
> > >     * Patch 4:
> > >       * Benchmark again after rebase and update numbers
> > >       * Check in_nmi() in __refill_stock()
> > > 
> > >   v1: https://lore.kernel.org/linux-mm/20261016052811.3085635-1-kuniyu@google.com/
> > > 
> > > 
> > > Kuniyuki Iwashima (6):
> > >   memcg: Remove unnecessary READ_ONCE() under memcg_stock.lock.
> > >   memcg: Reduce nesting in consume_stock() and refill_stock().
> > >   memcg: Annotate slow paths in consume_stock() and refill_stock().
> > >   memcg: Batch mod_memcg_state() for MEMCG_SOCK.
> > >   memcg: Uncharge pages outside memcg_stock.lock in __refill_stock().
> > >   selftests: cgroup: Deflake test_memcg_sock() in test_memcontrol.c.
> > 
> > Decouple the 4th patch (batch MEMCG_STOCK) from the remaining and send the
> > remaining patches separately and upfront.

Sure.


> > 
> > For the 4th patch, I would prefer we first try to move the network sockets
> > from memcg to objcg path.

sk_forward_alloc is already batched per page, and I think
migrating to objcg would just add an indirect layer and some
costs for css_tryget() / css_put(), and still inlining
__consume_stock() or batching in memcg_stock would be crucial.


> > Then I would prefer we optimize the stats update for
> > all stats instead of special casing for MEMCG_STOCK.
> > 
> 
> MEMCG_SOCK instead of MEMCG_STOCK

I guess you mean optimising MEMCG_SOCK along with MEMCG_KMEM (or
mod_memcg_state() / memcg_rstat_updated() in general).

I can give it a try, though some stats already have specialised
batching (e.g. NR_SLAB_RECLAIMABLE_B in obj_stock and folio stats
in uncharge_batch()).
