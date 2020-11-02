From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v20 08/20] mm: page_idle_get_page() does not need lru_lock
Date: Mon, 2 Nov 2020 09:41:10 -0500
Message-ID: <20201102144110.GB724984@cmpxchg.org>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
 <1603968305-8026-9-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EFQY01EyQEOZuxyO/m/7TxD1TS0aUUa0gmanbTdmHu4=;
        b=Wz2IE1DQU+bCAzYFTSbwl/3Wdg8BO9G9iu5/96MzFSytj8SJW4UwXqN4SfmYHKcLOx
         nM7CFATxwP5AzIsJgj8OQjBdfw/OxeCZVvGXUBn1yyZyqAOxxH09/1QHD6qIvv1JBVSH
         D/PW0demiOmu01+v6nS60rKe2GrY9KDnsNqmI0kFgatG6ap1JznKEEFmPL8oNHaRXyoX
         DKdhKpLRg/vG8Q+wr1G6mF+IWnI4SbUsqpGlOwvoZZwWAJa5An0gnBPWj80C0qSGVQNn
         uHTTWyqvbSO6YmINQgzFwu9Xs09qPxjAJ4JEzdHCyrZlfA8vOM+NtagPK1hXbqgk9+fR
         TO1g==
Content-Disposition: inline
In-Reply-To: <1603968305-8026-9-git-send-email-alex.shi@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com, Vlastimil Babka <vbabka@suse.cz>, Minchan Kim <minchan@kernel.org>

On Thu, Oct 29, 2020 at 06:44:53PM +0800, Alex Shi wrote:
> From: Hugh Dickins <hughd@google.com>
> 
> It is necessary for page_idle_get_page() to recheck PageLRU() after
> get_page_unless_zero(), but holding lru_lock around that serves no
> useful purpose, and adds to lru_lock contention: delete it.
> 
> See https://lore.kernel.org/lkml/20150504031722.GA2768@blaptop for the
> discussion that led to lru_lock there; but __page_set_anon_rmap() now
> uses WRITE_ONCE(),

That doesn't seem to be the case in Linus's or Andrew's tree. Am I
missing a dependent patch series?

> and I see no other risk in page_idle_clear_pte_refs() using
> rmap_walk() (beyond the risk of racing PageAnon->PageKsm, mostly but
> not entirely prevented by page_count() check in ksm.c's
> write_protect_page(): that risk being shared with page_referenced()
> and not helped by lru_lock).

Isn't it possible, as per Minchan's description, for page->mapping to
point to a struct anon_vma without PAGE_MAPPING_ANON set, and rmap
thinking it's looking at a struct address_space?
