From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v20 08/20] mm: page_idle_get_page() does not need lru_lock
Date: Mon, 2 Nov 2020 15:20:03 -0500
Message-ID: <20201102202003.GA740958@cmpxchg.org>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
 <1603968305-8026-9-git-send-email-alex.shi@linux.alibaba.com>
 <20201102144110.GB724984@cmpxchg.org>
 <20201102144927.GN27442@casper.infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KGaTJmrQfb84Zu/sOJ7IzGE95V5QBTb6nK7txU9KSJQ=;
        b=bBEKVnMgjoWujuv68Y0rl6eDm5sl+RLsRxWldpJosx8V8ORC5f5WNURvzRPF1NBv6v
         Hw8SkPEFiVazRpc8HtbAFv6rySvi+dOgYcijpf6DGivgxo6rHAxTkqYtg7KMW/nWj0FK
         jNVL3+jbG7w71qugmLw3Xz4ncKPZ2iWxLBTPPCt8BD1uQREeERQz3EX3KuToBY6VIz+L
         zWgI8CrMO0KLAeTkRYk8aUfxLK5LxOxKT8l/+pOHEe6cjDYpW8aCCLwlS41l8QROI6B/
         mwQYZlJ8/jHFIKB9IuKFrZteCWMQ5raxOMQKUfKXvcqF/2zfCoNEJ2DCqrzBN7oVKQ3f
         3fMQ==
Content-Disposition: inline
In-Reply-To: <20201102144927.GN27442@casper.infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com, Vlastimil Babka <vbabka@suse.cz>, Minchan Kim <minchan@kernel.org>

On Mon, Nov 02, 2020 at 02:49:27PM +0000, Matthew Wilcox wrote:
> On Mon, Nov 02, 2020 at 09:41:10AM -0500, Johannes Weiner wrote:
> > On Thu, Oct 29, 2020 at 06:44:53PM +0800, Alex Shi wrote:
> > > From: Hugh Dickins <hughd@google.com>
> > > 
> > > It is necessary for page_idle_get_page() to recheck PageLRU() after
> > > get_page_unless_zero(), but holding lru_lock around that serves no
> > > useful purpose, and adds to lru_lock contention: delete it.
> > > 
> > > See https://lore.kernel.org/lkml/20150504031722.GA2768@blaptop for the
> > > discussion that led to lru_lock there; but __page_set_anon_rmap() now
> > > uses WRITE_ONCE(),
> > 
> > That doesn't seem to be the case in Linus's or Andrew's tree. Am I
> > missing a dependent patch series?
> > 
> > > and I see no other risk in page_idle_clear_pte_refs() using
> > > rmap_walk() (beyond the risk of racing PageAnon->PageKsm, mostly but
> > > not entirely prevented by page_count() check in ksm.c's
> > > write_protect_page(): that risk being shared with page_referenced()
> > > and not helped by lru_lock).
> > 
> > Isn't it possible, as per Minchan's description, for page->mapping to
> > point to a struct anon_vma without PAGE_MAPPING_ANON set, and rmap
> > thinking it's looking at a struct address_space?
> 
> I don't think it can point to an anon_vma without the ANON bit set.
> Minchan's concern in that email was that it might still be NULL.

Hm, no, the thread is a lengthy discussion about whether the store
could be split such that page->mapping is actually pointing to
something invalid (anon_vma without the PageAnon bit).

From his email:

        CPU 0                                                                           CPU 1

do_anonymous_page
  __page_set_anon_rmap
  /* out of order happened so SetPageLRU is done ahead */
  SetPageLRU(page)
  /* Compilr changed store operation like below */
  page->mapping = (struct address_space *) anon_vma;
  /* Big stall happens */
                                                                /* idletacking judged it as LRU page so pass the page
                                                                   in page_reference */
                                                                page_refernced
                                                                        page_rmapping return true because
                                                                        page->mapping has some vaule but not complete
                                                                        so it calls rmap_walk_file.
                                                                        it's okay to pass non-completed anon page in rmap_walk_file?
