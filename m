From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 05/18] mm: memcontrol: convert page cache to a new
 mem_cgroup_charge() API
Date: Fri, 8 May 2020 12:01:22 -0400
Message-ID: <20200508160122.GB181181@cmpxchg.org>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200420221126.341272-6-hannes@cmpxchg.org>
 <20200422064041.GE6780@js1304-desktop>
 <20200422120946.GA358439@cmpxchg.org>
 <20200423052450.GA12538@js1304-desktop>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=adGLp+IkZj0kV6al1ow9OZ12NwQUohKl91WoYoRS5mM=;
        b=AD8oPcvgFYrmzgjNeM2wsXcLVPN0AkMug1eHqMYDzwg9wcsDaWQTI7MZjNtQ0vQAET
         yjL+hZDuCAvyKfp1PAsutuQ+N00mzu4qMxKWgb9VeK6dAvKs9kww1sjHvozmAkK8kFDA
         oDMF8oRZcnxLhj2ISmjVIgU9BG1rTrwAy0jCeX9Q0c5zO+fVaoM0zXlzDWk+MiiWNOOO
         pykUZcukMrXvpICiZxRTi3xw16nQWAydQVSnECMCflP6yv1wfyZ4+zxFig/sjw9aiIWy
         PNbXG+cvkMUYIgk3bp26wMSolRmwGl3CsiwjLpHrocKvX0WbYR8xIC1meL1duhenHdeK
         7AbA==
Content-Disposition: inline
In-Reply-To: <20200423052450.GA12538@js1304-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joonsoo Kim <js1304@gmail.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>, Shakeel Butt <shakeelb@google.com>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, Apr 23, 2020 at 02:25:06PM +0900, Joonsoo Kim wrote:
> On Wed, Apr 22, 2020 at 08:09:46AM -0400, Johannes Weiner wrote:
> > On Wed, Apr 22, 2020 at 03:40:41PM +0900, Joonsoo Kim wrote:
> > > On Mon, Apr 20, 2020 at 06:11:13PM -0400, Johannes Weiner wrote:
> > > > @@ -1664,29 +1678,22 @@ static int shmem_swapin_page(struct inode *inode, pgoff_t index,
> > > >  			goto failed;
> > > >  	}
> > > >  
> > > > -	error = mem_cgroup_try_charge_delay(page, charge_mm, gfp, &memcg);
> > > > -	if (!error) {
> > > > -		error = shmem_add_to_page_cache(page, mapping, index,
> > > > -						swp_to_radix_entry(swap), gfp);
> > > > -		/*
> > > > -		 * We already confirmed swap under page lock, and make
> > > > -		 * no memory allocation here, so usually no possibility
> > > > -		 * of error; but free_swap_and_cache() only trylocks a
> > > > -		 * page, so it is just possible that the entry has been
> > > > -		 * truncated or holepunched since swap was confirmed.
> > > > -		 * shmem_undo_range() will have done some of the
> > > > -		 * unaccounting, now delete_from_swap_cache() will do
> > > > -		 * the rest.
> > > > -		 */
> > > > -		if (error) {
> > > > -			mem_cgroup_cancel_charge(page, memcg);
> > > > -			delete_from_swap_cache(page);
> > > > -		}
> > > > -	}
> > > > -	if (error)
> > > > +	error = shmem_add_to_page_cache(page, mapping, index,
> > > > +					swp_to_radix_entry(swap), gfp,
> > > > +					charge_mm);
> > > > +	/*
> > > > +	 * We already confirmed swap under page lock, and make no
> > > > +	 * memory allocation here, so usually no possibility of error;
> > > > +	 * but free_swap_and_cache() only trylocks a page, so it is
> > > > +	 * just possible that the entry has been truncated or
> > > > +	 * holepunched since swap was confirmed.  shmem_undo_range()
> > > > +	 * will have done some of the unaccounting, now
> > > > +	 * delete_from_swap_cache() will do the rest.
> > > > +	 */
> > > > +	if (error) {
> > > > +		delete_from_swap_cache(page);
> > > >  		goto failed;
> > > 
> > > -EEXIST (from swap cache) and -ENOMEM (from memcg) should be handled
> > > differently. delete_from_swap_cache() is for -EEXIST case.
> > 
> > Good catch, I accidentally changed things here.
> > 
> > I was just going to change it back, but now I'm trying to understand
> > how it actually works.
> > 
> > Who is removing the page from swap cache if shmem_undo_range() races
> > but we fail to charge the page?
> > 
> > Here is how this race is supposed to be handled: The page is in the
> > swapcache, we have it locked and confirmed that the entry in i_pages
> > is indeed a swap entry. We charge the page, then we try to replace the
> > swap entry in i_pages with the actual page. If we determine, under
> > tree lock now, that shmem_undo_range has raced with us, unaccounted
> > the swap space, but must have failed to get the page lock, we remove
> > the page from swap cache on our side, to free up swap slot and page.
> > 
> > But what if shmem_undo_range() raced with us, deleted the swap entry
> > from i_pages while we had the page locked, but then we simply failed
> > to charge? We unlock the page and return -EEXIST (shmem_confirm_swap
> > at the exit). The page with its userdata is now in swapcache, but no
> > corresponding swap entry in i_pages. shmem_getpage_gfp() sees the
> > -EEXIST, retries, finds nothing in i_pages and allocates a new, empty
> > page.
> > 
> > Aren't we leaking the swap slot and the page?
> 
> Yes, you're right! It seems that it's possible to leak the swap slot
> and the page. Race could happen for all the places after lock_page()
> and shmem_confirm_swap() are done. And, I think that it's not possible
> to fix the problem in shmem_swapin_page() side since we can't know the
> timing that trylock_page() is called. Maybe, solution would be,
> instead of using free_swap_and_cache() in shmem_undo_range() that
> calls trylock_page(), to use another function that calls lock_page().

I looked at this some more, as well as compared it to non-shmem
swapping. My conclusion is - and Hugh may correct me on this - that
the deletion looks mandatory but is actually an optimization. Page
reclaim will ultimately pick these pages up.

When non-shmem pages are swapped in by readahead (locked until IO
completes) and their page tables are simultaneously unmapped, the
zap_pte_range() code calls free_swap_and_cache() and the locked pages
are stranded in the swap cache with no page table references. We rely
on page reclaim to pick them up later on.

The same appears to be true for shmem. If the references to the swap
page are zapped while we're trying to swap in, we can strand the page
in the swap cache. But it's not up to swapin to detect this reliably,
it just frees the page more quickly than having to wait for reclaim.

That being said, my patch introduces potentially undesirable behavior
(although AFAICS no correctness problem): We should only delete the
page from swapcache when we actually raced with undo_range - which we
see from the swap entry having been purged from the page cache
tree. If we delete the page from swapcache just because we failed to
charge it, the next fault has to read the still-valid page again from
the swap device.

I'm going to include this:

diff --git a/mm/shmem.c b/mm/shmem.c
index e80167927dce..236642775f89 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -640,7 +640,7 @@ static int shmem_add_to_page_cache(struct page *page,
 		xas_lock_irq(&xas);
 		entry = xas_find_conflict(&xas);
 		if (entry != expected)
-			xas_set_err(&xas, -EEXIST);
+			xas_set_err(&xas, expected ? -ENOENT : -EEXIST);
 		xas_create_range(&xas);
 		if (xas_error(&xas))
 			goto unlock;
@@ -1683,17 +1683,18 @@ static int shmem_swapin_page(struct inode *inode, pgoff_t index,
 	error = shmem_add_to_page_cache(page, mapping, index,
 					swp_to_radix_entry(swap), gfp,
 					charge_mm);
-	/*
-	 * We already confirmed swap under page lock, and make no
-	 * memory allocation here, so usually no possibility of error;
-	 * but free_swap_and_cache() only trylocks a page, so it is
-	 * just possible that the entry has been truncated or
-	 * holepunched since swap was confirmed.  shmem_undo_range()
-	 * will have done some of the unaccounting, now
-	 * delete_from_swap_cache() will do the rest.
-	 */
 	if (error) {
-		delete_from_swap_cache(page);
+		/*
+		 * We already confirmed swap under page lock, but
+		 * free_swap_and_cache() only trylocks a page, so it
+		 * is just possible that the entry has been truncated
+		 * or holepunched since swap was confirmed.
+		 * shmem_undo_range() will have done some of the
+		 * unaccounting, now delete_from_swap_cache() will do
+		 * the rest.
+		 */
+		if (error == -ENOENT)
+			delete_from_swap_cache(page);
 		goto failed;
 	}
 
