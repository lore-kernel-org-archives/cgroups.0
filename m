From: Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH 00/19 V2] mm: memcontrol: charge swapin pages on
 instantiation
Date: Wed, 13 May 2020 11:30:32 +0000
Message-ID: <20200513113032.GA93568@dev-dsk-sblbir-1c-a524888b.ap-northeast-1.amazon.com>
References: <20200508183105.225460-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2Ktd5bounBb85k+GhDJYQBKwGNjtE8xOQJSWOO0qVps=;
        b=hfgNGCstCMJHb8IVTFUEeL+3JGilD81+7rwOcqzOpwjQoMrYv2Z5LeMUCzJ8pzCf9p
         8oqSZVzVevLUBq3aqDYXpA5ZPorxTlk4GyVcCXcXtDCgg7rf32OqplGewGX/Tq71KaH0
         6x4rjEaB8R/x8vYndWFQEzIeiZi6qCG+t/GUzp8QQzYxcta8Da+BQ1XqadEpTVA62rkk
         zElKLJwK03h9CYhA0lS21Apb7+3W2n0SDgmVpoyRqDKhiNiSbPAdNABETh7/377aNjfT
         BOlkWnf4jhBvUOSUv52te1U6tfHKfFNhSm+45+yDmrE3aEbTj6mQI4lzTBQIqGH/hj/R
         mnSw==
Content-Disposition: inline
In-Reply-To: <20200508183105.225460-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Shi <alex.shi@linux.alibaba.com>, Joonsoo Kim <js1304@gmail.com>, Shakeel Butt <shakeelb@google.com>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Fri, May 08, 2020 at 02:30:47PM -0400, Johannes Weiner wrote:
> This patch series reworks memcg to charge swapin pages directly at
> swapin time, rather than at fault time, which may be much later, or
> not happen at all.
> 
> Changes in version 2:
> - prevent double charges on pre-allocated hugepages in khugepaged
> - leave shmem swapcache when charging fails to avoid double IO (Joonsoo)
> - fix temporary accounting bug by switching rmap<->commit (Joonsoo)
> - fix double swap charge bug in cgroup1/cgroup2 code gating
> - simplify swapin error checking (Joonsoo)
> - mm: memcontrol: document the new swap control behavior (Alex)
> - review tags
> 
> The delayed swapin charging scheme we have right now causes problems:
> 
> - Alex's per-cgroup lru_lock patches rely on pages that have been
>   isolated from the LRU to have a stable page->mem_cgroup; otherwise
>   the lock may change underneath him. Swapcache pages are charged only
>   after they are added to the LRU, and charging doesn't follow the LRU
>   isolation protocol.
> 
> - Joonsoo's anon workingset patches need a suitable LRU at the time
>   the page enters the swap cache and displaces the non-resident
>   info. But the correct LRU is only available after charging.
> 
> - It's a containment hole / DoS vector. Users can trigger arbitrarily
>   large swap readahead using MADV_WILLNEED. The memory is never
>   charged unless somebody actually touches it.
> 
> - It complicates the page->mem_cgroup stabilization rules
> 
> In order to charge pages directly at swapin time, the memcg code base
> needs to be prepared, and several overdue cleanups become a necessity:
> 
> To charge pages at swapin time, we need to always have cgroup
> ownership tracking of swap records. We also cannot rely on
> page->mapping to tell apart page types at charge time, because that's
> only set up during a page fault.
> 
> To eliminate the page->mapping dependency, memcg needs to ditch its
> private page type counters (MEMCG_CACHE, MEMCG_RSS, NR_SHMEM) in favor
> of the generic vmstat counters and accounting sites, such as
> NR_FILE_PAGES, NR_ANON_MAPPED etc.

Could you elaborate on what this means and the implications of this on
user space programs?

> 
> To switch to generic vmstat counters, the charge sequence must be
> adjusted such that page->mem_cgroup is set up by the time these
> counters are modified.
> 
> The series is structured as follows:
> 
> 1. Bug fixes
> 2. Decoupling charging from rmap
> 3. Swap controller integration into memcg
> 4. Direct swapin charging
>

Thanks,
Balbir Singh. 
