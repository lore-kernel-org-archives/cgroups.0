From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -next v3 3/3] blk-cgroup: synchronize pd_free_fn() from
 blkg_free_workfn() and blkcg_deactivate_policy()
Date: Thu, 19 Jan 2023 06:15:55 -1000
Message-ID: <Y8lsuwtrCYE9jiHb@slm.duckdns.org>
References: <20230119110350.2287325-1-yukuai1@huaweicloud.com>
 <20230119110350.2287325-4-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ae6CLA/wyp/IvxNOrUUr/ZjdhSOngZFFYXXmGXpC8Eo=;
        b=IHB4k/BCpN5sgx7Si8MmzTbFCivgZU+rJneogVjYsDfEIK9Z03JTHrf+NRUAAjBV6j
         le9FgFaerU+8HdJ8/cF3P4PUTaJ7NduhYrsyULClMw+M38tARHzdUegH3US59Ru9HpRi
         M3mmkyFOa+I6j6zZ+drM9VxU0fmrxERrcei5iEBQUkPAwEW0Ah8alPIVjPblmz9jY74S
         gnT22G4f13X5F0ExocvzTFlib3QcpSXseTC3YwSJMlXTJnEWM+boHGUkV4HgSkXCDi7y
         DcDyLOQfSr42qNBkzng4sdtwAhXb2o/2M8effxXUzeBEtd2sAdPgswgOSgEpFGPOsxaZ
         f1SA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230119110350.2287325-4-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com

On Thu, Jan 19, 2023 at 07:03:50PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Currently parent pd can be freed before child pd:
> 
> t1: remove cgroup C1
> blkcg_destroy_blkgs
>  blkg_destroy
>   list_del_init(&blkg->q_node)
>   // remove blkg from queue list
>   percpu_ref_kill(&blkg->refcnt)
>    blkg_release
>     call_rcu
> 
> t2: from t1
> __blkg_release
>  blkg_free
>   schedule_work
> 			t4: deactivate policy
> 			blkcg_deactivate_policy
> 			 pd_free_fn
> 			 // parent of C1 is freed first
> t3: from t2
>  blkg_free_workfn
>   pd_free_fn
> 
> If policy(for example, ioc_timer_fn() from iocost) access parent pd from
> child pd after pd_offline_fn(), then UAF can be triggered.
> 
> Fix the problem by delaying 'list_del_init(&blkg->q_node)' from
> blkg_destroy() to blkg_free_workfn(), and using a new disk level mutex to
> synchronize blkg_free_workfn() and blkcg_deactivate_policy().
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
