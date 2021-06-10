From: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v9 3/8] writeback, cgroup: increment isw_nr_in_flight
 before grabbing an inode
Date: Thu, 10 Jun 2021 14:57:03 +0800
Message-ID: <YMG3v13caUW5BX8n@T590>
References: <20210608230225.2078447-1-guro@fb.com>
 <20210608230225.2078447-4-guro@fb.com>
 <YMA2XEnJrHyVLWrD@T590>
 <YMFa+guFw7OFjf3X@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623308241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2xI9DhwUbPIwsok2RGKHqBDnQZkdygy7sVBmHeixOo0=;
        b=caabeBX53LFseGeLuONcHfQNlTJ21BOR2Nit0B9s+k1lnSiL34SVzMvnNO2ieIxIQC+d5F
        NqrW+iiXT7OWms1/hgDJQGpPNKSnk2iwNGniFTh8v0n88MCpnwKh9QrHoskNwqRsKtnSOy
        ZvoZzB+q2S1nD0lmeORwnmjBoaz5mnM=
Content-Disposition: inline
In-Reply-To: <YMFa+guFw7OFjf3X-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>

On Wed, Jun 09, 2021 at 05:21:14PM -0700, Roman Gushchin wrote:
> On Wed, Jun 09, 2021 at 11:32:44AM +0800, Ming Lei wrote:
> > On Tue, Jun 08, 2021 at 04:02:20PM -0700, Roman Gushchin wrote:
> > > isw_nr_in_flight is used do determine whether the inode switch queue
> > > should be flushed from the umount path. Currently it's increased
> > > after grabbing an inode and even scheduling the switch work. It means
> > > the umount path can be walked past cleanup_offline_cgwb() with active
> > > inode references, which can result in a "Busy inodes after unmount."
> > > message and use-after-free issues (with inode->i_sb which gets freed).
> > > 
> > > Fix it by incrementing isw_nr_in_flight before doing anything with
> > > the inode and decrementing in the case when switching wasn't scheduled.
> > > 
> > > The problem hasn't yet been seen in the real life and was discovered
> > > by Jan Kara by looking into the code.
> > > 
> > > Suggested-by: Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
> > > Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> > > Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> > > ---
> > >  fs/fs-writeback.c | 5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > > index b6fc13a4962d..4413e005c28c 100644
> > > --- a/fs/fs-writeback.c
> > > +++ b/fs/fs-writeback.c
> > > @@ -505,6 +505,8 @@ static void inode_switch_wbs(struct inode *inode, int new_wb_id)
> > >  	if (!isw)
> > >  		return;
> > >  
> > > +	atomic_inc(&isw_nr_in_flight);
> > 
> > smp_mb() may be required for ordering the WRITE in 'atomic_inc(&isw_nr_in_flight)'
> > and the following READ on 'inode->i_sb->s_flags & SB_ACTIVE'. Otherwise,
> > cgroup_writeback_umount() may observe zero of 'isw_nr_in_flight' because of
> > re-order of the two OPs, then miss the flush_workqueue().
> > 
> > Also this barrier should serve as pair of the one added in cgroup_writeback_umount(),
> > so maybe this patch should be merged with 2/8.
> 
> Hi Ming!
> 
> Good point, I agree. How about a patch below?
> 
> Thanks!
> 
> --
> 
> From 282861286074c47907759d80c01419f0d0630dae Mon Sep 17 00:00:00 2001
> From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Date: Wed, 9 Jun 2021 14:14:26 -0700
> Subject: [PATCH] cgroup, writeback: add smp_mb() to inode_prepare_wbs_switch()
> 
> Add a memory barrier between incrementing isw_nr_in_flight
> and checking the sb's SB_ACTIVE flag and grabbing an inode in
> inode_prepare_wbs_switch(). It's required to prevent grabbing
> an inode before incrementing isw_nr_in_flight, otherwise
> 0 can be obtained as isw_nr_in_flight in cgroup_writeback_umount()
> and isw_wq will not be flushed, potentially leading to a memory
> corruption.
> 
> Added smp_mb() will work in pair with smp_mb() in
> cgroup_writeback_umount().
> 
> Suggested-by: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> ---
>  fs/fs-writeback.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 545fce68e919..6332b86ca4ed 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -513,6 +513,14 @@ static void inode_switch_wbs_work_fn(struct work_struct *work)
>  static bool inode_prepare_wbs_switch(struct inode *inode,
>  				     struct bdi_writeback *new_wb)
>  {
> +	/*
> +	 * Paired with smp_mb() in cgroup_writeback_umount().
> +	 * isw_nr_in_flight must be increased before checking SB_ACTIVE and
> +	 * grabbing an inode, otherwise isw_nr_in_flight can be observed as 0
> +	 * in cgroup_writeback_umount() and the isw_wq will be not flushed.
> +	 */
> +	smp_mb();
> +
>  	/* while holding I_WB_SWITCH, no one else can update the association */
>  	spin_lock(&inode->i_lock);
>  	if (!(inode->i_sb->s_flags & SB_ACTIVE) ||

Looks fine, you may have to merge this one with 2/8 & 3/8, so the memory
barrier use can be correct & intact for avoiding the race between switching
cgwb and generic_shutdown_super().


Thanks,
Ming

