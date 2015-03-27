From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 28/48] writeback: implement and use mapping_congested()
Date: Fri, 27 Mar 2015 14:06:26 -0400
Message-ID: <20150327180626.GA19117@redhat.com>
References: <1427086499-15657-1-git-send-email-tj@kernel.org>
 <1427086499-15657-29-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1427086499-15657-29-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Mon, Mar 23, 2015 at 12:54:39AM -0400, Tejun Heo wrote:
> In several places, bdi_congested() and its wrappers are used to
> determine whether more IOs should be issued.  With cgroup writeback
> support, this question can't be answered solely based on the bdi
> (backing_dev_info).  It's dependent on whether the filesystem and bdi
> support cgroup writeback and the blkcg the asking task belongs to.
> 
> This patch implements mapping_congested() and its wrappers which take
> @mapping and @task and determines the congestion state considering
> cgroup writeback for the combination.  The new functions replace
> bdi_*congested() calls in places where the query is about specific
> mapping and task.
> 
> There are several filesystem users which also fit this criteria but
> they should be updated when each filesystem implements cgroup
> writeback support.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/fs-writeback.c           | 39 +++++++++++++++++++++++++++++++++++++++
>  include/linux/backing-dev.h | 27 +++++++++++++++++++++++++++
>  mm/fadvise.c                |  2 +-
>  mm/readahead.c              |  2 +-
>  mm/vmscan.c                 | 12 ++++++------
>  5 files changed, 74 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 48db5e6..015f359 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -130,6 +130,45 @@ static void __wb_start_writeback(struct bdi_writeback *wb, long nr_pages,
>  	wb_queue_work(wb, work);
>  }
>  
> +#ifdef CONFIG_CGROUP_WRITEBACK
> +
> +/**
> + * mapping_congested - test whether a mapping is congested for a task
> + * @mapping: address space to test for congestion
> + * @task: task to test congestion for
> + * @cong_bits: mask of WB_[a]sync_congested bits to test
> + *
> + * Tests whether @mapping is congested for @task.  @cong_bits is the mask
> + * of congestion bits to test and the return value is the mask of set bits.
> + *
> + * If cgroup writeback is enabled for @mapping, its congestion state for
> + * @task is determined by whether the cgwb (cgroup bdi_writeback) for the
> + * blkcg of %current on @mapping->backing_dev_info is congested; otherwise,
> + * the root's congestion state is used.
> + */
> +int mapping_congested(struct address_space *mapping,
> +		      struct task_struct *task, int cong_bits)
> +{
> +	struct inode *inode = mapping->host;
> +	struct backing_dev_info *bdi = inode_to_bdi(inode);
> +	struct bdi_writeback *wb;
> +	int ret = 0;
> +
> +	if (!inode || !inode_cgwb_enabled(inode))
> +		return wb_congested(&bdi->wb, cong_bits);
> +
> +	rcu_read_lock();
> +	wb = wb_find_current(bdi);

Hi Tejun,

I am wondering that why do we lookup bdi_writeback using blkcg of
task and why not use the bdi_writeback associated with inode?

IIUC, whole idea is to attach an inode to bdi_writeback (and
change it later if need be) and that writeback is used for
controlling IO to that inode. And blkcg associated with the
writeback will be put in bio which in turn will be used
by block layer.

IOW, blkcg of a bio gets decided by the bdi_writeback
attached to inode and current writer does not seem to
matter. So I am not sure why mapping_congested() should
take task's blkcg into consideration instead of just
taking bdi_writeback from inode and see if it is congested
or not.

Thanks
Vivek
