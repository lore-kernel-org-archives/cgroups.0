Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1AA3D567F
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 23:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788306152; cv=none; b=XdlFYm03WGhffjUKgMAsvfyB2NndZRh4t8uUD496II3JGzlxHmspyIUwvhiOsWBV3M3nTLyhx6AR7U8MIG6R3ZswEb1ie0mejGf+xDhl4G0rT2Spe56F7VXibKt7kwC9/+4OdYyF+XYe/opkK1ArZbeNAfPBtSPusqvMLClMheo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788306152; c=relaxed/simple;
	bh=4ydYbdDql6hmFQ5Ou+STmnKuVvjKslHDSVVQGCCK/D8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mBUMLhbudDJP4OrVEkxFiWHbnjz8j0ONo2/BkdgZPermUWrlcvSLI93dSuo9NV18Rk4ibtk9rFL3p1LeohJEwZetN5DSsPr6fKmWZEHNHG6BGK5zdcLb7uy2gkJ1KXFXL3MYYgi/HcbXPG2itUZd1jHyowNuuy1hfLytDE/IFDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ahVsk5ab; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ahVsk5ab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8A41F00A3F
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 23:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788306151;
	bh=GjwEru2BaocN4L4JOnAlUtxbfajrtGVgmkUYz0mgZkc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ahVsk5abrzmFa2pS9IiNOFAkAgZIO6VRkFSkjcpU2U7X9srVrCDBYinXUJsorILY6
	 zHPGD0M2coV1PSCGAv/sDgvpAl7dyoBoBxFICkCpzAhN8aCO8/ENUMfv9tP/C/XsXP
	 vzkvovUutVORbzIUwUDPEzV0QfDc8OnrHX6ms+vf3lXd+O5tTpL6h/dyITJ8NeKw7B
	 B1r8bQrkPvxu5chtsz9M9L019kl3WhSxxzb3IFFVbq1Y1t87c716monSkZ+jM9ZeGS
	 uunYjT7U6b5xW1/CRxRA/BPh4iPyHk1skZN2Apr9L1AsVVglZifuvdhMMeNTfwQBk/
	 mEd9IUGrr+01Q==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6a20319d030so547792a12.2
        for <cgroups@vger.kernel.org>; Tue, 01 Sep 2026 16:42:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrsbFbz7bUhHPlrI0bgpl5pt11c7ZTuwD1R2t0P+ZGNsGILlYNUFNMC1dpuhqP6a9qhErU73xq1@vger.kernel.org
X-Gm-Message-State: AFuF++mG43Mc4xrxkbXbOPcXoXVgKV9A6Iv0lGqFWGjHSBuYTe439U+m
	evzlxEmA84fVWLkMlCdfi/J2vC07jkrVV2cBR5qEGaQNiCDyoeGzbIrX2EXpRqIxBDM+Gg1A6/8
	xxJJmJ1kMR3yCrByF2SbHLqmg/ND4d8g=
X-Received: by 2002:a17:907:3f9e:b0:c25:32ae:a6e4 with SMTP id
 a640c23a62f3a-c25d5276c08mr47951766b.9.1788306150004; Tue, 01 Sep 2026
 16:42:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260901232834.22221-1-joannelkoong@gmail.com>
In-Reply-To: <20260901232834.22221-1-joannelkoong@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 1 Sep 2026 16:42:17 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOTd5HjbDfMXuh+VHLGCAkHwyKx4CV-rjgBuxTpEZ6THw@mail.gmail.com>
X-Gm-Features: AcwNN1VLQyfDp7XP9T9t8iAAeQ-yNELmTvSOCFEKyDLZtzmygwMEeQQ_pzGaRBY
Message-ID: <CAO9r8zOTd5HjbDfMXuh+VHLGCAkHwyKx4CV-rjgBuxTpEZ6THw@mail.gmail.com>
Subject: Re: [PATCH v1] mm/memcontrol: drop non-hierarchical memcg-wide stats
 in non-v1 kernels
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 1, 2026 at 4:32=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> memcg_vmstats keeps a non-hierarchical copy of every memcg-wide stat item
> and event alongside the hierarchical one. The only readers however are
> the legacy memory.stat and memory.numa_stat, and reparenting on offline.
> All of them live under CONFIG_MEMCG_V1, and their accessors
> (memcg_page_state_local() and memcg_events_local()) are already compiled
> out with it. This means on a CONFIG_MEMCG_V1=3Dn kernel, memcg_vmstats's
> non-hierarchial arrays are written to on every rstat flush, despite
> their values never being read / accessed.
>
> Compile this out and only carry the non-hierarchical memcg-wide stat
> arrays if the kernel actually supports v1.
>
> This makes flushes cheaper. mem_cgroup_stat_aggregate() can now skip the
> read-modify-write of ac->local[i]. Nothing else on a kernel with
> CONFIG_MEMCG_V1=3Dn accesses state_local or events_local, so those
> cachelines get pulled in solely for the writes, and they are separate
> from the ones the loop is already walking / accessing.
>
> On a 80-cpu x86_64 machine with 500 cgroups each running a workload that
> dirties anon, file, dirty/writeback, slab, kmem, mlock, and reclaim
> counters, timing mem_cgroup_css_rstat_flush() in-kernel in TSC ticks per
> flush showed roughly
>
>                          before   after    delta
> memcg-wide aggregation   1231     1180     -4.1%
> overall flush function   2452     2397     -2.2%
>
> These numbers are from taking the median of 70 samples, one per 20s
> window on each kernel. The 95% intervals observed on the two deltas are
> [-5.41%, -1.76%] and [-4.53%, -0.14%]. The values above include the
> timing overhead itself, so only the delta is meaningful here.
>
> Counting the items that actually changed, a median of 1.5 of the 77
> memcg-wide items (57 state + 20 events) had a non-zero per-cpu delta at
> each flush, which means the benchmarks above are with one or two fewer
> cachelines pulled in per flush. The count is low because the benchmark
> reads memory.stat in a loop to keep the flush rate up. For cases where
> flushes are triggered only by the 2s periodic worker, more changes will
> have accumulated between flushes, so more cachelines are skipped and the
> per-flush saving should be larger.
>
> Please note that the per-node lruvec array is left unchanged, as that is
> not v1-only (count_shadow_nodes() needs to read
> lruvec_page_state_local() under CONFIG_MEMCG rather than
> CONFIG_MEMCG_V1).
>
> This adds no functional changes to kernel builds with CONFIG_MEMCG_V1=3Dy=
.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  mm/memcontrol.c | 49 ++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 42 insertions(+), 7 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 7ce50bccf126..b98b2d68c62b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -675,9 +675,11 @@ struct memcg_vmstats {
>         long                    state[MEMCG_VMSTAT_SIZE];
>         unsigned long           events[NR_MEMCG_EVENTS];
>
> +#ifdef CONFIG_MEMCG_V1
>         /* Non-hierarchical (CPU aggregated) page state & events */
>         long                    state_local[MEMCG_VMSTAT_SIZE];
>         unsigned long           events_local[NR_MEMCG_EVENTS];
> +#endif
>
>         /* Pending child counts during tree propagation */
>         long                    state_pending[MEMCG_VMSTAT_SIZE];
> @@ -687,6 +689,32 @@ struct memcg_vmstats {
>         atomic_long_t           stats_updates;
>  };
>
> +/*
> + * The non-hierarchical memcg-wide counters are read back only by the le=
gacy
> + * memory.stat and by reparenting on offline, both of which are v1-only.
> + */
> +#ifdef CONFIG_MEMCG_V1

Can we query the boot parameter instead of the config option here?
IIUC this should work even if v1 is only disabled at boot.
