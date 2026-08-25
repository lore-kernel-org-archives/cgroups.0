Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB384405F7
	for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 00:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787617407; cv=pass; b=AxWYJ9fgvAmIuRNHiQTyfeErrrWNtkD9nz/ohEN3rEQT0C4A9PtE/KPazihlzV4nFpNTxKSX+UVmGPOe5yOpW3z/exnJbyyEMopdZIdORpyOexaCIayQVIV7lIkWJY5eWUSXf+RMZX8SpdbwCkesGuABEW6InoagbQ2jdNSPz4g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787617407; c=relaxed/simple;
	bh=Mc+mIOEpcyAtCao0U0R6eUo+FlI3Vuw+GR2lvav9qA4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uC6P5vBV/o+wYPSBf74w423uKgNm3uuECFI5GvgGdiC/gxToN92qVORv9AwiyGauQYJlQskmu0qCbqULzdi3Iu4iYod66kGxQ4pHRrwOjY9BA0g892GxpthUe69PIvsvObeMuNcxprTMcpKZu//GIWDIFeg/HWcdJwVLAeeVsE0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HtKTae3w; arc=pass smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HtKTae3w"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4998590d392so16325205e9.0
        for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 17:23:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787617404; cv=none;
        d=google.com; s=arc-20260327;
        b=QgzXZizTiUNX0b1aXLJif8iAn6RpkyHv6+vRmaZYO41O914v3YNc9iFyYq7b4tC5TA
         1EknxtyvaR33QH9gaOPlpDIJf41bRttOMis4hBvlo808W4FifHqD2uOHLLx+9CtsSHBb
         cxdG9nUbYeyzYqYgY9ioW6QbpFqu+5g52W9Rs08QnbbPYlBc4g3tbIp7VIbpK2rHmUNK
         FUofEhZ8YolEnVghbFS+o/GoR9aMMUpizc2u8PqkC95h2QNejbVEkppE7DaTz+N70juq
         28J0E0SlLJAizkNO5OgGo+Z+6C4/+uZdog/PmGeLAJRtChxhq75vaCeGNOvym/qheIIA
         an4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=q4D+JzVq7rrVWcTNgs+vhZxnGwZ9hLVGhQYwWgduIQI=;
        fh=qSqkEcoKv46vdFD0FI7BMcrVYqqRLrbkVOSabHX6E0Y=;
        b=Y8tXCYZmqg0ex58LdIZizS0IOl8knUuR5wqewbllrzQzLv9ta/PrA8dSOWtznrMYyb
         7I3RWPuA0hi+pV8zjUqDpt8+vzRDqzdyCzoSgUSsAPrK/sWkJIEK6xZpAYAS0Qyc4Ggw
         Y4WcgmqRG0RlrEZlNdgSXoVHWQvW2BtE3VfhgwNJwHnIZFf0tcQ6x/Ua3TdQjN7TW7Gm
         faPxvQDllTFbVy1nN73fx2GGvi0BtdFGAgbC3WC8+bx0GlatfIFJbr5fSQoJrjxw4ism
         6X5tXU8bppHc3oJkKQfb2Ms7IAdw8I5/q+le3qbrYo+KQpAgxApwQ3UgoRaGupSfJDAA
         G05g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787617404; x=1788222204; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=q4D+JzVq7rrVWcTNgs+vhZxnGwZ9hLVGhQYwWgduIQI=;
        b=HtKTae3wgG3ZIvBeo4VH/9EB+T6SPXwOoNOZRVkBNKnZ8drXW4r4bh+VSPww4hoavq
         Qm9oqEogkR8DozLO/bU1zdtWrVeUAGF9HKjThbsuTfkxqyyWC8gQc3EEr20/jA97QBHV
         u/b091UKN+b5FvIIXmykJ8dvo58V7JB8GNyhVQ39Tjvs/+LwG16FJ6P/FIxjsCYB48D1
         IM8YaXAhBJrEMtFJL6Rab/msH1I6DITY3R0LOgJFHqpUOgEmhsuVSbJQk0/s3gAW8Aui
         vUqIQxR4pwGXL6JJW8Ns6n5AIpPRHvgyVWx7eC4xbT3zwE4FnAWCKSnjNDV3lN/qv4kC
         2ncw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787617404; x=1788222204;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q4D+JzVq7rrVWcTNgs+vhZxnGwZ9hLVGhQYwWgduIQI=;
        b=s0ft/EL1n/eD/PFq5L+2tm+qWFU/gd/EiE2+auelBT+DBIj7ujCwUAPOGURwqO03EP
         c0eAMx4oxcDhms6brIlBckNHNWbNoGWeLt/JTGqYZNSMr1DyqS2LV8bva88C8CvEdOyB
         kqJr9qn6IdRWUcO9+syS1XYCtN/fRfSexusVvMw0ih9zsaLmMgjCWd7eh4JTrILGQW54
         ePIdZCeU/38NZhlESyNohK1ibjuGg2KfytfPcCZg3fy8YWrs4WVGTYn844pCjp0B3Ccg
         qt0iUdhLhc4qma19uIbdFa6rpWKhYJ9UajCMpfdD0lEkJHc7cFH4ao2mZhcYpzvS5129
         zqWw==
X-Forwarded-Encrypted: i=1; AHgh+RoCjmA5xr9dcszgu2VoxxK18/LWqTO/1+ttiD54QSXQLXhudS7WIW7AJugCCdgdlEhVqO0I5F9H@vger.kernel.org
X-Gm-Message-State: AFuF++nley6RrRxpRMhismKvtGhRZFlvvhRPM/gxzuWJKEIWpo2XfYoX
	sQcmAo/+94mjZfklyEoFOdfSzaxhjI2RAZjj19Or3MtV1iUNmvG0IeRdybh1xFlO9z+pDFC1o2p
	4+GBM/BfZpjYlp80Q2kA6xAXQSKSXnB4o64OA
X-Gm-Gg: AR+sD12js1HHag58o24qtklDaO0YUrpKqKIF6FsxK3AxoOlv+t/8hsQ69xXjXlQP7r8
	H7CwjFGAeLf3hNRGHTUQ7IFgjFcZnu72L9JUmizEb/JwWkfSYyQuEPzKjKH6cy8Eb+ivJ1PgRep
	NxcRRDroxdZDtwTd/OVwRhWeIEMJDmS89qHyH6g+3YozYjJZ7H6Q/1JI6pOozK7vJl4JIaAwVWp
	1yldEqREgOMdZp1uNJRqHQGQnnQETHSfrUTinly5dHKYDnC3TcQbQi08xGdJQdQHBCZ8rH/a1YW
	xsdB87qQISxHwcPKE4Ae0KSkQ3spkFLKrJNYT0vyGlD1V3fsuJol+Vuh+YRPkZljEJDm7sZiKd2
	UzEAf+iPQ0lcxVt7SDbXOSCSNCt98O8hJQP2AXQ==
X-Received: by 2002:a05:600c:b86:b0:499:8156:cd3f with SMTP id
 5b1f17b1804b1-499b8301913mr299612535e9.8.1787617403993; Mon, 24 Aug 2026
 17:23:23 -0700 (PDT)
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
 <CAJnrk1bOdTE+YQRQqzfKUkOGR67a28t3p1r1zeBNzwz9xHEYdw@mail.gmail.com> <CAO9r8zNQzqwVeOoZr71juX3xV06LUTntBp+7bmGdwK_s6FoT6w@mail.gmail.com>
In-Reply-To: <CAO9r8zNQzqwVeOoZr71juX3xV06LUTntBp+7bmGdwK_s6FoT6w@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 24 Aug 2026 17:23:12 -0700
X-Gm-Features: AcwNN1XMPf-DlGUepZHoJG1Jp04G9mgCU5EYS_1mSHsNifKV_m10Rr4sNDM_8KE
Message-ID: <CAJnrk1YgM0h48v1wpORLtD2Z4ypv7oU-ptokjoNBp7p-Bs2YsA@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in obj_cgroup_may_zswap()
To: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Song Hu <husong@kylinos.cn>, 
	Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, yunzhao@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 24, 2026 at 2:16=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> > > > > For this zswap stat, I ran some benchmarks comparing 4 approaches
> > > > > (switchable behind a runtime knob [1]):
> > > > > a) rstat + forced flush       (baseline aka what the tree does to=
day)
> > > > > b) rstat + ratelimited         (Song's proposal)
> > > > > c) hierarchical per-CPU   (Yosry's idea from [2])
> > > > > d) page counters              (following what all the other memcg=
 limits do)
> > >
> > > Thanks for trying this. I actually thought about page counters but
> > > quickly dismissed it because zswap needs sub-page charging. I see you
> > > are using the page counters here as byte counters tho :)
> > >
> > > It's probably fine, I think the risk of overflow is low (at least on =
64-bit).
> > >
> > > > >
> > > > > For the setup, the benchmark creates a cgroup chain at depth X wi=
th
> > > > > memory.max set to 1G on the leaf and memory.zswap.max set to 512M=
 on
> > > > > every level, and spins up 20 processes there that each allocate 1=
00
> > > > > MiB, fault it in, and touch every page four more times. With that=
 2000
> > > > > MiB against the 1 GiB memory.max, it triggers reclaim continuousl=
y and
> > > > > makes the swap traffic go through zswap. The machine I ran this o=
n had
> > > > > 80 CPUs.
> > > > >
> > > > > I also ran it with no memory.zswap.max set (ie no reads triggered=
,
> > > > > only update path runs) - as I understand it, this is the configur=
ation
> > > > > that is more often used in practice.
> > > > >
> > > > > These are the results I saw:
> > > > >
> > > > > kernel cpu time (in ns) per zswap store, zswap.max set
> > > > >                       a)                     b)            c)    =
            d)
> > > > > depth 1        567,116          35,604     35,841     34,995
> > > > > depth 2      1,082,007          35,507     37,803     36,209
> > > > > depth 4      2,153,329          37,591     40,117     39,893
> > > > > depth 8      4,211,692          34,963     41,070     44,211
> > > > > depth 32    15,728,220       53,575     94,685     65,946
> > > > >
> > > > > kernel cpu time (in ns) per zswap store, no zswap.max (update pat=
h only):
> > > > >                         a)                  b)              c)   =
         d)
> > > > > depth 1         34,787          34,062     34,930     35,630
> > > > > depth 2         34,913          35,061     36,404     36,360
> > > > > depth 4         36,422          36,809     36,922     37,483
> > > > > depth 8         42,177          34,440     36,679     40,793
> > > > > depth 32        55,309          55,321     57,671     59,190
> > > > >
> > > > > c) and d) are for the most part pretty comparable to b) without
> > > > > introducing the staleness problem of b). Between c) and d), I thi=
nk d)
> > > > > ends up outperforming c) as the # of cpus and depth gets larger.
> > >
> > > The main advantage of (c) to me is that we can probably update ~all
> > > memcg stats to use this scheme, or at least the problematic ones, it
> > > should be generic enough. Also, I have a concern about (d), see below=
.
> > >
> > > > >
> > > > > I'm seeing that all the other memory limits (eg memory.swap.max,
> > > > > memory.max, etc) are already using page counters. Is there a reas=
on
> > > > > the zswap stat can't? If not, does it make sense for the zswap st=
at to
> > > > > switch over to using page counters?
> > > >
> > > > Thanks for running these.
> > > >
> > > > I used the vmstat counter on the assumption that setting zswap.max =
is
> > > > rare and the counter is maintained anyway for memory.stat.
> > > >
> > > > But I never actually tested it. The assumption was that surely walk=
ing
> > > > ancestors on a quick if (max =3D=3D PAGE_COUNTER_MAX) continue woul=
d be
> > > > much cheaper than page counter atomics at every level. And so I'm
> > > > surprised by your results.
> >
> > I think your assumptions are correct. In that second table above (no
> > zswap.max set, only update path runs), d) has worse performance than
> > the baseline a) (except for depth=3D8, which was a noisy fluke). Rerun
> > with 20 reps, I saw similiar-ish results:
> >
> > depth       a)                       d)                       diff
> >      1  35051 +/- 116   35635 +/- 149    +584 +/- 189   (+1.7%)
> >      2  35603 +/- 142   35859 +/- 179    +256 +/- 229   (+0.7%)
> >      4  36358 +/- 115   37761 +/- 167   +1403 +/- 203   (+3.9%)
> >      8  39537 +/- 178   41225 +/- 240   +1688 +/- 299   (+4.3%)
> >    32  52181 +/- 210   59042 +/- 161   +6861 +/- 265  (+13.2%)
> >
> > I think the atomics do cost roughly what you assumed, but compared to
> > the overall latency of the zswap path, it's adding hundreds of
> > nanoseconds to a path that takes tens of microseconds.
> >
> > >
> > > +1.
> > >
> > > I previously did an experiment with per-cgroup atomics (should be the
> > > same as page counters), and it scaled more poorly than the numbers yo=
u
> > > have here. I was running tests in a VM on an AMD Turin CPU, and I
> > > think I tried 10, 20, and 50 processes, so maybe I pushed it to the
> > > limit. I remember seeing a large regression with 50 processes. I used
> > > bpftrace to measure the latency of zswap loads and zswap stores.
> > >
> > > Would you be able to also collect numbers with >20 processes and with
> >
> > Beyond 20 workers, I'm seeing that the additional workers basically
> > just queue, without improving throughput much. I don't think this
> > bottleneck is related to the accounting method used though. a), c) and
> > d) all are within 1% of each other at 40 and 80 workers, so all 3
> > approaches are bottlenecked by this.
> >
> > > zswap loads? I think latency of zswap loads is more critical because
> > > it's usually in the fault path. One other thing is, you need to be
> > > careful with zswap loads because a miss will be really fast, so they
> > > will pull the average latency down. Ideally you'd only measure zswap
> > > load hits. It would also be useful to see the latency at the tail
> > > (e.g. p90, p95, p99), as people usually care a lot about page fault
> > > latency at the tail, not just the average.
> > >
> > > Sorry if I am asking too much :)
> > >
> > > Honestly, I am not sure if >20 processes is a practical concern, but
> > > zswap load latency is.
> >
> > Ah, thanks for pointing out the zswap load path and its relation to
> > faults. These are the results I'm seeing:
> >
> > zswap_load() latency, (hits only (retval =3D=3D 0), no zswap.max set, 2=
0
> > workers on 80 cpus, 5 runs, ns):
> >                   a)              c)       d)
> >   depth 2
> >     p50        6,850      6,700    6,850
> >     p90       10,000    9,750   10,000
> >     p95       11,050   10,800   11,000
> >     p99       13,600   13,350   13,500
> >     avg       7,269    7,128    7,297
> >   depth 4
> >     p50        6,600    6,500    6,700
> >     p90        9,700    9,650    9,950
> >     p95       10,800   10,750   11,000
> >     p99       13,350   13,250   13,550
> >     avg       7,034    7,029    7,266
> >   depth 8
> >     p50        6,000    6,150    6,750
> >     p90        9,000    9,250    9,900
> >     p95       10,050   10,300   11,050
> >     p99       12,500   12,800   13,650
> >     avg       6,508    6,652    7,273
> >   depth 32
> >     p50        5,250    5,400    9,100
> >     p90        7,900    8,050   12,550
> >     p95        9,000    9,150   13,800
> >     p99       11,550   11,700   16,450
> >     avg       5,786    5,958    9,469
> >
> > For depths 2 and 4, there's no real difference for d), but depth 8+
> > shows worse performance. In Meta's fleet, hierarchies of depth 8+ are
> > common.
> >
> > >
> > > That being said, I generally prefer (c) better because it should scal=
e
> >
> > I now prefer (c) as well. I hadn't realized setting zswap.max is a
> > rare path until Johannes mentioned it, and with your mention of
> > zswap_load() sitting in the fault-critical path, I think the benchmark
> > results show a clear improvement for c) over d) at higher depths.
> >
> > I was uneasy about the cost of c)'s reads scaling linearly with the #
> > of cpus on a system (ie for_each_possible_cpu per level), but given
> > the uncommonness of the zswap.max path, I think that's the right thing
> > to trade away. Either way, it's a big improvement over the baseline a)
> > path that currently exists anyways.
> >
> > > with more concurrency/CPUs and should generalize better to other
> > > stats. But I am obviously biased :P
> >
> > I'm still investigating the writeback and vmscan cases. For writeback,
> > using (c) is more complicated since NR_FILE_DIRTY and NR_WRITEBACK are
> > node stats. I'm planning to spend time this week running benchmarks
> > for it.
> >
> > If for those cases, (c) is viable, then I'll send a patch that adds
> > (c) as general infrastructure. Otherwise, I'll send out (c) as a zswap
> > specific patch.
> >
> > Does this sound good to everyone? If there are any objections, please
> > let me know.
>
> If (c) is holding up for writeback and vmscan, I would question a more
> radical approach of tearing apart the rstat framework and using it
> across the board. That is obviously a heavier lift and more
> controversial, but if we can get away with it, I think it will
> simplify things greatly and honestly rstat has been causing a lot of
> trouble in the last few years.
>
> But this can be done incrementally too, we can start by separating out
> the problematic stats to use the new update/flushing scheme, and then
> do the larger overhaul when it holds up.
>
> Either way, thanks a lot for all the work you're doing here.

Thanks for all your guidance with this memcg stats work, Yosry! I appreciat=
e it.
