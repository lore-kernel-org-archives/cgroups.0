From: Dennis Zhou <dennis@kernel.org>
Subject: Re: [PATCH] cgroup writeback: use online cgroup when switching from
 dying bdi_writebacks
Date: Fri, 19 Jul 2019 17:13:14 -0400
Message-ID: <20190719211314.GA5066@dennisz-mbp.dhcp.thefacebook.com>
References: <156355839560.2063.5265687291430814589.stgit@buzz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <156355839560.2063.5265687291430814589.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org

On Fri, Jul 19, 2019 at 08:46:35PM +0300, Konstantin Khlebnikov wrote:
> Offline memory cgroups forbids creation new bdi_writebacks.
> Each try wastes cpu cycles and increases contention around cgwb_lock.
> 
> For example each O_DIRECT read calls filemap_write_and_wait_range()
> if inode has cached pages which tries to switch from dying writeback.
> 
> This patch switches inode writeback to closest online parent cgroup.
> 
> Fixes: e8a7abf5a5bd ("writeback: disassociate inodes from dying bdi_writebacks")
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> ---
>  fs/fs-writeback.c |   13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 542b02d170f8..3af44591a106 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -505,7 +505,7 @@ static void inode_switch_wbs(struct inode *inode, int new_wb_id)
>  	/* find and pin the new wb */
>  	rcu_read_lock();
>  	memcg_css = css_from_id(new_wb_id, &memory_cgrp_subsys);
> -	if (memcg_css)
> +	if (memcg_css && (memcg_css->flags & CSS_ONLINE))
>  		isw->new_wb = wb_get_create(bdi, memcg_css, GFP_ATOMIC);
>  	rcu_read_unlock();
>  	if (!isw->new_wb)
> @@ -579,9 +579,16 @@ void wbc_attach_and_unlock_inode(struct writeback_control *wbc,
>  	/*
>  	 * A dying wb indicates that the memcg-blkcg mapping has changed
>  	 * and a new wb is already serving the memcg.  Switch immediately.
> +	 * If memory cgroup is offline switch to closest online parent.
>  	 */
> -	if (unlikely(wb_dying(wbc->wb)))
> -		inode_switch_wbs(inode, wbc->wb_id);
> +	if (unlikely(wb_dying(wbc->wb))) {
> +		struct cgroup_subsys_state *memcg_css = wbc->wb->memcg_css;
> +
> +		while (!(memcg_css->flags & CSS_ONLINE))
> +			memcg_css = memcg_css->parent;
> +
> +		inode_switch_wbs(inode, memcg_css->id);
> +	}
>  }
>  EXPORT_SYMBOL_GPL(wbc_attach_and_unlock_inode);
>  
> 

Hi Konstantin,

Alibaba also hit this a few months back, but never got back to me about
the patch I sent them [1]. At least in v2, it gets a little hairy with
the no internal process constraint. You end up with IO being attributed
to cgroups you may not necessarily expect and how IO competes then I'm
not really sure. Below is what I sent them. This punts to root instead
which isn't necessarily better.

Thanks,
Dennis

[1] https://lore.kernel.org/linux-mm/1557389033-39649-1-git-send-email-zhangliguang@linux.alibaba.com/

----
commit 0908bd801cc1dac120fa3b213174670a1d6487ff
Author: Dennis Zhou <dennis@kernel.org>
Date:   Mon May 13 09:44:12 2019 -0700

    wb: fix trying to switch wbs on a dead memcg

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 36855c1f8daf..fb331ea2a626 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -577,7 +577,7 @@ void wbc_attach_and_unlock_inode(struct writeback_control *wbc,
 	 * A dying wb indicates that the memcg-blkcg mapping has changed
 	 * and a new wb is already serving the memcg.  Switch immediately.
 	 */
-	if (unlikely(wb_dying(wbc->wb)))
+	if (unlikely(wb_dying(wbc->wb)) && !css_is_dying(wbc->wb->memcg_css))
 		inode_switch_wbs(inode, wbc->wb_id);
 }
 
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 72e6d0c55cfa..685563ed9788 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -659,7 +659,7 @@ struct bdi_writeback *wb_get_create(struct backing_dev_info *bdi,
 
 	might_sleep_if(gfpflags_allow_blocking(gfp));
 
-	if (!memcg_css->parent)
+	if (!memcg_css->parent || css_is_dying(memcg_css))
 		return &bdi->wb;
 
 	do {

