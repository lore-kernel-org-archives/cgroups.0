From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v21 07/19] mm: page_idle_get_page() does not need lru_lock
Date: Tue, 10 Nov 2020 14:01:36 -0500
Message-ID: <20201110190136.GD850433@cmpxchg.org>
References: <1604566549-62481-1-git-send-email-alex.shi@linux.alibaba.com>
 <1604566549-62481-8-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IPj1mYmXqOWOz3TEiog9Zh5vT3acF5XixS22iuZzAIA=;
        b=oSzlQ+aZKJ+JtX7hBOzJ6QuxNdqcLauhjHFsVIve5PuHfOiAhBQP7vT28Pm0UhsV1F
         niWeWfpQFlQfk/RbeF3CC/XDpLPH8x2OpyaosMNkEKmofRAP2RLPWK0CISlT7mz8+k6L
         Ogvl1E8vhzyA4EBAyDF5hZ87LvKJk1nPjzHtRvVxPcpYstS8Y6gbvBorj4CWcBizdaci
         sXILka5r/IVEdHN6qNh+d4lj/vl6K02b9mjiEJEunCrInhniMjic3dfF9flk981t6QnU
         L47YPELx/y+49FzFNqmf4vmsapRk4D9hpHq2HOCrTOOAfkdrWtK6Z1iVx4ZUH2br1ppd
         lENw==
Content-Disposition: inline
In-Reply-To: <1604566549-62481-8-git-send-email-alex.shi@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com, Vlastimil Babka <vbabka@suse.cz>, Minchan Kim <minchan@kernel.org>

On Thu, Nov 05, 2020 at 04:55:37PM +0800, Alex Shi wrote:
> From: Hugh Dickins <hughd@google.com>
> 
> It is necessary for page_idle_get_page() to recheck PageLRU() after
> get_page_unless_zero(), but holding lru_lock around that serves no
> useful purpose, and adds to lru_lock contention: delete it.
> 
> See https://lore.kernel.org/lkml/20150504031722.GA2768@blaptop for the
> discussion that led to lru_lock there; but __page_set_anon_rmap() now
> uses WRITE_ONCE(), and I see no other risk in page_idle_clear_pte_refs()
> using rmap_walk() (beyond the risk of racing PageAnon->PageKsm, mostly
> but not entirely prevented by page_count() check in ksm.c's
> write_protect_page(): that risk being shared with page_referenced() and
> not helped by lru_lock).
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
