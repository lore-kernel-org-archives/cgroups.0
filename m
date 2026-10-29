Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793241161;
	b=Je9y9+5awoz1mHuzWfRbmy9r7E0fdeY6Ou15dok5EuWN3Kb+9q+DSdgFuIhWarfmZE6E
	 DWkoB2cjvsVcvTwJxmhcz80c7GEdnRehXwdc8adM9PXUvF5LINmomZbToLNvSow050I+y
	 cs4l+Gq6FdzzVLzxCO6Zj6Xjqm8INcvdy7G8RYvwNaBlNf69VQLoykebg/klQC/bG/tWL
	 aciqTp3kxnsliyj6TQmxlw6sWd9uvSblPT5bGtqbfnxvPX32N6ZQA51q5qNqGuLoxOnCK
	 /H66uUcDKCyDZUxYR6lkJ48Q/wZ+rpe8sucAvdYShTUs+zOk54auPnalKDj5MiMN6cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793241161;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=rrsknUuPusVLZmi3TYlB3zEC9aJluMm+Yj7vSmErNwA=;
	b=OaRsHzqMP6Waqkisc1J6RpLjVqOZw6JzBOz56TggjsCyqDqzGG2pdlU5joL/qyxSUEc1
	 c1Ak3j6lXizNajJtxJevUZIOM+usTvkyFleQr4+PPHvqVhdN69GWueR1sBl6QdkR6dyGM
	 xiBwKdql1sF/LGd00r6vN62MGqCYrdr+lafL0WaTB1vmfIOafX10MHomhZh45SBcWLJ05
	 N5w+f5hxVlCcnUpAVN2Aa5LVowPl7frKcxxfbGfZI+4lg+pbZvJlKgL4eRixLbjQpUYH3
	 zWde6CL/P5Cy70ywCzlQi1pALxykNy9Us6iZYSJHZGHJxd5HGG1tceZ1orogPw1sE7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MqWUcUUB;
	arc=none smtp.remote-ip=209.85.216.72
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EF6606A31A
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 02:32:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40EF6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MqWUcUUB
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3acc98e3b3cso1344826a91.3
        for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 19:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793241160; x=1793845960; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rrsknUuPusVLZmi3TYlB3zEC9aJluMm+Yj7vSmErNwA=;
        b=MqWUcUUBE1wPgYsO5UkOLZZSz4T5gRDj+DJYGMyI5cNuwfIuBoeUvVqrj27CmEWJa9
         XDX80XzhNLFKbjJbfIXRr/y2DyaOVG8NUnpEuljIy8NSZluXLw94kJ20u96GAhxe8sB/
         K8dWcKmL88x2iR0juJA2M8WY67v1HZFrZtUg7G9ekCcL/L2wDEvWZtuEacZvlZ48mMdV
         DdHXYVWFUnpelNPjzwDkGsNpH3JHFJ+oWmpXyggA517/3DjAnEr3A6R1BAsAD2OHxjF9
         drsQCvMMGuiNlCL/gP+uFQJhG3LpuDMveBTgzQDnKiZ7zq5CUpGT9osfCJlqaBRC4jXA
         gfyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793241160; x=1793845960;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rrsknUuPusVLZmi3TYlB3zEC9aJluMm+Yj7vSmErNwA=;
        b=khvfFjPuatbot/TiGvMhZdRYs8+xfDcqGW9uocAoyHI/nr6ERKp7D2C2sebMiKllwt
         cXrk1FEhs/Btm7rarhexQeN9SuqADQcNM72DdtMogEoAyLkbD1V4ITjiT7E6Lbcr72cD
         N9VE6hCCtBBHWz9iodpo2aDBMmb3Sm178mMHNq2y3DuyS7DgoVZCeUDGc/IReKZ+JsIl
         oyjI/wrUBMJhk06U/mp0QsY69MqHrrgVwcwJJF0xcsM1Of47OQEQ+OSfxZia3PR4BHSH
         eBQZK/n6VRfzWlGw4VCmA/v8ysuCFBjHk2eXbzXqKrUFN/1XcBDsuhQZcrAolrqMDJWQ
         qUuA==
X-Forwarded-Encrypted: i=1; AKwUvBzeNajR9uZzp+p0K6DKgY9imWIvhhYtAG/N7xZ03qkPxb6ROo53Wkrfwl74fbg619ly7FzzXyB/@vger.kernel.org
X-Gm-Message-State: AFq9FYJLxDVgoKKf82lT2QLCMV0o0dJiGraY0nYwDOm4WCb8LHfLlcwx
	QMLhSqSN1Q+KoGOQPz0j+r/wBZVYh92QOz5BRRXJojXciAGNukxWde4XWJY2S/hRTacCQ/B7ooX
	Yp1/obQ==
X-Received: from pgdo3-n2.prod.google.com ([2002:a05:6a02:6203:20b0:cd6:1345:d20b])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e185:b0:3ad:77fd:c3d8
 with SMTP id 98e67ed59e1d1-3ae57e2b5b1mr3164327a91.1.1793241160346; Wed, 28
 Oct 2026 19:32:40 -0700 (PDT)
Date: Thu, 29 Oct 2026 02:32:39 +0000
In-Reply-To: <auKcNvAizn-B92xB@google.com>
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
 <auKYs_ucslI-tdar@linux.dev> <auKcNvAizn-B92xB@google.com>
Message-ID: <auKvUCpDaGgvJcmQ@google.com>
Subject: Re: [PATCH v2 0/6] memcg: Batch mod_memcg_state() for MEMCG_SOCK.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, yosry@kernel.org, joannelkoong@gmail.com
Content-Type: text/plain; charset="us-ascii"

On Thu, 29 Oct 2026 01:35:18 +0000, Kuniyuki Iwashima wrote:
> On Wed, 28 Oct 2026 17:52:32 -0700, Shakeel Butt wrote:
> > On Wed, Oct 28, 2026 at 05:41:04PM -0700, Shakeel Butt wrote:
> > > On Wed, Oct 28, 2026 at 06:50:12PM +0000, Kuniyuki Iwashima wrote:
> > > > On our production fleet, we saw mem_cgroup_sk_charge() spent over
> > > > 3x the cycles of try_charge_memcg() although the former should be
> > > > a thin wrapper of the latter.
> > > > 
> > > > Looking at perf during tcp_rr, most of the cycles were spent in
> > > > mod_memcg_state(MEMCG_SOCK), which incurred two heavy memory stalls
> > > > due to cache line misses. (see patch 4)
> > > > 
> > > > Also, tcp_rr w/ 20000 flows throughput often degrades by ~50% on
> > > > many core machine. (see patch 5)
> > > > 
> > > > This series adds nr_sock[] to struct memcg_stock_pcp to batch
> > > > mod_memcg_state() for MEMCG_SOCK and move heavy operations to
> > > > out of local_lock(&memcg_stock.lock).
> > > > 
> > > > With this series, tcp_rr w/ 10000 flows achieves 31% more
> > > > throughput with lower latency on machine w/ AMD EPYC 7B12 64-Core
> > > > Processor (Zen 2 Rome, 2 sockets, 256 vCPU)
> > > > 
> > > >   tcp_rr (10000 flows, 128 threads, 60s, average of 3 runs):
> > > > 
> > > >   Metric                     |       Baseline |        Patched |    Diff
> > > >   ---------------------------+----------------+----------------+--------
> > > >   Throughput (RPS)           |     20,884,499 |     27,466,490 | +31.52%
> > > >   Latency Mean (us)          |         478.46 |         363.71 | -23.98%
> > > >   Latency p50 (us)           |         453.96 |         356.68 | -21.43%
> > > >   Latency p90 (us)           |         669.00 |         479.56 | -28.32%
> > > >   Latency p99 (us)           |         969.38 |         617.80 | -36.27%
> > > > 
> > > > 
> > > > Changes:
> > > >   v2:
> > > >     * Rebased on mm.git/mm-new
> > > >     * Add patch 5 for flaky throughput issue
> > > >     * Patch 4:
> > > >       * Benchmark again after rebase and update numbers
> > > >       * Check in_nmi() in __refill_stock()
> > > > 
> > > >   v1: https://lore.kernel.org/linux-mm/20261016052811.3085635-1-kuniyu@google.com/
> > > > 
> > > > 
> > > > Kuniyuki Iwashima (6):
> > > >   memcg: Remove unnecessary READ_ONCE() under memcg_stock.lock.
> > > >   memcg: Reduce nesting in consume_stock() and refill_stock().
> > > >   memcg: Annotate slow paths in consume_stock() and refill_stock().
> > > >   memcg: Batch mod_memcg_state() for MEMCG_SOCK.
> > > >   memcg: Uncharge pages outside memcg_stock.lock in __refill_stock().
> > > >   selftests: cgroup: Deflake test_memcg_sock() in test_memcontrol.c.
> > > 
> > > Decouple the 4th patch (batch MEMCG_STOCK) from the remaining and send the
> > > remaining patches separately and upfront.
> 
> Sure.
> 
> 
> > > 
> > > For the 4th patch, I would prefer we first try to move the network sockets
> > > from memcg to objcg path.
> 
> sk_forward_alloc is already batched per page, and I think
> migrating to objcg would just add an indirect layer and some
> costs for css_tryget() / css_put(), and still inlining
> __consume_stock() or batching in memcg_stock would be crucial.

Interestingly, patch 5 only (without patch 4) gives even more
throughput gain on the platform mentioned in patch 4.

But as expected, __css_rstat_updated() spends more cycles.

  tcp_rr (10000 flows, 128 threads, 60s, average of 3 runs):

  Metric                     |       Baseline |   Patched  |    Diff
  ---------------------------+----------------+---------------------+--------
  Throughput (RPS)           |     20,884,499 | 28,453,051 | +36.24%
  Latency Mean (us)          |         478.46 |     351.07 | -26.63%
  Latency p50 (us)           |         453.96 |     343.04 | -24.43%
  Latency p90 (us)           |         669.00 |     479.57 | -28.32%
  Latency p99 (us)           |         969.38 |     593.92 | -38.73%

  perf cycles (10000 flows, 10s, average of 3 runs):

  Server (M cycles / %)      |           Baseline |            Patched |    Diff
  ---------------------------+--------------------+-----------------------+--------
  Host Total Cycles          |        4,566,914 M |        4,548,747 M |   -0.4%
  tcp_rcv_established()      | 158,009 M (3.460%) | 158,773 M (3.490%) |   +0.5%
  mem_cgroup_sk_charge()     |  18,420 M (0.403%) |  16,211 M (0.356%) |  -12.0%
  mem_cgroup_sk_uncharge()   |  16,593 M (0.363%) |  12,121 M (0.266%) |  -27.0%
  __css_rstat_updated()      |   3,502 M (0.077%) |   5,606 M (0.123%) |  +60.0%
  Memcg Sock Total           |  38,515 M (0.843%) |  33,937 M (0.746%) |  -11.9%


> 
> 
> > > Then I would prefer we optimize the stats update for
> > > all stats instead of special casing for MEMCG_STOCK.
> > > 
> > 
> > MEMCG_SOCK instead of MEMCG_STOCK
> 
> I guess you mean optimising MEMCG_SOCK along with MEMCG_KMEM (or
> mod_memcg_state() / memcg_rstat_updated() in general).
> 
> I can give it a try, though some stats already have specialised
> batching (e.g. NR_SLAB_RECLAIMABLE_B in obj_stock and folio stats
> in uncharge_batch()).
