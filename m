From: Ionela Voinescu <ionela.voinescu@arm.com>
Subject: Re: [PATCH 5/6] blk-cgroup: reimplement basic IO stats using cgroup
 rstat
Date: Thu, 14 Nov 2019 12:17:43 +0000
Message-ID: <3c76ab1f-6836-fb60-11ed-25d6db9a2a57@arm.com>
References: <20191107191804.3735303-1-tj@kernel.org>
 <20191107191804.3735303-6-tj@kernel.org>
 <cd3ebcee-6819-a09b-aeba-de6817f32cde@ti.com>
 <20191113163501.GI4163745@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191113163501.GI4163745@devbig004.ftw2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Faiz Abbas <faiz_abbas@ti.com>
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, kernel-team@fb.com, Dan Schatzberg <dschatzberg@fb.com>, Daniel Xu <dlxu@fb.com>

Hi Tejun,

On 13/11/2019 16:35, Tejun Heo wrote:
> Hello,
> 
> Can you please see whether the following patch fixes the issue?
> 

This patch does fix the issue for me.


Thanks,
Ionela.

> Thanks.
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
