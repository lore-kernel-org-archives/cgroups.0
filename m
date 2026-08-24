Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F822388881
	for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 21:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787605281; cv=pass; b=Hodc/K0t2O9Px1L3Fm90niQ+l0JMTYIbFuegtvOqFG0orUqUOLgC4ylpcBp7dGWObKm7Rg3vbyvSGNhP/Gos5k5QqDxyNCPJXfElRRG7pwKoq4Tr++kutElyJM+BeP3tNefbd/Az8IDVdt20r6p6blRaIpwPYnqbO2G8sYBmaRE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787605281; c=relaxed/simple;
	bh=QuBpPYuUWo1tcq7PxYzEPs6+71a6PnnGpsVs93zjhdc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ra651WYpwMZaoUrwVbxIujvKBcXWHLCGXTCulEl779XAewc22bqe2GT2JNchyCMEBUdAwCz+Ah2HmghD0imp6Wa5CH3emNcgYcQErYlXdpUf1UX5LI+E0KzeHxsQUTn0bJKLCFglU++VDHRMZmsSgXx+uBrU1rIZFUvx2Qaxf34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NdtNqLd9; arc=pass smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NdtNqLd9"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-480033bdcf4so1922361f8f.2
        for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 14:01:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787605277; cv=none;
        d=google.com; s=arc-20260327;
        b=KjvnK0ocZxc+nB0h11Qjs6gwDpsWWxrhvy/NnU1LaFcTSY1GVxZUF/SCgxqjIbUUvG
         Mwaj851UoG3CR9ErDGblQCrNSBfAB1WWpER2HiHbtqWzk7H/gW5QjorASjYXBfuzIxja
         P/Z4Q0/zsXhRBAerXKWr+Y6XcPZQ+geTPgHw3DPy6Wun9rcxJ0HF6/bPX3trjidQVnWF
         bnJGoZDgdSBfAKHz/RQm+jyAUDb0tZE4lNTMpE2T/2OL0GERTZnjhxabPZVkaNqAoBzZ
         uMo516BH33PQHCFlLtWGkgHJ1u9R7Lu4pwNXoosb9FPrWqA5pTUUxUTwqyD20q9O4/Tp
         O7jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HyMvbAPjY1T1FBP31LAHW0LPjM6RCAcdyyCk0Ooq5rM=;
        fh=gTfhEb4qykaVLa5NpU1ShEW2gWwYgAoZsRrOV9DW6os=;
        b=EDiMDWFdAB83FSzwfpNvVw08qMxmwSipkx3EzHnZ/XvkvkInd9RZEwUBmhyM6Fg+ha
         u4OrFjf++NJuVJr5USzJ6Qpee1cVTVAEIXiLzvVq/94s2sf97+6zux296UlWgi/96o25
         IbSR/+Et0bnIHkp6u6/XvWhGrjsAAlNOk+CoAyao7+KkFI2Bm/AKBKHTuACMOiEgk1bL
         Z0kvso/okqb4xzoZhz5oD7aNVxr+hVX7vb7Xxt1w5CICK7cPj3y6q8WQOEKrPRVTHmuZ
         fHvguJ3JhSUKsuo2A9HDlfuen0tOOki8vDw/WPlITqvA90Mh2ZEOVLg2ehVO61ha/F4Z
         7lNw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787605277; x=1788210077; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HyMvbAPjY1T1FBP31LAHW0LPjM6RCAcdyyCk0Ooq5rM=;
        b=NdtNqLd9EdiMJ1mkj+5g8YpbwMSNcesZiyUNGD4L7j2Op7RJJpxkrZ5dkSpx/7WSnA
         N+WcWGHEoZZHHD7Y/3PBGbfEMZuV34yDdaum2iXOuWMoCSPUpnp5qX4eyPVdAL8qK+Rq
         pRNJ/Bl0LJmziEL0TgB69LrJYwXooEki6G5RkJNthkcY64iyye2+/nuhISkUP2am8opw
         vWmO+4iRCjCg+WiwOxeg10ClBlUAbNZgYeCN7fwfJ3DrTWYeyL1M4tasQjvMTwrdjo/j
         INpRw/n+h4AlwX1bfDAj9DZZ5nqqHWys1nCPBqg4z2ZgdKqAQmYrEXP7+SoxvCJyeILs
         K1BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787605277; x=1788210077;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HyMvbAPjY1T1FBP31LAHW0LPjM6RCAcdyyCk0Ooq5rM=;
        b=oBtNjjaHrqJPcUIAQC476gJ5PW7809K9z8/Muj9aLfsk3ao+z1ARUGE9nONtI8zNKf
         sC1aHLNCvEdbrJghYVd8h0DioDRGvKLUvK9PHZr+be4U3+qPt9AvDZYvwiQD0ahFqAtM
         l2LTfs2kNacFwnen8Gy8+gFSUCueVI+GmRt3LeP6bOf2CiIkn6jtX43G3E/NH+kBm2xD
         7hZKP5MsNRVm0gnPrU6oZkqEZC9CNKwBLeWJ5osofzVBld15o9klHGfCmkh+CPR9GNYq
         SqU5lOcpA4/qFdbCtjEPV+igZC97agDc8HJTpuj227vaJlc1+D5U+NsHgaxf4oRVcL3j
         IVPA==
X-Forwarded-Encrypted: i=1; AHgh+RqRIQHkL37qOph40GYnk5VPp04qSfdkCDeltyQjnMjhkDDYXG6LTOwtPzNroyxnUaaW92o/xB5u@vger.kernel.org
X-Gm-Message-State: AFuF++kdGfYQBshOHgMYsMm+VKlQXH77f2bx2LknEmw1J54a1iVgqKB2
	qu1XQyEDfDUiju3y6a8/66hZHUiuhAdI5egm9bLtFHxvszKV52Bc8CmbwXsFqnPxAKZJwQ49KXO
	PYD5wv+e92oR0wz7d45zFv2VYKZTPuQA=
X-Gm-Gg: AR+sD10VvHgtOXlzg2/+7W8Qw7axhsp6e9K7ua5IlDcFHknevCeU8TEVlCGB6QMAW8Z
	zNm7SBjs32UhwiGT1TI9b2/HPA1ctJeIYoPY2UOnWGPno/YKYuSnsb1vwPhijVvFYbr373AGatV
	m+pdXTRlZDyCd9xfwNzvW7HdQ4gBX3TEY6l/5kCfnL/+rRizgWdTbkm4E9JjOiU27vkb9Gt28HO
	1Q7FYwsL5AaLq5jn+F3qDr9eG98QwbLtDXfEKVM7kp77HMiRVKLGCKd6IX+hjuxT+wf9GCVL6dp
	BYfpOqFSqjTBvl5/LEQVfGOw2QJuRHjlBiiw+9GhlevVpe601yKbsJUGUgHN6AfFTg4DVI84NKd
	q1zRUirJ+slxELmRXZZ6BIcq/gCA=
X-Received: by 2002:a05:6000:25f5:b0:482:a610:7a27 with SMTP id
 ffacd0b85a97d-482c815def2mr27207718f8f.20.1787605277226; Mon, 24 Aug 2026
 14:01:17 -0700 (PDT)
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
In-Reply-To: <CAO9r8zM+w-wb44G+GXev+eHVEOty5GNcmRkui4PxgeF=Hqv_DQ@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 24 Aug 2026 14:01:04 -0700
X-Gm-Features: AcwNN1WeQE7_yHCQauA3HQyhqmdwOnqSt8GTqj97c9EPEGBEmz_L9Cew2TNBsQw
Message-ID: <CAJnrk1bOdTE+YQRQqzfKUkOGR67a28t3p1r1zeBNzwz9xHEYdw@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in obj_cgroup_may_zswap()
To: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Song Hu <husong@kylinos.cn>, 
	Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, yunzhao@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 21, 2026 at 12:28=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Fri, Aug 21, 2026 at 10:52=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.=
org> wrote:
> >
> > On Thu, Aug 20, 2026 at 03:18:39PM -0700, Joanne Koong wrote:
> > > On Tue, Aug 18, 2026 at 11:35=E2=80=AFAM Yosry Ahmed <yosry@kernel.or=
g> wrote:
> > > >
> > > > On Mon, Aug 17, 2026 at 6:53=E2=80=AFPM Song Hu <husong@kylinos.cn>=
 wrote:
> > > > >
> > > > >
> > > > >
> > > > > =E5=9C=A8 2026/8/18 00:04, Shakeel Butt =E5=86=99=E9=81=93:
> > > > > > On Mon, Aug 17, 2026 at 09:18:43PM +0800, Song Hu wrote:
> > > > > >> obj_cgroup_may_zswap() runs on every folio swapped out through
> > > > > >> zswap.  For each ancestor with a non-max zswap.max, it flushes=
 the
> > > > > >> cgroup rstat hierarchy synchronously with force=3Dtrue, which =
skips
> > > > > >> the ratelimit inside __mem_cgroup_flush_stats().  In a swap st=
orm
> > > > > >> with zswap.max configured, a container takes the global rstat =
lock
> > > > > >> on every swapped-out folio.
> > > > > >
> > > > > > Any reason you are limiting zswap through zswap.max?
> > > > > >
> > > > >
> > > > > Mostly fairness on a shared pool: zswap.max_pool_percent is globa=
l
> > > > > only, so on a multi-tenant host one cgroup's cold anonymous memor=
y
> > > > > can soak the pool and crowd out the others.  zswap.max is the onl=
y
> > > > > per-cgroup control over that share; memory.max bounds the total
> > > > > footprint, not the share of the pool.
> > > > >
> > > > > >>
> > > > > >> zswap_shrinker_count() had the same pattern and switched to
> > > > > >> mem_cgroup_flush_stats_ratelimited() in commit ea80da363a1f
> > > > > >> ("mm/zswap: use ratelimited stats flush in zswap_shrinker_coun=
t()"),
> > > > > >> where the same flush on the shrinker side showed up at 2.88% o=
f
> > > > > >> kernel cycles under osq_lock on a 96-core machine.
> > > > > >>
> > > > > >> Measured on a KVM guest with a swap storm under a cgroup with
> > > > > >> zswap.max set: obj_cgroup_may_zswap() was entered 198,977 time=
s
> > > > > >> before the patch and 198,968 times after, while
> > > > > >> __mem_cgroup_flush_stats() was entered 281,017 times before an=
d
> > > > > >> 80,445 times after.  The removed 200,572 flushes match the sto=
re
> > > > > >> attempt count almost exactly; the remainder comes from other s=
tats
> > > > > >> readers in the swap path.
> > > > > >
> > > > > > This is a known issue. Using ratelimited interface also comes w=
ith a drawback
> > > > > > that the kernel may react on stale information and the conseque=
nces might be
> > > > > > unneeded oom-kills.
> > > > > >
> > > > > > There was orthogonal discussion on moving zswap limit enforceme=
nt away from
> > > > > > rstat. Yosry, any updates on that?
> > > >
> > > > I am not actively looking into that, but Joanne was looking into
> > > > AFAICT. I will respond to the thread there and CC Song as well.
> > > >
> > >
> > > For this zswap stat, I ran some benchmarks comparing 4 approaches
> > > (switchable behind a runtime knob [1]):
> > > a) rstat + forced flush       (baseline aka what the tree does today)
> > > b) rstat + ratelimited         (Song's proposal)
> > > c) hierarchical per-CPU   (Yosry's idea from [2])
> > > d) page counters              (following what all the other memcg lim=
its do)
>
> Thanks for trying this. I actually thought about page counters but
> quickly dismissed it because zswap needs sub-page charging. I see you
> are using the page counters here as byte counters tho :)
>
> It's probably fine, I think the risk of overflow is low (at least on 64-b=
it).
>
> > >
> > > For the setup, the benchmark creates a cgroup chain at depth X with
> > > memory.max set to 1G on the leaf and memory.zswap.max set to 512M on
> > > every level, and spins up 20 processes there that each allocate 100
> > > MiB, fault it in, and touch every page four more times. With that 200=
0
> > > MiB against the 1 GiB memory.max, it triggers reclaim continuously an=
d
> > > makes the swap traffic go through zswap. The machine I ran this on ha=
d
> > > 80 CPUs.
> > >
> > > I also ran it with no memory.zswap.max set (ie no reads triggered,
> > > only update path runs) - as I understand it, this is the configuratio=
n
> > > that is more often used in practice.
> > >
> > > These are the results I saw:
> > >
> > > kernel cpu time (in ns) per zswap store, zswap.max set
> > >                       a)                     b)            c)        =
        d)
> > > depth 1        567,116          35,604     35,841     34,995
> > > depth 2      1,082,007          35,507     37,803     36,209
> > > depth 4      2,153,329          37,591     40,117     39,893
> > > depth 8      4,211,692          34,963     41,070     44,211
> > > depth 32    15,728,220       53,575     94,685     65,946
> > >
> > > kernel cpu time (in ns) per zswap store, no zswap.max (update path on=
ly):
> > >                         a)                  b)              c)       =
     d)
> > > depth 1         34,787          34,062     34,930     35,630
> > > depth 2         34,913          35,061     36,404     36,360
> > > depth 4         36,422          36,809     36,922     37,483
> > > depth 8         42,177          34,440     36,679     40,793
> > > depth 32        55,309          55,321     57,671     59,190
> > >
> > > c) and d) are for the most part pretty comparable to b) without
> > > introducing the staleness problem of b). Between c) and d), I think d=
)
> > > ends up outperforming c) as the # of cpus and depth gets larger.
>
> The main advantage of (c) to me is that we can probably update ~all
> memcg stats to use this scheme, or at least the problematic ones, it
> should be generic enough. Also, I have a concern about (d), see below.
>
> > >
> > > I'm seeing that all the other memory limits (eg memory.swap.max,
> > > memory.max, etc) are already using page counters. Is there a reason
> > > the zswap stat can't? If not, does it make sense for the zswap stat t=
o
> > > switch over to using page counters?
> >
> > Thanks for running these.
> >
> > I used the vmstat counter on the assumption that setting zswap.max is
> > rare and the counter is maintained anyway for memory.stat.
> >
> > But I never actually tested it. The assumption was that surely walking
> > ancestors on a quick if (max =3D=3D PAGE_COUNTER_MAX) continue would be
> > much cheaper than page counter atomics at every level. And so I'm
> > surprised by your results.

I think your assumptions are correct. In that second table above (no
zswap.max set, only update path runs), d) has worse performance than
the baseline a) (except for depth=3D8, which was a noisy fluke). Rerun
with 20 reps, I saw similiar-ish results:

depth       a)                       d)                       diff
     1  35051 +/- 116   35635 +/- 149    +584 +/- 189   (+1.7%)
     2  35603 +/- 142   35859 +/- 179    +256 +/- 229   (+0.7%)
     4  36358 +/- 115   37761 +/- 167   +1403 +/- 203   (+3.9%)
     8  39537 +/- 178   41225 +/- 240   +1688 +/- 299   (+4.3%)
   32  52181 +/- 210   59042 +/- 161   +6861 +/- 265  (+13.2%)

I think the atomics do cost roughly what you assumed, but compared to
the overall latency of the zswap path, it's adding hundreds of
nanoseconds to a path that takes tens of microseconds.

>
> +1.
>
> I previously did an experiment with per-cgroup atomics (should be the
> same as page counters), and it scaled more poorly than the numbers you
> have here. I was running tests in a VM on an AMD Turin CPU, and I
> think I tried 10, 20, and 50 processes, so maybe I pushed it to the
> limit. I remember seeing a large regression with 50 processes. I used
> bpftrace to measure the latency of zswap loads and zswap stores.
>
> Would you be able to also collect numbers with >20 processes and with

Beyond 20 workers, I'm seeing that the additional workers basically
just queue, without improving throughput much. I don't think this
bottleneck is related to the accounting method used though. a), c) and
d) all are within 1% of each other at 40 and 80 workers, so all 3
approaches are bottlenecked by this.

> zswap loads? I think latency of zswap loads is more critical because
> it's usually in the fault path. One other thing is, you need to be
> careful with zswap loads because a miss will be really fast, so they
> will pull the average latency down. Ideally you'd only measure zswap
> load hits. It would also be useful to see the latency at the tail
> (e.g. p90, p95, p99), as people usually care a lot about page fault
> latency at the tail, not just the average.
>
> Sorry if I am asking too much :)
>
> Honestly, I am not sure if >20 processes is a practical concern, but
> zswap load latency is.

Ah, thanks for pointing out the zswap load path and its relation to
faults. These are the results I'm seeing:

zswap_load() latency, (hits only (retval =3D=3D 0), no zswap.max set, 20
workers on 80 cpus, 5 runs, ns):
                  a)              c)       d)
  depth 2
    p50        6,850      6,700    6,850
    p90       10,000    9,750   10,000
    p95       11,050   10,800   11,000
    p99       13,600   13,350   13,500
    avg       7,269    7,128    7,297
  depth 4
    p50        6,600    6,500    6,700
    p90        9,700    9,650    9,950
    p95       10,800   10,750   11,000
    p99       13,350   13,250   13,550
    avg       7,034    7,029    7,266
  depth 8
    p50        6,000    6,150    6,750
    p90        9,000    9,250    9,900
    p95       10,050   10,300   11,050
    p99       12,500   12,800   13,650
    avg       6,508    6,652    7,273
  depth 32
    p50        5,250    5,400    9,100
    p90        7,900    8,050   12,550
    p95        9,000    9,150   13,800
    p99       11,550   11,700   16,450
    avg       5,786    5,958    9,469

For depths 2 and 4, there's no real difference for d), but depth 8+
shows worse performance. In Meta's fleet, hierarchies of depth 8+ are
common.

>
> That being said, I generally prefer (c) better because it should scale

I now prefer (c) as well. I hadn't realized setting zswap.max is a
rare path until Johannes mentioned it, and with your mention of
zswap_load() sitting in the fault-critical path, I think the benchmark
results show a clear improvement for c) over d) at higher depths.

I was uneasy about the cost of c)'s reads scaling linearly with the #
of cpus on a system (ie for_each_possible_cpu per level), but given
the uncommonness of the zswap.max path, I think that's the right thing
to trade away. Either way, it's a big improvement over the baseline a)
path that currently exists anyways.

> with more concurrency/CPUs and should generalize better to other
> stats. But I am obviously biased :P

I'm still investigating the writeback and vmscan cases. For writeback,
using (c) is more complicated since NR_FILE_DIRTY and NR_WRITEBACK are
node stats. I'm planning to spend time this week running benchmarks
for it.

If for those cases, (c) is viable, then I'll send a patch that adds
(c) as general infrastructure. Otherwise, I'll send out (c) as a zswap
specific patch.

Does this sound good to everyone? If there are any objections, please
let me know.

Thanks,
Joanne

>
> >
> > But that was the sole reason. If it doesn't stand up to benchmarking,
> > no objection to streamlining the control to a standard implementation.
