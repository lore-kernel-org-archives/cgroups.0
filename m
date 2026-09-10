Received: from mta1.migadu.com (out-234.mta1.migadu.com [95.215.58.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80AE2C234E
	for <cgroups@vger.kernel.org>; Thu, 10 Sep 2026 07:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789024240; cv=none; b=iSpgW0ry1aW9BFLzX7LbGiRXCXtrAx7JVtTz/c2rGACIYiXTYOlBqP/n6eCLia6NSv9qzEFXibSdGejZZtT0RsDoEJJ9by+OJWDBWgocSqyP6gzTYT5JFo78BO4j8Ufo4ZVgq3xU1aD7q+UU0dSHNBS7+WtfWOATcW31GR5SIGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789024240; c=relaxed/simple;
	bh=FfYc4aLXu2DF2lIjaj0B+4sqMfbvOvrYCGEer2SwT/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q3Td8KN+IxraNARjB01FtC/hmnQXPa+FlpcFT/L0f/2BsjXPaxJ+4ICXpq1J5J+B2C9MhdpZqF7enlmK/cqmDbkes4puwONJLZhyx485hXeHYYxGlPELXkjzpkcrCYDUGJl9LSjHWxkIUhnDbefjB2LslrqL9O1UmEJ0iLVtKaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fNRlnKQD; arc=none smtp.client-ip=95.215.58.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fNRlnKQD"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=FfYc4aLXu2DF2lIjaj0B+4sqMfbvOvrYCGEer2SwT/Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789024234; v=1; x=1789629034;
 b=fNRlnKQD9hJd8fi2znJ3kEE0iaiXEi1IPG5NSgGVEoHdwc9OYNLhHx1clvgPHHbtsmYCJtKf
 9wInfx3/SSFMCRb+WYptDIxpPms8Xa4Odz5t+sPbRiGBJfn9l4Q2qZOT45cAoNeSKWsDQ/L+BHx
 oSOkH0OQ0L87OZhnV/KFkqac=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 9478eb5f3bcfb84b;
	Thu, 10 Sep 2026 07:10:06 +0000
X-Mizu-Trace-ID: 9478eb5f3bcfb84b
X-Migadu-Flow: FLOW_OUT
Date: Thu, 10 Sep 2026 15:09:59 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
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
Message-ID: <aqJXx2vtbKaRLt3x@fedora>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>

Hi Nhat,

On 09/04/26 at 02:14pm, Nhat Pham wrote:
.....snip...
> Now, on xswap. Baoquan's working on a series [15] that covers some of the
> same ground, and the VM_SPARSE cluster_info idea in it is genuinely good.
> I've been reviewing that lineage since July [16] and I'd like whatever
> lands to end up with the best parts of both. From my perspective the
> differences are:
> 
> 1. Userspace knobs. xswap asks the admin for a size (a percent of RAM) plus
>    a per-device limit to tune afterwards. I'm not aware of any use case
>    that needs those, and I don't think users have a good way to answer the
>    question anyway - sizing swap for compressed memory depends on memory
>    size, workload, and compression ratio all at once. That's precisely the
>    provisioning problem vswap exists to remove. The kernel should be as
>    transparent and dynamic as possible here, and not add knobs unless
>    there's a use case for them.
> 
> 2. Writeback support. Writeback is core functionality for zswap, not an
>    add-on, and a design needs to account for it from the start. This came
>    up before, in the discussion around Chris' ghost swapfile RFC [17]: for
>    a solution here to be acceptable, it has to work with the primary
>    usecase and support disk writeback. Without it, whatever zswap won't
>    take (incompressible pages especially) has nowhere to go, and cold
>    compressed data can never leave RAM.
> 
> 3. Cgroup charging behavior. vswap/xswap shouldn't be charged against the
>    swap usage counter. It's fundamentally a different resource from
>    physical swapfile space, and memory.swap.* should read 0 when nothing is
>    on disk [18]. I made the longer argument for this in [19].
> 
> 4. Data structure (xarray vs sparse vmalloc array). Even with xarray, vswap
>    is already on par with or beating baseline. I like the sparse array
>    idea, but why are we landing an optimization before the feature itself,
>    without any A/B data showing the difference matters?


Thanks for laying this out, and for the honest push to converge. Let me
be equally direct about the ordering: I think the xswap base should land
first, and the things vswap demonstrates -  writeback, rmap lookup, the
charging semantics, later THP -- should be built on top of it. Because
it is the foundation that keeps the swap core simpler, and the first thing
to merge should be the one that doesn't have to be redone.

The VM_SPARSE array is not an optimization to bolt on later; it is a
structural choice, and the code reflects it. In vswap, the cluster
metadata lives in a dynamically-allocated xarray.

struct swap_cluster_info_dynamic {
        struct swap_cluster_info ci;
        unsigned int index;             /* for cluster_index() */
        struct rcu_head rcu;
        atomic_long_t *virtual_table;   /* Backing pointers for vswap slots */
};

To support dynamic growth and shrink, vswap stores its cluster metadata
in an xarray, and that forces two things the plain swap_cluster_info[]
array never needed:

1. Every cluster has to carry an extra index and an rcu_head —
24 bytes per cluster — purely so the xarray can locate it and free
it safely.
2. To keep that bookkeeping from leaking into the normal-swap code, the
cluster had to be wrapped in a container, swap_cluster_info_dynamic,
so the xarray holds a pointer to the wrapper instead of an inline
array element.

So in vswap, every cluster access in the shared hot path has to answer
"is this a vswap device?" and take a separate branch:

- swap_is_vswap() is checked in 36 places across page_io.c, swapfile.c,
  zswap.c and swap.h;
- __swap_offset_to_cluster() branches into xa_load() for vswap vs the
  flat array otherwise, and the xarray path can return NULL (a cluster
  can be torn down);
- __swap_cluster_lock() branches into __vswap_cluster_lock(), which
  wraps every access in rcu_read_lock() and a CLUSTER_FLAG_DEAD check,
  plus kfree_rcu()/container_of()/rcu_head plumbing for node lifetime.

With VM_SPARSE, xswap's cluster access is exactly the plain-array line the
rest of swap already uses:

    return &si->cluster_info[offset / SWAPFILE_CLUSTER];

no branch, no RCU discipline, no tear-down state machine, and no NULL
return. So VM_SPARSE doesn't add complexity to close a gap; it lets the
cluster layer stay as simple as it already is, which is precisely the
part later work (writeback, rmap lookup, memcg charging, THP) has to sit
on.

I'm not going to claim xswap wins on throughput. I measured it:
on a 64G/64-thread swapout, xswap, vswap and plain swap+zswap are all
within ~2-3% of each other, effectively identical. Because the cost is
dominated by zswap compression, not the cluster table. So the ordering
question is not "which is faster" but "which structure should the use-case
layer be built on". If vswap is chosen, the xarray-based table is an
intermediate form. Your own ablative study already showed the flat array
wins, and VM_SPARSE is exactly that flat array plus lazy mapping.
 
On the metadata side I want to be precise, because it is easy to overstate:
the per-cluster cost that xswap saves is the xarray-induced index + rcu_head
(20 bytes/cluster or 24bytes for alignment), small. 

On writeback: agreed it is required in the end. But it is a consumer of
the foundation, not a reason to pick a different one. xswap is deliberately
the base; 
- writeback
- rmap lookup
- THP support
- memcg accounting
All these can land on top of the xswap base rather than be stranded on a table
we later replace. As we have discussed and I have been mentioning in each
cover-letter, I didn't touch these core changes, glad to see your work built
on top of it.

On the interface, xswap v2 drops the percent knob entirely (your point about
"why not just max out" is taken): create now takes only an optional
priority, a device starts at full RAM, which is free because the VM_SPARSE
area is mapped lazily, with an optional per-device size limit for admins
who want a ceiling. More importantly, xswap keeps per-device instances
because the swap->ops and swap tiering that come next need per-device
operations. A single boot-time vswap can't express that, and it breaks the
per-device conventions the rest of swap already follows. When I tested it,
there is no way to disable it at runtime, so it can't even be A/B-tested
against regular swap in the same boot. So I think a boot-time vswap is an
independent issue which deserves a separate patch posting with a convincing
justification later.

So concretely: xswap base first (runtime file-less device + VM_SPARSE
cluster foundation + sysfs create/destroy), then the use-case layer, where
your writeback work, etc is very welcome. The base should be the one that
doesn't need to be redone; by both our measurements, that is the flat-cluster
substrate.

Thanks
Baoquan

> 
> One thing I do want to be clear about: I'm glad other people care about
> this problem. Chris' ghost swapfile and Baoquan's xswap are both going
> after the same set of problems, and that's a good sign. It means this is
> real and shared, not something only Meta runs into.
> 
> What's been harder is the shape of the engagement. Alternatives keep
> getting posted and pushed that don't cover all the requirements, while this
> series sits without review. I don't think I'm owed anyone's interest in the
> problems I care about. But I do think working code, with benchmarks and
> production exposure behind it, deserves a fair hearing next to in-progress
> proposals.
> 
> So what I'm asking for: I'd like us to converge rather than keep two series
> in flight. My preference is that we land vswap first, then build Baoquan's
> sparse array on top of it as an optimization. That gets the feature in, and
> by then we'd have the A/B data to show whether the sparse array actually
> beats the xarray.
> 
> If you think that's the wrong order, I'd genuinely like to understand why -
> after 17 months and 10 revisions I still don't have a clear picture of the
> objection.
> 
> [1] https://lore.kernel.org/all/20250407234223.1059191-1-nphamcs@gmail.com/
> [2] https://lore.kernel.org/all/20250429233848.3093350-1-nphamcs@gmail.com/
> [3] https://lore.kernel.org/all/20260208215839.87595-1-nphamcs@gmail.com/
> [4] https://lore.kernel.org/all/20260318222953.441758-1-nphamcs@gmail.com/
> [5] https://lore.kernel.org/all/20260320192735.748051-1-nphamcs@gmail.com/
> [6] https://lore.kernel.org/all/20260505153854.1612033-1-nphamcs@gmail.com/
> [7] https://lore.kernel.org/all/20260528212955.1912856-1-nphamcs@gmail.com/
> [8] https://lore.kernel.org/all/20260612193738.2183968-1-nphamcs@gmail.com/
> [9] https://lore.kernel.org/all/20260806184254.3790858-1-nphamcs@gmail.com/
> [10] https://lore.kernel.org/all/20260825153238.2695446-1-nphamcs@gmail.com/
> [11] https://lwn.net/Articles/1016136/
> [12] https://lore.kernel.org/all/CAMgjq7AQNGK-a=AOgvn4-V+zGO21QMbMTVbrYSW_R2oDSLoC+A@mail.gmail.com/
> [13] https://lore.kernel.org/all/CACePvbVXQWgcPD-bgK7iDba4NFLo2tT89ZbLOa03maJU4er4ag@mail.gmail.com/
> [14] https://lore.kernel.org/all/aZyFxKGXc8J6PIij@cmpxchg.org/
> [15] https://lore.kernel.org/all/20260827094509.1016740-1-hebaoquan@kylinos.cn/
> [16] https://lore.kernel.org/lkml/CAKEwX=Pe+qMZd2xhnU-PAGQtgXkp56c-JwYCbt2Lux9htgB67Q@mail.gmail.com/
> [17] https://lore.kernel.org/all/20251121114011.GA71307@cmpxchg.org/
> [18] https://lore.kernel.org/all/anYIboHEUZb4fhHv@cmpxchg.org/
> [19] https://lore.kernel.org/all/CAKEwX=P4syV38jAVCWq198r2OHXXc=xA-fx1dk6+qYef6yzxWQ@mail.gmail.com/
