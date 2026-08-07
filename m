Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7B63DD508
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 09:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786093640; cv=none; b=If2QOr95GI6pLO4QMnrrIYjLTXtl4cMzHpl+be9QMh0AzXZoZo4tPXDk+6i8WYjPh3eq5a0oOuZ0HmYaEuujWuBPYlETSiAAWXSjAdn5Z6WSgVs1ECujj609fFT1fmbOCwYMvseRAv3/y007CCFvCBSwIWvuWs0iKFC/cJSU7GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786093640; c=relaxed/simple;
	bh=3R3goslJkHLwWlgsqH61TBJGOdnAXt/RMqlKkBQhRek=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nRDnV3OEGCt5y6o898DP4MM5k3c6uZh8O5y4va6CutgUDjMxLv3Wwk0Lk/2JcCblC0kBO8VAKucvCGKiAuMxRJkCC3mzrR+BtlGlTY+LgGgwZO16hSnn0mOFYzj9alqDHgWFtGGJicgX+N0AxBeHBTwLZrpgDJYh1JSn/JcKO7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GWPmXhXF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GWPmXhXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC711F0155B
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 09:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786093638;
	bh=a1EWiRm8rGvBaX2BeGAVlCIriDzLuZieyXEjm7j2gz4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GWPmXhXFQM9B+0LygdH3F4qjU4rkRFr1kHphnAkq6yXk9RadM49miP/KKwyZQaSE/
	 De9PClZ/SZOqK/izYHSsKh3C+xQQJqGC3d2/fgFLaVQ8dx/CRKoh7I4JpSFQGhwcLM
	 Mg08+PocMvp9jBN9LjaIVocy0vIWUOXQtnOS6jFZ1WosXWnvMn+mQzwot0BNrTiB0t
	 KFtLsjd+CGIqurU8buXChcvPBZILF2tU0cDDZiGeDQyvTphsIyoQTSCXYd/x+ZVPBO
	 oi7qzYc+ngS4VIFaUK9z6cMxkdgcL9uInuPVgr2ny+PcNSm0JxDjyQ/kc5rFnoaPxr
	 ijfVDdJGLxMTA==
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-80bb41f7f3cso34778057b3.2
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 02:07:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqThEfDtEVjAX2gI+Y3pbHZjEHRo48oL6XkMfSiz1OMKz6vUHEJKqoQp+ssg8h0kniX7SsAdcXA@vger.kernel.org
X-Gm-Message-State: AOJu0Yxoo/XW+If8dHOX5PoKw0tlNM2tqRtSrwFirpICPMv+RJ+tqqqr
	jCNLsXUJQgCivu6hglFpD1HnctQXJv96K4YuUVGZOGRUZ9X7Tq+lwTGgk9g+SJF80ApAUhR0cPn
	5ZDrm1krggcvHMS+LwZ5GagqXliuOtBiRnsIs01jSBA==
X-Received: by 2002:a05:690c:6d8c:b0:80b:a6a3:937c with SMTP id
 00721157ae682-8225ba2bad2mr44320407b3.20.1786093637197; Fri, 07 Aug 2026
 02:07:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260806184254.3790858-1-nphamcs@gmail.com>
In-Reply-To: <20260806184254.3790858-1-nphamcs@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 7 Aug 2026 02:07:04 -0700
X-Gmail-Original-Message-ID: <CACePvbX+3tO91BmRwaLqf3Xia32GCemt3W8tayErG81BYLgrzA@mail.gmail.com>
X-Gm-Features: AUfX_mxPrM2en4hyjOF6IVnj1qpcR-vwyigyA_-EV71vhTPhotW10G_NYfxDjDI
Message-ID: <CACePvbX+3tO91BmRwaLqf3Xia32GCemt3W8tayErG81BYLgrzA@mail.gmail.com>
Subject: Re: [PATCH v3 00/11] Virtual Swap Space (Swap Table Edition)
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Nhat,

First of all, thank you very much for addressing the feedback
regarding the swap metadata size concern and for stopping the
punishment of zram usage. I'm unsure how to proceed with your earlier
VS series (before swap table version V2), given the previous concerns.

I was a bit nervous when you reverted the swap table and replaced it
with something that performed worse in earlier series. I'm not
attached to the swap table. The performance regression for existing
use cases simply doesn't make sense to me. Thanks again that is no
longer the case.

On Thu, Aug 6, 2026 at 11:43=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> Changelog:
> * v2 [v2] -> v3:
>     * Rebased onto current mm-unstable.
>     * Add a runtime vm.vswap_enabled sysctl and CONFIG_VSWAP_DEFAULT_ON
>       to gate vswap allocation.
>     * More cleanups and small bug fixes.
>     * Split THP swapin enablement into its own patch (patch 5).
>     * Add production workload benchmark results, and drop RFC tag.
> * v1 [v1] -> v2:
>     * Rebased to a newer mm-unstable tip.
>     * Fix a bunch of assorted issues (incorrect zswap store failure
>       rollback, vswap_init() failure handling, rmap-encoding collision,
>       etc.) and clean up the code (rename a bunch of functions to
>       more closely follow existing patterns, etc.).
>     * Some more code clean up and simplification: some renamings to more
>       closely follow existing patterns, move vswap backing check to
>       __swap_cache_add_check, store zero state in the swap_table for
>       vswap entries, etc.. Many of these are proposed by Kairui Song
>       in [1].
>     * Defer memcg_table allocation on physical clusters until the first
>       vswap-backing slot installs. Saves ~512 bytes per physical cluster
>       that only serves vswap-backing slots (this is the new patch 8).
>     * Widen swap_info_struct->max and ->pages (and the swapoff unuse-path
>       index) so vswap supports ~8 PB of swap space (this is the new
>       patch 9).
>     * Split the physical-swap-backend patch into three for reviewability:
>       the core backend (patch 3), zswap writeback to physical swap
>       (patch 4), and reclaim of cache-only physical slots (patch 5). No
>       functional change.
>     * Add kerneldoc for the vswap API.
>     * Add some benchmark numbers for zswap case.
>
>
> I. Context and Motivation
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>
> Currently, when an anon page is swapped out, a slot in a backing swap
> device is allocated and stored in the page table entries that refer to
> the original page. This slot is also used as the "key" to find the
> swapped out content, as well as the index to swap data structures, such
> as the swap cache, or the swap cgroup mapping. Tying a swap entry to its
> backing slot in this way is performant and efficient when swap is purely
> just disk space, and swapoff is rare.
>
> However, the advent of many swap optimizations has exposed major
> drawbacks of this design. The first problem is that we occupy a physical
> slot in the swap space, even for pages that are NEVER expected to hit
> the disk: pages compressed and stored in the zswap pool, zero-filled
> pages, or pages rejected by both of these optimizations when zswap
> writeback is disabled. This is arguably the central shortcoming of
> zswap:
> * Resource-wise, it is hugely wasteful in terms of disk usage. At Meta,
>   we size swapfile in the order of 25-50% of host RAM, depending on flash
>   availaiblity. This is a lot of flash for a fleet of our size, and
>   with universal zswap enablement, most of this is wasted for zswap
>   entries.
>
> * In deployments when no disk space can be afforded for swap (such as
>   mobile and embedded devices), users cannot adopt zswap, and are forced
>   to use zram. This is confusing for users, and creates extra burdens
>   for developers, having to develop and maintain similar features for
>   two separate swap backends (writeback, cgroup charging, THP support,
>   etc.). For instance, see the discussion in [2].
>
> * Tying zswap (and more generally, other in-memory swap backends) to
>   the current physical swapfile infrastructure makes zswap implicitly
>   statically sized. This does not make sense, as unlike disk swap, in
>   which we consume a limited resource (disk space or swapfile space) to
>   save another resource (memory), zswap consumes the same resource it is
>   saving (memory). The more we zswap, the more memory we have available,
>   not less. We are not rationing a limited resource when we limit
>   the size of the zswap pool, but rather we are capping the resource
>   (memory) saving potential of zswap. Under memory pressure, using
>   more zswap is almost always better than the alternative (disk IOs, or
>   even worse, OOMs), and dynamically sizing the zswap pool on demand
>   allows the system to flexibly respond to these precarious scenarios.
>
> * Operationally, static provisioning the swapfile for zswap poses
>   significant challenges, because the sysadmin has to prescribe how
>   much swap is needed a priori, for each combination of
>   (memory size x disk space x workload usage). It is even more
>   complicated when we take into account the variance of memory
>   compression, which changes the reclaim dynamics (and as a result,
>   swap space size requirement). The problem is further exacerbated for
>   users who rely on swap utilization (and exhaustion) as an OOM signal.
>
>   All of these factors make it very difficult to configure the swapfile
>   for zswap: too small of a swapfile and we risk preventable OOMs and
>   limit the memory saving potentials of zswap; too big of a swapfile
>   and we waste disk space and memory due to swap metadata overhead.
>   This dilemma becomes more drastic in high memory systems, which can
>   have up to TBs worth of memory.
>
> Swap virtualization is the answer to these issues, with three properties:
>
> 1. Decoupled backends. For zswap in particular, this means we eliminate
>    the unused storage space, and allows zswap to be used in systems that
>    do not have enough storage capacity for physical swap (without having
>    to resort to silly hacks). Zero-filled swap pages and swap-cache-only
>    folios also benefit here.
>
> 2. Dynamic swap space. Since virtual swap is not tied to any physical
>    resource, we can make it infinite and dynamically grow it on demand.
>    This massively simplifies operational provisioning, and increases the
>    utilization of compressed swap backends (zswap). Dynamicity also
>    reduces overhead on unused swap capacity.
>
> 3. Efficient backend transfer. The virtualization scheme should not
>    introduce PTE/rmap walking overhead for backend transfer. This
>    is crucial for systems that want to support multiple swap backends
>    in a tiering fashion (for e.g zswap -> disk swap).
>
> For more historical contexts and references, please take a look at
> the cover letter of the older vswap submissions ([3] and [v2]).
>
> II. Design
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> When we compile kernel with CONFIG_VSWAP, a special vswap device is

Does the CONFIG_VSWAP only make sense for zswap right now? No other
swap usage can benifit from CONFIG_VSWAP.

> allocated at boot time, and all swapped out pages try to allocate from
> this device first, falling back to a physical swap device on failure.

Does it create a new user visible behavior change where users don't
need to swapon and can start using VSWAP for zswap?
That is a user-visible behavior change and we need to be more cautious abou=
t it.

I think a system should not use zswap or any type of swap if no device
is swapped on.

Have vm.vswap_enabled is no the answer to address the new API change
because existing distro that use fstab to control swap will need to
jump through hooks.
Previously, using fstab to control was at least consistent for all swap typ=
es.

> Routing can also be turned off at runtime with the vm.vswap_enabled
> sysctl, which defaults to 0 unless CONFIG_VSWAP_DEFAULT_ON=3Dy. It is
> allocation-only: new swapouts go straight to physical swap, while
> entries already backed by vswap keep being served and drain as they
> are faulted back in or freed.
>
> These swap entries can subsequently acquire backend on-demand, such as

What do "These" refer to? Are they entries already backed by vswap?

> a zswap entry, or a slot on a physical swap device.
>
> We repurpose much of the existing swap_table infrastructure and
> swapfile allocator for this new vswap device, with two notable
> differences:
> * Clusters are dynamically allocated on demand and managed through
>   an xarray. This in turn allows us to avoid static provisioning and
>   let swap space grow dynamically.
>
> * Each cluster of this new vswap device has a virtual_table that stores
>   the backend information of the entries in the cluster (see below).
>
> Diagrams:
>
>   Case 1: vswap entry (virtualized)
>
>   PTE                  swap_cluster_info_dynamic
>   vswap_entry          +---------------------------------+
>   (swp_entry_t) ------>| swap_cluster_info (ci)          |
>                        | +----------------------------+  |
>                        | | swap_table                 |  |
>                        | |   PFN / Shadow             |  |
>                        | | memcg_table                |  |
>                        | | count,flags,order          |  |
>                        | | lock, list                 |  |
>                        | +----------------------------+  |
>                        |                                 |
>                        | virtual_table                   |
>                        | +----------------------------+  |
>                        | | NONE                       |  |
>                        | | SWAPFILE(swp_entry_t)      |  |
>                        | | ZSWAP(struct zswap_entry*) |  |
>                        | +----------------------------+  |
>                        +---------------------------------+
>                               |
>                               | SWAPFILE resolves to
>                               v
>                        PHYSICAL CLUSTER (swap_cluster_info)
>                        +--------------------------+
>                        | swap_table per-slot:     |
>                        |   NULL   - free          |
>                        |   PFN    - cached folio  |
>                        |   Shadow - swapped out   |
>                        |   Pointer- vswap rmap    |
>                        |   Bad    - unusable      |
>                        |                          |
>                        | Vswap-backing slot:      |
>                        |   Pointer(C|swp_entry_t) |
>                        |     rmap back to vswap   |
>                        +--------------------------+
>
>   Case 2: direct-mapped physical entry (no vswap)
>
>   PTE                  PHYSICAL CLUSTER (swap_cluster_info)
>   phys_entry           +--------------------------+
>   (swp_entry_t) ------>| swap_table per-slot:     |
>                        |   NULL   - free          |
>                        |   PFN    - cached folio  |
>                        |   Shadow - swapped out   |
>                        |   Bad    - unusable      |
>                        +--------------------------+
>
> struct swap_cluster_info_dynamic {
>     struct swap_cluster_info ci;       /* swap_table, lock, etc. */
>     unsigned int index;                /* position in xarray */
>     struct rcu_head rcu;               /* kfree_rcu deferred free */
>     atomic_long_t *virtual_table;      /* backend info, 8 B/slot */
> };

No a big fan of this two personality data structure thing depending on
whether it is VS or not.
If ci is the common part, I prefer to keep it separate and leave it alone.

Also the extension is too vswap specific, it does not apply to other
swap device types that might need their own private extension.
You can take the VFS layer as an example. There is a VFS layer generic
inode, which is common and shared by all file systems. And then you
have filesystem-specific inodes as extensions, e.g. ext4_inode. The
ext4_inode does not contain VFS inode. You don't see VFS having a code
path like: if it is ext4, get the inode this way, else if f2fs, get
the inode that way.

In the first swap abstraction LPC talk, where I co-hosted with Yosry,
I talked about the alternative approach: "VFS-like swap layers". That
is exactly what I have in mind. We are getting very close to
fulfilling that promise via swap ops and xswap extension interfaces.

I think implementing the generic interface first is simpler than
implementing the non-generic vswap interface, ripping it out to
replace it with a generic interface, and then putting back the generic
modified version of vswap.
If the two personality vswap xarray lookup gets in first, it will
ultimately take more work to achieve the desired VFS-like extendable
swap operations.

I am happy to spend some time working with you to discuss the generic
adopted version of vswap, if you are open to it. Or if you don't want
to waste time on it. I can have someone else or myself come up with
the generic adopted version of vswap for you to review, which I prefer
less.

Another piece of feedback is to please come up with a plan to submit
your vswap changes piecemeal rather than as one long series. There is
a lot of change like swap charging, that deserves a separate
discussion before it gets merged. Look, the swap table changes took
four phases. Each phase achieved a smaller milestone, with four of
them ultimately reaching the finish line. I wish vswap had a similar
piecemeal plan.

Sorry I have to crash now, to be continued...

> Each vswap cluster (swap_cluster_info_dynamic) extends the classic
> swap_cluster_info struct with a virtual_table array that stores the
> backend information for each virtual swap entry in the cluster. Each
> entry is tag-encoded in the low 3 bits to indicate the backend type:
>
>   NONE:     |----- 0000 ------|000|  free / unbacked
>   SWAPFILE: |- type:5,off:56 -|001|  on a physical swapfile
>   ZSWAP:    |--- zswap_entry* |010|  compressed in zswap
>
> Other design highlights:
>
> * Note that for the vswap device, we have merged the zswap xarray tree
>   with the swapfile-level clusters. This means that for zswap only users,
>   we have negligible extra space overhead.
>
> * Both vswap entries (Case 1) and directly-mapped physical entries
>   (Case 2) coexist as first-class citizens. When CONFIG_VSWAP=3Dn the
>   vswap paths compile out.
>
> * Backend transitions in the virtual_table are synchronized through the
>   swap cache and the folio lock - the same mechanism that already
>   serializes ordinary swap operations (swapin, swapout, zswap
>   writeback, swap cache reclaim). IOW, we can only assume that the
>   backend of a vswap entry is stable through swap cache/folio lock.
>   Looking at the backend without this should be done at best for
>   optimization purposes, as there is no guarantee that the backend
>   will not change under the observer.
>
> * Pointer-tagged swap_table entries on physical clusters provide the
>   rmap (physical -> virtual) lookup.
>
> * Virtual swap slots not backed by physical swap are not charged to
>   memcg swap counters - only physical backing is charged (I made the
>   case for this in [4]).
>
>
> III. Benchmarks
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Note that the goal is not to match vswap performance with baseline on
> every single case yet - we still maintain !CONFIG_VSWAP setup. We can
> optimize further once we have landed this new feature.
>
> A. Production Workload: Instagram
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> To test vswap's stability and performance, I ran an A/B experiment on
> Instagram (django) workload, with zswap as the swap backend. On these
> hosts, the swapfiles' size is 50% of RAM.
>
> Compared to baseline, vswap gives:
>
> * On par request throughput.
> * Lower request serving latency (by about 1-3%).
> * Lower memory pressure in the system service cgroups running alongside
>   the workload. PSI-based proactive reclaimer can therefore recover more
>   from them, lowering their overall memory footprint, allowing the main
>   workload to expand.
> * Elimination of swapfile footprint for all zswap users in the host.
>
> B. Semi-synthetic Workloads (memhog, usemem, kernel build)
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> All values are mean +/- standard deviation across rounds.
>
> Test system: x86_64, 52 cores, 64 GB swapfile for all 3 benchmarks.
> Swap backend: zswap (zstd) with the traditional active/inactive LRU. We
> focus on zswap here because it is the motivating use case for vswap.
>
> For each benchmark, we test 3 kernels:
> * Baseline: mm-unstable, no vswap patches.
> * VSS off: vswap series applied, CONFIG_VSWAP not set, to verify that
>   there is no regression to existing swap paths when we disable vswap.
> * VSS on: vswap series applied, CONFIG_VSWAP=3Dy.
>
> 1. Memhog: single-threaded, 48GB allocation on a host with 16GB RAM,
>    20 rounds.
>
>                     Baseline           VSS off            VSS on
>    real (s)        131.71 +/- 13.54   132.47 +/- 10.10   120.56 +/- 15.37
>    sys (s)         114.05 +/- 13.03   115.11 +/- 9.76    103.73 +/- 15.06
>    user (s)        10.86 +/- 0.13     10.97 +/- 0.10     10.87 +/- 0.11
>    delta real              -              +0.6%              -8.5%
>    delta sys               -              +0.9%              -9.1%
>
> Dropping the best and the worst round to reduce variance:
>
>    memhog              Baseline           VSS off            VSS on
>    real (s)        130.24 +/- 8.56    131.51 +/- 5.82    119.39 +/- 12.06
>    sys (s)         112.58 +/- 7.88    114.26 +/- 5.74    102.63 +/- 11.83
>    user (s)        10.86 +/- 0.14     10.97 +/- 0.10     10.86 +/- 0.10
>    delta real              -              +1.0%              -8.3%
>    delta sys               -              +1.5%              -8.8%
>
>
> 2. Usemem single-threaded: 56GB allocation on a host with 32GB RAM,
>    16 rounds.
>
>                     Baseline           VSS off            VSS on
>    real (s)        177.14 +/- 7.34    178.20 +/- 5.12    175.83 +/- 6.96
>    sys (s)         125.30 +/- 7.47    125.19 +/- 5.18    124.09 +/- 7.07
>    tput (KB/s)     390668 +/- 16840   387878 +/- 11769   390921 +/- 15798
>    free (ms)       7739 +/- 125       7734 +/- 120       6572 +/- 121
>    delta real              -              +0.6%              -0.7%
>    delta sys               -              -0.1%              -1.0%
>    delta tput              -              -0.7%              +0.1%
>    delta free              -              -0.1%             -15.1%
>
> 3. Kernel build: 52 workers (one per processor), memory.max=3D3GB, 10 rou=
nds.
>
>                     Baseline           VSS off            VSS on
>    real (s)        168.13 +/- 0.77    168.46 +/- 0.45    167.75 +/- 0.65
>    sys (s)         772.49 +/- 19.77   781.82 +/- 26.32   763.60 +/- 33.02
>    user (s)       5128.41 +/- 1.31   5130.64 +/- 1.67   5130.74 +/- 1.66
>    delta real              -              +0.2%              -0.2%
>    delta sys               -              +1.2%              -1.1%
>    delta user              -              +0.0%              +0.0%
>
>
> For zswap backend, vswap outperforms baseline on usemem freeing, and
> memhog benchmark, and is on par with baseline on the rest.
>
> In the RFC v2 ([v2]), I put out several theories for this. I have
> done some prototyping to isolate effects, and it turns out the
> performance wins come primarily from the elimination of zswap's
> xarray and the merging of zswap's metadata to swap device's cluster.
> Several code paths are optimized thanks to this - for instance,
> in swap_range_free(), we call zswap_invalidate() once for each entry the
> range, resulting in multiple xarray tree walks. With vswap, we perform
> one single xarray walk to grab a 512-slot cluster, then performs a
> flat array scan to free zswap metadata. Similar wins can be observed
> in Baoquan's optimization ([8]), which also optimizes away the zswap tree=
.
>
> IV. References
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> [v1]: https://lore.kernel.org/all/20260528212955.1912856-1-nphamcs@gmail.=
com/
> [v2]: https://lore.kernel.org/all/20260612193738.2183968-1-nphamcs@gmail.=
com/
> [1]: https://lore.kernel.org/all/CAMgjq7BhOn48xEyC=3D2j837R7qddfjeBVHMiRq=
dx8no4ZEBpBLg@mail.gmail.com/
> [2]: https://lore.kernel.org/all/Zqe_Nab-Df1CN7iW@infradead.org/
> [3]: https://lore.kernel.org/all/20260505153854.1612033-1-nphamcs@gmail.c=
om/
> [4]: https://lore.kernel.org/linux-mm/CAKEwX=3DP4syV38jAVCWq198r2OHXXc=3D=
xA-fx1dk6+qYef6yzxWQ@mail.gmail.com/
> [5]: https://lore.kernel.org/all/CAKEwX=3DP50av2rfocpsqZoDQowZ=3DEEhQ-5vj=
5tBykbNz8vtKTzA@mail.gmail.com/
> [6]: https://lore.kernel.org/all/20260727135029.1059441-1-baoquan.he@linu=
x.dev/
> [7]: https://lore.kernel.org/all/20260220-swap-table-p4-v1-15-104795d1981=
5@tencent.com/
> [8]: https://lore.kernel.org/all/20260707073215.72183-1-baoquan.he@linux.=
dev/
>
>
> Appendix: Alternative Designs and Improvements
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> A. Vmalloc Data Structure:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>
> This is a promising alternative to the xarray data structure, reducing
> the indirection overhead. The initial version relies on userspace knob to
> trigger swap address space growth - I have commented on why this is shaky
> in [5].
>
> Baoquan has followed-up with a new version (see [6]) that should give us
> kernel-driven dynamic growth and (tail-only) shrink. This seems sufficien=
t
> for vswap use case, AFAICT - but seems like it would need a couple more
> versions to finalize the design.
>
> I think it is better to proceed with the xarray data structure first,
> especially since we already see some positive signals on performance
> by storing zswap metadata in a per-cluster flat table. With vswap landed,
> we will have a concrete setup to show vmalloc data structure's wins.
>
> B. Moving the backend table to struct swap_cluster_info
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>
> Another approach Baoquan and I discussed on is to structure vswap patch
> series as follows:
>
> 1. Moving vtable (renamed to something more generic) to swap cluster,
>    which removes the xarray.
>
> 2. Once vswap is introduced, we simply use this field to store the
>    backend.
>
> I have a prototype for this, but I ended up scrapping the whole thing, fo=
r
> the following reasons:
>
> 1. It ended up being even more code than what I sent out here - most of
>    which touches the non-vswap code paths, which we either want to leave
>    alone (generic swap logic) or want to rip out wholesale down the line
>    (zswap).
>
> 2. There are several fields that are ONLY needed for the vswap clusters
>    (for instance, rcu_head and index). Shoving them into the shared struc=
t
>    swap_cluster_info imposes memory and mental overhead for non-vswap
>    clusters and users.
>
>    We can avoid this by simply moving it to the wrapper struct
>    (swap_cluster_info_dynamic). This is actually Kairui's design
>    (see [7]), but after trying to deviate from it, I have to conclude
>    it is the right choice too.

Kairui took a shortcut to deliver a simpler demo RFC, it is not ready
for merge as is. Please take a look at the VFS inode vs
ext4_inode_info for the effect I am trying to get to.

I am really crashing now.

Chris

>
> 3. Replacing zswap tree with the per-cluster backend table results in
>    performance wins even when vswap is turned off (this is how I
>    verified that vswap's performance wins comes from here).
>
>    However, it requires more code to make sure this table is not allocate=
d
>    when not needed. Note that the eventual goal is to make vswap the ONLY
>    way to use zswap, so we are literally adding complexity and overhead
>    (even for non-vswap users) to optimize for a code path that is rarely
>    exercised after vswap lands, and will be ripped out soon after.
>    That seems very off to me.
>
> To close out, this design brings together the ideas from the earlier
> discussions:
>
> 1. All of the requirements I set out to solve (dynamicity, backend
>    decoupling, efficient backend transfer) are implemented.
>
> 2. Vswap device now repurpose the swap table design and most of the
>    generic swap operations.
>
> 3. Minimal overhead for non-vswap users, and zswap-no-writeback users.
>    If you disable writeback, vswap *is* a ghost swapfile.
>
> Nhat Pham (11):
>   mm, swap: add virtual swap device infrastructure
>   mm, swap: support zswap and zeroswap as vswap backends
>   mm, swap: prepare the swap IO path for vswap
>   mm, swap: support physical swap as a vswap backend
>   mm, swap: enable THP swapin for vswap entries
>   mm, swap: write back vswap zswap entries to physical swap
>   mm, swap: reclaim physical slots backing cache-only vswap entries
>   mm, swap: only charge physical swap entries
>   mm, swap: add debugfs counters for vswap
>   mm, swap: defer memcg_table allocation for physical swap clusters
>   mm, swap: widen swap_info_struct max/pages to unsigned long
>
>  Documentation/admin-guide/sysctl/vm.rst |   16 +
>  MAINTAINERS                             |    1 +
>  include/linux/memcontrol.h              |    5 +
>  include/linux/swap.h                    |   88 +-
>  include/linux/zswap.h                   |    3 +
>  mm/Kconfig                              |   21 +
>  mm/memcontrol.c                         |  166 +++-
>  mm/memory.c                             |   28 +-
>  mm/page_io.c                            |  103 +-
>  mm/shmem.c                              |    4 +-
>  mm/swap.h                               |   55 +-
>  mm/swap_state.c                         |   64 +-
>  mm/swap_table.h                         |   62 ++
>  mm/swapfile.c                           | 1194 +++++++++++++++++++++--
>  mm/vmscan.c                             |   14 +-
>  mm/vswap.h                              |  454 +++++++++
>  mm/zswap.c                              |  140 ++-
>  17 files changed, 2207 insertions(+), 211 deletions(-)
>  create mode 100644 mm/vswap.h
>
>
> base-commit: bacc32cc7de65ffff70080a48eb294f89e434d5e
> --
> 2.53.0-Meta
