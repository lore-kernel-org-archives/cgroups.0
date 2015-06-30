From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 26/51] writeback: let balance_dirty_pages() work on the
 matching cgroup bdi_writeback
Date: Tue, 30 Jun 2015 16:31:00 +0200
Message-ID: <20150630143100.GL7252@quack.suse.cz>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-27-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1432329245-5844-27-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru

On Fri 22-05-15 17:13:40, Tejun Heo wrote:
> Currently, balance_dirty_pages() always work on bdi->wb.  This patch
> updates it to work on the wb (bdi_writeback) matching memcg and blkcg
> of the current task as that's what the inode is being dirtied against.
> 
> balance_dirty_pages_ratelimited() now pins the current wb and passes
> it to balance_dirty_pages().
> 
> As no filesystem has FS_CGROUP_WRITEBACK yet, this doesn't lead to
> visible behavior differences.
...
>  void balance_dirty_pages_ratelimited(struct address_space *mapping)
>  {
> -	struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
> -	struct bdi_writeback *wb = &bdi->wb;
> +	struct inode *inode = mapping->host;
> +	struct backing_dev_info *bdi = inode_to_bdi(inode);
> +	struct bdi_writeback *wb = NULL;
>  	int ratelimit;
>  	int *p;
>  
>  	if (!bdi_cap_account_dirty(bdi))
>  		return;
>  
> +	if (inode_cgwb_enabled(inode))
> +		wb = wb_get_create_current(bdi, GFP_KERNEL);
> +	if (!wb)
> +		wb = &bdi->wb;
> +

So this effectively adds a radix tree lookup (of wb belonging to memcg) for
every set_page_dirty() call. That seems relatively costly to me. And all
that just to check wb->dirty_exceeded. Cannot we just use inode_to_wb()
instead? I understand results may be different if multiple memcgs share an
inode and that's the reason why you use wb_get_create_current(), right?
But for dirty_exceeded check it may be good enough?

								Honza

>  	ratelimit = current->nr_dirtied_pause;
>  	if (wb->dirty_exceeded)
>  		ratelimit = min(ratelimit, 32 >> (PAGE_SHIFT - 10));
> @@ -1616,7 +1622,9 @@ void balance_dirty_pages_ratelimited(struct address_space *mapping)
>  	preempt_enable();
>  
>  	if (unlikely(current->nr_dirtied >= ratelimit))
> -		balance_dirty_pages(mapping, current->nr_dirtied);
> +		balance_dirty_pages(mapping, wb, current->nr_dirtied);
> +
> +	wb_put(wb);
>  }
>  EXPORT_SYMBOL(balance_dirty_pages_ratelimited);
>  
> -- 
> 2.4.0
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
