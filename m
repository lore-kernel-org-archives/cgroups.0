From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 4/5] blk-iocost: fix divide by 0 error in calc_lcoefs()
Date: Wed, 18 Jan 2023 07:18:29 -1000
Message-ID: <Y8gp5ZeHbs/U1Qfe@slm.duckdns.org>
References: <20230117070806.3857142-1-yukuai1@huaweicloud.com>
 <20230117070806.3857142-5-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6jlTZEN1utYn3NK0RDj87Oh5/DtKY5pKiAHoIwQXuHc=;
        b=nyNGxdNG/Zdzr9E1yPijuDXODjLQQP6MdAGR3XhLofQhx+8VjEZOWff7AFSFOdqB0t
         bSi1cCaNAEo4ddCyQc3RjvRDMlgVrDbpNUWDlPQq6bqKzi8O7feqKReVTbWWkXFxRbC2
         2RXYw3mjH01Cg2RVqfJ5wPB/aib/zg0Ejq2WJkvHyETy/nczZnHWL1WJ8khb1yyba6eH
         J9IUn8KI/mx+yTnU8zvDkfXdey6dujH9rpmkeljkfhQSXnYT3N999Nn96+B0+GxHHfwb
         bZ/fRxJTUXLnvmdOagmBRJwdNedvLCXNhwSTJXIDLV7tLm510U9mQrjWipTL8PnIe7eW
         t16Q==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230117070806.3857142-5-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com

On Tue, Jan 17, 2023 at 03:08:05PM +0800, Yu Kuai wrote:
> From: Li Nan <linan122@huawei.com>
> 
> echo max of u64 to cost.model can cause divide by 0 error.
> 
>   # echo 8:0 rbps=18446744073709551615 > /sys/fs/cgroup/io.cost.model
> 
>   divide error: 0000 [#1] PREEMPT SMP
>   RIP: 0010:calc_lcoefs+0x4c/0xc0
>   Call Trace:
>    <TASK>
>    ioc_refresh_params+0x2b3/0x4f0
>    ioc_cost_model_write+0x3cb/0x4c0
>    ? _copy_from_iter+0x6d/0x6c0
>    ? kernfs_fop_write_iter+0xfc/0x270
>    cgroup_file_write+0xa0/0x200
>    kernfs_fop_write_iter+0x17d/0x270
>    vfs_write+0x414/0x620
>    ksys_write+0x73/0x160
>    __x64_sys_write+0x1e/0x30
>    do_syscall_64+0x35/0x80
>    entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> calc_lcoefs() uses the input value of cost.model in DIV_ROUND_UP_ULL,
> overflow would happen if bps plus IOC_PAGE_SIZE is greater than
> ULLONG_MAX, it can cause divide by 0 error.
> 
> Fix the problem by setting basecost
> 
> Signed-off-by: Li Nan <linan122@huawei.com>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
