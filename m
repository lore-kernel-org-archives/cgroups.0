Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28F03B777C
	for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 16:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790355290; cv=pass; b=ECkCYZ/Fr06FUjHWlVhjBJVg/YxQQZtzylfNyLX4V6EmaRJfttn4xuP5kLYG7lP279eAvaFUC5eXssXapYWIn7Ggw5PCs17tAMDzR6HHRNBaaM5h9bFium7VTePOrVqkk1ZqRmgjWEFO/5ffi7N+6T9qbqQpN7LGM7RWz6dlTLc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790355290; c=relaxed/simple;
	bh=Rq8JlmKjQPqCOGt36H4bhTZin8GIP9f142Zycu8n3OI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k3NLopfCLlWinvW7/2imtzt0xkPlso0Hg+vo5Vuda4EtRh95SmfSJgD3i8cWLC987CBrGfarHAdtJ2d/A5sFWaHFxRlDEA/XfVHPflN4bQMBUw9zvdT6r2XXx6jY0ZjW/47/N1HoW9iwQlO036Kb3VEkYUjqA1ZR7E6j7H7fjJ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YTl1cngy; arc=pass smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YTl1cngy"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f63546c5so923409f8f.2
        for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 09:54:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790355277; cv=none;
        d=google.com; s=arc-20260327;
        b=VTLuadnJVMNYDMEMfbUrZNwsvKVAltxr15UAc+Km6Xwe/2ln430Z24eGJO+11c2RN/
         Y1nDUutIR9P8tRFCgFfwXOJPvdsltue9yAooHFFI08svH1JXZSyVbZDqnKXPqbj1eLAP
         I31jmyTVdE60SScqpRcbejdhI4jrbNfhiWIWtWmfJI1WFwwZiNXdVkHxqXBP/lcTRhSv
         q0x2Vt0Rrndo0mgaN1x5PVd0hFanOD0jFCD8pzHuSIbigOPbbvmoyCx20V9f+HRz0SZi
         huraKY8TX8Mys26TBZPs6+lhaVm2wP0ZU1x5c+ciWlEF899rxYpLZuiHoRZFsfd46Fxu
         5qYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zB6y5YhkOLzSNaiUrMoC/Z2pJ3kqHY43Xibqpz7MDRs=;
        fh=MNxQ0siM8xGOpC1zzX6gZF9hNf79ZjkdVTYdSS+X+sQ=;
        b=B8yiWPu0TycNPRKrGadh1Zbc1APv2DYp+Yug60Vr/fxvxJJ76LLt5uhhOWjBBsy8ry
         Lsv0KkbwBRtifV6W55tg1oYxkgW4i94QOGtwzoZUGq86dEcsRrRB0jXlM8fSQbPrFey0
         LrtB2rUQlwVcfdwDbOGEL6TKnkxBJoOcI3I3Dq9ckWtGYYdd231Ee6dfaoFmsyN+q9fK
         x7jYuei0oqqICznQtuNJYGybGwdJnlT4RjSfskJWxrpOUfqEbYm2tIBhsQ7EeUiUWBqf
         +kkBoHeg51nFkvBkGN/qz7uYFBU2I53ysBL/J6BVzuDuUa5UgMeQeWZHanGNXCdVRupK
         cUxQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790355277; x=1790960077; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zB6y5YhkOLzSNaiUrMoC/Z2pJ3kqHY43Xibqpz7MDRs=;
        b=YTl1cngyva0z4WhvRtyB2EXtfsgpzF6BRD6CQnHXqoE91l/eC3TCidBhVn69KJ6fxC
         kmq0MBFXBOEGmfl+mu5jMxIfjJmuJShXWKZEyodZxw9p0pTgYRdeveRpnty22LIUd567
         P4zPw0JbSJg6DhkTtqFP52fKy9X69R9WYhI0n+eFsnEX54YvWVkLLIxRTJYvSKbBGRPE
         mqmx6myzJDRz/Bu62ukSWYUH3DfLygiPzecFUoDV/j+eS7wB3BYJCBt3QiJ+Fa0qHWUA
         I1HDPzscBnfcOYZYiwnWjcvxYLKoqK2+h4yGGKkLbb/N62PiEiEmHQT8YXqcfLQD3AUm
         dvdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790355277; x=1790960077;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zB6y5YhkOLzSNaiUrMoC/Z2pJ3kqHY43Xibqpz7MDRs=;
        b=kuJqmFL7hOaOAT2qu09C1BMKSWo2hRten6EyKDPQVFBspxRyM+U6dd8XSFaYmHTxdk
         78iTXKxm7GogYwy7LGoet5vGzSz1YDsYKUNq8EEdRMlnFk9cFHOwQVWmXoreo0VysfdU
         502KPg4UcDOQJoJz0E4b3W3Hh3SccOYUDMAfiwqrE7A4LnwPL7lQxpSIepD4rYN9QFuf
         TO6Ye/XWFe4Ox7v74fc19GQEzalCYorZrHAy1Oukc0VKwVQ6reTWpR3oe8VcmEVKVkUM
         yuxtL3VVxe/7+BjAkEzKA5u2SSgCnow+55kN3AeZ2nlNefRbSkAVK+hpwfrQ49H/0dUC
         m9rg==
X-Forwarded-Encrypted: i=1; AKwUvByP8sb/KdOHsKwDvW9a03AHdRwEKgRaypCawf9TitxwliPIKmFmOs79+ep/HuO80supLmTLTF93@vger.kernel.org
X-Gm-Message-State: AFuF++mdsUwVgcvJHqwR1tcewTKWa6ve98At49r7LUsJTSqw/GfiUScM
	iaDKy6H/72bwUlaOPaJRINnDIkSu4QMlbzWeT61y7qGgbnchtmG1NQ3rSMsdTFdAJtIbVzrmZ8c
	2pbMWczNteSh1XdNnYx7GqfnPB29/XE0=
X-Gm-Gg: AYBFou1F8mWmLj7xj6XrSxoZ7NcECaa2O6sBKo00tHyZtKu8+xrg/tbVGsYKD29/jz8
	iV2YB42hmJdqEA3jF6+ya7BUDqSubkUTWIpeuZBV76K6sNvXvYHnnbDpdAHlsXWZN1Avc/X2i5F
	cpax/Ak/250dRWVdpN6FHHXWy4HrqbSekTHSPtAVrrr/td9Q4U/zk4ROu3OMq6BOgsiMD5Xi8oB
	YpePGo90ou9UpvgciQNoWCi5e82Lk4uliMnX0FCLqrLzSATc46+zavDb9ZhfnWOjeC0lu3Isdef
	QGvtLWKmisf+wHt1WMsYt619d+8/E4HbZLTAINYQiICpIuC+7H+mHLlliswQGqpntv/FEF6ZG72
	TgscCZblk4hA=
X-Received: by 2002:a05:6000:2c0e:b0:488:8546:d0b2 with SMTP id
 ffacd0b85a97d-4888546d0e7mr166478f8f.51.1790355276640; Fri, 25 Sep 2026
 09:54:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aqQrPLPXHXiuKup0@linux.dev> <aqjcFb6MFNiA6n4V@fedora>
 <aqjpYHbZ14A8xRtK@fedora> <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com> <arUcil9kxUPiymXI@KASONG-MC4>
In-Reply-To: <arUcil9kxUPiymXI@KASONG-MC4>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 25 Sep 2026 09:54:25 -0700
X-Gm-Features: AclHuK-Pj8MGTN6slhH4ZC6bRNscyhuI_rUSwJmyxZ_HRRIbsrEA4QXnbtSmaac
Message-ID: <CAKEwX=PXRB35bUL1=O4Bgx9A7aD4izZZ3dcEcCuMBBhBrMv7fg@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Kairui Song <ryncsn@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Rik van Riel <riel@surriel.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
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

On Fri, Sep 25, 2026 at 6:15=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Tue, Sep 22, 2026 at 09:44:37PM +0100, Chris Li wrote:
> > It seems you are talking about a different topic: the vswap charging is=
sue.
> > There is a golden rule that we should follow: don't break existing
> > users. At least with the same persistence, this rule should apply
> > universally.
> > In the swap tiers discussion, the UAPI was such a big deal that we
> > couldn't implement new UAPI. On the other hand here we argue for
> > liberally changing user-space visible behavior.
> >
> > BTW, I already shared that changing swap counter charging will break
> > our and others' existing deployments.
>
> Hi all

Hi Kairui,

Thank you for your thoughtful response! Lots of food for thought for me :)


>
> As I read the threads and try to clean up the requirement, just
> realized that I forgot and ignored something previously. I think I can
> share a few things here.
>
> I also see that Rik mentioning that:
>
> > It adds up anonymous, file, accounted slab, and
> > (after compression) zswap memory use for a cgroup,
> > and can be limited with all the usual cgroup
> > limits.
>
> That's very true, and that's also the one reason we can't
> migrate some workload to zswap easily (at least yet) :D
> See below.
>
> The discussion on this can be saw two years before (I know
> things are different for V2, so see below):
> https://lore.kernel.org/linux-mm/CAMgjq7AYA91f4g-bknUZOMg6hApTD-X5LqjcTBN=
2u-Lu8pjs+w@mail.gmail.com/
>
> An minor update for that, memsw in V1 serves pretty well (we also
> modded that part and would try push to upstream if doable), and as
> memsw is missing in V2, we can still workaround that using
> memory.current and memory.swap.current. BUt missing the offloaded
> part in memory.swap seems a problem.
>
> First a little bit off topic, I'll be really happy if we can make
> both compressed memory and swap as separate counters (I even once
> tried to implement a zpool accounting to account compressed memory
> in some unified way, but, well, zpool got killed before I post
> that :P), or at least a way to do that, e.g. something like nokmem.
> Due to our real usage:
>
> With compressed memory staying in a separate counter (which
> we manged to do that with ZRAM) the memory.current + memory.swap
> (or, memsw for cgv1) could be the exactly planned or sold size of a
> container, the scheduler (e.g. from k8s level) is fully aware of
> the packing rate of a host based on this reading. and can make
> scheduling decisions based on that. And can control it by
> adjusting the limit two combined.
>
> But with compression as a fixed part in memory.current, first the
> compression rate is totally uncontrollable, both the user and us
> will be fully *unaware* of how much memory they can *actually* use,
> that makes the planning really awkward. memory.max stops being the
> bound of what we planned or sold, anything compressed lets the raw
> footprint go past it by however much the compression ratio happens
> to give, so what we oversold is bounded by the workload's data and
> not by anything we configure. We can substract the zswap reading
> though with adaption, however it's hard to change the performance,
> OOM behavior or reclaim behavior:
>
> As you may considering compression is trading CPU time with memory,
> then two things here: the user could use more memory than we expected
> by burning the CPU. And, some users has a leaking application, the
> application could goes super slow or experiencing high CPU usage due
> to memory being compressed. They really just want to get OOM killed
> in time when ever the application leaks beyound a threshold (and
> yes that is a real and actually practical model for many applications).
> And, we can't simply disable memory compression for them.
>
> In many cases we just want a best effort compression to make space
> for low priority tasks, and do not want ordinary containers to use
> compression at the cost of lose of performance. While still has
> a fixed limit as usual. So simply disable memory compression is also
> not the plan, we do need compression to make place for other
> applications, we just don't want their real raw usage to exceed
> memory.max, and we can dynamically adjust memory.swap.max to
> control the oversold part, compression or physical.
>
> And this is not about residency, so memory.min/low don't help here:
> it's about overselling, and about not leaving a container thrashing in
> compress/decompress loops instead of being killed.
>
> And if the memory compression is really fully transparent (not
> doable by software), yeah, that's great as there is nothing to do
> with reclaim.  But, for now, we have to go through page fault / folio
> allocation / map it again. So For example, if we already have
> memory.max =3D=3D memory.current or under high pressure, then now
> doing any read from the compressed part would need to some
> require further eviction first to make place for the decompressed
> new data, this is not like any kind of "real" memory, something
> feels not right here.
>
> Another thing is that I think we has been assuming that physical
> swap is slower than compressed memory, which is not always true either.
> They all need to be read through page fault, the page fault could
> be the real blocker here rather than IO or de-compression.
>
> I also want to separate two things that I think got bundled together
> here: not requiring a physical slot behind a compressed entry, and not
> charging the raw size to the swap counter. The first one is great, yeah,
> and it's exactly the part we want, it's what makes compression usable
> without provisioning disk. The second one is a policy change, maybe it's
> not needed for the first stage, charging a cgroup for the
> memories it has offloaded doesn't require any slot to exist behind them.
> If someone wants to run memory compression with no disk at all,
> memory.swap.max defaults to max, so that still works fine, right?
>
> And I'm not saying "keep everything as it is forever": it is that the
> raw offloaded size (the entries, whatever the backing ends up being)
> should stays accounted and enforceable, and that anything which wants
> to describe physical storage gets its own counter.
>
> And I'm not asking the compression layer to have an opinion on how
> much compression or ratio is too much, just think we need a sane limit
> for container schedulers to sets on top of it.
>
> And "it's opt-in so nobody breaks" doesn't really hold for us: we do
> want generic compression solution, that's the whole point, so we would
> be turning the knob on and losing the counter at the same time. If we
> want one generic solution for memory compression, this is not opt-in.
>
> And if we check again, currently, with upstream kernel,
> using ZRAM, we have:
>
> memory.max: control the raw usage of application.
> memory.swap.current/max: controls the offloaded size/limit of a applicati=
on.
> With (memory.max + memory.swap.max) <=3D planned usage (and this is memsw=
).
>
> We can keep the compressed part in memory.current of course, as already
> did in upstream with ZSWAP, and things can be further adapted, we
> still have:
>
> memory.max: control the real usage of application.
> memory.swap.current/max: controls the offloaded size/limit of a applicati=
on.
> With (memory.max - <compress memory> + memory.swap.max) <=3D planned usag=
e.
>
> Things are not too crazy, but if we lose the compressed raw size in
> memory.swap, things seem to be out of control: the raw footprint can go
> past memory.max by whatever the compression ratio happens to give, and
> nothing bounds it in raw terms, memory.zswap.max is in compressed bytes
> and zero-filled entries are not covered by anything. I can't see a very
> clean offloading model for us here.  And we note, use use both kind
> of deployments, pure compression and hybrid writeback.


Thanks for explaining your perspective!

>
> Just for reference. Maybe a seperate counter, tiering, is a better idea
> than changing the swap counter?

I think memory.swap.* is never meant to be used as the "offloaded
footprint". It is incidentally correct, because of architectural
limitations: zswap/swap cache/zero page usage leads to real
consumption of real resources (physical swapfile).

But I understand your concerns regarding the missing observability of
the "logical" footprint (i.e the "offloaded size"), and how that would
hamper legitimate use cases.

How about a vswap counter that tracks the vswap usage? That would
provide the "logical" view. Userspace can then monitor and act based
on it.

I think that should cover both of the situations that you (and
Johannes in [1]) pointed out:

(1): With memory.current and this vswap counter, you can kill any
workloads that violate the level of overcommitting that you set out.

(2): For us, we can use memory.swap.* counter to provide isolation to
the physical swap space, which is a real, static resource that can be
hogged.

There will unfortunately be changes in userspace programs/scripts that
is required. It's unavoidable. We're adding a new behavior. It's the
whole point of this line of work. But I think as long as we provide a)
a way for userspace to index on (the param which tells you if vswap is
enabled or not) and b) enough userspace machinery to achieve most
common use cases, it should be good.

Let me know what you think. I look forward to hearing from you :)

[1]: https://lore.kernel.org/all/araWKyJ5MENBwXCL@cmpxchg.org/
