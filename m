Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629EC3C0606
	for <cgroups@vger.kernel.org>; Sat, 19 Sep 2026 08:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789807520; cv=none; b=jlbcYmmZ9lKkNX7LMYrtLVOxhxZmmdJB1dlhT11cc84WlbjdrWiTXmLddWVLT8MeME/oYuAaOdMHw+fRgacslOODFU5KkRb74O14zODBUvNu3/aJ87sOExzIJnM7NU1QxpwYjFnDE7bsYyDGjtD3ixLq4qLe26dNWsFpvM+I0j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789807520; c=relaxed/simple;
	bh=l+x5WCLLD0K04uu+nBOntOn1LVxd/nVcQpDlvHSC54o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FMSX+gkNEVaq29zPs3PVaS/A/Ga+9lQt5RdzwLKSx2rMR/EEmQdYxQ4qZYlvqooLOD1LleYUm9n7VX6rTtvWr9G0zNyMzRvBYCbGjMtjkWFXwubbFVAMcnPpjFeQ6N85nrcCk0GN0P8xD+mxgNSsYF9cEFme3wCi5t8Ux5oMedk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A68R2BYz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A68R2BYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AD31F00906
	for <cgroups@vger.kernel.org>; Sat, 19 Sep 2026 08:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789807517;
	bh=nRAOCdD7CM/ufO6rn26d3KJoJhB/ZPshvT6Y3xlQiRE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=A68R2BYzG0ARFfgXWQsIPqx8KcSadlX0CSMhxlpZBDvA3zdKQwi89+I/zDfUqGApE
	 UcGym7KwXm447C5aB5gErlKaOM1y6qTRHAhmSPRktBgUI8Guf6pow0MSaAhmcgmZ06
	 RTiEKFbcLHOPndbzqS2blG/v8ZfD7RuWOFHtvRS6DjIFhlCJ4Sx6urjTUnvB/MzTYz
	 WnkEZkwpX41NJ3nVmJ7D6klvbL9AQvLtnAmBx2+f/fzN4cqWSD27bff5HeSNyR7wD7
	 d6wlwiqz+HaUWsAHSTI53NKgwO6kuTXGCGKnV4pmH1tYwEU/6Q47R7PIun+iphOrmc
	 ja2gB2fDRdhXA==
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e4aae314aso1195742d50.3
        for <cgroups@vger.kernel.org>; Sat, 19 Sep 2026 01:45:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzQlwDNTHqAPtjEHx1AFwrQQuQbKB1P9+g1nc3D4uzXDWVD6tTUlHVfYxauLeO6aP7BheLTFiMU@vger.kernel.org
X-Gm-Message-State: AFuF++lX9SG2lolrBsFF5HCtJSCHOqhYeVd31lQ1YuocnNIwK8ayILGv
	jYpB0mAHnvRnC/GtWx73n/zNoQWK7uUSHeHN/p6qbGQM1P/bkw3ZIk2Lj0kPQ1BB45dT6Hm27Sq
	StDvr5fY5urwfXP1C20ZxTnzg9F2jPOZ+i+G/cITo7w==
X-Received: by 2002:a05:690e:134f:b0:671:70d1:d6cf with SMTP id
 956f58d0204a3-6717fdf88camr1241019d50.65.1789807516526; Sat, 19 Sep 2026
 01:45:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org>
In-Reply-To: <aqLi6cIjD2wJwk0B@cmpxchg.org>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 19 Sep 2026 03:45:03 -0500
X-Gmail-Original-Message-ID: <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
X-Gm-Features: AcwNN1WSLyMhlFxNJHsYTCCD0ttIzwGTm48gSwEkZRKgP4Dxnf1FT7qjZCZg9Rg
Message-ID: <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
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

On Thu, Sep 10, 2026 at 12:03=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.or=
g> wrote:
>
> [This reply was not LLM-generated.]

Why does it matter?

>
> On Thu, Sep 10, 2026 at 03:09:59PM +0800, Baoquan He wrote:
> > Hi Nhat,
> >
> > On 09/04/26 at 02:14pm, Nhat Pham wrote:
> > .....snip...
> > > Now, on xswap. Baoquan's working on a series [15] that covers some of=
 the
> > > same ground, and the VM_SPARSE cluster_info idea in it is genuinely g=
ood.
> > > I've been reviewing that lineage since July [16] and I'd like whateve=
r
> > > lands to end up with the best parts of both. From my perspective the
> > > differences are:
> > >
> > > 1. Userspace knobs. xswap asks the admin for a size (a percent of RAM=
) plus
> > >    a per-device limit to tune afterwards. I'm not aware of any use ca=
se
> > >    that needs those, and I don't think users have a good way to answe=
r the
> > >    question anyway - sizing swap for compressed memory depends on mem=
ory
> > >    size, workload, and compression ratio all at once. That's precisel=
y the
> > >    provisioning problem vswap exists to remove. The kernel should be =
as
> > >    transparent and dynamic as possible here, and not add knobs unless
> > >    there's a use case for them.
> > >
> > > 2. Writeback support. Writeback is core functionality for zswap, not =
an
> > >    add-on, and a design needs to account for it from the start. This =
came
> > >    up before, in the discussion around Chris' ghost swapfile RFC [17]=
: for
> > >    a solution here to be acceptable, it has to work with the primary
> > >    usecase and support disk writeback. Without it, whatever zswap won=
't
> > >    take (incompressible pages especially) has nowhere to go, and cold
> > >    compressed data can never leave RAM.
> > >
> > > 3. Cgroup charging behavior. vswap/xswap shouldn't be charged against=
 the
> > >    swap usage counter. It's fundamentally a different resource from
> > >    physical swapfile space, and memory.swap.* should read 0 when noth=
ing is
> > >    on disk [18]. I made the longer argument for this in [19].
> > >
> > > 4. Data structure (xarray vs sparse vmalloc array). Even with xarray,=
 vswap
> > >    is already on par with or beating baseline. I like the sparse arra=
y
> > >    idea, but why are we landing an optimization before the feature it=
self,
> > >    without any A/B data showing the difference matters?
> >
> >
> > Thanks for laying this out, and for the honest push to converge. Let me
> > be equally direct about the ordering: I think the xswap base should lan=
d
> > first, and the things vswap demonstrates -  writeback, rmap lookup, the
> > charging semantics, later THP -- should be built on top of it. Because
> > it is the foundation that keeps the swap core simpler, and the first th=
ing
> > to merge should be the one that doesn't have to be redone.
> >
> > The VM_SPARSE array is not an optimization to bolt on later; it is a
> > structural choice, and the code reflects it. In vswap, the cluster
> > metadata lives in a dynamically-allocated xarray.
> >
> > struct swap_cluster_info_dynamic {
> >         struct swap_cluster_info ci;
> >         unsigned int index;             /* for cluster_index() */
> >         struct rcu_head rcu;
> >         atomic_long_t *virtual_table;   /* Backing pointers for vswap s=
lots */
> > };
> >
> > To support dynamic growth and shrink, vswap stores its cluster metadata
> > in an xarray, and that forces two things the plain swap_cluster_info[]
> > array never needed:
> >
> > 1. Every cluster has to carry an extra index and an rcu_head =E2=80=94
> > 24 bytes per cluster =E2=80=94 purely so the xarray can locate it and f=
ree
> > it safely.
> > 2. To keep that bookkeeping from leaking into the normal-swap code, the
> > cluster had to be wrapped in a container, swap_cluster_info_dynamic,
> > so the xarray holds a pointer to the wrapper instead of an inline
> > array element.
> >
> > So in vswap, every cluster access in the shared hot path has to answer
> > "is this a vswap device?" and take a separate branch:
> >
> > - swap_is_vswap() is checked in 36 places across page_io.c, swapfile.c,
> >   zswap.c and swap.h;
> > - __swap_offset_to_cluster() branches into xa_load() for vswap vs the
> >   flat array otherwise, and the xarray path can return NULL (a cluster
> >   can be torn down);
> > - __swap_cluster_lock() branches into __vswap_cluster_lock(), which
> >   wraps every access in rcu_read_lock() and a CLUSTER_FLAG_DEAD check,
> >   plus kfree_rcu()/container_of()/rcu_head plumbing for node lifetime.

I dislike those code paths in vswap as well.

>
> Well to state the obvious: the reason it does all that is to make the
> compression space transparent to the user.

I found this new concept of "compression space" very confusing to me.
Can you explain the swap behavior and problem using only normal memory
usage reduction and latency without introducing a new term or new
metrics?

The normal user doesn't even know what compression space is, let alone
what makes it transparent.

>
> The user can answer a simple boolean question: whether they want
> compression or not. And it will work on tiny machines, on humongous

In my mind, swap trades RSS memory reduction for increased latency
when accessing the swapped-out data.
Whether the memory reduction is by compression or by writing to a hard
drive is an implementation detail. It has different characteristics.

When we have "compressed space" for zswap, should we also have "ssd
space" for data store in ssd and "hdd space" for data stored on HDD?
They has different IO accessing latencies.

> machines, and everything in between. That's a simple policy question
> with a clear answer.
>
> What you're doing, asking the user for a static size, is much more
> difficult and has usability issues.
>
> You're comparing implementations that don't accomplish the same thing.
>
> The problem we're trying to solve is implementing a clean compression
> space abstraction. I'm arguing that vswap does, and xswap does not.

I feel that you are arguing a conceptual construct you define. Can you
explain the difference using external measurable metrics? For example
in this workload, using vswap, the user sees workload latency as X,
throughput as Y, and memory usage as Z. Using xswap, the user sees a
different X1, Y1, Z1. Then we can reason why X, Y, Z is better or
worse than X1, Y1, Z1.

My simpler brain just doesn't see why this new compression space matters.

> While they're both using parts of the swap device code to implement a
> compression space, xswap actually PRESENTS IT TO THE USER as a swap
> device, and then makes optimizations BASED ON BAKED IN LIMITATIONS.
>
> But a conventional, statically sized swap device is a bad abstraction
> for the compression space. Here is why:
>
> In conventional swap space, one memory page translates to one swap
> page. Compression space doesn't act this way: a memory page can
> consume anything between a few bytes to a full page in compression
> space. It depends on memory contents and compression algorithm. So
> right off the bat, this is a hard question to answer at the host level
> which could run all kinds of workloads.
>
> In conventional swap space, the resource consumed is a different
> one. You're offloading memory by consuming disk space. This eats into
> the space available to the filesystem, which is totally unrelated.
> Asking the user for this tradeoff is a legitimate policy question.
>
> Compression space is not a separate resource. It's page tables,
> backing pages, and swap descriptors. It's just MEMORY. There isn't a
> size tradeoff, because moving pages from memory space into compression
> space DOES NOT CONSUME A NEW RESOURCE. It's still just memory. All you
> need for containment already exists: rlimits, OOM killer, cgroup
> memory controls.

Why does the user need to care about compression space again?

> By making this a user-visible virtual swap device, you're sending
> users down the wrong path. You're asking them to set a new limit on a
> resource that's already limited by other means. You're framing the
> question as conventional swap which behaves completely differently.

The user cares how much memory it can save and what performance price
to pay for it.
Why does the user need to care about compression space again? We've
used zswap/ZRAM and other swap mechanisms for a long time without ever
hearing about "compression space". Why now?

Again what exactly does compression space do that can't be explained
by external metrics e.g. memory saved and the performance penalty on
access?

Please help me understand.

Chris

>
> If you ask them "how much swap space", they WILL reference this to
> available RAM capacity. Maybe half of ram, maybe twice the RAM.
>
> But when compression space is referenced to RAM, it's trivial to fill
> it up with zeroed pages or easily compressible data LONG BEFORE the
> process or container would hit any of its MEMORY limits.
>
> This creates an artificial resource shortages. It forces a competition
> where there shouldn't be one. And then you need new controls to manage
> a competition that doesn't have to exist.
>
> Like I said before, including compression space (which is memory) in
> memory.swap.* (which is for disk space) is not going to be acceptable
> from the cgroup side. We can talk about that if you want.
>
> But asking the user questions they shouldn't have to answer, or
> already answered elsewhere, is weak interface design. Allowing, let
> alone encouraging, answers that create a whole new host of
> organizational issues is outright bad interface design.
>
> So if you want to compare implementations, you first have to actually
> implement the same thing:
>
> Stop asking user "how large". Let compression space expand towards
> existing memory limits, such that it doesn't create an awkward and
> artificial new resource competition.
>
> Then we can compare implementations.
>
> If the optimizations still apply under those constraints, great.
>
> Until then, there is little point in discussing differences that, by
> your own admission, have little to no impact on real world performance.
>
