From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 25/51] writeback: attribute stats to the matching
 per-cgroup bdi_writeback
Date: Tue, 30 Jun 2015 16:17:42 +0200
Message-ID: <20150630141742.GK7252@quack.suse.cz>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-26-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432329245-5844-26-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org

On Fri 22-05-15 17:13:39, Tejun Heo wrote:
> Until now, all WB_* stats were accounted against the root wb
> (bdi_writeback), now that multiple wb (bdi_writeback) support is in
> place, let's attributes the stats to the respective per-cgroup wb's.
> 
> As no filesystem has FS_CGROUP_WRITEBACK yet, this doesn't lead to
> visible behavior differences.
> 
> v2: Updated for per-inode wb association.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

Looks good. You can add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza

> ---
>  mm/page-writeback.c | 24 +++++++++++++++---------
>  1 file changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 9b95cf8..4d0a9da 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2130,7 +2130,7 @@ void account_page_cleaned(struct page *page, struct address_space *mapping,
>  	if (mapping_cap_account_dirty(mapping)) {
>  		mem_cgroup_dec_page_stat(memcg, MEM_CGROUP_STAT_DIRTY);
>  		dec_zone_page_state(page, NR_FILE_DIRTY);
> -		dec_wb_stat(&inode_to_bdi(mapping->host)->wb, WB_RECLAIMABLE);
> +		dec_wb_stat(inode_to_wb(mapping->host), WB_RECLAIMABLE);
>  		task_io_account_cancelled_write(PAGE_CACHE_SIZE);
>  	}
>  }
> @@ -2191,10 +2191,13 @@ EXPORT_SYMBOL(__set_page_dirty_nobuffers);
>  void account_page_redirty(struct page *page)
>  {
>  	struct address_space *mapping = page->mapping;
> +
>  	if (mapping && mapping_cap_account_dirty(mapping)) {
> +		struct bdi_writeback *wb = inode_to_wb(mapping->host);
> +
>  		current->nr_dirtied--;
>  		dec_zone_page_state(page, NR_DIRTIED);
> -		dec_wb_stat(&inode_to_bdi(mapping->host)->wb, WB_DIRTIED);
> +		dec_wb_stat(wb, WB_DIRTIED);
>  	}
>  }
>  EXPORT_SYMBOL(account_page_redirty);
> @@ -2373,8 +2376,7 @@ int clear_page_dirty_for_io(struct page *page)
>  		if (TestClearPageDirty(page)) {
>  			mem_cgroup_dec_page_stat(memcg, MEM_CGROUP_STAT_DIRTY);
>  			dec_zone_page_state(page, NR_FILE_DIRTY);
> -			dec_wb_stat(&inode_to_bdi(mapping->host)->wb,
> -				    WB_RECLAIMABLE);
> +			dec_wb_stat(inode_to_wb(mapping->host), WB_RECLAIMABLE);
>  			ret = 1;
>  		}
>  		mem_cgroup_end_page_stat(memcg);
> @@ -2392,7 +2394,8 @@ int test_clear_page_writeback(struct page *page)
>  
>  	memcg = mem_cgroup_begin_page_stat(page);
>  	if (mapping) {
> -		struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
> +		struct inode *inode = mapping->host;
> +		struct backing_dev_info *bdi = inode_to_bdi(inode);
>  		unsigned long flags;
>  
>  		spin_lock_irqsave(&mapping->tree_lock, flags);
> @@ -2402,8 +2405,10 @@ int test_clear_page_writeback(struct page *page)
>  						page_index(page),
>  						PAGECACHE_TAG_WRITEBACK);
>  			if (bdi_cap_account_writeback(bdi)) {
> -				__dec_wb_stat(&bdi->wb, WB_WRITEBACK);
> -				__wb_writeout_inc(&bdi->wb);
> +				struct bdi_writeback *wb = inode_to_wb(inode);
> +
> +				__dec_wb_stat(wb, WB_WRITEBACK);
> +				__wb_writeout_inc(wb);
>  			}
>  		}
>  		spin_unlock_irqrestore(&mapping->tree_lock, flags);
> @@ -2427,7 +2432,8 @@ int __test_set_page_writeback(struct page *page, bool keep_write)
>  
>  	memcg = mem_cgroup_begin_page_stat(page);
>  	if (mapping) {
> -		struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
> +		struct inode *inode = mapping->host;
> +		struct backing_dev_info *bdi = inode_to_bdi(inode);
>  		unsigned long flags;
>  
>  		spin_lock_irqsave(&mapping->tree_lock, flags);
> @@ -2437,7 +2443,7 @@ int __test_set_page_writeback(struct page *page, bool keep_write)
>  						page_index(page),
>  						PAGECACHE_TAG_WRITEBACK);
>  			if (bdi_cap_account_writeback(bdi))
> -				__inc_wb_stat(&bdi->wb, WB_WRITEBACK);
> +				__inc_wb_stat(inode_to_wb(inode), WB_WRITEBACK);
>  		}
>  		if (!PageDirty(page))
>  			radix_tree_tag_clear(&mapping->page_tree,
> -- 
> 2.4.0
> 
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
