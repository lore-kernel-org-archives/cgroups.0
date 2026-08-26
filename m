Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C813B8BD9
	for <cgroups@vger.kernel.org>; Wed, 26 Aug 2026 23:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787786107; cv=none; b=Ihs/gAGi/HdAybzHzK2PMrhfR9WeKRtyVhFyct6LemJ5eS8fuQpU3DIfTNfu9+zWYatz0KN8CLNie/ZYkQd70/5UVzIqB6h72g/0G1huaHOu5YjwyyyUAVeReOXt2cM12w1EqCXBZTyhWibOOBkjpRpKIl88FlRSAn2hem9fF1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787786107; c=relaxed/simple;
	bh=YUaMLPNhuDaYNJ0D8OpsuiWvuLoQ1w65HAWCQ0qaaRI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qBLV8ZCsjbZtUdm6TPc/pH7cr65gxacygY7L2SGi2YprIswyLqRNbDlimNr41T+aXZ1BR8nJFzM6SST316Is8Ug+U2PcFlhtK+BrrvHLqX50MGljNvaf2fj2TWkwzJR/Ma3/FG/xYWYn2yoJ3I2Kj8ewJAevDwmoywgdcSsqk1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jwg1mBsn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jwg1mBsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628541F000E9
	for <cgroups@vger.kernel.org>; Wed, 26 Aug 2026 23:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787786106;
	bh=YUaMLPNhuDaYNJ0D8OpsuiWvuLoQ1w65HAWCQ0qaaRI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Jwg1mBsnwMtqkVVzzMFGfQCThc1btDwD3mJ7wJaHS8UvvA/rFu4oJgn+Y9VYOL2Zw
	 AQr3u1wr+7wXmarpeIsQ7iPPK8i125aNwfUcdHXwoIo3FAx/5HcEi93YE58NiInHva
	 KTjaQc7I4dHL/yYzXPid8YPXIwQayoFRx1IR6u84Giy7ZuYDqAB9iH/12nAAfJ3uZ4
	 keEfIm8qgocd5PcPj6jfpw8FTrPpAOa/GnlP3bw4NgF+c4PRScn5FAMdcfqt2gQbKV
	 2BgDuEHxtsBt2cKTtJ74gfGFQSxd22in6wzk2iF7e3QIz3KdQW3NLGSJjo+B0Qqb4u
	 /DzueysUCHcbg==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c250c6a6a6eso238232766b.0
        for <cgroups@vger.kernel.org>; Wed, 26 Aug 2026 16:15:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rp8yjYUg4HG/4tVO12IPxUnLcBEsGcyhZSrXaMThzedh6+wUrG0aD7vAodAVGS0qrW5f4l4gf9w@vger.kernel.org
X-Gm-Message-State: AFuF++kxl2IMzy1QLqt40aabU4uSQGxUodB32jd7u4w/+N4xA0hvUVNy
	uoaZItG1n4RZN/mehoDv1kDwBBO/juT1i5pbeXoauDtJi5jIlEChZb82iVtBM16/sHquN2WsTtS
	Qiu4Bflt3lX+wSU37XTZiNvm7uXHK7MM=
X-Received: by 2002:a17:907:980e:b0:c25:2f12:1441 with SMTP id
 a640c23a62f3a-c252f121647mr587317666b.12.1787786105306; Wed, 26 Aug 2026
 16:15:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1787017182353556.21.seg@mailgw.kylinos.cn> <0689d805-45c6-4bb2-8eb2-f065457c45bf@kylinos.cn>
 <CAO9r8zNxnVYpwrsuB1Ofcwf-Lks2e+DL1Ys9CXZ5jozBug_ybQ@mail.gmail.com>
 <CAJnrk1bFq7J7K0=X67voeZVkAb0dmiLkqomuQ+VcXBLyP5hMVg@mail.gmail.com>
 <aoiQPrudvYZ76ZSD@cmpxchg.org> <CAO9r8zM+w-wb44G+GXev+eHVEOty5GNcmRkui4PxgeF=Hqv_DQ@mail.gmail.com>
 <CAJnrk1bOdTE+YQRQqzfKUkOGR67a28t3p1r1zeBNzwz9xHEYdw@mail.gmail.com>
 <CAO9r8zNQzqwVeOoZr71juX3xV06LUTntBp+7bmGdwK_s6FoT6w@mail.gmail.com>
 <ao9YFgBQJEy-85iB@linux.dev> <CAO9r8zO6VWRGh3CbqyymSkEaw6gFd6AKYQgZE_rTQP7svWEMfw@mail.gmail.com>
 <ao9q-m9k-NMxDvA1@linux.dev>
In-Reply-To: <ao9q-m9k-NMxDvA1@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 26 Aug 2026 16:14:53 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPqJncFKQbF3tGe1d4sg-4dLQ3dQRGze_vab26wWrXTqA@mail.gmail.com>
X-Gm-Features: AcwNN1V63NfeSNegK4PJcDTArzQ_WtI1O3OguNxglcCIZITphCd5lzAAhhQ5eqc
Message-ID: <CAO9r8zPqJncFKQbF3tGe1d4sg-4dLQ3dQRGze_vab26wWrXTqA@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in obj_cgroup_may_zswap()
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Joanne Koong <joannelkoong@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Song Hu <husong@kylinos.cn>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, yunzhao@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 26, 2026 at 4:08=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Wed, Aug 26, 2026 at 02:55:57PM -0700, Yosry Ahmed wrote:
> > > >
> [...]
> > > > If (c) is holding up for writeback and vmscan, I would question a m=
ore
> > > > radical approach of tearing apart the rstat framework and using it
> > > > across the board. That is obviously a heavier lift and more
> > > > controversial,
> > >
> > > Yes controversial because we used to have similar mechanism which did=
 not work
> > > and we had to move to rstat. Check the commit 42a300353577 and fixes =
to it.
> >
> > IIUC, in that commit, the update side modifies one per-CPU per-cgroup
> > counters, and when those counters exceed a threshold atomic updates
> > are performed on all parents, which I think is the slow side. Then,
> > the read side just reads the potentially stale atomic. That was
> > problematic because:
> > (1) The update side can end up performing atomic updates on all parents=
.
> > (2) The read side can be inaccurate by up to MEMCG_CHARGE_BATCH *
> > nr_cpus * nr_children
> >
> > What I am proposing in (c) is different:
> >
> > (1) The update side always updates per-CPU per-cgroup counters in all
> > the parents. It never does atomic operations. The parent iteration is
> > not cheap, but it is cheaper than atomics for sure and we already do
> > parent iteration today in some cases in memcg_rstat_updated().So the
> > "slow" path should be the same as today.
>
> Yes but that parent traversal is short circuited when we hit the flush
> threshold. At Meta scale, we have observed significant cpus being spent o=
n
> memcg_rstat_updated before that.

Interesting. So the upward per-CPU traversal takes time? Perhaps due
to concurrent flushers causing the cachelines to bounce?

>
> > (2) The read side always iterates per-CPU counters in this cgroup, so
> > it's always accurate. This might be more expensive on an rstat flush
> > on average (e.g. if memcg_vmstats_needs_flush() skips the flush), but
> > it is much more consistent and the tail latency is much better.
> >
>
> It might be or not. Usually such things are more clear at scale in produc=
tion
> instead of benchmarks.

Agreed.

>
> > >
> > > This worked for zswap stats because their update and consumption are =
not on
> > > performance critical code paths i.e. these are on the way to compress=
 or
> > > decompress or in reclaim context.
> >
> > Well, decompression is in the fault path, that's performance critical
> > to some extent (although not like other stats updated by networking).
> > Anyway, I think the update path shouldn't regress much with the
> > approach described in (c).
>
> Decompression is on the scale of micro-seconds (and I suspect the simple =
minor
> page faults are on nano-seconds scale) and the upward traversal is defini=
tely
> much cheaper and will be a noise there.
>
> >
> > >
> > > > but if we can get away with it, I think it will
> > > > simplify things greatly and honestly rstat has been causing a lot o=
f
> > > > trouble in the last few years.
> > > >
> > > > But this can be done incrementally too, we can start by separating =
out
> > > > the problematic stats to use the new update/flushing scheme,
> > >
> > > This I think we do need but for specific stats. I think the stats whi=
ch have
> > > in-kernel consumers need this. However not all such stats might be fi=
ne with
> > > slow update side like zswap. So, we need to evaluate thoroughly.
> >
> > I think in the proposed approach (c) the main concern is actually read
> > latency, not update latency. So if it works for in-kernel consumers it
> > should definitely work for userspace consumers as well?
>
> Here I was mainly talking about consumers which has more strict staleness
> requirements and those are mainly kernel consumers. Rstat flushing is def=
initely
> more expensive than this for-each-cpu traversal and most of the time they=
 just
> need it for one or very small set of stats.
>
> I am imagining once we have this special mechanism for selected stats, we=
 can
> potentially remove ratelimited flush and stats update threshold code.

Yeah that's the hope. I was basically saying that I am hoping for
more, to transition everything to this flushing scheme if it works
well.

Anyway, as you mentioned, ideally we need production data to proceed.
Joanne, is this something that you are trying to collect by any
chance? :)
