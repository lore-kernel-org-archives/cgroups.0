From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v7 5/6] writeback, cgroup: support switching multiple
 inodes at once
Date: Mon, 7 Jun 2021 11:00:50 +0200
Message-ID: <20210607090050.GB30275@quack2.suse.cz>
References: <20210604013159.3126180-1-guro@fb.com>
 <20210604013159.3126180-6-guro@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1623056451; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DFwjE+z0lEnHuGuwIYHSS4DoT9tAvhOIoQsNTyBPlnM=;
        b=VuRCo59JDusjwHbv+PStigZT0YwYXb/tebQ1vXZ0UVQnqBo5rqB/hFPdQ06Fqg6AjxPWcy
        8bps4sK7FRMUnTGuDqO04nD55v4L9g4AY4+h5uRRVh4RDXRHeZFrFiilL41cMM1FJzDX2Z
        fTvU4dBVVGT3u1yvLS8spxbEpBVSz9A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1623056451;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DFwjE+z0lEnHuGuwIYHSS4DoT9tAvhOIoQsNTyBPlnM=;
        b=dvuqxgkOnkTb3+9ojbmnjKhQmf56EjBAmcKknZ9R4oLVY96dmknVeGlsSgs+dH/VdzYupR
        tktAfWrOLyy6DfCQ==
Content-Disposition: inline
In-Reply-To: <20210604013159.3126180-6-guro-b10kYP2dOMg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 03-06-21 18:31:58, Roman Gushchin wrote:
> Currently only a single inode can be switched to another writeback
> structure at once. That means to switch an inode a separate
> inode_switch_wbs_context structure must be allocated, and a separate
> rcu callback and work must be scheduled.
> 
> It's fine for the existing ad-hoc switching, which is not happening
> that often, but sub-optimal for massive switching required in order to
> release a writeback structure. To prepare for it, let's add a support
> for switching multiple inodes at once.
> 
> Instead of containing a single inode pointer, inode_switch_wbs_context
> will contain a NULL-terminated array of inode pointers.
> inode_do_switch_wbs() will be called for each inode.
> 
> To optimize the locking bdi->wb_switch_rwsem, old_wb's and new_wb's
> list_locks will be acquired and released only once altogether for all
> inodes. wb_wakeup() will be also be called only once. Instead of
> calling wb_put(old_wb) after each successful switch, wb_put_many()
> is introduced and used.
> 
> Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Looks good except for one small issue:

> +	for (inodep = isw->inodes; *inodep; inodep++) {
> +		WARN_ON_ONCE((*inodep)->i_wb != old_wb);
> +		if (inode_do_switch_wbs(*inodep, old_wb, new_wb))
> +			nr_switched++;
> +		iput(*inodep);
> +	}

You have to be careful here as iput() can be dropping last inode reference
and in that case it can sleep and do a lot of heavylifting (which cannot
happen under the locks you hold). So you need another loop after dropping
all the locks to do iput() on all inodes. After fixing this feel free to
add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
