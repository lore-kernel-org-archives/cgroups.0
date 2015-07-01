From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 49/51] buffer, writeback: make __block_write_full_page()
 honor cgroup writeback
Date: Wed, 1 Jul 2015 21:28:00 +0200
Message-ID: <20150701192800.GM7252@quack.suse.cz>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-50-git-send-email-tj@kernel.org>
 <20150701192102.GK7252@quack.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150701192102.GK7252-+0h/O2h83AeN3ZZ/Hiejyg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Wed 01-07-15 21:21:02, Jan Kara wrote:
> On Fri 22-05-15 17:14:03, Tejun Heo wrote:
> > [__]block_write_full_page() is used to implement ->writepage in
> > various filesystems.  All writeback logic is now updated to handle
> > cgroup writeback and the block cgroup to issue IOs for is encoded in
> > writeback_control and can be retrieved from the inode; however,
> > [__]block_write_full_page() currently ignores the blkcg indicated by
> > inode and issues all bio's without explicit blkcg association.
> > 
> > This patch adds submit_bh_blkcg() which associates the bio with the
> > specified blkio cgroup before issuing and uses it in
> > __block_write_full_page() so that the issued bio's are associated with
> > inode_to_wb_blkcg_css(inode).
> 
> One comment below...
> 
> > @@ -44,6 +45,9 @@
> >  #include <trace/events/block.h>
> >  
> >  static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
> > +static int submit_bh_blkcg(int rw, struct buffer_head *bh,
> > +			   unsigned long bio_flags,
> 
> The argument bio_flags is unused. What is is good for?

Ah, sorry, I guess I'm too tired. I now see how bio_flags are used. The
patch looks good. You can add:

Reviewed-by: Jan Kara <jack-IBi9RG/b67k@public.gmane.org>

								Honza
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
