From: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 1/5] mm: memcontrol: generalize locking for the
 page->mem_cgroup binding
Date: Wed, 27 Jan 2016 17:30:45 +0300
Message-ID: <20160127143045.GA9623@esperanza>
References: <1453842006-29265-1-git-send-email-hannes@cmpxchg.org>
 <1453842006-29265-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1453842006-29265-2-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Jan 26, 2016 at 04:00:02PM -0500, Johannes Weiner wrote:

> @@ -683,17 +683,17 @@ int __set_page_dirty_buffers(struct page *page)
>  		} while (bh != head);
>  	}
>  	/*
> -	 * Use mem_group_begin_page_stat() to keep PageDirty synchronized with
> -	 * per-memcg dirty page counters.
> +	 * Lock out page->mem_cgroup migration to keep PageDirty
> +	 * synchronized with per-memcg dirty page counters.
>  	 */
> -	memcg = mem_cgroup_begin_page_stat(page);
> +	memcg = lock_page_memcg(page);
>  	newly_dirty = !TestSetPageDirty(page);
>  	spin_unlock(&mapping->private_lock);
>  
>  	if (newly_dirty)
>  		__set_page_dirty(page, mapping, memcg, 1);

Do we really want to pass memcg to __set_page_dirty and then to
account_page_dirtied, increasing stack/regs usage even in case memory
cgroup is disabled? May be, it'd be better to make
mem_cgroup_update_page_stat take a page instead of a memcg?

Thanks,
Vladimir

>  
> -	mem_cgroup_end_page_stat(memcg);
> +	unlock_page_memcg(memcg);
>  
>  	if (newly_dirty)
>  		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
