From: Faiz Abbas <faiz_abbas@ti.com>
Subject: Re: [PATCH block/for-next] blk-cgroup: cgroup_rstat_updated()
 shouldn't be called on cgroup1
Date: Mon, 18 Nov 2019 14:09:40 +0530
Message-ID: <6f791736-2728-be53-9544-e0a0f0d09dd0@ti.com>
References: <20191107191804.3735303-1-tj@kernel.org>
 <20191107191804.3735303-6-tj@kernel.org>
 <cd3ebcee-6819-a09b-aeba-de6817f32cde@ti.com>
 <20191113163501.GI4163745@devbig004.ftw2.facebook.com>
 <20191114223128.GM4163745@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1574066328;
        bh=2FmC6WnguELH0WljaqAvUXHz4oovTIg5XA3M9m7laOM=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=JQk58HK+KG2z9Y7+qVN3JLPmEHQ+wsw40VdDVyonlPjWTyUovUDwXsKg1NKgobvMG
         bMeoY97hekPv8YSMIffnOMGmbk6NqrB+OONU9gvN1GMg5ZC4CsTUDHdz3DUrVk3pZ7
         D8vjzUdjnTP5OwUMqW61010vvke/PcVkUYYejwB8=
In-Reply-To: <20191114223128.GM4163745@devbig004.ftw2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, kernel-team@fb.com, Dan Schatzberg <dschatzberg@fb.com>, Daniel Xu <dlxu@fb.com>

Hi,

On 15/11/19 4:01 AM, Tejun Heo wrote:
> Currently, cgroup rstat is supported only on cgroup2 hierarchy and
> rstat functions shouldn't be called on cgroup1 cgroups.  While
> converting blk-cgroup core statistics to rstat, f73316482977
> ("blk-cgroup: reimplement basic IO stats using cgroup rstat")
> accidentally ended up calling cgroup_rstat_updated() on cgroup1
> cgroups causing crashes.
> 
> Longer term, we probably should add cgroup1 support to rstat but for
> now let's mask the call directly.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Fixes: f73316482977 ("blk-cgroup: reimplement basic IO stats using cgroup rstat")
Tested-by: Faiz Abbas <faiz_abbas@ti.com>
> ---
>  include/linux/blk-cgroup.h |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
> index 48a66738143d..19394c77ed99 100644
> --- a/include/linux/blk-cgroup.h
> +++ b/include/linux/blk-cgroup.h
> @@ -626,7 +626,8 @@ static inline bool blkcg_bio_issue_check(struct request_queue *q,
>  		bis->cur.ios[rwd]++;
>  
>  		u64_stats_update_end(&bis->sync);
> -		cgroup_rstat_updated(blkg->blkcg->css.cgroup, cpu);
> +		if (cgroup_subsys_on_dfl(io_cgrp_subsys))
> +			cgroup_rstat_updated(blkg->blkcg->css.cgroup, cpu);
>  		put_cpu();
>  	}
>  
> 

Thanks,
Faiz
