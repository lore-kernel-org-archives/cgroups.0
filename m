From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 01/12] blkcg: fix ref count issue with bio_blkcg using
 task_css
Date: Fri, 7 Sep 2018 09:52:03 -0700
Message-ID: <20180907165203.GA1100574@devbig004.ftw2.facebook.com>
References: <20180906211045.29055-1-dennisszhou@gmail.com>
 <20180906211045.29055-2-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AYh0rsaO0mmz5DzqRm/SBc9j8B8bdzOEyVdu2zac50c=;
        b=qdtROdG6MlI2jCeC8xPFJSCUsMb7JD7bxiKFKFDmA/o2LEJVqp737ya+RlQoKKsJvp
         lz0s8SDgxQptPm1+xTE3ZO2Bba1zBpbyvi0qepNCWwTC6H1EO/bLWIZE7YWTLPa+l4sy
         K1waJ9082Ka+RN68p0kVmJ2Y6Inb80QDcs3PbgMK+dV5zJY2hxzxGwsa2Xdj5yjLru7a
         sC/ZwVAqywy3UIgQuGcPxbEO57VuTG8keXI9n6clbrcWSFlvZkS+tkXBDJFg+QxiIU1S
         2xymJ7ATjJzGENiDHS68iDIsmDDkgTvoTBwAHX3KbnUyzGY2Wt5qx+jSUMNHh/0+4tje
         GxVg==
Content-Disposition: inline
In-Reply-To: <20180906211045.29055-2-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Sep 06, 2018 at 05:10:34PM -0400, Dennis Zhou wrote:
> From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>
> 
> The accessor function bio_blkcg either returns the blkcg associated with
> the bio or finds one in the current context. This can cause an issue
> when trying to associate a bio with a blkcg. Particularly, it's the
> third case that is problematic:
> 
> 	return css_to_blkcg(task_css(current, io_cgrp_id));
> 
> As the above may race against task migration and the cgroup exiting, it
> is not always ok to take a reference on the blkcg returned from
> bio_blkcg.
> 
> This patch adds association ahead of calling bio_blkcg rather than
> after. This makes association a required and explicit step along the
> code paths for calling bio_blkcg. blk_get_rl is modified as well to get
> a reference to the blkcg it may use and blk_put_rl will always put the
> reference back. Association is also moved above the bio_blkcg call to
> ensure it will not return NULL in blk-iolatency.
> 
> BFQ and CFQ utilize this flaw, but due to the complexity, I do not want
> to address this in this series. I've created a private version of the
> function with notes not to use it describing the flaw. Hopefully soon,
> that code can be cleaned up.
> 
> Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
