From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch 13/13] mm: memcontrol: rewrite uncharge API
Date: Fri, 25 Jul 2014 13:34:06 -0400
Message-ID: <20140725173406.GL1725@cmpxchg.org>
References: <20140722150825.GA4517@dhcp22.suse.cz>
 <CAJfpegscT-ptQzq__uUV2TOn7Uvs6x4FdWGTQb9Fe9MEJr2KjA@mail.gmail.com>
 <20140723143847.GB16721@dhcp22.suse.cz>
 <20140723150608.GF1725@cmpxchg.org>
 <CAJfpegs-k5QC+42SzLKUSaHrdPxWBaT_dF+SOPqoDvg8h5p_Tw@mail.gmail.com>
 <20140723210241.GH1725@cmpxchg.org>
 <20140724084644.GA14578@dhcp22.suse.cz>
 <20140724090257.GB14578@dhcp22.suse.cz>
 <20140725152654.GK1725@cmpxchg.org>
 <20140725154320.GB18303@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=qgh/PxOP+ChkCia7R2nJg+LiBf2Pb92kBzB+L82dl9A=;
	b=pgWQK4zbJi6Yrnw12xdsOV6750YjVmoRwDl3HGsIukmBQXSOj6DdvjB5WIEfHgp68/tHup24w3ukp7p3p9B1kcmUtPoEuftBKDvN/kLzsr/1pfnFLGSWZKourUVwPdri5Li89Fkb32TQdYUB6Yvwxqh9wgfbGLTTCtZgG9xTW5w=;
Content-Disposition: inline
In-Reply-To: <20140725154320.GB18303@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, Kernel Mailing List <linux-kernel@vger.kernel.org>

On Fri, Jul 25, 2014 at 05:43:20PM +0200, Michal Hocko wrote:
> On Fri 25-07-14 11:26:54, Johannes Weiner wrote:
> > On Thu, Jul 24, 2014 at 11:02:57AM +0200, Michal Hocko wrote:
> > > On Thu 24-07-14 10:46:44, Michal Hocko wrote:
> > > > On Wed 23-07-14 17:02:41, Johannes Weiner wrote:
> > > [...]
> > > > We can reduce the lookup only to lruvec==true case, no?
> > > 
> > > Dohh
> > > s@can@should@
> > > 
> > > newpage shouldn't charged in all other cases and it would be bug.
> > > Or am I missing something?
> > 
> > Yeah, but I'd hate to put that assumption onto the @lrucare parameter,
> > it just coincides.
> 
> Yes, you are right. Maybe replace_page_cache_page should have it's own
> memcg variant which does all the trickery and then call
> mem_cgroup_migrate when necessary...

The code flow doesn't really lend itself to nesting.  It's basically
three steps: validate input, clear the old page, commit the new page.

void mem_cgroup_migrate(struct page *oldpage, struct page *newpage)
{
	VM_BUG_ON_PAGE(!PageLocked(oldpage), oldpage);
	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
	VM_BUG_ON_PAGE(PageLRU(oldpage), oldpage);
	VM_BUG_ON_PAGE(PageLRU(newpage), newpage);
	VM_BUG_ON_PAGE(PageAnon(oldpage) != PageAnon(newpage), newpage);
	VM_BUG_ON_PAGE(PageTransHuge(oldpage) != PageTransHuge(newpage),
		       newpage);

	if (mem_cgroup_disabled())
		return;

	/* Re-entrant migration: old page already uncharged? */
	pc = lookup_page_cgroup(oldpage);
	if (!PageCgroupUsed(pc))
		return;

	VM_BUG_ON_PAGE(!(pc->flags & PCG_MEM), oldpage);
	VM_BUG_ON_PAGE(do_swap_account && !(pc->flags & PCG_MEMSW), oldpage);

	pc->flags = 0;
	commit_charge(newpage, pc->mem_cgroup, false);
}

void mem_cgroup_replace_page_cache(struct page *oldpage, struct page *newpage)
{
	struct page_cgroup *pc;
	int isolated;

	VM_BUG_ON_PAGE(!PageLocked(oldpage), oldpage);
	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);

	if (mem_cgroup_disabled())
		return;

	/* New page already charged? */
	pc = lookup_page_cgroup(newpage);
	if (PageCgroupUsed(pc))
		return;

	pc = lookup_page_cgroup(oldpage);

	VM_BUG_ON_PAGE(!(pc->flags & PCG_MEM), oldpage);
	VM_BUG_ON_PAGE(do_swap_account && !(pc->flags & PCG_MEMSW), oldpage);

	lock_page_lru(oldpage, &isolated);
	pc->flags = 0;
	unlock_page_lru(oldpage, isolated);

	commit_charge(newpage, pc->mem_cgroup, true);
}

Only the call to commit_charge() is the same and there is a little bit
of overlap in the VM_BUG_ON_PAGEs...  I'd rather have a single migrate
function, because it's so small that the code is simpler than nesting
and/or duplicating multiple functions.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
