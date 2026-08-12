Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C39542CB14
	for <cgroups@vger.kernel.org>; Wed, 12 Aug 2026 16:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786552296; cv=pass; b=EBbNBqIAi/FxAtOJK3iUnll7IVaGlB/wVPSgFfXtJvcrpWUllAZZj5Lxbi9OU4i4Oxf+z4m+sMr2/Jh7nbCHg4+5/MhWjwc1fY0+PXaxLBUcBvv1yutS6Ytw8gMaj8tiN5j/hr7fH1eDMbGr9qQKJglGFY9WxTAQNxGJp2LgN74=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786552296; c=relaxed/simple;
	bh=USwbS+94VV2LWF6tT0TB0lFWUzt26MH1nbm9QtmZb9I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PVwQe3sTlgmqXvVAA0TH4dv2jgVOzAi53j9lq4mi6t5Dj94TMXEp9QX0lDlpdo6N/cR5KVrOgnOPQDu3f/VTU52w6nq1od2OYba9Vr0DnON69htdDVMxm9f2b1lDYdbL135UE/KzV/1lIMNvaqvfBr9S8Jr4WusQE4L4Uh7wAU8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VFXKmMyN; arc=pass smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VFXKmMyN"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-47f71156e1aso538278f8f.3
        for <cgroups@vger.kernel.org>; Wed, 12 Aug 2026 09:31:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786552292; cv=none;
        d=google.com; s=arc-20260327;
        b=cPj4ITg7R8vmfiLaPMlsgy7Z/wlAwPVy1cJbm0foYY3vzjXv0M+EJJf6MkzCYI2T/O
         LsJFTkbraRRRRBwUDbGopNex6NfjFzcOsW8ppW35Dj7YrbT4d1mG7cALHj3dhJVrCIOz
         BWlWL/CZ0SrAQGvKUmpP5EajKjqYrAv9nkVrcyfmhc4KxIBrGsKrtzOD7GGJ6TiRUQIb
         C2keHUdX4UoD6PP/Lt4t6o2R1q9pXYREBHHaLhfopwNflJ1+Chmnea83D/592NGTzCmi
         MiosO8jYJfn+qhVKTWzwAXQfjME6efAnLdOqTL+Diq7rdGUomESUtZ0VXtfSQhg5Us4F
         oo/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=28gd3J2v+Z0sZUbhsqqZbC9VAYrt+YqzWhI5/85OLmw=;
        fh=gjgsWGM8ZvyDRd0Aey+PL2tJ7jA3FIiNcLlyjj1lYNg=;
        b=RZs92Cx2kPp1MD3IAzkcu/+d8h+/B+5hJIhuTlAJC7jFdDMV9V+FNNO4xcJDrlY/Eo
         xjG3s2MDzz40Efi6STG93VT9sr1cNmX1VO6c3NCNPNLrbaKeIGKSzJyNfxvDctFgPKoS
         G84XFGGQN6pL3FarKhy3X0lP9wKJ9t1+j6rAGezimg2Y84dmQ32oAAO00T1K9F9CkbyL
         lWE2eAIqNjG1KtxNQFM0LK6rb6r/fZpJHbIZ6lE8LCfmrQIhtnUsXJz9nrsb/Oo7jNvJ
         +Nx5HL+Wswd9Fd+NWkLc6AUYwOurpSxgpUZB/+icyUptwcZ1idvxfOQnmGkkQJfrCNY3
         thzw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786552292; x=1787157092; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=28gd3J2v+Z0sZUbhsqqZbC9VAYrt+YqzWhI5/85OLmw=;
        b=VFXKmMyNDtNtCYO10HHMn6vN+q3yTPMw7IjI1pkr6aH9YzQq7FHD95Dfwlri1/ZqCf
         psT5GMDK4gceiCqLsksdkrhIrbSMMKr/rmRRyOe1FO23+YcyiYmP3TQNktmGJW4+gwu/
         6z4hPVP6AzzT10JZnzBaOZsgVdK2oxopzsZiLmHAy4NCMYF3TveyIEonnQuBFm29q/5Q
         JWWWYnARDAgzzIvsfDPEJjEKLMVdNb1YQZp+I73y56huLdWjwC+RUW1JkQfEupIcbUTJ
         MS2rL0GNq+HCyAJfYO2ShSCBRUMtWzorSgdUOrksKcWqAdChyf2MVz+sFU2PPbDauUKz
         P2YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786552292; x=1787157092;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=28gd3J2v+Z0sZUbhsqqZbC9VAYrt+YqzWhI5/85OLmw=;
        b=WFlRwtmdgM1Y1ZDFig/+QSxX/J2F3vQLeChMikacYl+hulAg8/UbmDcpA9Kps367KU
         sI5cOh8vTYDzvhlSaph4sHgFGR/9WOYkU9s1Sol0r+rBSk309z0LlOJqXpQbuoJ9ptsG
         Q9+5kv8iJtCndqzqNrRX9V0yni/rrHfTpxE9owIbnCjCBHeYmJwrL6PnVTajgFSmZ/0Y
         GBVKCXWwSvqV2NXs2/NU32C4cKujlfqagz7Tc+3Rrdku2I+EOfGfK8eaKqk4XGjqQa/h
         87jluAZRljQ8rDfPV97qqW5olzE6byCHSReUkNdlAUBHbtGOpUTynZOglxEtEPjGicM7
         f4cA==
X-Forwarded-Encrypted: i=1; AHgh+RrS0lL+Ij3F1DEvNQbgQupQPNUt9bVxtaz4LTw64RF31vqXWMIrOldIIG80wyIJ+78N+LIqoQfu@vger.kernel.org
X-Gm-Message-State: AOJu0YzLlGpsjEBkw6VpN53N9K05rWCGZTSantmg5ESiM1mO4Wx+cm62
	I2rkMGJx2et2lUV8YlG5Z6VbqQ5XHbOQYkA3LVKpk4vIeOoNxcck1FMXa5GQO824bCmAr5sZ2fM
	hX3lgMN3pKAVJXR+FEJGex0lPDnJZevI=
X-Gm-Gg: AR+sD11r+50PYWbTC6EFOvLsXoxJCaIRcrIgUmH5Kw4U3l6wAVdMBQ8ffHvUA/7MLXV
	xQpxGgNX8F9Mh3uSgGsOHF8gsRo6ntirhqRj1lTYT1+kK4CiPnEss9s3ikhSLOgztmf+9BNi3Rf
	UBAJK8x0HzB0DDtRYFP3+bYD/GYXOU+WDf5NZWGqHWDK9xJaRIwfhyJ1YR96Z/301D5alasiLOM
	Ez0i0f+DtW66FRrXC0/cr+3SsNN5ZgtlG0y7OM5c/nrW+BmH8CaYEkIADt7dx7WKD58SSRU0M1C
	V0nD6DoQJNr0BLjthILN9jqTezflP2Yxypa1KR/ZOzPO8+ppH0ub04k9pqy8BbF6CCZTTKkzWB5
	Y
X-Received: by 2002:a05:6000:470b:b0:481:5657:5299 with SMTP id
 ffacd0b85a97d-481565752a7mr6852007f8f.0.1786552292251; Wed, 12 Aug 2026
 09:31:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260806184254.3790858-1-nphamcs@gmail.com> <CACePvbX+3tO91BmRwaLqf3Xia32GCemt3W8tayErG81BYLgrzA@mail.gmail.com>
In-Reply-To: <CACePvbX+3tO91BmRwaLqf3Xia32GCemt3W8tayErG81BYLgrzA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 12 Aug 2026 09:31:20 -0700
X-Gm-Features: AUfX_myNxWLKbey6UqnimGgaytWlmCtyk7j5TdlPuoAnbTv6EzNqg0hpri4e0do
Message-ID: <CAKEwX=NNVshitZv+zp6ONVDku4JWcwGgZ2-hSirsKfa-fs6D9w@mail.gmail.com>
Subject: Re: [PATCH v3 00/11] Virtual Swap Space (Swap Table Edition)
To: Chris Li <chrisl@kernel.org>
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

On Fri, Aug 7, 2026 at 2:07=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
>
> Hi Nhat,
>
> First of all, thank you very much for addressing the feedback
> regarding the swap metadata size concern and for stopping the
> punishment of zram usage. I'm unsure how to proceed with your earlier
> VS series (before swap table version V2), given the previous concerns.
>
> I was a bit nervous when you reverted the swap table and replaced it
> with something that performed worse in earlier series. I'm not
> attached to the swap table. The performance regression for existing
> use cases simply doesn't make sense to me. Thanks again that is no
> longer the case.

Eh, I'm open minded. I try lots of stuff - I tried the swap table
direction twice actually.

>
> On Thu, Aug 6, 2026 at 11:43=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >
> > Changelog:
> > * v2 [v2] -> v3:
> >     * Rebased onto current mm-unstable.
> >     * Add a runtime vm.vswap_enabled sysctl and CONFIG_VSWAP_DEFAULT_ON
> >       to gate vswap allocation.
> >     * More cleanups and small bug fixes.
> >     * Split THP swapin enablement into its own patch (patch 5).
> >     * Add production workload benchmark results, and drop RFC tag.
> > * v1 [v1] -> v2:
> >     * Rebased to a newer mm-unstable tip.
> >     * Fix a bunch of assorted issues (incorrect zswap store failure
> >       rollback, vswap_init() failure handling, rmap-encoding collision,
> >       etc.) and clean up the code (rename a bunch of functions to
> >       more closely follow existing patterns, etc.).
> >     * Some more code clean up and simplification: some renamings to mor=
e
> >       closely follow existing patterns, move vswap backing check to
> >       __swap_cache_add_check, store zero state in the swap_table for
> >       vswap entries, etc.. Many of these are proposed by Kairui Song
> >       in [1].
> >     * Defer memcg_table allocation on physical clusters until the first
> >       vswap-backing slot installs. Saves ~512 bytes per physical cluste=
r
> >       that only serves vswap-backing slots (this is the new patch 8).
> >     * Widen swap_info_struct->max and ->pages (and the swapoff unuse-pa=
th
> >       index) so vswap supports ~8 PB of swap space (this is the new
> >       patch 9).
> >     * Split the physical-swap-backend patch into three for reviewabilit=
y:
> >       the core backend (patch 3), zswap writeback to physical swap
> >       (patch 4), and reclaim of cache-only physical slots (patch 5). No
> >       functional change.
> >     * Add kerneldoc for the vswap API.
> >     * Add some benchmark numbers for zswap case.
> >
> >
> > I. Context and Motivation
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> >
> > Currently, when an anon page is swapped out, a slot in a backing swap
> > device is allocated and stored in the page table entries that refer to
> > the original page. This slot is also used as the "key" to find the
> > swapped out content, as well as the index to swap data structures, such
> > as the swap cache, or the swap cgroup mapping. Tying a swap entry to it=
s
> > backing slot in this way is performant and efficient when swap is purel=
y
> > just disk space, and swapoff is rare.
> >
> > However, the advent of many swap optimizations has exposed major
> > drawbacks of this design. The first problem is that we occupy a physica=
l
> > slot in the swap space, even for pages that are NEVER expected to hit
> > the disk: pages compressed and stored in the zswap pool, zero-filled
> > pages, or pages rejected by both of these optimizations when zswap
> > writeback is disabled. This is arguably the central shortcoming of
> > zswap:
> > * Resource-wise, it is hugely wasteful in terms of disk usage. At Meta,
> >   we size swapfile in the order of 25-50% of host RAM, depending on fla=
sh
> >   availaiblity. This is a lot of flash for a fleet of our size, and
> >   with universal zswap enablement, most of this is wasted for zswap
> >   entries.
> >
> > * In deployments when no disk space can be afforded for swap (such as
> >   mobile and embedded devices), users cannot adopt zswap, and are force=
d
> >   to use zram. This is confusing for users, and creates extra burdens
> >   for developers, having to develop and maintain similar features for
> >   two separate swap backends (writeback, cgroup charging, THP support,
> >   etc.). For instance, see the discussion in [2].
> >
> > * Tying zswap (and more generally, other in-memory swap backends) to
> >   the current physical swapfile infrastructure makes zswap implicitly
> >   statically sized. This does not make sense, as unlike disk swap, in
> >   which we consume a limited resource (disk space or swapfile space) to
> >   save another resource (memory), zswap consumes the same resource it i=
s
> >   saving (memory). The more we zswap, the more memory we have available=
,
> >   not less. We are not rationing a limited resource when we limit
> >   the size of the zswap pool, but rather we are capping the resource
> >   (memory) saving potential of zswap. Under memory pressure, using
> >   more zswap is almost always better than the alternative (disk IOs, or
> >   even worse, OOMs), and dynamically sizing the zswap pool on demand
> >   allows the system to flexibly respond to these precarious scenarios.
> >
> > * Operationally, static provisioning the swapfile for zswap poses
> >   significant challenges, because the sysadmin has to prescribe how
> >   much swap is needed a priori, for each combination of
> >   (memory size x disk space x workload usage). It is even more
> >   complicated when we take into account the variance of memory
> >   compression, which changes the reclaim dynamics (and as a result,
> >   swap space size requirement). The problem is further exacerbated for
> >   users who rely on swap utilization (and exhaustion) as an OOM signal.
> >
> >   All of these factors make it very difficult to configure the swapfile
> >   for zswap: too small of a swapfile and we risk preventable OOMs and
> >   limit the memory saving potentials of zswap; too big of a swapfile
> >   and we waste disk space and memory due to swap metadata overhead.
> >   This dilemma becomes more drastic in high memory systems, which can
> >   have up to TBs worth of memory.
> >
> > Swap virtualization is the answer to these issues, with three propertie=
s:
> >
> > 1. Decoupled backends. For zswap in particular, this means we eliminate
> >    the unused storage space, and allows zswap to be used in systems tha=
t
> >    do not have enough storage capacity for physical swap (without havin=
g
> >    to resort to silly hacks). Zero-filled swap pages and swap-cache-onl=
y
> >    folios also benefit here.
> >
> > 2. Dynamic swap space. Since virtual swap is not tied to any physical
> >    resource, we can make it infinite and dynamically grow it on demand.
> >    This massively simplifies operational provisioning, and increases th=
e
> >    utilization of compressed swap backends (zswap). Dynamicity also
> >    reduces overhead on unused swap capacity.
> >
> > 3. Efficient backend transfer. The virtualization scheme should not
> >    introduce PTE/rmap walking overhead for backend transfer. This
> >    is crucial for systems that want to support multiple swap backends
> >    in a tiering fashion (for e.g zswap -> disk swap).
> >
> > For more historical contexts and references, please take a look at
> > the cover letter of the older vswap submissions ([3] and [v2]).
> >
> > II. Design
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > When we compile kernel with CONFIG_VSWAP, a special vswap device is
>
> Does the CONFIG_VSWAP only make sense for zswap right now? No other
> swap usage can benifit from CONFIG_VSWAP.

Good point, yeah.

Maybe have CONFIG_VSWAP depends on CONFIG_ZSWAP, until another use
case comes (I was thinking of discontig physical swapping, but this
damn patch series is long.)

>
> > allocated at boot time, and all swapped out pages try to allocate from
> > this device first, falling back to a physical swap device on failure.
>
> Does it create a new user visible behavior change where users don't
> need to swapon and can start using VSWAP for zswap?
> That is a user-visible behavior change and we need to be more cautious ab=
out it.

Userspace behavior change *is* the whole point here though. I want the
users to not having to specify a static capacity :)

Furthermore, the implication of not breaking existing users'
deployment is that if users want this new feature, they have to change
their existing config. It's just about where it makes the most sense
(a compile time config? boot time config? runtime config? some
combinations of these?)

However, I absolutely agree with you about being cautious with the
exact API. I'm still evaluating the best way to bring about this
(perhaps a boot time parameters is better than this runtime knob, but
let me prototype and test things).

>
> I think a system should not use zswap or any type of swap if no device
> is swapped on.

Why not? If we don't specify the size, and just want on/off knob (say
at boot time), seems like an overkill to use this interface. But maybe
I'm missing something.

>
> Have vm.vswap_enabled is no the answer to address the new API change
> because existing distro that use fstab to control swap will need to
> jump through hooks.
> Previously, using fstab to control was at least consistent for all swap t=
ypes.
>
> > Routing can also be turned off at runtime with the vm.vswap_enabled
> > sysctl, which defaults to 0 unless CONFIG_VSWAP_DEFAULT_ON=3Dy. It is
> > allocation-only: new swapouts go straight to physical swap, while
> > entries already backed by vswap keep being served and drain as they
> > are faulted back in or freed.
> >
> > These swap entries can subsequently acquire backend on-demand, such as
>
> What do "These" refer to? Are they entries already backed by vswap?

Yep. Vswap entries

>
> > a zswap entry, or a slot on a physical swap device.
> >
> > We repurpose much of the existing swap_table infrastructure and
> > swapfile allocator for this new vswap device, with two notable
> > differences:
> > * Clusters are dynamically allocated on demand and managed through
> >   an xarray. This in turn allows us to avoid static provisioning and
> >   let swap space grow dynamically.
> >
> > * Each cluster of this new vswap device has a virtual_table that stores
> >   the backend information of the entries in the cluster (see below).
> >
> > Diagrams:
> >
> >   Case 1: vswap entry (virtualized)
> >
> >   PTE                  swap_cluster_info_dynamic
> >   vswap_entry          +---------------------------------+
> >   (swp_entry_t) ------>| swap_cluster_info (ci)          |
> >                        | +----------------------------+  |
> >                        | | swap_table                 |  |
> >                        | |   PFN / Shadow             |  |
> >                        | | memcg_table                |  |
> >                        | | count,flags,order          |  |
> >                        | | lock, list                 |  |
> >                        | +----------------------------+  |
> >                        |                                 |
> >                        | virtual_table                   |
> >                        | +----------------------------+  |
> >                        | | NONE                       |  |
> >                        | | SWAPFILE(swp_entry_t)      |  |
> >                        | | ZSWAP(struct zswap_entry*) |  |
> >                        | +----------------------------+  |
> >                        +---------------------------------+
> >                               |
> >                               | SWAPFILE resolves to
> >                               v
> >                        PHYSICAL CLUSTER (swap_cluster_info)
> >                        +--------------------------+
> >                        | swap_table per-slot:     |
> >                        |   NULL   - free          |
> >                        |   PFN    - cached folio  |
> >                        |   Shadow - swapped out   |
> >                        |   Pointer- vswap rmap    |
> >                        |   Bad    - unusable      |
> >                        |                          |
> >                        | Vswap-backing slot:      |
> >                        |   Pointer(C|swp_entry_t) |
> >                        |     rmap back to vswap   |
> >                        +--------------------------+
> >
> >   Case 2: direct-mapped physical entry (no vswap)
> >
> >   PTE                  PHYSICAL CLUSTER (swap_cluster_info)
> >   phys_entry           +--------------------------+
> >   (swp_entry_t) ------>| swap_table per-slot:     |
> >                        |   NULL   - free          |
> >                        |   PFN    - cached folio  |
> >                        |   Shadow - swapped out   |
> >                        |   Bad    - unusable      |
> >                        +--------------------------+
> >
> > struct swap_cluster_info_dynamic {
> >     struct swap_cluster_info ci;       /* swap_table, lock, etc. */
> >     unsigned int index;                /* position in xarray */
> >     struct rcu_head rcu;               /* kfree_rcu deferred free */
> >     atomic_long_t *virtual_table;      /* backend info, 8 B/slot */
> > };
>
> No a big fan of this two personality data structure thing depending on
> whether it is VS or not.
> If ci is the common part, I prefer to keep it separate and leave it alone=
.

I don't get what you meant. It is separate, and alone, no?

Originally Baoquan and I were thinking of shoving the virtual table
into "struct swap_cluster_info". I tried prototyping that one out, but
it looks uglier than I anticipated, so I dropped that approach.

>
> Also the extension is too vswap specific, it does not apply to other
> swap device types that might need their own private extension.
> You can take the VFS layer as an example. There is a VFS layer generic
> inode, which is common and shared by all file systems. And then you
> have filesystem-specific inodes as extensions, e.g. ext4_inode. The
> ext4_inode does not contain VFS inode. You don't see VFS having a code
> path like: if it is ext4, get the inode this way, else if f2fs, get
> the inode that way.


Hmmm, I'm not an FS expert. But struct ext4_inode_info does contain a
generic vfs inode field ("struct inode vfs_inode"), no? That is
actually more analogous than I would think: we have a vswap-specific
cluster struct (struct swap_cluster_info_dynamic) that wraps the
generic, shared metadata struct (struct swap_cluster_info).

I also never claim to re-implement vfs for swap. We take inspirations
where appropriate, but we're just writing our own thing at this point
:)

>
> In the first swap abstraction LPC talk, where I co-hosted with Yosry,
> I talked about the alternative approach: "VFS-like swap layers". That
> is exactly what I have in mind. We are getting very close to
> fulfilling that promise via swap ops and xswap extension interfaces.

I remember that talk. I don't remember how backend transfer would be
implemented in that proposal.

>
> I think implementing the generic interface first is simpler than
> implementing the non-generic vswap interface, ripping it out to
> replace it with a generic interface, and then putting back the generic
> modified version of vswap.
> If the two personality vswap xarray lookup gets in first, it will
> ultimately take more work to achieve the desired VFS-like extendable
> swap operations.
>
> I am happy to spend some time working with you to discuss the generic
> adopted version of vswap, if you are open to it. Or if you don't want
> to waste time on it. I can have someone else or myself come up with
> the generic adopted version of vswap for you to review, which I prefer
> less.

I would love to hear more about it, but so far I haven't quite
understood how it's going to achieve all of the requirements vswap is
trying to solve.

>
> Another piece of feedback is to please come up with a plan to submit
> your vswap changes piecemeal rather than as one long series. There is
> a lot of change like swap charging, that deserves a separate
> discussion before it gets merged. Look, the swap table changes took
> four phases. Each phase achieved a smaller milestone, with four of
> them ultimately reaching the finish line. I wish vswap had a similar
> piecemeal plan.

Lemme think about this a bit more. But in the meantime, could you at
least take a look at the general directions? For your use case (zswap
as the terminal swap level), I think the first two patches are the
most relevant, but the rest is crucial too for a generic use case.
