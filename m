From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch] mm: memcontrol: update mem_cgroup_page_lruvec()
 documentation
Date: Mon, 20 Oct 2014 15:46:34 -0400
Message-ID: <20141020194634.GA12120@phnom.home.cmpxchg.org>
References: <1413732616-15962-1-git-send-email-hannes@cmpxchg.org>
 <20141020191256.GD505@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20141020191256.GD505@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 09:12:56PM +0200, Michal Hocko wrote:
> On Sun 19-10-14 11:30:16, Johannes Weiner wrote:
> > 7512102cf64d ("memcg: fix GPF when cgroup removal races with last
> > exit") added a pc->mem_cgroup reset into mem_cgroup_page_lruvec() to
> > prevent a crash where an anon page gets uncharged on unmap, the memcg
> > is released, and then the final LRU isolation on free dereferences the
> > stale pc->mem_cgroup pointer.
> > 
> > But since 0a31bc97c80c ("mm: memcontrol: rewrite uncharge API"), pages
> > are only uncharged AFTER that final LRU isolation, which guarantees
> > the memcg's lifetime until then.  pc->mem_cgroup now only needs to be
> > reset for swapcache readahead pages.
> 
> Do we want VM_BUG_ON_PAGE(!PageSwapCache, page) into the fixup path?

While that is what we expect as of right now, it's not really a
requirement for this function.  Should somebody later add other page
types they might trigger this assertion and scratch their head about
it and wonder if they're missing some non-obvious dependency.

> > Update the comment and callsite requirements accordingly.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
