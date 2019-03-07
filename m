From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v2 3/3] blkcg: implement sync() isolation
Date: Thu, 7 Mar 2019 17:07:01 -0500
Message-ID: <20190307220659.5qmye2pxmto7nlei@macbook-pro-91.dhcp.thefacebook.com>
References: <20190307180834.22008-1-andrea.righi@canonical.com>
 <20190307180834.22008-4-andrea.righi@canonical.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5XqGPOhHxWelDgT11+htERfFUnfLr39ckjM2oBzWcuM=;
        b=hg7NUf0VaR7rWE9ExshFRFdJUBKdlHgyhBWn7fpjNak6rkxf3itb5EAT/yLjZIgs5I
         PqLKwWBjIsOsCasCwpoEFwHh16ddfXVwzx9FvJOt76zVAt4KwA9lhQLTSvqp5aVi9nfp
         OLc7ZTSc9ofuBPPFhBVgn/JjmxwiAw9grGfKYve8t2h6dJP3YdzsJykQ137aLgGZcVQQ
         VrQpJ1IQzv2koxKRIhT5auG+a8z/d8jXn2c446S8wZ18mlVD4GQIa840ydnLLmZDEn/g
         lEWpO6x46h8n6/oPsjC6Pv+gSDsVjdOI2iSkuv6c3RhQmZsXH5qCpEjvo+HCT7qI+dgu
         iS0w==
Content-Disposition: inline
In-Reply-To: <20190307180834.22008-4-andrea.righi@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrea Righi <andrea.righi@canonical.com>
Cc: Josef Bacik <josef@toxicpanda.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Paolo Valente <paolo.valente@linaro.org>, Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>, Dennis Zhou <dennis@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Thu, Mar 07, 2019 at 07:08:34PM +0100, Andrea Righi wrote:
> Keep track of the inodes that have been dirtied by each blkcg cgroup and
> make sure that a blkcg issuing a sync() can trigger the writeback + wait
> of only those pages that belong to the cgroup itself.
> 
> This behavior is applied only when io.sync_isolation is enabled in the
> cgroup, otherwise the old behavior is applied: sync() triggers the
> writeback of any dirty page.
> 
> Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
> ---
>  block/blk-cgroup.c         | 47 ++++++++++++++++++++++++++++++++++
>  fs/fs-writeback.c          | 52 +++++++++++++++++++++++++++++++++++---
>  fs/inode.c                 |  1 +
>  include/linux/blk-cgroup.h | 22 ++++++++++++++++
>  include/linux/fs.h         |  4 +++
>  mm/page-writeback.c        |  1 +
>  6 files changed, 124 insertions(+), 3 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 4305e78d1bb2..7d3b26ba4575 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -1480,6 +1480,53 @@ void blkcg_stop_wb_wait_on_bdi(struct backing_dev_info *bdi)
>  	spin_unlock(&blkcg_wb_sleeper_lock);
>  	rcu_read_unlock();
>  }
> +
> +/**
> + * blkcg_set_mapping_dirty - set owner of a dirty mapping
> + * @mapping: target address space
> + *
> + * Set the current blkcg as the owner of the address space @mapping (the first
> + * blkcg that dirties @mapping becomes the owner).
> + */
> +void blkcg_set_mapping_dirty(struct address_space *mapping)
> +{
> +	struct blkcg *curr_blkcg, *blkcg;
> +
> +	if (mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK) ||
> +	    mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
> +		return;
> +
> +	rcu_read_lock();
> +	curr_blkcg = blkcg_from_current();
> +	blkcg = blkcg_from_mapping(mapping);
> +	if (curr_blkcg != blkcg) {
> +		if (blkcg)
> +			css_put(&blkcg->css);
> +		css_get(&curr_blkcg->css);
> +		rcu_assign_pointer(mapping->i_blkcg, curr_blkcg);
> +	}
> +	rcu_read_unlock();
> +}
> +
> +/**
> + * blkcg_set_mapping_clean - clear the owner of a dirty mapping
> + * @mapping: target address space
> + *
> + * Unset the owner of @mapping when it becomes clean.
> + */
> +
> +void blkcg_set_mapping_clean(struct address_space *mapping)
> +{
> +	struct blkcg *blkcg;
> +
> +	rcu_read_lock();
> +	blkcg = rcu_dereference(mapping->i_blkcg);
> +	if (blkcg) {
> +		css_put(&blkcg->css);
> +		RCU_INIT_POINTER(mapping->i_blkcg, NULL);
> +	}
> +	rcu_read_unlock();
> +}
>  #endif
>  

Why do we need this?  We already have the inode_attach_wb(), which has the
blkcg_css embedded in it for whoever dirtied the inode first.  Can we not just
use that?  Thanks,

Josef
