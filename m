Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B109F48D893
	for <cgroups@vger.kernel.org>; Mon, 14 Sep 2026 16:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789404594; cv=pass; b=k3tsG9WRFaGG1xWFlxPVS/zIsb6/Vak4ebOg+YVOzoAEXdtEkOzc3XUQnx4nDX8jKC0CLJMOO7NxqpAE1rRQGFm5wakxAN3k44L5XdDMJF/2dn8cNuir/mm3eaHxK0Nbt8XVi/9ktXLUVIU8i7EYV6r5yJUCkBwVaS7/NIZCM40=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789404594; c=relaxed/simple;
	bh=7jqLPXF1igJUd80a+c0Yy1y5YA/B5JPdvkj9X3w++FA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j9AWx8C6NzJX1MfysdcKoT5+quMoOD1vY5o+3V6eCqgAjqW895Is1G66mn9GabfxA8mxt5qKflOZKmvkFhyrmZjHBkNAhyxM9cCVvGjs+AW9BKYGDvqMe/FxJnYgPQLfbCDy9/cgPvjfcqyKydfXYPnuTtRs22wSWycEL8sTdMQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JrQILUID; arc=pass smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JrQILUID"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6350f91so1224735f8f.1
        for <cgroups@vger.kernel.org>; Mon, 14 Sep 2026 09:49:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789404591; cv=none;
        d=google.com; s=arc-20260327;
        b=qkipPZV6+dMsdX5/W8zZBaIPtmYQpCtZT9URJtQEQoNa1L1whztNbee3I93WRJqhEj
         guWEeLIfw7EFsWK39ODQM0Xst19q0D3BthtWm0wMoD9UaZHyBpReBSdXSS0+n27EmysD
         +HTOBrsxz6qIOdyWL5BAAamumXuQTvYgZybg5+bMUBdXdTzWCG/yTsKzFQjhxld0DeNp
         EWRiNvpXd6t7vE66tOn/VrymPOuY2pLb9XDE+qIeJc0YVjXtwv/eiPWodIYaSIYpDhi0
         P3X857vz7zYyUaOGj+cc6ITozRAfgVcdR/rQMqYanGidWTWoynZqlchqfRvcpdMwJAJt
         NVQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=G183+Yxm6/Twsin5qYVqwM95g4Sy/Qck0fET7NLxE+k=;
        fh=P9SwNmi0+sGEQxl+JLf8Cpu/SxNxhSqBOiuU1ePw0gg=;
        b=gu9y767gbRULyqY4j2bKkjoRlgkJBrvfT9+O0kItgRwQRBNKa3s8/o62BEROwr3lmM
         Q5nPFVeodfVQLKNocV5CIRYLQTmK9c/CqZAqE7dHjfH6a8WmmFaDlK40aG9sc/Oq52gF
         kYCTm+rwKVGwsotxfkDb2RPG15qOF/dQ/RXuYjyrnjNvgFWDMjw+d1sSjp7Q4UHoEEeF
         0CxeV0thCmdD3IEYsuWJ4azBaEcy5VlrAsFW78evtu1FsUHRFa20oDjCra4cupSY5hAA
         a4P/9EeNNQm4jcMk23+vZo0W7sqXh4wIaaKN0KnYpja7Ux5YNmPS0/5Csnsvaoy9KMRX
         oqdA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789404591; x=1790009391; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=G183+Yxm6/Twsin5qYVqwM95g4Sy/Qck0fET7NLxE+k=;
        b=JrQILUID1bKBhb+/x3xIgPavKzr+v2xHSfsbF9dZU9Ee480JcjOvWdw60nLeUeeusQ
         AWsoT8npn0DBvLpBDqky1T2wBqSSBFGunkpjoNWQOEz9ZXkHouxEcHx6v/qTC0HNqIMS
         om1ADZuRMc052tqrcywgFTjZlen5YhGzeXz8WYDSDdgMmquoWWLnX0PbJlpyp7sPZ4N6
         Tz+j4NxQc9nXE1hV7wudS68m595/97lKGe88pRVRJssFxTb0DxCr53vpf19ohR5cJDTw
         cSA9pURmDtXQ6EJLY2LDocQ1fbW0k1UPZO5NsTJ64MOexBX4WrnLNi6SD/1FqXRPIQnT
         srnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789404591; x=1790009391;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G183+Yxm6/Twsin5qYVqwM95g4Sy/Qck0fET7NLxE+k=;
        b=VQH6xKYATOOmEvlTDeyNl5yK5g9EfGN/6uiGXA+X9gXjT/4XKQiWSYSFlzZMemzhJn
         Nde8H7elbI4gWtOA4FMDXEwssm9UOE4U1l20iv0yj1ywmrC9nasDLruGrzth4K/akETO
         OlyNTbv8OZtfgUi7Lk/wTTVxBywCpGILjTEvoGg5oBOGNVYyNcejxIgUDpddgW/hZMQK
         CLYhj4n2E91vXczzzs2TfCxcFdfOQAxo9nOzgPbPh1P8ypKtwNnQU859C5RWayJ+u77C
         it3owOJx+qIe2BjqUGChuX9r1sfOmQG0kPCHaS9zisoeO8G1PXJU2Gm+wjF1V7sF7F9X
         rFtA==
X-Forwarded-Encrypted: i=1; AKwUvByj4lGkAtkgY/Mu43FhjDfhhRMD/TcnKnSwUYMzSzJVaLi1lPn3LSJQhb/14kkR0bf1nStheFOI@vger.kernel.org
X-Gm-Message-State: AFuF++lm+Q6Qcy3BDFSbxKZuqYlC6ve300qgNqd+kAKR6XC4UX+BuLki
	7ABd6qEAgE2nTPrFBvMUdF4Eh2a2VH7dxp3sCZMQfhua4ob6rfbiFEtJHqH96JzV6gJLdHoUEwM
	DtIbkQkjpzuwATfljxdfWOevX29a+r+w=
X-Gm-Gg: AYBFou23/ya64v0YNQwJ2TzSwqXqy0kHmfYAPJm+VHbi+8gW436oQEt7BBCD5vwcDp0
	IXO8ZnYsdyMGQ/lpyR58yn6zzbD/mowRV3H+y3ApQtDSEfczU/LtPjSRermEGfQNY4TerZiPIMB
	Rm91DCXubQJctJ4uTf5wfm9T8hpIQUXkHlIQ6rnYZXohknHA1wcOzwE1WPw1aAO25WHO60Z1sOR
	8QAIanBKF23nsDSBzMhd8u5m7iN4W/cAjz89xumA6UH49ej/W18mgTsFRrBwDtF8ixMEuUsRp3r
	DUjz3nU8+4EbWWQxkdE0uqCAsdpFNsLZ51lGMN0iXxqyBB4soYSPCQv4+mXRN9yAI6kTeylJQkQ
	B0WIIrfvYBJJs
X-Received: by 2002:a05:6000:27c8:b0:487:4ba:97f0 with SMTP id
 ffacd0b85a97d-48704ba998fmr1121463f8f.23.1789404590535; Mon, 14 Sep 2026
 09:49:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
 <CAKEwX=O8i+OsP6BJXNZNk07hveN9HDT+PoyMTAU6gOc-xp0Ppg@mail.gmail.com>
 <CAMgjq7BQeQQOZMDPFJ+8LS2N4t3x53r6Nm+9o0_pi92oVUgjgQ@mail.gmail.com>
 <CAKEwX=MS-7C96i4tzBijHN=-xuZgny_wQEa_0YjfHzhoNysdYQ@mail.gmail.com>
 <CAMgjq7B7Mc7vpQN0gBknsSrfZWXdif5L7nU29YskG9mzS-_jsA@mail.gmail.com>
 <CAKEwX=PxZ68_4240DC8HjcqPRE0bQWGmouoqapqqTQ2b0xqpvg@mail.gmail.com> <CAMgjq7D40KGRjwpFMH4x4fhJ18OQyZwPtovhc8Hm3Y7+__d4Lw@mail.gmail.com>
In-Reply-To: <CAMgjq7D40KGRjwpFMH4x4fhJ18OQyZwPtovhc8Hm3Y7+__d4Lw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 14 Sep 2026 09:49:38 -0700
X-Gm-Features: AcwNN1WO51K14Fm2T1tur-3vx3APS3D8nhOV3AEZCzJzOrHll5YjpThxvhcytDE
Message-ID: <CAKEwX=NvHj-Py22-QuR10gynfRk0g5y8g6Cs2+L-hbuAyfmXFw@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Kairui Song <ryncsn@gmail.com>
Cc: YoungJun Park <youngjun.park@lge.com>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 12, 2026 at 1:48=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Sat, Sep 12, 2026 at 3:04=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >
> > On Fri, Sep 11, 2026 at 11:14=E2=80=AFAM Kairui Song <ryncsn@gmail.com>=
 wrote:
> > >
> > > > Would something like this fix it for you? ZRAM users will not get
> > > > vswap indirection overhead at all, because it would bypass vswap :)
> > > > Down the line we can revisit this decision - for e.g, if there is a
> > > > use case for vswap-on-top-of-swapfile. There might be other interfa=
ce
> > > > that makes more sense.
> > >
> > > Hmm, this interface looks confusing though. you mean tangles vswap
> > > with zswap through the cgroup's zswap limit? I originally expected
> > > this to be a problem solved by tiering, skipping certain tiers seems
> > > much more intuitive. Maybe Youngjun have some idea here?
> >
> > It wouldn't be confusing if this is something users don't have to
> > think about at all :) My point is that we don't have a use case where
> > we need userspace input on vswap-enablement on a per-cgroup basis yet,
>
> Ha, you really can't assume that for everyone :), we even have
> workloads working at different compression levels, and the tiering
> series shows different cgroups working on different devices, there has
> been pathes enabling per-cgroup swap device a decade ago.

I still don't think you're getting my points.

Compression levels have nothing to do with vswap selection. It has to
do with *zswap* (i.e compressed swapping) selection (or the algorithm
being selected). Vswap is just the transparent mechanism underneath.

Once you HAVE selected zswap, then the question of "do you want vswap
or not" is easier to answer:

1. Overhead: rather minimal with vswap (at least based on the testing
I have done so far).

2. Usability: vswap buys you the decoupling of swap space from
physical swapfile.

I struggle to see why you would not enable vswap if you enable zswap.
And more accurately, a scenario where you want vswap in some cgroups
with zswap, but not others.

Taking a step back from all of this - we're arguing about the
participation of vswap/xswap in an interface that has not even been
merged yet. None of us can say for sure how it will look, or if it
will be merged in the first place. I think that making sure vswap can
participate in that interface is already more than reasonable. Once
that interface is in, AND the usecase that necessitates per-cgroup
vswap selection presents itself, then we can expose vswap later.

>
> > > > Potentially, but we have many users at Meta. There's a huge diversi=
ty
> > > > of machine types, workingset size, access patterns (both frequency =
and
> > > > file:anon split), compressibility, etc.
> > >
> > > You can just set the number as 8PB? :)
> >
> > Sure, but with the vmalloc-array approach, there is more metadata
> > overhead even if we have not allocated the backing page of the
> > clusters yet. This will be annoying on the smaller size machines
> > (O(dozen of GB)) to also pay the overhead of 8PB-swap space metadata
> > reservation.
>
> Not al all? With VM_SPARSE, you literally have zero overhead, unless
> you really use these slots.
>
> And even if you really use these slots, the overhead in both CPU and
> memory is lower than Xarray, if I did the math right. I just ran a
> quick test with Baoquan's Xswap, forcing it to start with 8PB on boot;
> it was smooth as batter on a 1GB box and still worked fine after heavy
> anon memory pressure.
>
> See below (8PB xswap device with almost no metadata overhead, the only
> overhead comes from zswap so I reduced the tree number but that can be
> easily merged into clusters as we discussed before):
>
> ### Before XSWAP
> # free -m
>                total        used        free      shared  buff/cache   av=
ailable
> Mem:            1464         405         756           1         544     =
   1058
> Swap:              0           0           0
>
> ### Create a XSWAP device, I hardcoded the max size in code to 8PB,
> ### and use fewer ZSWAP trees:
> # echo 0 > /sys/kernel/mm/xswap/create
> [  140.289280] xswap: adding extendable swap type 0 (prio -1, init 733
> clusters =3D 375295 pages, max 2199023255552 pages)
> # free -m
>                total        used        free      shared  buff/cache   av=
ailable
> Mem:            1464         407         755           1         545     =
   1057
> Swap:           1465           0        1465
>
> ### Lift the ceiling to 8PB:
> # echo 4294967296 > /sys/kernel/debug/xswap/type0_cluster_limit
> # free -m
>                total        used        free      shared  buff/cache   av=
ailable
> Mem:            1464         403         756           1         547     =
   1060
> Swap:     8589934591           0  8589934591
>
> ### Run memhog:
> # time memhog 12G
> ...
> ________________________________________________________
> Executed in    4.36 secs    fish           external
>    usr time    0.46 secs    0.00 millis    0.46 secs
>    sys time    3.77 secs    3.80 millis    3.76 secs
>
> ### After memhog:
> # free -m
>                total        used        free      shared  buff/cache   av=
ailable
> Mem:            1464         336        1136           0         222     =
   1127
> Swap:     8589934591          31  8589934560
>
> The only different from vswap now is that you just hides everything :)
> (writeback is not hard to add)

Ah I see hmmm. I probably messed up my napkin math.

Regardless, I think we have strayed far from my original ask. It's a
good idea, but with significantly less exposure to correctness and
performance testing. Baoquan himself said it:

"Throughput is within ~2-3% of plain swap+zswap on a 64G/64-thread
swapout, so it is dominated by zswap compression, not the cluster table."

I've even tried to show that that if we are to want it, replacing the
xarray with vmalloc is simple, conceptually.

Why are we throwing away all of the testing, validation, design work?

Let's recap the arguments so far:

1. We began with: it's more performant/less overhead. Which
intuitively makes sense, but the numbers have not played out yet. And
as I have said, we still keep the old code in tact. Optimizations can
be done on top after the main use cases have been landed - it in fact
gives us a testing grounds for optimizations.

2. Now we have moved on to "it's simpler". My apologies, but I have to
push back on this, because the comparison so far is so unfair it's
farcical.

With xswap, we're rolling a custom-written extensible array. It
requires a 1000+LoC patch series to implement.

With vswap, we're using a data structure that work out-of-the-box
(xarray), with well-understood API and concurrency model. Yes, it
involves more null checks and interactions with RCU, but with vmalloc
we're adding a workqueue to support only tail-shrink, and have to
invoke vmalloc API, which includes nasty surprises such as sleepable
allocations, which can cause deadlocks in lock section.

If we're comparing LoC, the first 2 patches of vswap, which enables
writeback-less swap virtualization, is "+440 / -37" and "+456 / -29",
respectively (including places where I have to set things up for
writeback, detailed documentation of the encodings, etc.).

I don't think vmalloc is significantly simpler. It *looks* simpler,
because the interface looks like plain array access, but unlike the
xarray we're in charge of maintaining the entire data structure
itself, not just using it, so we have to take into account the data
structure's implementation in the complexity equations.

3. Userspace API - there's more to argue here, but I will note that
vswap can be runtime-enabled and sized too. I just don't think there's
a good use case for it yet (but we're discussing this in other
threads).

>
> > https://lore.kernel.org/all/CAKEwX=3DNYoMH8pTKeCvA=3DXHFmmNVMeDz3mxbhp5=
q6-PxSTJ5wOg@mail.gmail.com/
>
> Right I saw that, but 64 bit of private id will make shadows really
> awkward, not for SWAP but for file folios and file mappings, swap
> table is actully fine since memcg_table is standaone, and we can
> workaround the hieratical refault distance issue in other ways (e.g.
> record the reclaim level instead of memcgid direct). I think 24 bit is
> good for now? As I've never see anyone ran into issues
> with even 16 bits in production.

I think you misunderstood me. I'm not proposing raising the private id
- I'm proposing we raise the size of the refcnt field. That's the
thing that gets saturated.

Technically I think you can reproduce it with baseline - if my napkin
math is correct, if a cgroup has more than 8TB worth of swap entries
(4k size), then the refcnt will be saturated. You can already create
an 8TB swapfile today, IIUC (even without vswap).

Anyway that can be fixed as the independently from swap
virtualization. One thing at a time.
