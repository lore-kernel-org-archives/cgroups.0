Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8218B3AAF75
	for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 16:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789143677; cv=none; b=RUuR4R/a1L2eRuh/s/EvqlhTn7hZxoecHudasimnXNHDs+/Sch17I2phZz9ktwR/WiG9jKwkdDF1YzLMk37+xEmM3q5YtoNUmh4GdemkCQGl2GDPkUtEsnSUBd1GGwBm6mslSs3ow6L4IpJ5yaiWSMBdFucp58PqztGWO4RPhx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789143677; c=relaxed/simple;
	bh=E5aLrOEcpjHMCvCy2tZZDsD3xzjmw+bFWjrFay4JW7I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BR6hMOUIdPtG0TPvg5v5HURE5VcEGZo4/YtnFEC2j2mT056CcIybicb4b+jjChU9N4Hxxe4dxlQnuiCcHklxs/xM1oZlQLmkK0i3Rm+7X5PPhCE3fSvD5Ilv/5UA/b1V9qaV32K2+gybdl8bVRtTCkUGj05qu3G0r6UA0dagaZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=jNMv/tQa; arc=none smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="jNMv/tQa"
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-939109fafd7so99981985a.2
        for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 09:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1789143673; x=1789748473; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nEwb8woqh6nRAXbiUoFhhnkq6OhguWwIPf7kiOxr9zo=;
        b=jNMv/tQaI7skGuscuxVjEd/uoxITBqBCd1waB4dRcznGeLvf127w0/DoscfoRtCqDE
         sLNaqbpaOPI2tXjDRo51+7+cUMvRNJ3Xpj1Q/lXjABxM315n6Gr23BZZfRjPkje67gp7
         y15BVqVGSj1jfGXTp9FK9+emAMYT1cNND5y9mC4vsRw/sFUvh+E+8yvnMYnpJm3e7PPh
         swVkng6BdeEKze27dtwyzu0JlcTPsfgpLuVa9ICBDkwkcMGAcC63kdiE7B1S6c0njGUd
         HHQgPz3i576hW1dIcOKZ40Z3q0bVOfyFtCx2JuAvGksCB515Jj25hJORpJDBzvpCtz3r
         PO1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789143673; x=1789748473;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=nEwb8woqh6nRAXbiUoFhhnkq6OhguWwIPf7kiOxr9zo=;
        b=UKG32muKnVTpnMZ1COxRkTMgSgaUolcfOwqAKQ7oXuXvKUAd3L2buvtivdZ32EuByZ
         9f/C/ueoZG1AXer9hwA/t4VijCpyy1p8pVrzYVXnOhJm7XxH2ke1OpiYSAiQ2Iukfc6g
         7bCUQrbsNicO3fBcTyK6YtPsp9JNnvCqCSN5rQk/CXZ88bfZ5tGjNFzB1+njByElUELe
         vehssBAmpwEI+b0P4HYwY3s4KfY0K83Af4I002y6H7Ae+aRdaAtQlCBcqI0LlBLc6fhG
         cDokIZCVhreYxUvXso4LFI9dLTaqoUxQNZlBRUFENEJrCD04JAWmzTU3fdgsmr9yUIDm
         TrFg==
X-Forwarded-Encrypted: i=1; AKwUvBwQB2udIR9MOAuzgcINgDwI1BHSZOmghKblyskU2t3mH3osoHe6415YQeiVnQ/YRhmbxbqy+0gM@vger.kernel.org
X-Gm-Message-State: AFuF++lRilTYJQklCBZQCJomVAfxzmfeiq5RCFk17FVyNtBpcpU4MtNl
	H9Cua9051GxOKEfgkoG+Ky7sHVMnB8kwJwesKw+r+CCuYsfkGLRMpx9+6fmZIv8sZ6Q=
X-Gm-Gg: AYBFou3vgUcE2PE82uoH2JmNZIPi7wCC61F1vJ5T0OnK2d+G8Fio4uNa9zd89MeQJJI
	p3P0W6fUBH9Ykl6717RGbeNNtBmHvPPfUokrRGh7DeucMQ7UcSgeIaHbtsa/5k+qUo0JUTndmzS
	Z8QsT3a3PcnedlcumB72Uq2CGXE6O70ObO+GuGHaZECapMTL+6v6guFjMXZ3BLwVilHUZFvlH6m
	WFBW+cM0NxksEIMjDPACh17qeBepwBCFaGThwCBALSSo4cT6B8gZuieHCkmZDdRdWNtzMB+qaNl
	yCBfnTtbsJsYV1mbfP2mckYbA7KrTXtrXpzdSxYomA25PU8AoABGzLvP1zYJuoXUfHXPeYPfsF5
	0WnZZF4JSUXLVJ820+PiIGAxWOcb52Ja4OfR7AjpxgwunAt802q4qR68pPFt8EiDC0Od828ftCE
	kpgjgKSarfvx2nu2dfoNTn02XLfoGLS4+yIFFku1t7bVH4ZNv38W9qNvRdCu6sD2XSjVh50w==
X-Received: by 2002:a05:620a:2410:20b0:939:eb65:bd38 with SMTP id af79cd13be357-939eb65be93mr420474985a.35.1789143672247;
        Fri, 11 Sep 2026 09:21:12 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e809fd0bsm272865785a.33.2026.09.11.09.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 09:21:11 -0700 (PDT)
Date: Fri, 11 Sep 2026 12:21:08 -0400
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
Message-ID: <aqQqdJWtjAUBytkK@cmpxchg.org>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora>
 <aqLi6cIjD2wJwk0B@cmpxchg.org>
 <aqPzlIVJccbqbaUr@fedora>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aqPzlIVJccbqbaUr@fedora>

On Fri, Sep 11, 2026 at 08:27:00PM +0800, Baoquan He wrote:
> On 09/10/26 at 01:03pm, Johannes Weiner wrote:
> > [This reply was not LLM-generated.]
> > 
> > On Thu, Sep 10, 2026 at 03:09:59PM +0800, Baoquan He wrote:
> > > Hi Nhat,
> > > 
> > > On 09/04/26 at 02:14pm, Nhat Pham wrote:
> > > .....snip...
> > > > Now, on xswap. Baoquan's working on a series [15] that covers some of the
> > > > same ground, and the VM_SPARSE cluster_info idea in it is genuinely good.
> > > > I've been reviewing that lineage since July [16] and I'd like whatever
> > > > lands to end up with the best parts of both. From my perspective the
> > > > differences are:
> > > > 
> > > > 1. Userspace knobs. xswap asks the admin for a size (a percent of RAM) plus
> > > >    a per-device limit to tune afterwards. I'm not aware of any use case
> > > >    that needs those, and I don't think users have a good way to answer the
> > > >    question anyway - sizing swap for compressed memory depends on memory
> > > >    size, workload, and compression ratio all at once. That's precisely the
> > > >    provisioning problem vswap exists to remove. The kernel should be as
> > > >    transparent and dynamic as possible here, and not add knobs unless
> > > >    there's a use case for them.
> > > > 
> > > > 2. Writeback support. Writeback is core functionality for zswap, not an
> > > >    add-on, and a design needs to account for it from the start. This came
> > > >    up before, in the discussion around Chris' ghost swapfile RFC [17]: for
> > > >    a solution here to be acceptable, it has to work with the primary
> > > >    usecase and support disk writeback. Without it, whatever zswap won't
> > > >    take (incompressible pages especially) has nowhere to go, and cold
> > > >    compressed data can never leave RAM.
> > > > 
> > > > 3. Cgroup charging behavior. vswap/xswap shouldn't be charged against the
> > > >    swap usage counter. It's fundamentally a different resource from
> > > >    physical swapfile space, and memory.swap.* should read 0 when nothing is
> > > >    on disk [18]. I made the longer argument for this in [19].
> > > > 
> > > > 4. Data structure (xarray vs sparse vmalloc array). Even with xarray, vswap
> > > >    is already on par with or beating baseline. I like the sparse array
> > > >    idea, but why are we landing an optimization before the feature itself,
> > > >    without any A/B data showing the difference matters?
> > > 
> > > 
> > > Thanks for laying this out, and for the honest push to converge. Let me
> > > be equally direct about the ordering: I think the xswap base should land
> > > first, and the things vswap demonstrates -  writeback, rmap lookup, the
> > > charging semantics, later THP -- should be built on top of it. Because
> > > it is the foundation that keeps the swap core simpler, and the first thing
> > > to merge should be the one that doesn't have to be redone.
> > > 
> > > The VM_SPARSE array is not an optimization to bolt on later; it is a
> > > structural choice, and the code reflects it. In vswap, the cluster
> > > metadata lives in a dynamically-allocated xarray.
> > > 
> > > struct swap_cluster_info_dynamic {
> > >         struct swap_cluster_info ci;
> > >         unsigned int index;             /* for cluster_index() */
> > >         struct rcu_head rcu;
> > >         atomic_long_t *virtual_table;   /* Backing pointers for vswap slots */
> > > };
> > > 
> > > To support dynamic growth and shrink, vswap stores its cluster metadata
> > > in an xarray, and that forces two things the plain swap_cluster_info[]
> > > array never needed:
> > > 
> > > 1. Every cluster has to carry an extra index and an rcu_head —
> > > 24 bytes per cluster — purely so the xarray can locate it and free
> > > it safely.
> > > 2. To keep that bookkeeping from leaking into the normal-swap code, the
> > > cluster had to be wrapped in a container, swap_cluster_info_dynamic,
> > > so the xarray holds a pointer to the wrapper instead of an inline
> > > array element.
> > > 
> > > So in vswap, every cluster access in the shared hot path has to answer
> > > "is this a vswap device?" and take a separate branch:
> > > 
> > > - swap_is_vswap() is checked in 36 places across page_io.c, swapfile.c,
> > >   zswap.c and swap.h;
> > > - __swap_offset_to_cluster() branches into xa_load() for vswap vs the
> > >   flat array otherwise, and the xarray path can return NULL (a cluster
> > >   can be torn down);
> > > - __swap_cluster_lock() branches into __vswap_cluster_lock(), which
> > >   wraps every access in rcu_read_lock() and a CLUSTER_FLAG_DEAD check,
> > >   plus kfree_rcu()/container_of()/rcu_head plumbing for node lifetime.
> > 
> > Well to state the obvious: the reason it does all that is to make the
> > compression space transparent to the user.
> > 
> > The user can answer a simple boolean question: whether they want
> > compression or not. And it will work on tiny machines, on humongous
> > machines, and everything in between. That's a simple policy question
> > with a clear answer.
> > 
> > What you're doing, asking the user for a static size, is much more
> > difficult and has usability issues.
> > 
> > You're comparing implementations that don't accomplish the same thing.
> > 
> > The problem we're trying to solve is implementing a clean compression
> > space abstraction. I'm arguing that vswap does, and xswap does not.
> > 
> > While they're both using parts of the swap device code to implement a
> > compression space, xswap actually PRESENTS IT TO THE USER as a swap
> > device, and then makes optimizations BASED ON BAKED IN LIMITATIONS.
> > 
> > But a conventional, statically sized swap device is a bad abstraction
> > for the compression space. Here is why:
> > 
> > In conventional swap space, one memory page translates to one swap
> > page. Compression space doesn't act this way: a memory page can
> > consume anything between a few bytes to a full page in compression
> > space. It depends on memory contents and compression algorithm. So
> > right off the bat, this is a hard question to answer at the host level
> > which could run all kinds of workloads.
> > 
> > In conventional swap space, the resource consumed is a different
> > one. You're offloading memory by consuming disk space. This eats into
> > the space available to the filesystem, which is totally unrelated.
> > Asking the user for this tradeoff is a legitimate policy question.
> > 
> > Compression space is not a separate resource. It's page tables,
> > backing pages, and swap descriptors. It's just MEMORY. There isn't a
> > size tradeoff, because moving pages from memory space into compression
> > space DOES NOT CONSUME A NEW RESOURCE. It's still just memory. All you
> > need for containment already exists: rlimits, OOM killer, cgroup
> > memory controls.
> > 
> > By making this a user-visible virtual swap device, you're sending
> > users down the wrong path. You're asking them to set a new limit on a
> > resource that's already limited by other means. You're framing the
> > question as conventional swap which behaves completely differently.
> > 
> > If you ask them "how much swap space", they WILL reference this to
> > available RAM capacity. Maybe half of ram, maybe twice the RAM.
> > 
> > But when compression space is referenced to RAM, it's trivial to fill
> > it up with zeroed pages or easily compressible data LONG BEFORE the
> > process or container would hit any of its MEMORY limits.
> > 
> > This creates an artificial resource shortages. It forces a competition
> > where there shouldn't be one. And then you need new controls to manage
> > a competition that doesn't have to exist.
> > 
> > Like I said before, including compression space (which is memory) in
> > memory.swap.* (which is for disk space) is not going to be acceptable
> > from the cgroup side. We can talk about that if you want.
> > 
> > But asking the user questions they shouldn't have to answer, or
> > already answered elsewhere, is weak interface design. Allowing, let
> > alone encouraging, answers that create a whole new host of
> > organizational issues is outright bad interface design.
> > 
> > So if you want to compare implementations, you first have to actually
> > implement the same thing:
> > 
> > Stop asking user "how large". Let compression space expand towards
> > existing memory limits, such that it doesn't create an awkward and
> > artificial new resource competition.
> > 
> > Then we can compare implementations.
> > 
> > If the optimizations still apply under those constraints, great.
> > 
> > Until then, there is little point in discussing differences that, by
> > your own admission, have little to no impact on real world performance.
> 
> Thanks for your sharing with deliberate thought.
> 
> Agreed, and I want to be clear that the size knob is my implementation
> choice, not something the design needs.

+1

> Now in v2, xswap's create() already takes no size, only an optional
> priority: the device's address space is set by the kernel to the machine's
> memory

I've tried to explain above why this is a problem ;)

To be sure, the space cannot be completely unlimited. There are
internal restrictions, such as the refcount_t issue Nhat surfaced in
testing.

But I want to re-iterate the need to separate implementation choices
from what is visible to the user.

The address space should not be limited by anything but these hard
(and temporary) implementation limits. They can be fixed later as
machines evolve. But they shouldn't be anywhere near where real setups
can run out of compression space before they run out of memory.

Whether we want to vmap a petabyte+ of address space on boot, I'm a
bit skeptical... That sounds like an inherent point of tension between
large and small machines again. Dynamically extending the cluster
space as needed seems much more robust to me.

> and cluster_info is mapped lazily, so nothing is allocated up front.
> The only knob left is an optional per-device ceiling. If we really want to
> remove it, that's quite easy thing, we can just remove the runtime
> growth ceiling and the shrink machinery that serves it.

+1

> When I asked why shrink is needed, Nhat told on system, memory pressure
> could reach a peak, than later may not reach it again for a long time. I
> don't like the continuous automatic growing/shrinking, I think it
> doesn't make much sense just for saving that memory serving struct
> swap_cluster_info. But it's not bad to provide a mechanism for
> admin/users to tune it.

This also sounds like punting an implementation problem to userspace
again. If a workload peaks into compression space, the management
overhead is expected. But if they clear out, that memory should come
back predictably and automatically.

Requiring userspace to make garbage collection choices is not great.

I assume there is a limit to predictability either way because the
clusters may well fragment and remain sparsely populated. But IMO at
least the clusters that do clear out should free their memory quickly.

> But as I said, xswap/vswap both claim to solve the problem of zswap
> physical disk slot and swap slot coupling, and meantime extend
> functionality to make it more flexible than zswap/zram. While Nhat's
> vswap is boot-time per-device swap. And Nhat's own description of it
> in this thread is "vswap is just a normal swap device, no?". If I didn't
> apply Nhat's code and test I couldn't realize it. I executed swapon but
> can't see any output. I was shocked.

That's the implementation vs user-visible abstraction I was talking
about. This is why I think we should stop talking about swapfiles and
frame the discussion around how a compression space should act from a
user POV.

Compression space should not look like a conventional swap device to
users. Even if it shares an implementation.

Wanting visibility is fine. We have RSS, we have counts for zswap, we
should probably have counts for swapped zerofilled pages. Having
numbers for aggregate virtual swap entries is fine too. The problem is
showing some sort of hard upper bound, or showing it side to side with
conventional swapfiles that actually sit in storage.

> I really appreciated your patient and detailed sharing, while it takes
> you so long words to explain it. IMHO, it deserves a separate patch
> posting to justify it so that anyone can know why it is.

Thanks for the discussion!
