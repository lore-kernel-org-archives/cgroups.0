Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852C957C712
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 16:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788885389; cv=pass; b=nvkwVvp0FBWzSrQM0ThVo5x5pN+GGuiy5Ux1JvUVqhPktepDTD4lzAmdv6akLcJ7smRY2Ob0pN8KzCRsPrckYR1liJTyGEXftt6luebAYZq9a6G9o+f3H9ATyP0Q9IMZFIKJ3tsDwByBhnjuRxSnPuGM/TQy1XFWVrRBx/ePF5w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788885389; c=relaxed/simple;
	bh=lEBoRG2/h9gB2hK12UZam2uOCsmYfB1pjTSo33Y1C/c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XlLweXKmuUbWM+SQagw/0bpjkhg7/bFkd15ym6C5D1WRozk//Z9dvij5xaPaZ2IYWWoMBjVhiSE5N3oPr1ToVfIpZjIUDcgCuCmllhKy0kphQwC22EKVgRgtH3iPvnssOYgEgWWT+Wsb4yQDuB9RR+9Ry7X7+6o4OA6XTo4/JiY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kWnF9a0h; arc=pass smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kWnF9a0h"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49b8687630fso41441285e9.3
        for <cgroups@vger.kernel.org>; Tue, 08 Sep 2026 09:36:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788885384; cv=none;
        d=google.com; s=arc-20260327;
        b=e1Qx1CToN+6yNW8w/Hf4aHVbHG5jmOlAN1JTCAW7unJfIMHyRW9QtSWfIvKp6CaJqQ
         cNVkjfba5WXfgVGaPFg6yPtE5Y301V9hVV2ezxLB8vTPnc4biRKzGGyq6EtmrYjbT+hk
         N32rMXe9agsImjGm1yM8X46cx/xSSbbzuDbZlws1b/FPybXrrHzOBanwbhwaIi81JmwG
         fDLVZU7gJrFn8ihJNHhijQOkUpyRdJN4ZAXXqJ0aKi7bBxAXLnXAdYDx5X2Y3sx4QT7t
         2sVBqRO5i3+rzKnyscVVqE61KcoXMyDv4qfZ/yUIWKDjEeWOTC1asM4JoxJ7vXgqE35A
         x5mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4Zr/BCHnDam4SH1NFfeVx9MdOiWK7PPMoeiEMtlXpgg=;
        fh=xc0qDxcDxR6CPYaEvTOMPCPfP9fhKOmO69JR1IAd1v0=;
        b=GQJn9FkX+1dE6HVt9higkxFpbmZxz9de4+RYj/btlamtxxRKmL3ZbTYnJV/NRgLSUB
         R68NMM130+nMweyOtP95n2wARI++nwwwHC3Re78dw/7RKBp+91N06i0r1KT53UDJyFon
         YhgS5FIJgWHO0aZnd8xVX26haUEzg3+adYCcqu5Vruu/tIwSppxFpIcFJyDF5GOuwm6p
         2+2SI+/FPucjlsaDwLCnLodds0dBJFlE1a8JSHs02ztuTGMuWzcgkSJKt6dKH4BvoHSz
         v0RUFGTkmtSkfLrKwog4LHlIg7aK6tq2uvfWercKdaoKv3XW3nbC0JgZEeKhzk7hzHlk
         h4Qg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788885384; x=1789490184; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4Zr/BCHnDam4SH1NFfeVx9MdOiWK7PPMoeiEMtlXpgg=;
        b=kWnF9a0hEGMmpvEFLApUnMHHkwUkvJkQYRLAUHJ914sP22daG3j2PxVnkVK7M/BYWt
         8AGcqG40osZ4cI5y4SIue5Lyinwnp5ytc3HNYNLnq1R9vqItk0TP3XfvZETtxqiJZg9u
         eTEb3vMRw8gaL9CMiDzWmjXmtEplI8tg5u1GtokC0/B6qz7YZnlXNj8jAECEmYVvqKdo
         qfQeuGxXu0HhgRyCAg3R6MmJSUHJLUpaLBUlNf8ymtd07pSvjHwdWU7ft9zaQhkej9Ki
         iNd32zzgzvChp+0uqQP4VFFab5iAA30qrtgYxfx6GKMr7Qtexdtklwc5wiIlAlfir5gX
         SuVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788885384; x=1789490184;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4Zr/BCHnDam4SH1NFfeVx9MdOiWK7PPMoeiEMtlXpgg=;
        b=GiA9U+hBOX+YbPQaLC9IOhSoLNZGhGWYRyxW+qRgTde+1I0FtmZ0OWrTL3GAbGWUvR
         NwTfFfqurtznTH8sJnvYYsNHdIja/0ZaxxCZAf5vsQpAyzYWJuSBjeSV86O9CgYHoZFj
         pu6p5Kkxgy24qRbYimF9SiBDVZfkxzP06WSpuYSuATUFzyl+QDn3bAIdzbLVBYFZSVQB
         Ap+oo0Vg+NTuWcGoxTSOoWQKi9GTIvYr3hQbrwKYLkEV3DmBDIGWfstS5HwoJM5tO29/
         gCEOpvEjaxTZ0oEQG/DVHmSZJ2RWs0FZwFsX0I7ue2cTMXWhKY1zly0tFFh/s4LRt8tQ
         Jyiw==
X-Forwarded-Encrypted: i=1; AKwUvBxU4C5d9XOO7Mm0tI8ZI5bAQ+9Vu1yxd6PgES7BY3Tv0lnIrz4Fgdqfvzb6oJXvMtDwmodWnFlF@vger.kernel.org
X-Gm-Message-State: AFuF++mLQBVtAfASDJdm5PYbogtPVw4eJtlHT6XSoDlSmtnLOPph8JJc
	Gv6APmJuODYOv52UAgKe9AJmaYIDAXmPOboNIruLNO5tqR/fDS0HKLkq/IYTHvuVU/G9jUdfAMh
	RKOwQlE4bFgb7Aogoe2UEDOoQs1fvVvg=
X-Gm-Gg: AYBFou2DqvFvQueH5J5z1Ql8N49axD0qIcdo+n8a59z9DvIxebGbYVHUUSNKHh0zEe6
	bPrJpfKGjZiFErM17GZ2SMil+Cgih2oHpxOhe5JuaJdD4uOI+CgUL+EzmfYehOpTXzszlukYYOn
	ykeeeTrBqeoVdVlGf7PT9aeRhAR70YsIp7mJJ9LBg8VuYMP39c2rGedGfKZ91FuOzTtXBk5ye5Y
	aoGZ6GQmnc3FXWHnQ/jjmO22XDl494Dd34xXMkpxfKs8RY4f3brY6IOFNM0SJf2M6bPOp/EzVQ3
	NRuShlBdJ9OF31xkKB/i1KV7LRUi6LZYRs90efRb9TMW34x6tinnX/kJJIuY2WPnodOu4tt8X0g
	7
X-Received: by 2002:a05:600c:3145:b0:49d:1916:59c7 with SMTP id
 5b1f17b1804b1-49d19165a7amr61456895e9.7.1788885384057; Tue, 08 Sep 2026
 09:36:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
In-Reply-To: <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 8 Sep 2026 09:36:12 -0700
X-Gm-Features: AcwNN1Vi9M-_5AS5imWp6tHLc7BhYcF9rX-QthcMM81tAZyi-lnj_U6rqt_3bHk
Message-ID: <CAKEwX=O8i+OsP6BJXNZNk07hveN9HDT+PoyMTAU6gOc-xp0Ppg@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Kairui Song <ryncsn@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
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

On Sun, Sep 6, 2026 at 10:52=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:

Hi Kairui,

Thank you for the kind words and encouragement :) It means a lot
coming from you.

My main concern so far has been - it seems like every time I satisfied
one of your guys' requirements, another pre-requisite is added to the
list. I mean the performance regression and memory overhead concerns
make a lot of sense, especially when vswap is non-optional. But now it
just seems like we're delaying real use case for the fabled perfect
swap system. It gets very exhausting trying to keep expanding the
scope of this.

>
> I asked Baoquan the same thing, see the "Why not make both args
> optional" part:
>
> https://lore.kernel.org/linux-mm/apaw_XmqnEcY8sv7@MiWiFi-R3L-srv/
>
> Where I've ended up is that unbounded growth is a real concern. On a
> host with no memcg limit (root cgroup, and most desktop and embedded
> setups), an unlimited pool means usage can keep growing, with no
> admin visible ceiling at all. I'm not attached to xswap's percent of RAM
> knob specifically, but I do think some kind of bound makes sense.

Technically speaking, virtual swap *is* bounded, i.e 8PB (xarray
induced a limit to the number of clusters it can allocate). But more
importantly, it's effectively capped by the backend it can take:
zswap, swap cache, disk swap, etc.

I'm not entirely certain this will be problem in practice...? Besides,
we can always add new knobs if needs arise (especially since the old
design still exists if unlimited swapping is somehow real), but if we
started out with some knobs that turns out to be unnecessary or
undesirable, removing them and/or educating users to be careful with
using them is harder, in my opinion and experience deploying zswap
across the fleet in the past 4 years.

>
> > 2. Writeback support. Writeback is core functionality for zswap, not an
> >    add-on, and a design needs to account for it from the start. This ca=
me
> >    up before, in the discussion around Chris' ghost swapfile RFC [17]: =
for
> >    a solution here to be acceptable, it has to work with the primary
> >    usecase and support disk writeback. Without it, whatever zswap won't
> >    take (incompressible pages especially) has nowhere to go, and cold
> >    compressed data can never leave RAM.
>
> Agreed completely, and I think this one is settled: whatever lands
> has to support disk writeback in the end. Baoquan mentioned that
> what he sent is just a foundation though. I know talking is cheap
> but still, could it be combined with the writeback support from the
> other side? Or am I missing anything here?

I'm just very nervous about any design that doesn't quite take that
into account and handwave it away into a follow-up :)

>
> > 3. Cgroup charging behavior. vswap/xswap shouldn't be charged against t=
he
> >    swap usage counter. It's fundamentally a different resource from
> >    physical swapfile space, and memory.swap.* should read 0 when nothin=
g is
> >    on disk [18]. I made the longer argument for this in [19].
>
> I personally don't have a strong opinion on this. But I think this
> needs an explicit decision from the group rather than being
> inherited from whichever series merges first. Skipping the charge
> when a device has a special flag isn't hard to do if the code
> abstraction is done well, so this is more of a design decision
> than a technical problem.

I'm fine with discussing about this. I just want to point out that
this is not something I snuck in :) This has been the behavior since
probably the first or second RFC of the first design though, and in
most of them, it is a front-and-centre patch of its own, not hushed
away in one big patch. Folks have had 1.5 years to comment on it (and
still not too late - nothing is merged yet!)

I'd love to hear opinions from other zswap users regarding this :)

>
> > 4. Data structure (xarray vs sparse vmalloc array). Even with xarray, v=
swap
> >    is already on par with or beating baseline. I like the sparse array
> >    idea, but why are we landing an optimization before the feature itse=
lf,
> >    without any A/B data showing the difference matters?
>
> This is where I'd push back a little. To be clear, my concern isn't the
> size of the win, it's that VM_SPARSE isn't purely an optimization. It
> changes the cluster/metadata layout and avoids RCU conventions,
> could help avoid some future sleep while atomic limitations and
> it's tangled with the initial size issue too. So bolting it on afterwards
> could mean rewriting the parts of vswap that touch it and could be
> costly some conflict in ideas. That's why I'd rather we agree on
> it now, not that it has to land first.

I don't think the current code differs significantly from the existing
model, no?

For the most part, RCU played quite nicely with the current swap code.
Practically, it's just:

1. If you have a reference to the swap entry, you can assume entry and
the cluster owning it is safe.

2. If you don't, then do not assume it's safe once you exit the rcu
read section.

What conflicts specifically do you have in mind here :)

>
> Using VM_SPARSE does outsmart my earlier xarray suggestion :) There
> is an interesting early benchmark from Baoquan, VM_SPARSE wasn't there
> yet, but with it we can use clusters natively in the same way. It shows
> about 20% latency cut and 10% throughput gain, which seems a major
> improvement, and that's serial performance, not even mentioning
> scalability yet:
> https://lore.kernel.org/linux-mm/20260707073215.72183-1-baoquan.he@linux.=
dev/

I think a lot of these wins come from the fact that the zswap's xarray
specifically is *really* bad in certain paths. For instance, in the
free path (swap_range_free() -> zswap_invalidate()), there is no
batching behavior, so we walk the tree from scratch for each entry
rather than using an xas iterator for the entire batch. That goes away
in the current vswap model, because the xarray manages cluster rather
than entries, so you just do one tree walk + one flat array walk.

You can see some performance numbers in my cover letter - it's
promising on both micro benchmarks, and a production workload that I
throw vswap on :) I've also done an ablative study, where I still let
zswap and swapfile coupled, but only remove the xarray and replace it
with the flat array in swapfile's cluster struct. I observe the same
win, basically (especially on the usemem benchmark).

>
> And it matters more than most micro-optimizations: under heavy
> pressure many workloads spend less than half of system time in
> compression itself, the rest is mm/swap. Swap has had a terrible
> reputation for good reasons, and even with zswap/zram users
> have been scared of the performance.
>
> After the recent refactor and optimization we already noticed many
> users can now run much heavier workloads using compressed memory only
> or fast storages, which is a real breakthrough. Every chunk of
> overhead we remove there unblocks another class of user from using
> compressed memory as a "secondary memory".

I don't necessarily disagree with any of the points you made here.
FWIW, I like the vmalloc array idea too. I have actually put in work
to review Baoquan's patch series, because I'm hopeful that it will be
superior in the end (we're using this infra too so it helps us too :))

I just want to re-iterate that:

1. Vswap is already decently performant.

2. We're not removing the old code, so no one will regress with vswap
(they can just disable it for now). Optimization can be done on top of
it after we land the use cases (which also unblock zswap usage for
many parties who are capped by the storage limitations).

>
> >
> > One thing I do want to be clear about: I'm glad other people care about
> > this problem. Chris' ghost swapfile and Baoquan's xswap are both going
> > after the same set of problems, and that's a good sign. It means this i=
s
> > real and shared, not something only Meta runs into.
> >
> > What's been harder is the shape of the engagement. Alternatives keep
> > getting posted and pushed that don't cover all the requirements, while =
this
> > series sits without review. I don't think I'm owed anyone's interest in=
 the
> > problems I care about. But I do think working code, with benchmarks and
> > production exposure behind it, deserves a fair hearing next to in-progr=
ess
> > proposals.
>
> I'm sorry it has felt that way, and I don't want to hand wave it. For
> what it's worth, I did review it, and I did think it could be merged
> with some adjustments:
>
> https://lore.kernel.org/linux-mm/CAMgjq7D4XsAD4NGDL7FC2kaYAQAP8PDJdn4bpzG=
ZwXYtjEpJ6w@mail.gmail.com/#t
>
> We were also discussing the limitation of the global cluster cache in
> that thread, so I paused my other work for a while and posted the swap
> queue series first. That one is orthogonal on purpose, and helps both
> swap tier and vswap, it reduces the overhead enough to cancel out
> the layering cost due to missing caching for either:
> https://lore.kernel.org/linux-mm/20260829-swap-pcp-priq-v2-resend-0-68d3d=
925578c@gmail.com/
> (this is V2, V1 is earlier - thanks to Lian for keeping this going!)

Ah that! I sort of tabled that as a nice-idea-but-still-optimization :P

I'll spend some time thinking about the design and reviewing it. In
the long run, it will get things more simple, but another thing that
should not be a blocker, correct?

>
> Then xswap appeared with the VM_SPARSE idea and exploring it seems
> necessary because getting the cluster foundation right affects
> everything built above where it went. Not because the vswap series
> wasn't worth reviewing.
>
> > So what I'm asking for: I'd like us to converge rather than keep two se=
ries
> > in flight. My preference is that we land vswap first, then build Baoqua=
n's
> > sparse array on top of it as an optimization. That gets the feature in,=
 and
> > by then we'd have the A/B data to show whether the sparse array actuall=
y
> > beats the xarray.
> >
> > If you think that's the wrong order, I'd genuinely like to understand w=
hy -
> > after 17 months and 10 revisions I still don't have a clear picture of =
the
> > objection.
>
> I fully agree we must converge. At the moment I don't think one can
> can settle that alone as there are several of us reviewing both. I'll try
> to be more concrete about what I think has to be agreed first.
>
> The two interfaces aren't equivalent, xswap has its limitations, but a
> couple of xswap's properties look genuinely better to me. Runtime
> on/off rather than a boot parameter is better, more flexibility and

I would also like to point out - I *do* have a runtime parameter in an
older version of vswap (v3). There is also not a lot of engagement
from folks in that version - no one expressed any interest in that
runtime knob in particular. Only Johannes made the case that a boot
parameter is superior, so I switched over. I think his reasoning makes
sense at the time FWIW, and it also removes the need for CONFIG_VSWAP
(which in turns remove a bunch of useless stubs - saving 100 LoCs), so
I figure folks will prefer less code and less userspace decisions :)

v3: https://lore.kernel.org/all/20260806184254.3790858-1-nphamcs@gmail.com/

Regardless - do you have a specific use case in mind where a runtime
knob would be useful?

> doesn't conflict with what vswap is trying to do. Some other of these
> differences involve design decisions rather than just surface knobs,
> and those are the parts we're stuck with once they ship.
>
> So a few current interface difference of vswap and xswap I've noticed are=
:
>
>  - default size: somehow also tangled with VM_SPARSE, which
> needs an initial virtual value. It's super cheap if not zero cost
> (the only cost is occupying some vmalloc area, which is fine
> I guess?). But we still have to pick a number, could be large
> enough to satisfy everyone?

8PB? ;)

I think choosing a meaningful number that covers from O(dozen of GB)
to O(terrabytes) scale machine, with different workload shapes, access
patterns, memory compressibility, etc. is an unsolvable problem. If
it's cheap, why don't we just max out?

>  - boot vs runtime toggle: I believe a runtime toggle is better. It
> can still be tuned on boot via cmdline, but it offers the extra
> ability to turn it on without modifying a base VM boot image or
> kernel.
>  - growth / limits: as talked above.
>  - charging semantics
>  - there could be other longterm design decisions on top of these as
> we talked in above.
>
> Once these settle, I think the picture will be clean. Your writeback
> logic and swap table integration are solid, while Baoquan's VM_SPARSE,
> previous preparation with swap ops give us a structural foundation. A
> clean long-term architecture means getting the core structure right,
> let's try not treating this as a race between series.

I've reached out to Baoquan as well, but I figured there's value in
both discussions in big and small groups, and especially since there's
a chance some of us might not be coming to LPC. Let's see what we come
up with.
