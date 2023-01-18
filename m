From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -next v2 2/3] blk-cgroup: support to track if policy is
 online
Date: Wed, 18 Jan 2023 06:55:03 -1000
Message-ID: <Y8gkZzvhnL6+0YQz@slm.duckdns.org>
References: <20230118123152.1926314-1-yukuai1@huaweicloud.com>
 <20230118123152.1926314-3-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A7F6VPbhMnzjimtiCShZ77ZvG/bSXxm/Jis8nNrNKeM=;
        b=XuT/m/jKqKU3pK9KFC1rR7pyI+ajP9HGz+9CmIHpgh9GlUoRUpIPOtc0TZvnqpZeyr
         Ba3IlJooRL4qJQ3msXeozWveqt8Mcrz6dGVGKYWbzSDJ1UQCLQ+ws1lYXWPsIon2u4J9
         lbFzmO0dVPXbG0hO2DHEJi/m9XEnW3NXwdDlu+62sjYnKx3N7prYNncVKORJG6bZ41UV
         0lGBxSy1NHQ9hmvIlI/dFom49BtT0+7K3i2/vlrDyT2rV5g7bakA1oJe/3dcZ0yip8J2
         ounssrODrQORokHwzX3OmhLnodUuQtZ1dAMe6Ii4bdqQ6lxlbD7WrllvZ0TnnMjRQAPq
         BGqg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230118123152.1926314-3-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com

On Wed, Jan 18, 2023 at 08:31:51PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> A new field 'online' is added to blkg_policy_date to fix following
                                                  ^
                                                  a
> 2 problem:
> 
> 1) In blkcg_activate_policy(), if pd_alloc_fn() with 'GFP_NOWAIT'
>    failed, 'queue_lock' will be dropped and pd_alloc_fn() will try again
>    without 'GFP_NOWAIT'. In the meantime, remove cgroup can race with
>    it, and pd_offline_fn() will be called without pd_init_fn() and
>    pd_online_fn(). This way null-ptr-deference can be triggered.
> 
> 2) In order to synchronize pd_free_fn() from blkg_free_workfn() and
>    blkcg_deactivate_policy(), 'list_del_init(&blkg->q_node)' will be
>    delayed to blkg_free_workfn(), hence pd_offline_fn() can be called
>    first in blkg_destroy(), and then blkcg_deactivate_policy() will
>    call it again, we must prevent it.
> 
> The new field 'online' will be set after pd_online_fn() and will be
> cleared after pd_offline_fn(), in the meantime pd_offline_fn() will only
> be called if 'online' is set.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
