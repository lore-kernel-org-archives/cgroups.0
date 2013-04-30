From: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v4 09/31] inode: convert inode lru list to generic lru
 list code.
Date: Tue, 30 Apr 2013 16:46:49 +0100
Message-ID: <20130430154649.GI6415@suse.de>
References: <1367018367-11278-1-git-send-email-glommer@openvz.org>
 <1367018367-11278-10-git-send-email-glommer@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1367018367-11278-10-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Sat, Apr 27, 2013 at 03:19:05AM +0400, Glauber Costa wrote:
> From: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> [ glommer: adapted for new LRU return codes ]
> Signed-off-by: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

Looks mostly mechanical with the main mess in the conversion of the
isolate function.

> +	if (inode_has_buffers(inode) || inode->i_data.nrpages) {
> +		__iget(inode);
> +		spin_unlock(&inode->i_lock);
> +		spin_unlock(lru_lock);
> +		if (remove_inode_buffers(inode)) {
> +			unsigned long reap;
> +			reap = invalidate_mapping_pages(&inode->i_data, 0, -1);
> +			if (current_is_kswapd())
> +				__count_vm_events(KSWAPD_INODESTEAL, reap);
> +			else
> +				__count_vm_events(PGINODESTEAL, reap);
> +			if (current->reclaim_state)
> +				current->reclaim_state->reclaimed_slab += reap;
>  		}
> +		iput(inode);
> +		spin_lock(lru_lock);
> +		return LRU_RETRY;
> +	}

Only concern is this and whether it can cause the lru_list_walk to
infinite loop if the inode is being continually used and the LRU list is
too small to win the race.

-- 
Mel Gorman
SUSE Labs
