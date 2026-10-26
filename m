Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792996029;
	b=2D/y1MswXIRiKtPgOxMxnTc5cEfn+Ht8gAr+F+iTHtGLEorKIjdh1Z/tPJPQHsMuLzCA
	 ijA6XNpO1GqdTcvzEgFzBtuf28Sua04TUIJ6pUvRJV/ehkG+rd458XLPytsz7w2hMM7F0
	 kIVvDsJZseVD1Yn7jGgp34dGwDjR76kXHZW30YovhtsKOeaZLGmamRtsLBUb5W4tSHc4e
	 H6u2raXnm8PYFy+I8jJ/Hrj9Vq2kFxhpniwVD7UQ08MOiqN7vEmMlnRjNr7gkLHdBcDQ6
	 OzDDEYx7CfRw7WbfAtSHvb213wRhDegys2K+C0XFyDIyvAYoBhuPs+IP9TS3yn4GyrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792996029;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=pQSTFgbxlxLL9jSJ52YUzd8VpEj4hxBSu+fg6mberfc=;
	b=qKXyl6AjgHyiMzhkQOh4XqXb/sb/W+w//iSX2ZGJWYpcXY5XPy8bKcLZ5CZc25o7/Ott
	 iRDq/mVTbGejBMct0uAHhZFEvnci+zPm/o8apxO74bjUBKMpHlgz/LJy2t0Phj3wfymlg
	 Cj4W5YD8/YDFydfapyePKIHhkp7DZ+Y786o4rwgyZTBkaonsV03SZmmVkG8wSEz3KiSF6
	 4vn8KEmcfpv/qV9nyznx9QrObKjmqyruqntROZjPfCffLnZ0sz0E2SQYBGyfYsn582fOW
	 znfVWlNm3bs4sew/CcFUCvWGy3WuBDGt4QnisNFH4Iv2m+42l7Eq0BPHb8TjByIJQbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=C7mZx1i+;
	arc=none smtp.remote-ip=115.124.30.98
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310B3606A31A;
	Mon, 26 Oct 2026 06:27:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 310B3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=C7mZx1i+
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792996024; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=pQSTFgbxlxLL9jSJ52YUzd8VpEj4hxBSu+fg6mberfc=;
	b=C7mZx1i+GZgsuuAQxPO7LzRyynVq6mzhK0H8f0lr8gIlfAHLFfFAL0fNHkZDKUGpGB/2WYfCjg5CL03jNho/QOgTmo3YgHHEzNAxCmODlqsJp/erHMfrYyQAtKa8Ji0WCnmohR+9t1+73rPop/QooZNl2+Qa7oJTtRt2nlkryps=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R261e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0XDSv6CD_1792996016;
Received: from 30.178.68.215(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XDSv6CD_1792996016 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 26 Oct 2026 14:27:01 +0800
Message-ID: <8fe2314a-ec7c-4ff0-92cf-27f7f8c9c132@linux.alibaba.com>
Date: Mon, 26 Oct 2026 14:26:55 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/5] mm: restore per-memcg reclaim for NONSLAB
 shrinkers under nokmem
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, mkoutny@suse.com,
 david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 usama.arif@linux.dev, david@fromorbit.com, qi.zheng@linux.dev,
 yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev,
 xlpang@linux.alibaba.com, ryncsn@gmail.com, gourry@gourry.net,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261013031221.1997194-1-qinyuntan@linux.alibaba.com>
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
In-Reply-To: <20261013031221.1997194-1-qinyuntan@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi, All

Gentle ping on this series.

V4 fixes the boot hang Kairui reported against v3 -- the root cause
was that the walker reverse-resolved xarray keys as private memcg IDs
after the keys were switched to cgroup IDs, causing shrink_dcache_sb()
to loop forever on the global drain. The fix passes the xarray index
directly through the internal walk path (new patch 1), so no reverse
lookup is needed.

Could someone take a look when they have a chance?

Thanks,
Qinyun Tan

On 10/13/26 11:12 AM, Qinyun Tan wrote:
> With cgroup.memory=nokmem, the THP deferred split shrinker and the
> zswap shrinker are degraded in two ways.
> 
> First, both shrinkers are missing the SHRINKER_NONSLAB flag, so
> shrinker_memcg_alloc() demotes them to non-memcg-aware shrinkers:
> limit-induced reclaim of a cgroup neither splits its partially
> unmapped THPs nor writes back its zswapped pages.  v1 of this series
> [1] restored the flag to fix that.
> 
> However, as Sashiko's review of v1 pointed out [2], the flag alone
> is not enough.  __list_lru_init() also collapses every list_lru into
> per-node lists under nokmem, so even with the flag restored, the
> objects of all cgroups share one list per node: the per-memcg
> shrinker bit is only set for whichever memcg happens to repopulate
> the empty list, so pressure in other cgroups may not even trigger
> the scan, and when it does, the scan walks everyone's objects.
> 
> Before commit fafaeceb89a5 ("mm: switch deferred split shrinker to
> list_lru"), THP had fully per-memcg deferred split queues embedded
> in struct mem_cgroup, working independently of kmem accounting.
> nokmem only opts out of kernel slab accounting; THPs and zswapped
> pages are user memory and remain charged to their cgroups, so
> per-memcg reclaim is still what these shrinkers want.
> 
> This series keeps list_lrus backed by SHRINKER_NONSLAB shrinkers
> memcg aware under nokmem:
> 
> Patch 1 passes the xarray index directly to the list_lru walker and
> drops the reverse memcg lookup that v3 still performed between the
> xarray iteration and the walk.  That lookup was the cause of the
> boot hang reported against v3 [3]: after the keys were switched to
> cgroup IDs, the walker kept resolving them as private memcg IDs, so
> the global drain kept skipping non-empty per-memcg sublists and
> shrink_dcache_sb() could loop forever.  Passing the index directly
> also removes the temporary css reference from the walk.
> 
> Patch 2 drops the kmemcg_id copy, which is only assigned when kmem
> accounting is enabled, and indexes the list_lru xarray with
> mem_cgroup_id() instead, so the index works independently of kmem
> accounting.  The list_lru plumbing passes memcg pointers now, and
> memcg_online_kmem()/memcg_offline_kmem() are inlined into the css
> online/offline hooks.  It also drops the nokmem early return from
> the offline path so these lrus are reparented on offline.
> 
> Patch 3 keeps a list_lru memcg aware under nokmem when its backing
> shrinker is registered SHRINKER_NONSLAB.
> 
> Patches 4 and 5 restore/add SHRINKER_NONSLAB on the THP deferred
> split shrinker and the zswap shrinker.
> 
> The savings of nokmem are preserved: slab-backed lrus (e.g. the
> superblock dentry/inode lrus) still fall back to per-node lists, and
> the per-memcg lists are only allocated when a memcg actually holds
> such objects.
> 
> Changes in v4:
>  - Fix the boot hang reported by Kairui against v3 [3]: the walker
>    no longer reverse-resolves the xarray keys; the index is passed
>    directly through the internal walk path (new patch 1, split out
>    as a preparation so patch 2 remains a pure key switch).
>  - Drop the kmemcg_id member from memcg_struct_check() along with
>    the field removal, as pointed out by Gregory Price [4].
>  - Otherwise unchanged from v3.
> 
> Changes in v3:
>  - Index the list_lru xarray with mem_cgroup_id() (the cgroup ID)
>    instead of the private memcg ID, whose lifetime only covers
>    online groups, and pass memcg pointers through the list_lru
>    plumbing; inline memcg_online_kmem()/memcg_offline_kmem() into
>    the css online/offline hooks (patch 1 as numbered in v3, per
>    Johannes's review of v2 [5]).
>  - Describe in the THP patch's changelog why fafaeceb89a5 dropped
>    SHRINKER_NONSLAB knowingly, per Johannes's pointer to the
>    original discussion [5].
>  - Collected review tags: Johannes's Reviewed-by on patches 2-4,
>    Nhat's and Yosry's Acked-by on patch 4 (numbering as in v3).
> 
> Changes in v2:
>  - Keep the list_lrus behind the two shrinkers per-memcg under
>    nokmem, so the shrinker bits are set for the right memcgs and
>    scans stay scoped to the target cgroup's objects (patches 1-2
>    as numbered in v2, new; addresses Sashiko's review of v1 [2]).
>  - Patches 3-4 unchanged from v1; collected the review tags.
> 
> [1] https://lore.kernel.org/lkml/20260904033503.4067283-1-qinyuntan@linux.alibaba.com/
> [2] https://sashiko.dev/#/patchset/20260904033503.4067283-1-qinyuntan@linux.alibaba.com
> [3] https://lore.kernel.org/lkml/20260910080722.3961351-1-qinyuntan@linux.alibaba.com/
> [4] https://lore.kernel.org/lkml/arNK64PxTXbVEhis@gourry-fedora-PF4VCD3F/
> [5] https://lore.kernel.org/lkml/20260907110111.2286932-1-qinyuntan@linux.alibaba.com/
> 
> Qinyun Tan (5):
>   mm: list_lru: pass the memcg index directly to the walker
>   mm: memcontrol: drop kmemcg_id and use mem_cgroup_id() for list_lru
>     indexing
>   mm: list_lru: keep per-memcg lists with nokmem for NONSLAB-backed lrus
>   mm: thp: restore SHRINKER_NONSLAB on the deferred split shrinker
>   mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB
> 
>  include/linux/memcontrol.h |  16 ------
>  mm/huge_memory.c           |   3 +-
>  mm/list_lru.c             | 114 +++++++++++++++++++++----------------
>  mm/memcontrol.c            |  45 +++------------
>  mm/zswap.c                 |   4 +-
>  5 files changed, 77 insertions(+), 105 deletions(-)
> 

