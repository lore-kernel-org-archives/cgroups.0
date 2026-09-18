Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB463546CD;
	Fri, 18 Sep 2026 08:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789721654; cv=none; b=t3NcfYqWx9st6xAi8UJGdQLdFj6GDgn9LrZETpYK67bFujGGPsEgizX5QGv+WXg3rPdOx80b6YiXZP7FiIHd2EUka2jo2DY/E2z41BjwNUHDz4nWe8EFE9q6ilBC+e3zNgyoq9yuwny7ONOjxx+OSelSQWyXBWFgldKWlBcz4ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789721654; c=relaxed/simple;
	bh=mc0laF+Rrv6F0Aaeni+B8Gm6Oo9raw0zuKM9XV7mPww=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=AkYI2hpcOfZBOhL9SMpPOg3sWabUJNxtvZAIR/iwIZnERG4TBgh2bprcTj8lvzpvRT6JOwd5A2GQ5gc+YO2KmpRwkehYFGacoDhWEG016wQKlR+RyCyb3r0McaoRrkfOekQ932koR+1iEdmAGSvvqMilZjYCA9oJCMsc9iJuNSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FnU51j/x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FnU51j/x"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 76177C2BCB9;
	Fri, 18 Sep 2026 08:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789721653;
	bh=mc0laF+Rrv6F0Aaeni+B8Gm6Oo9raw0zuKM9XV7mPww=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=FnU51j/xdKl2Bd9jS81pJLDSJbsv0+AO/tOHCVG8h93o+xsAtENmzPnSJnOMOEhFr
	 5jSELTw1mXmk9LKvMqfWpgCJz39YqSyU2PGQEmzv3+O+/spaiqWh8uTuaaXWRcVhlr
	 qW0kG1x8Nrvwcvyq+RjNX2cBx2j6quuEJ9E/h/pduXHM3TAPX977EEkhinZINhjo+Y
	 97Y5HNloaiOXq83psrACudqL9YOBzHFZaghIcjEWNlOyo3cVPiOnuO3YD2Ypz82B/0
	 Woj2DI/EX2p544UL06hXuQMFhizPfBy3xz+DYPuUTtIx4eqgc92KoGsxz/C1XBfips
	 er9aeVMtwo+TA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C583C88E72;
	Fri, 18 Sep 2026 08:54:13 +0000 (UTC)
From: Jingxiang Zeng via B4 Relay <devnull+linuszeng.tencent.com@kernel.org>
Subject: [PATCH 0/6] mm: memcontrol: implement the memsw limit on cgroup v2
Date: Fri, 18 Sep 2026 16:53:40 +0800
Message-Id: <20260918-descriptive-name-v1-0-dfcfdd91b456@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABT8rGoC/x3MTQqAIBBA4avErBPGfoS6SrSwcaxZZKERgXT3p
 OW3eC9D4iicYKwyRL4lyREKdF0BbTasrMQVQ4ONwUEb5ThRlPOSm1WwOyskj65vO7PQAiU7I3t
 5/uU0v+8H6UmwSWIAAAA=
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
 Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Oscar Salvador <osalvador@suse.de>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: Jingxiang Zeng <jingxiangzeng.cas@gmail.com>, cgroups@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-doc@vger.kernel.org, 
 Jingxiang Zeng <linuszeng@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789721651; l=6623;
 i=linuszeng@tencent.com; s=20260909; h=from:subject:message-id;
 bh=mc0laF+Rrv6F0Aaeni+B8Gm6Oo9raw0zuKM9XV7mPww=;
 b=RM1zhgBseQSHr0NWSr6StBGrfeyxAy9ZtlO0U66cJh5jbRc835a/Ii+noHNJQfwMnFm0YmIQz
 3kxCptrTsXiDrNpFxH2oJREf2Wqq+ba18OFWloiXpNW+iH/KuuH/5V/
X-Developer-Key: i=linuszeng@tencent.com; a=ed25519;
 pk=6K54xRzYIRWqatrAPy86M4E0MsI92BVJBhXwz5NdC74=
X-Endpoint-Received: by B4 Relay for linuszeng@tencent.com/20260909 with
 auth_id=1017
X-Original-From: Jingxiang Zeng <linuszeng@tencent.com>
Reply-To: linuszeng@tencent.com

cgroup v1 caps the sum of memory and swap through memsw.limit_in_bytes.
v2 only offers separate memory.max and memory.swap.max, so a workload
that has to be capped on the total of the two has no equivalent knob:
memory.max alone can be met by swapping, and capping both separately
reserves swap the workload may never use.

A container capped at N pages should stay capped at N once swapping is
possible, but with memory.max alone the pages move to swap and it
allocates N more; reserving swap per cgroup instead means guessing how
much of the footprint will be cold at any moment.  The combined limit
states the intent directly - N pages however they are divided between RAM
and swap - and leaves the host free to offload cold pages.

This has been discussed before [1], and the direction agreed on was to
track and control the combined counter as a proper v2 feature rather than
fold it into the existing swap knobs:

  My suggestion is to factor out from struct page_counter all the stuff
  that is not necessary for all users, and then have separate counters
  for swap and memsw.

  The protection stuff is long overdue for this.  It makes up nearly half
  of the struct's members, but is only used by the memory counter.  Even
  before your patches this is unnecessary bloat in the swap/memsw, kmem
  and tcpmem counters.

  Fix that and having separate counters is a non-issue.

and, on the interface:

  This should be new knobs, e.g. memory.memsw.current, memory.memsw.max.

Patches 1-3 are that refactoring.  Hierarchical protection is only used
by the memory counter and by dmem pools, yet every page_counter carried
it; moving it into a separate struct page_counter_protection, embedded
only where it is used, takes struct page_counter from 192 to 128 bytes on
x86_64.  Both embedders put the context on a cache line boundary (384 in
struct mem_cgroup, 192 in the dmem pool state), so the fields the charge
path touches - min, low and the four usage counters - share a cache line
with emin, which only reclaim recomputes; only elow crosses into the
next one.

Patch 4 splits the counters.  swap and memsw share a union today because
v1 only ever charges memsw and v2 only ever charges swap, so charging
both on both hierarchies is what the combined limit needs.  v2 hands the
combined charge over to the swap slot in __mem_cgroup_try_charge_swap()
and drops it again in __mem_cgroup_uncharge_swap().  memsw.max still
defaults to "max" and v2 cannot set it, so behaviour does not change.

Patch 5 exposes memory.memsw.current and memory.memsw.max on non-root
cgroups.  A charge counted there is held for as long as the memory
occupies either RAM or a swap slot, so reclaim cannot get back under the
limit by swapping; try_to_free_mem_cgroup_pages() is called without
MEMCG_RECLAIM_MAY_SWAP when the limit is written, and the cgroup OOM
killer is the last resort, mirroring memory.max.  Both writers keep
memory.max <= memory.memsw.max under a mutex, so the two limits cannot be
configured into a state reclaim could never satisfy - the invariant v1
keeps in mem_cgroup_resize_max(), including its serialization.

Patch 6 clamps mem_cgroup_get_max() to the new limit.  That value becomes
oc->totalpages for memcg OOM and oom_badness() scales oom_score_adj by
it, so while the v2 branch derived the ceiling from memory.max plus
memory.swap.max it overstated the reachable total once a combined limit
was set, and oom_score_adj weighed correspondingly more than intended.

Size effect, measured with pahole (x86_64, 64-byte cache lines).  The
split costs a cgroup one more page counter, and without patches 1-3 that
counter would be 192 bytes:

  struct mem_cgroup (CONFIG_MEMCG_V1=y)  2240 -> 2432 -> 2240
  struct mem_cgroup (CONFIG_MEMCG_V1=n)  1664 -> 1856 -> 1792

The middle figure is the same tree with the union split but the counters
left at 192 bytes, so it is what the series would have cost without the
refactoring.  On a v1 kernel that is the whole 192 bytes paid back; on a
v2-only one the three counters involved shed 192 bytes between them, but
the protection context takes 72 back and alignment a further 56, so 64
are paid back.  Counters that gain nothing keep their share:

  struct page_counter             192 -> 128 bytes
  struct hugetlb_cgroup          1344 -> 1088 bytes
  dmem pool state                 320 ->  320 bytes

Tested on x86_64 with CONFIG_MEMCG_V1=y and =n, each patch building on
its own:

- memory.memsw.current equals memory.current plus memory.swap.current
  across swapout, swapin and swapoff.
- Squeezing memory.max drops memory.current while memory.memsw.current
  holds, and a combined limit stops a 128M working set that otherwise
  escapes a 32M memory.max by swapping.
- Writing memory.memsw.max reclaims without MEMCG_RECLAIM_MAY_SWAP: swap
  usage stays flat and the cgroup goes to OOM, where writing memory.max
  swaps instead.
- Concurrent writers to the two limits could not leave the invariant
  violated in 600 rounds.
- A kretprobe on mem_cgroup_get_max() returns 48M for memory.max=32M and
  memory.memsw.max=48M with 2G of swap, and is unchanged with
  memory.memsw.max left at "max".
- v1 memsw.limit_in_bytes, and the v1 paths reaching the new NULL ->prot
  guards (css_offline, css_reset, lru_gen_age_node), behave as before.

[1] https://lore.kernel.org/all/20250320144722.GH1876369@cmpxchg.org/

Signed-off-by: Jingxiang Zeng <linuszeng@tencent.com>
---
Jingxiang Zeng (6):
      mm: page_counter: add page_counter_protection struct and init API
      mm: page_counter: track protection state in page_counter_protection
      mm: page_counter: drop protection fields from struct page_counter
      mm: memcontrol: give swap and memsw their own page counters
      mm: memcontrol: add memory.memsw.max to the default hierarchy
      mm: memcontrol: clamp mem_cgroup_get_max() to the combined limit

 Documentation/admin-guide/cgroup-v2.rst |  32 +++++
 include/linux/memcontrol.h              |  27 ++--
 include/linux/page_counter.h            |  88 +++++++++---
 kernel/cgroup/dmem.c                    |  21 +--
 mm/hugetlb_cgroup.c                     |   4 +-
 mm/memcontrol.c                         | 241 ++++++++++++++++++++++++++------
 mm/page_counter.c                       |  61 +++++---
 7 files changed, 371 insertions(+), 103 deletions(-)
---
base-commit: 1ed9cdd724d46119dd9adf0ffba2f2daaa3335ef
change-id: 20260916-descriptive-name-0cf0d5346bcb

Best regards,
-- 
Jingxiang Zeng <linuszeng@tencent.com>


