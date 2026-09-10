Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA4F53CA6D
	for <cgroups@vger.kernel.org>; Thu, 10 Sep 2026 17:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789060624; cv=pass; b=U1DM4Yvmgg3LjmmL1T+ovk+JzKbY0D31CzCzqmvIv1bNmAyvXLFIRH/pCGxSlYWSlpwUzmpZBvxVbJjloIQ6lAGUydBBvok42Y7UbYXvxxdxq0FcOmd+yEhin//kRyx/8ZTWenqDqV9pYkOlMOSLQNQvo/sxRwFuBVdKuHxjYnM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789060624; c=relaxed/simple;
	bh=A0RbsDG1ChzNVyidPdX7CwFzL627kDR4hq9OXIehPfo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cEaMlVXm87q6Wq3KEpc5Dg5dHrnXMPaW7bZsCg8/UO0pPXV54FD2Tk3lhDjr8t9DwoHtutFgNFBdD/uygwY2eoKkR8MY47cFUxmrV3l20vdI5B3w2i5x1BQygTUukbsx/XdjtaKh9B65SyRkE4nJz4F13reTSltzk06jTppu8Jc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OANOFSma; arc=pass smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OANOFSma"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49d1fb0cf5eso628375e9.3
        for <cgroups@vger.kernel.org>; Thu, 10 Sep 2026 10:16:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789060602; cv=none;
        d=google.com; s=arc-20260327;
        b=L4AgQbDmroWrCZ5txTwVwYgrfYv4a449P+ek9y1znKVJZMaMMpqVHNN/zXm9Q4rQLs
         wiEO+Ytxtbbg5IV65KMSYmrdhQIqRjeMfqhDk24iO04y3MPhoa9vos1zKpoy/AFM1EUK
         ZNgGg+uk0Saak1nOmYjq6CSsmFPx5NU3HxNd49oLcovhxdM/26/aYqeIfnzxce/A2t5M
         RLWYKAEOMvQUtRpyYXL/4+5kyygICgTjUAv9lcVJUx7lS3wxNFjlrngkc4QCby+6vzBB
         jQv6jq4dHhYnJ9t3if/nYUOVLSINmWMjyv33roHMKMvd/Fl0Mxre16yjfvtG0+Qkr4wf
         hWNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Un/VHATR/EGghh0ufBgw09ip6SjFofuvZJfHCoUMPHk=;
        fh=mfsKHp1T4hTTHmh1lKgRyIxM8BLCgHs26l0ADkw8MiI=;
        b=WjtKAuMw3BPfmzC8M1Zn2bGqOLadkXt0sK1vZYPlz5awZTFfklWEbDRFpppj/EidCr
         gwya0mdPy0l1UJ+V92rN6KafIoAgWUbnbfJ1N0AXkbSXlA2hLigaLfcmkd9QxReiTtMD
         7Fk109pknJTTaQ/wadBT75+PmiZ/0aLLwnSLAUEDqobTlfO4Azzq6Ll8uz2U4DeQngVv
         Q6Ftm0rgub6/vCcVZe4GP0+eJ9XeVJaerek1HbfE1InrSSOgm0uHaopLlwkUW3iiVdVf
         DaXrhNBBzlgYMRHM8Tn/by4cctAF1pu0D523vF+eU8p7n0Lw3NymmcGGk25XpbTLxlII
         nc2Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789060602; x=1789665402; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Un/VHATR/EGghh0ufBgw09ip6SjFofuvZJfHCoUMPHk=;
        b=OANOFSmaJ9QgCWjqNumMYGh18urEc6QtY0VoKvgSBIutiUNXmUrYkqwDKasPKkOqJh
         CEUWHIpHWwhDGue5cMa9uz1VoNexjg1y0Q7hgn6v/1GLKoH46vyThRe7S57k7ZSUYVYr
         jw5av8NI0z6kZW13dTdST1jaDDAZQHzm7wD+7pC9sc2MG5dqPzxSnxWLEb0xFMviKNWy
         OxKOV9aP4M+gdh9jzM2wbNRABkNxIgUtKHlicDVggTaVyMlgdz8Ct84ucNApXwzT+1qV
         eAPlEBHiKUJJb8br4BCTjU7V6EzsPB4Rzyeh14zeFsjTmKEG+XRCdY7IHPVggMzvhWQI
         T7QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789060602; x=1789665402;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Un/VHATR/EGghh0ufBgw09ip6SjFofuvZJfHCoUMPHk=;
        b=L69Ghi6v7CDW029QvZb8BLxiSQ0yTEET0Hs82I3Ta6OAuu2uBXozOTJGORCIiE5Zdu
         5FqofdHUr0ptK33D0bZbXjbh0EcA4H1ypaQZM10rtNfCpuKh6VXA9Tr2yZ58J+aBIvAY
         B0+BM4RKozMoTAioYHUYtHzQXrXqQxemQHFx1AElUrSzu1/KHjjf/MYXqw4wdRGxEn5i
         1PWHYXyfmI+EednL4o88Qr1yJA8HS4hYyh458UCLfvfGQResiehhhEon64fpS7AAmgBO
         aPabJt+JtEodwc5PcJO6ACUM6neK2/FGlG7ODPe5TTYWa2y0dwmdmiVJwpfvfN7PGhxt
         eE4Q==
X-Forwarded-Encrypted: i=1; AKwUvByXdKy6JuY3xEFKF2Ca1osy4zAFRAzQ/brbLY6RokxqAnHyhS3WfQo64shTe1MFQAT7bWqAhav0@vger.kernel.org
X-Gm-Message-State: AFuF++ldbBqwtGZ4Yhk3WzLkRqJzf2z0TPpMw7vM+KSxCbrLZj2io6x6
	x+77k6nJf96Wrh9WlwuFQRyK9MyMePfPbKcZGv4kMHvvgYpgwvaCJCjCsfnGESfu+QbA28zF8OB
	xrJ8/Fy6mS4oRKCDweYRHgaesee0ntMA=
X-Gm-Gg: AYBFou1/u3Jaloh+Go3boxXxeeVV/yI1ShnPiOo7aWwgIY8XAdIUCnYlBEE3ljhO2Hg
	IScizer7HAajdG5HgaFZ+4cXeetd+6GCwkSGtCyP46ULVl3lv2cRJcTI7tl9xPNaLpskXehPFAa
	UHM5EVfyub7PAQxv9xQOSRlxvTL4VK3UEkT3Yk93GZv/SDCUvcfOnII1W/9JoZx7khKzX2P/c3V
	PesfwyS0tkDHLp5wAivev2emAtGzFXJ6VQN955Y8E1ImCv+Ed54jFJijVFDEmioebGtLCsx1RC0
	8ILXJzDLOtytFtdPtcskpgMUKhTpETLwrlfaNjUAlZEbzkDABumB5qiGPLvnvIHghP8wVf69tWi
	h+HHQkAENgTGg
X-Received: by 2002:a05:600c:8b88:b0:49c:f512:2361 with SMTP id
 5b1f17b1804b1-49d2593842emr197602865e9.14.1789060601172; Thu, 10 Sep 2026
 10:16:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora>
In-Reply-To: <aqJXx2vtbKaRLt3x@fedora>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 10 Sep 2026 10:16:28 -0700
X-Gm-Features: AcwNN1VTPR2ZTAJOXYkJZpQy9m22jjFCFlr0LTd8tBFFtkKWaolpETKGFGCIdxs
Message-ID: <CAKEwX=PaQG68C6=jpaRmAXrzw4c_90rv1YwGdmrEWq_RXqVeEA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Baoquan He <baoquan.he@linux.dev>
Cc: Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
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
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 10, 2026 at 12:10=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> =
wrote:
>
> Hi Nhat,

Hi Baoquan,

Thanks for the detailed explanations. I'm glad it's all laid out - I
think this clarifies a lot of the confusions both of us have about
each other's perspectives so far. I suspect we're talking past each
other a bit (hence the effort to organize some form of VC, or
preferably a room where we can whiteboard things).

It's a very dense conversation, so I hope I don't miss any of your points.

>
> On 09/04/26 at 02:14pm, Nhat Pham wrote:
> .....snip...
> > Now, on xswap. Baoquan's working on a series [15] that covers some of t=
he
> > same ground, and the VM_SPARSE cluster_info idea in it is genuinely goo=
d.
> > I've been reviewing that lineage since July [16] and I'd like whatever
> > lands to end up with the best parts of both. From my perspective the
> > differences are:
> >
> > 1. Userspace knobs. xswap asks the admin for a size (a percent of RAM) =
plus
> >    a per-device limit to tune afterwards. I'm not aware of any use case
> >    that needs those, and I don't think users have a good way to answer =
the
> >    question anyway - sizing swap for compressed memory depends on memor=
y
> >    size, workload, and compression ratio all at once. That's precisely =
the
> >    provisioning problem vswap exists to remove. The kernel should be as
> >    transparent and dynamic as possible here, and not add knobs unless
> >    there's a use case for them.
> >
> > 2. Writeback support. Writeback is core functionality for zswap, not an
> >    add-on, and a design needs to account for it from the start. This ca=
me
> >    up before, in the discussion around Chris' ghost swapfile RFC [17]: =
for
> >    a solution here to be acceptable, it has to work with the primary
> >    usecase and support disk writeback. Without it, whatever zswap won't
> >    take (incompressible pages especially) has nowhere to go, and cold
> >    compressed data can never leave RAM.
> >
> > 3. Cgroup charging behavior. vswap/xswap shouldn't be charged against t=
he
> >    swap usage counter. It's fundamentally a different resource from
> >    physical swapfile space, and memory.swap.* should read 0 when nothin=
g is
> >    on disk [18]. I made the longer argument for this in [19].
> >
> > 4. Data structure (xarray vs sparse vmalloc array). Even with xarray, v=
swap
> >    is already on par with or beating baseline. I like the sparse array
> >    idea, but why are we landing an optimization before the feature itse=
lf,
> >    without any A/B data showing the difference matters?
>
>
> Thanks for laying this out, and for the honest push to converge. Let me
> be equally direct about the ordering: I think the xswap base should land
> first, and the things vswap demonstrates -  writeback, rmap lookup, the
> charging semantics, later THP -- should be built on top of it. Because
> it is the foundation that keeps the swap core simpler, and the first thin=
g
> to merge should be the one that doesn't have to be redone.
>
> The VM_SPARSE array is not an optimization to bolt on later; it is a
> structural choice, and the code reflects it. In vswap, the cluster
> metadata lives in a dynamically-allocated xarray.
>
> struct swap_cluster_info_dynamic {
>         struct swap_cluster_info ci;
>         unsigned int index;             /* for cluster_index() */
>         struct rcu_head rcu;
>         atomic_long_t *virtual_table;   /* Backing pointers for vswap slo=
ts */
> };
>
> To support dynamic growth and shrink, vswap stores its cluster metadata
> in an xarray, and that forces two things the plain swap_cluster_info[]
> array never needed:
>
> 1. Every cluster has to carry an extra index and an rcu_head =E2=80=94
> 24 bytes per cluster =E2=80=94 purely so the xarray can locate it and fre=
e
> it safely.

I will flip it the other way around too.

With this approach, you induce 8 bytes of overhead even on physical
cluster that has no business storing vswap related information. This
overhead exists as long as you build with CONFIG_XSWAP, even on
cgroups that don't use it.

That's sort of why I went with the new cluster struct embedding the
existing struct, rather than adding the vtable/xs_table to the
existing struct in v3 and v4. I mean it's small, but why do it if it's
avoidable?

> 2. To keep that bookkeeping from leaking into the normal-swap code, the
> cluster had to be wrapped in a container, swap_cluster_info_dynamic,
> so the xarray holds a pointer to the wrapper instead of an inline
> array element.
>
> So in vswap, every cluster access in the shared hot path has to answer
> "is this a vswap device?" and take a separate branch:
>
> - swap_is_vswap() is checked in 36 places across page_io.c, swapfile.c,
>   zswap.c and swap.h;

I think if you extend the vmalloc approach to cover the writeback use
case, you'll find equally many places where you want to check for
vswap.

It's simply cannot be avoided - if anything, for correctness. Some of
it will go away as we evolve the code (for e.g, if vswap becomes the
sole way we can use zswap).

> - __swap_offset_to_cluster() branches into xa_load() for vswap vs the
>   flat array otherwise, and the xarray path can return NULL (a cluster
>   can be torn down);

The xa_load() I have no arguments for. It's just data-structure
requirements, but it should go away were you to move to vmalloc array
down the line.

But the NULL-check is not an xarray property. It's a fundamental
requirement for true dynamicity - i.e if the cluster can go away under
us, then we have to null check wherever we do not have a surefire
reference, no? For e.g, in do_swap_page(), before adding the page into
swap cache, you cannot be certain that the swap entry is staying
around...

> - __swap_cluster_lock() branches into __vswap_cluster_lock(), which
>   wraps every access in rcu_read_lock() and a CLUSTER_FLAG_DEAD check,
>   plus kfree_rcu()/container_of()/rcu_head plumbing for node lifetime.
>
> With VM_SPARSE, xswap's cluster access is exactly the plain-array line th=
e
> rest of swap already uses:
>
>     return &si->cluster_info[offset / SWAPFILE_CLUSTER];
>
> no branch, no RCU discipline, no tear-down state machine, and no NULL
> return. So VM_SPARSE doesn't add complexity to close a gap; it lets the
> cluster layer stay as simple as it already is, which is precisely the
> part later work (writeback, rmap lookup, memcg charging, THP) has to sit
> on.

Except you have to write multiple patches to handle dynamic growth
(and a limited version of the shrinking).

I don't think it's a fair characterization to say "vmalloc is simpler
(if you just avoid these multiple patches I wrote to custom roll an
extensible array)".

>
> I'm not going to claim xswap wins on throughput. I measured it:
> on a 64G/64-thread swapout, xswap, vswap and plain swap+zswap are all
> within ~2-3% of each other, effectively identical. Because the cost is
> dominated by zswap compression, not the cluster table. So the ordering
> question is not "which is faster" but "which structure should the use-cas=
e
> layer be built on". If vswap is chosen, the xarray-based table is an
> intermediate form. Your own ablative study already showed the flat array
> wins, and VM_SPARSE is exactly that flat array plus lazy mapping.

I need to clarify this point in particular. What my experiments on the
synthetic/semi-synthetic benchmarks show is

1. Baseline (old code) / vswap / baseline + flatarray (i.e replacing
zswap xarray with a flat array) performs within noises in most
benchmarks, on most metrics

2. vswap and baseline + flatarray both outperforms baseline on free
time of usemem, by the same margin.

Basically, what I wanted to show that a huge part of the wins come
from zswap's xarray being very inefficiently used in free path (for
e.g during process exit). Vswap also uses xarray, but in a more
optimized way in this path (one single tree walk + one flat array
walk).

So I'm not quite sure your characterization of "flat array wins" here
is quite fair. It wins... compared to status quo, not vswap.

So IOW, vmalloc array approach does NOT outperform xarray approach, in
both of our testing.

>
> On the metadata side I want to be precise, because it is easy to overstat=
e:
> the per-cluster cost that xswap saves is the xarray-induced index + rcu_h=
ead
> (20 bytes/cluster or 24bytes for alignment), small.

Thanks for verifying my analysis. I understand that this overhead was
a long-time concern for folks - Chris pushed me a lot to minimize
this. Took me awhile to realize I could get around it.

>
> On writeback: agreed it is required in the end. But it is a consumer of
> the foundation, not a reason to pick a different one. xswap is deliberate=
ly
> the base;
> - writeback
> - rmap lookup
> - THP support
> - memcg accounting
> All these can land on top of the xswap base rather than be stranded on a =
table
> we later replace. As we have discussed and I have been mentioning in each
> cover-letter, I didn't touch these core changes, glad to see your work bu=
ilt
> on top of it.
>
> On the interface, xswap v2 drops the percent knob entirely (your point ab=
out
> "why not just max out" is taken): create now takes only an optional
> priority, a device starts at full RAM, which is free because the VM_SPARS=
E
> area is mapped lazily, with an optional per-device size limit for admins
> who want a ceiling. More importantly, xswap keeps per-device instances
> because the swap->ops and swap tiering that come next need per-device
> operations. A single boot-time vswap can't express that, and it breaks th=
e

Why do we need multiple devices to support per-device operations.

I have decided not to opt it in to swapops yet (vswap swapops),
because it just doesn't really buy anything quite yet.  But vswap is
just a normal swap device, no? It can have its own swap device
operations etc.

> per-device conventions the rest of swap already follows. When I tested it=
,
> there is no way to disable it at runtime, so it can't even be A/B-tested
> against regular swap in the same boot. So I think a boot-time vswap is an
> independent issue which deserves a separate patch posting with a convinci=
ng
> justification later.


I think it's the other way around. We need justifications for why we
should expose virtual swap device to the swap tiering abstraction.

I think we should leave virtual swap device out of this interface (i.e
being transparent to the user), and add it only IF both are true:

1. There are some cgroups where we want vswap, and other that we don't.

AND

2. This is not something the kernel can decide based on the
information it already has.

1 seems reasonable, but for the use case I can think of, I can almost
always come up with a heuristics to decide whether vswap can be
bypassed (for e.g, if a cgroup only allows for physical swap devices,
it seems like there's no good reason to use vswap at the moment -
you're just unnecessarily paying indirection cost). So we don't need
extra userspace input here.

Of course, this might change in the future. But I struggle to see how
vswap cannot be extended to fit in the swap tiering model? It's just a
normal swap device - you can export some special identifier for it,
and user can echo <that identifier> to the cgroup's swap tiering file.

>
> So concretely: xswap base first (runtime file-less device + VM_SPARSE
> cluster foundation + sysfs create/destroy), then the use-case layer, wher=
e
> your writeback work, etc is very welcome. The base should be the one that
> doesn't need to be redone; by both our measurements, that is the flat-clu=
ster
> substrate.

It's not quite as simple as that.

I think the other concerns is that can xswap be extended to support
vswap's full scope. I will note that as of the v1 of your patch
series, even the dynamic growth portion itself of xswap is still a bit
buggy. Maybe v2 will fix this, but that would be multiple more
versions to even unblock a subset of the use cases. Vswap meanwhile
has more efforts poured into it, including production workload
exposure. You're asking us to invalidate all of this effort, which
will set us back quite a bit of time.
