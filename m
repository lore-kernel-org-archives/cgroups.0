From: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 1/3] mm: migrate: do not touch page->mem_cgroup of live
 pages
Date: Wed, 3 Feb 2016 17:08:24 +0300
Message-ID: <20160203140824.GJ21016@esperanza>
References: <1454109573-29235-1-git-send-email-hannes@cmpxchg.org>
 <1454109573-29235-2-git-send-email-hannes@cmpxchg.org>
 <20160203131748.GB15520@mguzik>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160203131748.GB15520@mguzik>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Mateusz Guzik <mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, Feb 03, 2016 at 02:17:49PM +0100, Mateusz Guzik wrote:
> On Fri, Jan 29, 2016 at 06:19:31PM -0500, Johannes Weiner wrote:
> > Changing a page's memcg association complicates dealing with the page,
> > so we want to limit this as much as possible. Page migration e.g. does
> > not have to do that. Just like page cache replacement, it can forcibly
> > charge a replacement page, and then uncharge the old page when it gets
> > freed. Temporarily overcharging the cgroup by a single page is not an
> > issue in practice, and charging is so cheap nowadays that this is much
> > preferrable to the headache of messing with live pages.
> > 
> > The only place that still changes the page->mem_cgroup binding of live
> > pages is when pages move along with a task to another cgroup. But that
> > path isolates the page from the LRU, takes the page lock, and the move
> > lock (lock_page_memcg()). That means page->mem_cgroup is always stable
> > in callers that have the page isolated from the LRU or locked. Lighter
> > unlocked paths, like writeback accounting, can use lock_page_memcg().
> > 
> > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> [..]
> > @@ -372,12 +373,13 @@ int migrate_page_move_mapping(struct address_space *mapping,
> >  	 * Now we know that no one else is looking at the page:
> >  	 * no turning back from here.
> >  	 */
> > -	set_page_memcg(newpage, page_memcg(page));
> >  	newpage->index = page->index;
> >  	newpage->mapping = page->mapping;
> >  	if (PageSwapBacked(page))
> >  		SetPageSwapBacked(newpage);
> >  
> > +	mem_cgroup_migrate(page, newpage);
> > +
> >  	get_page(newpage);	/* add cache reference */
> >  	if (PageSwapCache(page)) {
> >  		SetPageSwapCache(newpage);
> > @@ -457,9 +459,11 @@ int migrate_huge_page_move_mapping(struct address_space *mapping,
> >  		return -EAGAIN;
> >  	}
> >  
> > -	set_page_memcg(newpage, page_memcg(page));
> >  	newpage->index = page->index;
> >  	newpage->mapping = page->mapping;
> > +
> > +	mem_cgroup_migrate(page, newpage);
> > +
> >  	get_page(newpage);
> >  
> >  	radix_tree_replace_slot(pslot, newpage);
> 
> I ran trinity on recent linux-next and got the lockdep splat below and if I
> read it right, this is the culprit.  In particular, mem_cgroup_migrate was put
> in an area covered by spin_lock_irq(&mapping->tree_lock), but stuff it calls
> enables and disables interrupts on its own.

It must be safe to move these calls outside tree_lock:

diff --git a/mm/migrate.c b/mm/migrate.c
index 307e95ece622..17db63b2dd36 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -379,8 +379,6 @@ int migrate_page_move_mapping(struct address_space *mapping,
 	if (PageSwapBacked(page))
 		SetPageSwapBacked(newpage);
 
-	mem_cgroup_migrate(page, newpage);
-
 	get_page(newpage);	/* add cache reference */
 	if (PageSwapCache(page)) {
 		SetPageSwapCache(newpage);
@@ -430,6 +428,8 @@ int migrate_page_move_mapping(struct address_space *mapping,
 	}
 	local_irq_enable();
 
+	mem_cgroup_migrate(page, newpage);
+
 	return MIGRATEPAGE_SUCCESS;
 }
 
@@ -463,8 +463,6 @@ int migrate_huge_page_move_mapping(struct address_space *mapping,
 	newpage->index = page->index;
 	newpage->mapping = page->mapping;
 
-	mem_cgroup_migrate(page, newpage);
-
 	get_page(newpage);
 
 	radix_tree_replace_slot(pslot, newpage);
@@ -472,6 +470,9 @@ int migrate_huge_page_move_mapping(struct address_space *mapping,
 	page_unfreeze_refs(page, expected_count - 1);
 
 	spin_unlock_irq(&mapping->tree_lock);
+
+	mem_cgroup_migrate(page, newpage);
+
 	return MIGRATEPAGE_SUCCESS;
 }
 
