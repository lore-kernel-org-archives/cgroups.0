From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH mm-unstable RFC 1/5] writeback: move wb_over_bg_thresh()
 call outside lock section
Date: Fri, 21 Apr 2023 10:53:41 +0200
Message-ID: <20230421085341.b2zvzeuc745bs6sa@quack3>
References: <20230403220337.443510-1-yosryahmed@google.com>
 <20230403220337.443510-2-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1682067222; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TCgmgxLZjgBpHMVFd5dl+S+78y8snFvoa5hj4IkLKoE=;
        b=DD3XydQvq2QEpcTvPifPVBUDTl+Q1vC8UkEnUANJmx94wjnPGZMZIdPgbbIjDTb6puvIEX
        N0IA1hP0Gyew7LmVfFz6UQqOWSYav9dSa+4gOBWY2nM+bid/rQgR+n896ET5c8MDUjLGhD
        +1gtKZkb0byMBdkk5cHcQhLuievKAbA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1682067222;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TCgmgxLZjgBpHMVFd5dl+S+78y8snFvoa5hj4IkLKoE=;
        b=X9A5npHx6rz1+iay8T2pmWurjIpbJdx/lP8Xi7ZG6oyuIl696EnQV4LsYls8Itl45mA1vJ
        dpFF1YcwgA4pfhBA==
Content-Disposition: inline
In-Reply-To: <20230403220337.443510-2-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon 03-04-23 22:03:33, Yosry Ahmed wrote:
> wb_over_bg_thresh() calls mem_cgroup_wb_stats() which invokes an rstat
> flush, which can be expensive on large systems. Currently,
> wb_writeback() calls wb_over_bg_thresh() within a lock section, so we
> have to make the rstat flush atomically. On systems with a lot of
> cpus/cgroups, this can cause us to disable irqs for a long time,
> potentially causing problems.
> 
> Move the call to wb_over_bg_thresh() outside the lock section in
> preparation to make the rstat flush in mem_cgroup_wb_stats() non-atomic.
> The list_empty(&wb->work_list) should be okay outside the lock section
> of wb->list_lock as it is protected by a separate lock (wb->work_lock),
> and wb_over_bg_thresh() doesn't seem like it is modifying any of the b_*
> lists the wb->list_lock is protecting. Also, the loop seems to be
> already releasing and reacquring the lock, so this refactoring looks
> safe.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

The patch looks good to me. Nice find. Feel free to add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza

> ---
>  fs/fs-writeback.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 195dc23e0d831..012357bc8daa3 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -2021,7 +2021,6 @@ static long wb_writeback(struct bdi_writeback *wb,
>  	struct blk_plug plug;
>  
>  	blk_start_plug(&plug);
> -	spin_lock(&wb->list_lock);
>  	for (;;) {
>  		/*
>  		 * Stop writeback when nr_pages has been consumed
> @@ -2046,6 +2045,9 @@ static long wb_writeback(struct bdi_writeback *wb,
>  		if (work->for_background && !wb_over_bg_thresh(wb))
>  			break;
>  
> +
> +		spin_lock(&wb->list_lock);
> +
>  		/*
>  		 * Kupdate and background works are special and we want to
>  		 * include all inodes that need writing. Livelock avoidance is
> @@ -2075,13 +2077,19 @@ static long wb_writeback(struct bdi_writeback *wb,
>  		 * mean the overall work is done. So we keep looping as long
>  		 * as made some progress on cleaning pages or inodes.
>  		 */
> -		if (progress)
> +		if (progress) {
> +			spin_unlock(&wb->list_lock);
>  			continue;
> +		}
> +
>  		/*
>  		 * No more inodes for IO, bail
>  		 */
> -		if (list_empty(&wb->b_more_io))
> +		if (list_empty(&wb->b_more_io)) {
> +			spin_unlock(&wb->list_lock);
>  			break;
> +		}
> +
>  		/*
>  		 * Nothing written. Wait for some inode to
>  		 * become available for writeback. Otherwise
> @@ -2093,9 +2101,7 @@ static long wb_writeback(struct bdi_writeback *wb,
>  		spin_unlock(&wb->list_lock);
>  		/* This function drops i_lock... */
>  		inode_sleep_on_writeback(inode);
> -		spin_lock(&wb->list_lock);
>  	}
> -	spin_unlock(&wb->list_lock);
>  	blk_finish_plug(&plug);
>  
>  	return nr_pages - work->nr_pages;
> -- 
> 2.40.0.348.gf938b09366-goog
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
