From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/3] mm: migrate: do not touch page->mem_cgroup of live
 pages
Date: Thu, 4 Feb 2016 14:53:24 -0500
Message-ID: <20160204195324.GA8208@cmpxchg.org>
References: <1454109573-29235-1-git-send-email-hannes@cmpxchg.org>
 <1454109573-29235-2-git-send-email-hannes@cmpxchg.org>
 <20160203131748.GB15520@mguzik>
 <20160203140824.GJ21016@esperanza>
 <20160203183547.GA4007@cmpxchg.org>
 <alpine.LSU.2.11.1602031648050.1497@eggly.anvils>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1602031648050.1497@eggly.anvils>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd@google.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>, Mateusz Guzik <mguzik@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Greg Thelen <gthelen@google.com>

On Wed, Feb 03, 2016 at 05:39:08PM -0800, Hugh Dickins wrote:
> On Wed, 3 Feb 2016, Johannes Weiner wrote:
> 
> > CCing Hugh and Greg, they have worked on the memcg migration code most
> > recently. AFAIK the only reason newpage->mem_cgroup had to be set up
> > that early in migration was because of the way dirty accounting used
> > to work. But Hugh took memcg out of the equation there, so moving
> > mem_cgroup_migrate() to the end should be safe, as long as the pages
> > are still locked and off the LRU.
> 
> Yes, that should be safe now: Vladimir's patch looks okay to me,
> fixing the immediate irq issue.

Okay, thanks for checking.

> But it would be nicer, if mem_cgroup_migrate() were called solely
> from migrate_page_copy() - deleting the other calls in mm/migrate.c,
> including that from migrate_misplaced_transhuge_page() (which does
> some rewinding on error after its migrate_page_copy(): but just as
> you now let a successfully migrated old page be uncharged when it's
> freed, so you can leave a failed new_page to be uncharged when it's
> freed, no extra code needed).

That should work and it's indeed a lot nicer.

> And (even more off-topic), I'm slightly sad to see that the lrucare
> arg which mem_cgroup_migrate() used to have (before I renamed it and
> you renamed it back!) has gone, so mem_cgroup_migrate() now always
> demands lrucare of commit_charge().  I'd hoped that with your
> separation of new from old charge, mem_cgroup_migrate() would never
> need lrucare; but that's not true for the fuse case, though true
> for everyone else.  Maybe just not worth bothering about?  Or the
> reintroduction of some unnecessary zone->lru_lock-ing in page
> migration, which we ought to try to avoid?
> 
> Or am I wrong, and even fuse doesn't need it?  That early return
> "if (newpage->mem_cgroup)": isn't mem_cgroup_migrate() a no-op for
> fuse, or is there some corner case by which newpage can be on LRU
> but its mem_cgroup unset?

That should be impossible nowadays.

I went through the git log to find out why we used to do the LRU
handling for newpage, and the clue is in this patch and the way
charging used to work at that time:

commit 5a6475a4e162200f43855e2d42bbf55bcca1a9f2
Author: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date:   Wed Mar 23 16:42:42 2011 -0700

    memcg: fix leak on wrong LRU with FUSE
    
    fs/fuse/dev.c::fuse_try_move_page() does
    
       (1) remove a page by ->steal()
       (2) re-add the page to page cache
       (3) link the page to LRU if it was not on LRU at (1)
    
    This implies the page is _on_ LRU when it's added to radix-tree.  So, the
    page is added to memory cgroup while it's on LRU.  because LRU is lazy and
    no one flushs it.

We used to uncharge the page when deleting it from the page cache, not
on the final put. So when fuse replaced a page in cache, it would
uncharge the stolen page while it was on the LRU and then re-charge.

Nowadays this doesn't happen, and if newpage is a stolen page cache
page it just remains charged and we bail out of the transfer.

I don't see a sceniaro where newpage would be uncharged yet on LRU.

Thanks for your insights, Hugh. I'll send patches to clean this up.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
