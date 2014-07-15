From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 13/13] mm: memcontrol: rewrite uncharge API
Date: Tue, 15 Jul 2014 15:04:54 -0400
Message-ID: <20140715190454.GW29639@cmpxchg.org>
References: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>
 <1403124045-24361-14-git-send-email-hannes@cmpxchg.org>
 <20140715155537.GA19454@nhori.bos.redhat.com>
 <20140715160735.GB29269@dhcp22.suse.cz>
 <20140715173439.GU29639@cmpxchg.org>
 <20140715184358.GA31550@nhori.bos.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=XZoaXyE4nl4xzehN+g368c03RpnzcnFNqQJI/rCIBwM=;
	b=Xvw1CrTK6St4VKGNyvcVUQRbtKLF3GwueSo6eD0NlguDGx7CRlItpO5JQMe2abIlqH7L8thqJhz3nwdQRzSNqrUEpoAVsRjQh1fWuIklacy35cvZ5yytJz9D1yVtzImaA3RAv/EcIR97PdEQNMy0QkfL39jiUE6h2Cw0gkBBgUE=;
Content-Disposition: inline
In-Reply-To: <20140715184358.GA31550-2Pg9w/axmyVjbeVWsgQ2eFaTQe2KTcn/@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jul 15, 2014 at 02:43:58PM -0400, Naoya Horiguchi wrote:
> On Tue, Jul 15, 2014 at 01:34:39PM -0400, Johannes Weiner wrote:
> > On Tue, Jul 15, 2014 at 06:07:35PM +0200, Michal Hocko wrote:
> > > On Tue 15-07-14 11:55:37, Naoya Horiguchi wrote:
> > > > On Wed, Jun 18, 2014 at 04:40:45PM -0400, Johannes Weiner wrote:
> > > > ...
> > > > > diff --git a/mm/swap.c b/mm/swap.c
> > > > > index a98f48626359..3074210f245d 100644
> > > > > --- a/mm/swap.c
> > > > > +++ b/mm/swap.c
> > > > > @@ -62,6 +62,7 @@ static void __page_cache_release(struct page *page)
> > > > >  		del_page_from_lru_list(page, lruvec, page_off_lru(page));
> > > > >  		spin_unlock_irqrestore(&zone->lru_lock, flags);
> > > > >  	}
> > > > > +	mem_cgroup_uncharge(page);
> > > > >  }
> > > > >  
> > > > >  static void __put_single_page(struct page *page)
> > > > 
> > > > This seems to cause a list breakage in hstate->hugepage_activelist
> > > > when freeing a hugetlbfs page.
> > > 
> > > This looks like a fall out from
> > > http://marc.info/?l=linux-mm&m=140475936311294&w=2
> > > 
> > > I didn't get to review this one but the easiest fix seems to be check
> > > HugePage and do not call uncharge.
> > 
> > Yes, that makes sense.  I'm also moving the uncharge call into
> > __put_single_page() and __put_compound_page() so that PageHuge(), a
> > function call, only needs to be checked for compound pages.
> > 
> > > > For hugetlbfs, we uncharge in free_huge_page() which is called after
> > > > __page_cache_release(), so I think that we don't have to uncharge here.
> > > > 
> > > > In my testing, moving mem_cgroup_uncharge() inside if (PageLRU) block
> > > > fixed the problem, so if that works for you, could you fold the change
> > > > into your patch?
> > 
> > Memcg pages that *do* need uncharging might not necessarily be on the
> > LRU list.
> 
> OK.
> 
> > Does the following work for you?
> 
> Unfortunately, with this change I saw the following bug message when
> stressing with hugepage migration.
> move_to_new_page() is called by unmap_and_move_huge_page() too, so
> we need some hugetlb related code around mem_cgroup_migrate().

Can we just move hugetlb_cgroup_migrate() into move_to_new_page()?  It
doesn't seem to be dependent of any page-specific state.

diff --git a/mm/migrate.c b/mm/migrate.c
index 7f5a42403fae..219da52d2f43 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -781,7 +781,10 @@ static int move_to_new_page(struct page *newpage, struct page *page,
 		if (!PageAnon(newpage))
 			newpage->mapping = NULL;
 	} else {
-		mem_cgroup_migrate(page, newpage, false);
+		if (PageHuge(page))
+			hugetlb_cgroup_migrate(hpage, new_hpage);
+		else
+			mem_cgroup_migrate(page, newpage, false);
 		if (remap_swapcache)
 			remove_migration_ptes(page, newpage);
 		if (!PageAnon(page))
@@ -1064,9 +1067,6 @@ static int unmap_and_move_huge_page(new_page_t get_new_page,
 	if (anon_vma)
 		put_anon_vma(anon_vma);
 
-	if (rc == MIGRATEPAGE_SUCCESS)
-		hugetlb_cgroup_migrate(hpage, new_hpage);
-
 	unlock_page(hpage);
 out:
 	if (rc != -EAGAIN)
