Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC79545DA2
	for <cgroups@vger.kernel.org>; Thu, 10 Sep 2026 17:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789059849; cv=none; b=WDiMmQNe/iIvh7b9eq9DQhvu3TWredcVYGUrta4b1K3YeUb4Y9kdu/dQ7Zj3mv/NU1WxtPoMC6N7Mp/bVgsaoibGlfDM4mxQ4eitKSvVaWD6pmrBKEKDG1b+PEtQ0kocOJQzGKTu3aXDkru406uvm0TxNhkNfg2WHOS9xhcA8+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789059849; c=relaxed/simple;
	bh=ckiR9yuXJpiot1fFEFedP8FkwiSAVjuSTZmoJWLADls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lZcZjGXk3Dta0pELt/4ht4MF3v+N6JQzWKwmgph82VmYchLwj7S9Uz5JkknJ5mJBjUMw52O4O3DNbzEPKOW/JC6vpH4NTs7XwpFAnolXtV6eatCKl2D6KLAUB+c53PnT+tMaUcbwXGiqmrScI/ugkLbNO4dZ8kbVwPxTS213PMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=FN4VExUc; arc=none smtp.client-ip=74.125.230.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="FN4VExUc"
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-90cdfcc3e03so13846696d6.1
        for <cgroups@vger.kernel.org>; Thu, 10 Sep 2026 10:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1789059822; x=1789664622; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Xk2OdPLDjL26fb8Tc2Cwml2fZiaKkha+GiG5IQjjOVM=;
        b=FN4VExUczsxr2DD9a3du3jbN+Dxm1holDGhdpEM0b3ZXbk2iv+V06u4m435h8YZWwa
         IPtD3eUTxmC0hf7/naXgoPnbDZuupBjIG/U+ZrayW4dkPPQEsjh7ykf/Q5gjAizERqMQ
         JDq2giLQV+92kgHJ7QH6NL6kU4P4eI15AekXonC0SfTTMJdN3w1kAN3vr2cziUa1lFli
         k4ZXSSPgCiU/0kLVtzX5SY9NPz44z1vpLtugZ48m/oApSe3vE8H1f+/B1DQt+F/lSeDx
         ct9vA53wrxPB/fACX9SfWuI51z2a/xNRVcHvAURDjfpk4W4ovb7FxWTh/d6W5ipQ1izB
         1mXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789059822; x=1789664622;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Xk2OdPLDjL26fb8Tc2Cwml2fZiaKkha+GiG5IQjjOVM=;
        b=ORu66gYGPLXUaJN0nLCUvu70bMRX/CkVesI0VcX8A4nTREsDT/WaDa2lYNnKHcrUYo
         6oL6QddFcDb+N1hvg1bujBWWcGU1qWB3cWlYscyVZxOyLlo8oC2y3N6X3lG9psaoy+j1
         //0SkqLKzLKSrZsKDbLRHaq1jNrIVu1dnwM5uYcRKkKjAAHljzNpPTf5sS5SF42nlyCb
         79S7WQ1iPoH5q95qcb7iTrWRVGxYK1GxrDi2WtrU5nRbVpyOMGAWv842Mj7I3i2vjAM9
         MFyptnx4zkZf3kwYkyXQv1x3OOAsekZVyYEFG7m5yTSORufnFYX6Cl8LsLV0aOdeT5Td
         SH2g==
X-Forwarded-Encrypted: i=1; AKwUvBz1BHXUn+EY/Wi5BfOginaNNwYbt8QJXVw0Fsl1xe3vE4OYfrKozopragRiSCYaBz9Rk7zKq+cC@vger.kernel.org
X-Gm-Message-State: AFuF++lwJPmlDhonLNngQrZGD3oVI36Cw5BVjVtYmzr1mKqR0x0mr+Bp
	1MLsLLofbCt9YlSgWAgCaZKKT+q6bZ3dDgkgW9jidAdMPv7ruIqXcHPSiyuPOEljK5M=
X-Gm-Gg: AYBFou1evi2Ope0uMyDouKZ4QCdRK32yKbAEdxqDR3H0FOC9PnzcG3nqNUfJqnGo6oh
	vI2K4WeRm/cs6+iy8mHLbEBkqlghS96Wrh0QW4F2ywTGnbVZWJJds1qyLe4NvK2fGKCYd8qjBFQ
	mFKqfeEK3Oc/mIW7d6grrokJzMlVX5ZVz4zZsrOGH5mKD7jJOSJBPn8qJbfa5LBVLpbgViNjTdD
	qZ21YGrtmjf2rLkPKE7VwfsBPWGQFduR+FHtD7RWRbHf/cFqOMwsXEjCBPkZ4Fmw6ZsYTPv1TcP
	Lha6feYH2npbNW5jlZWVDUK5NPAld3gRZC2imNdGZUdLSRoySOch2jUCu/ZwsHta/irbeZH7BBO
	k1IcKB0bIQq/GL/fI832vN3erLxRB9H0+LfoVOu0qKIkXKXTJLbNxQacYueIiPfTN4Lrzycq3nn
	HOwwkwhXj8BQpTX/FzPVj5UfjRgm0AtjSh9S+AJfPHnpMSfmbo8G8y7eHQDcq/4b3UIhzZtA==
X-Received: by 2002:a05:6214:2a4d:b0:911:9375:905e with SMTP id 6a1803df08f44-9120e7339bbmr5689416d6.0.1789059821830;
        Thu, 10 Sep 2026 10:03:41 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f20367dsm669896d6.6.2026.09.10.10.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 10:03:40 -0700 (PDT)
Date: Thu, 10 Sep 2026 13:03:37 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>,
	Chris Li <chrisl@kernel.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <ryncsn@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <aqLi6cIjD2wJwk0B@cmpxchg.org>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aqJXx2vtbKaRLt3x@fedora>

[This reply was not LLM-generated.]

On Thu, Sep 10, 2026 at 03:09:59PM +0800, Baoquan He wrote:
> Hi Nhat,
> 
> On 09/04/26 at 02:14pm, Nhat Pham wrote:
> .....snip...
> > Now, on xswap. Baoquan's working on a series [15] that covers some of the
> > same ground, and the VM_SPARSE cluster_info idea in it is genuinely good.
> > I've been reviewing that lineage since July [16] and I'd like whatever
> > lands to end up with the best parts of both. From my perspective the
> > differences are:
> > 
> > 1. Userspace knobs. xswap asks the admin for a size (a percent of RAM) plus
> >    a per-device limit to tune afterwards. I'm not aware of any use case
> >    that needs those, and I don't think users have a good way to answer the
> >    question anyway - sizing swap for compressed memory depends on memory
> >    size, workload, and compression ratio all at once. That's precisely the
> >    provisioning problem vswap exists to remove. The kernel should be as
> >    transparent and dynamic as possible here, and not add knobs unless
> >    there's a use case for them.
> > 
> > 2. Writeback support. Writeback is core functionality for zswap, not an
> >    add-on, and a design needs to account for it from the start. This came
> >    up before, in the discussion around Chris' ghost swapfile RFC [17]: for
> >    a solution here to be acceptable, it has to work with the primary
> >    usecase and support disk writeback. Without it, whatever zswap won't
> >    take (incompressible pages especially) has nowhere to go, and cold
> >    compressed data can never leave RAM.
> > 
> > 3. Cgroup charging behavior. vswap/xswap shouldn't be charged against the
> >    swap usage counter. It's fundamentally a different resource from
> >    physical swapfile space, and memory.swap.* should read 0 when nothing is
> >    on disk [18]. I made the longer argument for this in [19].
> > 
> > 4. Data structure (xarray vs sparse vmalloc array). Even with xarray, vswap
> >    is already on par with or beating baseline. I like the sparse array
> >    idea, but why are we landing an optimization before the feature itself,
> >    without any A/B data showing the difference matters?
> 
> 
> Thanks for laying this out, and for the honest push to converge. Let me
> be equally direct about the ordering: I think the xswap base should land
> first, and the things vswap demonstrates -  writeback, rmap lookup, the
> charging semantics, later THP -- should be built on top of it. Because
> it is the foundation that keeps the swap core simpler, and the first thing
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
>         atomic_long_t *virtual_table;   /* Backing pointers for vswap slots */
> };
> 
> To support dynamic growth and shrink, vswap stores its cluster metadata
> in an xarray, and that forces two things the plain swap_cluster_info[]
> array never needed:
> 
> 1. Every cluster has to carry an extra index and an rcu_head —
> 24 bytes per cluster — purely so the xarray can locate it and free
> it safely.
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
> - __swap_offset_to_cluster() branches into xa_load() for vswap vs the
>   flat array otherwise, and the xarray path can return NULL (a cluster
>   can be torn down);
> - __swap_cluster_lock() branches into __vswap_cluster_lock(), which
>   wraps every access in rcu_read_lock() and a CLUSTER_FLAG_DEAD check,
>   plus kfree_rcu()/container_of()/rcu_head plumbing for node lifetime.

Well to state the obvious: the reason it does all that is to make the
compression space transparent to the user.

The user can answer a simple boolean question: whether they want
compression or not. And it will work on tiny machines, on humongous
machines, and everything in between. That's a simple policy question
with a clear answer.

What you're doing, asking the user for a static size, is much more
difficult and has usability issues.

You're comparing implementations that don't accomplish the same thing.

The problem we're trying to solve is implementing a clean compression
space abstraction. I'm arguing that vswap does, and xswap does not.

While they're both using parts of the swap device code to implement a
compression space, xswap actually PRESENTS IT TO THE USER as a swap
device, and then makes optimizations BASED ON BAKED IN LIMITATIONS.

But a conventional, statically sized swap device is a bad abstraction
for the compression space. Here is why:

In conventional swap space, one memory page translates to one swap
page. Compression space doesn't act this way: a memory page can
consume anything between a few bytes to a full page in compression
space. It depends on memory contents and compression algorithm. So
right off the bat, this is a hard question to answer at the host level
which could run all kinds of workloads.

In conventional swap space, the resource consumed is a different
one. You're offloading memory by consuming disk space. This eats into
the space available to the filesystem, which is totally unrelated.
Asking the user for this tradeoff is a legitimate policy question.

Compression space is not a separate resource. It's page tables,
backing pages, and swap descriptors. It's just MEMORY. There isn't a
size tradeoff, because moving pages from memory space into compression
space DOES NOT CONSUME A NEW RESOURCE. It's still just memory. All you
need for containment already exists: rlimits, OOM killer, cgroup
memory controls.

By making this a user-visible virtual swap device, you're sending
users down the wrong path. You're asking them to set a new limit on a
resource that's already limited by other means. You're framing the
question as conventional swap which behaves completely differently.

If you ask them "how much swap space", they WILL reference this to
available RAM capacity. Maybe half of ram, maybe twice the RAM.

But when compression space is referenced to RAM, it's trivial to fill
it up with zeroed pages or easily compressible data LONG BEFORE the
process or container would hit any of its MEMORY limits.

This creates an artificial resource shortages. It forces a competition
where there shouldn't be one. And then you need new controls to manage
a competition that doesn't have to exist.

Like I said before, including compression space (which is memory) in
memory.swap.* (which is for disk space) is not going to be acceptable
from the cgroup side. We can talk about that if you want.

But asking the user questions they shouldn't have to answer, or
already answered elsewhere, is weak interface design. Allowing, let
alone encouraging, answers that create a whole new host of
organizational issues is outright bad interface design.

So if you want to compare implementations, you first have to actually
implement the same thing:

Stop asking user "how large". Let compression space expand towards
existing memory limits, such that it doesn't create an awkward and
artificial new resource competition.

Then we can compare implementations.

If the optimizations still apply under those constraints, great.

Until then, there is little point in discussing differences that, by
your own admission, have little to no impact on real world performance.
