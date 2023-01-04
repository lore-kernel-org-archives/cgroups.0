From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] blk-iocost: add refcounting for ioc
Date: Wed, 4 Jan 2023 11:45:42 -1000
Message-ID: <Y7XzhqyJYBDfZhnF@slm.duckdns.org>
References: <20221227125502.541931-1-yukuai1@huaweicloud.com>
 <20221227125502.541931-3-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HP49eHGQprOWy/o9YAiJT2BohVJETnV4fu4DZ9xoKVU=;
        b=am7cWJUxSY+kVv2i1XesOjuZY5/rfaau1sAwfQrVls7yEjhu3MCtLYYSO/yYult8Uo
         WHRb8isgq1iOq/Ng5Lg5PDY24f//vBjtz65tALlr2/6+H28fa1RqP5BhmWdtyw0Dhxae
         9HhYrvbluk8zh0BabpGcW0B61Vja8dkHDI4rODdtNvw13a0SqW+2hzPPbUjF1g2Z1Hkh
         Hc4kj22L2gF4BG3n8r5Hg+WpvoNc60VwppDumxDVcRAsZEl+uMyHGGfDNFUkVwNVgGeL
         oWWp961cGxDINEjbdae7xhsedktVsXAqF8OUhErIz9EvxppBMxuYo8VaH+cISWBU0DZy
         x3Vg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221227125502.541931-3-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Tue, Dec 27, 2022 at 08:55:02PM +0800, Yu Kuai wrote:
> Root cause is that blkg_free() can be asynchronously, and it can race
> with delete device:
> 
> T1			T2		T3
> //delete device
> del_gendisk
>  bdi_unregister
>   bdi_remove_from_list
>    synchronize_rcu_expedited
> 
> 			//rmdir cgroup
> 			blkcg_destroy_blkgs
> 			 blkg_destroy
> 			  percpu_ref_kill
> 			   blkg_release
> 			    call_rcu
>  rq_qos_exit
>   ioc_rqos_exit
>    kfree(ioc)
> 					__blkg_release
> 					 blkg_free
> 					  blkg_free_workfn
> 					   pd_free_fn
> 					    ioc_pd_free
> 					     spin_lock_irqsave
> 
> Fix the problem by add refcounting for ioc, and iocg will grab reference
> of ioc, so that ioc won't be freed until all the iocg is exited.

Ditto, why do this in iocost instead of blk-cgroup core?

Thanks.

-- 
tejun
