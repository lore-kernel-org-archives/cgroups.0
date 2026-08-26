Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CE9282F17
	for <cgroups@vger.kernel.org>; Wed, 26 Aug 2026 21:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787781372; cv=none; b=lgLj+gnpRFlFoQrV1UIQ3qsR1yEBoiR2+EONKLqxnboL3ZFLlmtFzjke/F0gB8lNYkg3sSe/kNAathjIGgPEB45Ra23Q3pXtrS0lTjQXeb10vsrnIl2E8g7kAhvMCH05GVcksA7lEQj0C1tv7XEKlhdimZSF40c42/qNElukTFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787781372; c=relaxed/simple;
	bh=KAkYXAYnfeM7EWZPb0UU2vxX96nlclIp0nAmWXUJyIA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QbClSrzBHbojL4Oy3ECTq1OVAjQ4a074ifS1vtyWSJkbg1sfskMyQ1+OUL96ZJE61Rcw3kb7wFmVD4rGPYUf3I9vfM/jK/1M0grircZZfCF3L0Cl4zIAdNRi3bNcyqQrVLT2Qi77/CpBqrNNtSjs7nH7dhRSzDTIz4wfyoSxNQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nh5AToR+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nh5AToR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20ED31F00A3E
	for <cgroups@vger.kernel.org>; Wed, 26 Aug 2026 21:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787781371;
	bh=KAkYXAYnfeM7EWZPb0UU2vxX96nlclIp0nAmWXUJyIA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=nh5AToR+8+Hy4JwDQLkAQn8JX3nCyjf2TXZmf8hTWyRrvNiP4emkuq3ejwqhcSTdH
	 DszsCD25k42ll/3FlOorkTiVJttraFnX9zOHO+jGxgbohoypS7CAw0DGKXWUdFlmpO
	 80St1R6mG3vurizq/YaEuZnl218kTVqVfw1pPKxKb8oyrCWoojUxFT7hv6Xjbj8jAN
	 QkWLZzjvn0oJSDjBkjHHTIiamGHHdcJLDb5Qj51AdhxG+8oYNbtnuTErj17fBUehNM
	 lBXRlggcv/NNz7Xozb9hddNlKABSZqyDedCnu7O4A6hFVcd93XOnx/u+sqlrQkj5M6
	 88/QGrEhrsi+g==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c197eaaab00so243814466b.0
        for <cgroups@vger.kernel.org>; Wed, 26 Aug 2026 14:56:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoaaM/HdeLgeWaHEC1g1Em7ESOJ1XK5wZVkP85BfFyK4aKTvwnZ7YAgcZTFeeK5i/pVKxieKB6t@vger.kernel.org
X-Gm-Message-State: AFuF++mGOCyliPeRPSwKjdMNLnhRHII3KX8zID+lBcfRuDH5JqI2qBgf
	hTVMhiToHRP3ZOnYrNmCsRG5XoF71Zc1BVGYIAAZVv/wnexdEt2yNhlfXwTqokYmUAmkfHA36L7
	SOOpBjYf0W4xePlFKAU+BYTtOTT3A+2Y=
X-Received: by 2002:a17:906:fd88:b0:c25:437:3dcf with SMTP id
 a640c23a62f3a-c250c3c07fcmr1219596066b.21.1787781370065; Wed, 26 Aug 2026
 14:56:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260817131843.45121-1-husong@kylinos.cn> <1787017182353556.21.seg@mailgw.kylinos.cn>
 <0689d805-45c6-4bb2-8eb2-f065457c45bf@kylinos.cn> <CAO9r8zNxnVYpwrsuB1Ofcwf-Lks2e+DL1Ys9CXZ5jozBug_ybQ@mail.gmail.com>
 <CAJnrk1bFq7J7K0=X67voeZVkAb0dmiLkqomuQ+VcXBLyP5hMVg@mail.gmail.com>
 <aoiQPrudvYZ76ZSD@cmpxchg.org> <CAO9r8zM+w-wb44G+GXev+eHVEOty5GNcmRkui4PxgeF=Hqv_DQ@mail.gmail.com>
 <CAJnrk1bOdTE+YQRQqzfKUkOGR67a28t3p1r1zeBNzwz9xHEYdw@mail.gmail.com>
 <CAO9r8zNQzqwVeOoZr71juX3xV06LUTntBp+7bmGdwK_s6FoT6w@mail.gmail.com> <ao9YFgBQJEy-85iB@linux.dev>
In-Reply-To: <ao9YFgBQJEy-85iB@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 26 Aug 2026 14:55:57 -0700
X-Gmail-Original-Message-ID: <CAO9r8zO6VWRGh3CbqyymSkEaw6gFd6AKYQgZE_rTQP7svWEMfw@mail.gmail.com>
X-Gm-Features: AcwNN1XUi59_7wlRX-aPfKbk6cG14-Ur0Kp10Fes9lEailhZFHURR2vWvYp7IrI
Message-ID: <CAO9r8zO6VWRGh3CbqyymSkEaw6gFd6AKYQgZE_rTQP7svWEMfw@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in obj_cgroup_may_zswap()
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Joanne Koong <joannelkoong@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Song Hu <husong@kylinos.cn>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, yunzhao@cloudflare.com
Content-Type: text/plain; charset="UTF-8"

[..]
> > > I now prefer (c) as well. I hadn't realized setting zswap.max is a
> > > rare path until Johannes mentioned it, and with your mention of
> > > zswap_load() sitting in the fault-critical path, I think the benchmark
> > > results show a clear improvement for c) over d) at higher depths.
> > >
> > > I was uneasy about the cost of c)'s reads scaling linearly with the #
> > > of cpus on a system (ie for_each_possible_cpu per level), but given
> > > the uncommonness of the zswap.max path, I think that's the right thing
> > > to trade away. Either way, it's a big improvement over the baseline a)
> > > path that currently exists anyways.
> > >
> > > > with more concurrency/CPUs and should generalize better to other
> > > > stats. But I am obviously biased :P
> > >
> > > I'm still investigating the writeback and vmscan cases. For writeback,
> > > using (c) is more complicated since NR_FILE_DIRTY and NR_WRITEBACK are
> > > node stats. I'm planning to spend time this week running benchmarks
> > > for it.
> > >
> > > If for those cases, (c) is viable, then I'll send a patch that adds
> > > (c) as general infrastructure. Otherwise, I'll send out (c) as a zswap
> > > specific patch.
> > >
> > > Does this sound good to everyone? If there are any objections, please
> > > let me know.
> >
> > If (c) is holding up for writeback and vmscan, I would question a more
> > radical approach of tearing apart the rstat framework and using it
> > across the board. That is obviously a heavier lift and more
> > controversial,
>
> Yes controversial because we used to have similar mechanism which did not work
> and we had to move to rstat. Check the commit 42a300353577 and fixes to it.

IIUC, in that commit, the update side modifies one per-CPU per-cgroup
counters, and when those counters exceed a threshold atomic updates
are performed on all parents, which I think is the slow side. Then,
the read side just reads the potentially stale atomic. That was
problematic because:
(1) The update side can end up performing atomic updates on all parents.
(2) The read side can be inaccurate by up to MEMCG_CHARGE_BATCH *
nr_cpus * nr_children

What I am proposing in (c) is different:

(1) The update side always updates per-CPU per-cgroup counters in all
the parents. It never does atomic operations. The parent iteration is
not cheap, but it is cheaper than atomics for sure and we already do
parent iteration today in some cases in memcg_rstat_updated(). So the
"slow" path should be the same as today.
(2) The read side always iterates per-CPU counters in this cgroup, so
it's always accurate. This might be more expensive on an rstat flush
on average (e.g. if memcg_vmstats_needs_flush() skips the flush), but
it is much more consistent and the tail latency is much better.

>
> This worked for zswap stats because their update and consumption are not on
> performance critical code paths i.e. these are on the way to compress or
> decompress or in reclaim context.

Well, decompression is in the fault path, that's performance critical
to some extent (although not like other stats updated by networking).
Anyway, I think the update path shouldn't regress much with the
approach described in (c).

>
> > but if we can get away with it, I think it will
> > simplify things greatly and honestly rstat has been causing a lot of
> > trouble in the last few years.
> >
> > But this can be done incrementally too, we can start by separating out
> > the problematic stats to use the new update/flushing scheme,
>
> This I think we do need but for specific stats. I think the stats which have
> in-kernel consumers need this. However not all such stats might be fine with
> slow update side like zswap. So, we need to evaluate thoroughly.

I think in the proposed approach (c) the main concern is actually read
latency, not update latency. So if it works for in-kernel consumers it
should definitely work for userspace consumers as well?
