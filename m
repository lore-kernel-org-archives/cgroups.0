From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 4/5] blk-iocost: fix divide by 0 error in calc_lcoefs()
Date: Wed, 4 Jan 2023 11:54:04 -1000
Message-ID: <Y7X1fFO4UP7QnwkC@slm.duckdns.org>
References: <20221226085859.2701195-1-yukuai1@huaweicloud.com>
 <20221226085859.2701195-5-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sj90lDqlFKxEDVLKZWeE4EHCh7ABoWinmRYd1NYrBKs=;
        b=q3KzqC+gP9yLfE3aszoMQ7HEr0XeZw3R7grDqDP7d4QVjYR9LM/P8JyWUSF/pHbHEw
         PJRl86/tE5xksAbgnZo5CNML6uwGSP5uBw5w5jb+o7vqkXDR5SF5rVqW9LOBhwPaNcVd
         AkN2NY+dcNhh3cVDfC+x2eGxh/cPI2/6KBaEmEN7RhrvA9eFvzLuxkOSHWMT9utuU+C5
         60ywfJkB2KdMFKZ1E1Ckyl3MeMoBOMGFCsEZ//y5XSNozt5WpabZW0sFLuqr74IHTmUW
         sMbGNeSq01e5OIKeizSnpThputbvC/3Da1hRa+FXDINniKdMSekabCHB6xJPJDNt7zDr
         9DFw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20221226085859.2701195-5-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

On Mon, Dec 26, 2022 at 04:58:58PM +0800, Yu Kuai wrote:
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
> ---
>  block/blk-iocost.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
> index f8726e20da20..c6b39024117b 100644
> --- a/block/blk-iocost.c
> +++ b/block/blk-iocost.c
> @@ -866,9 +866,13 @@ static void calc_lcoefs(u64 bps, u64 seqiops, u64 randiops,
>  
>  	*page = *seqio = *randio = 0;
>  
> -	if (bps)
> -		*page = DIV64_U64_ROUND_UP(VTIME_PER_SEC,
> -					   DIV_ROUND_UP_ULL(bps, IOC_PAGE_SIZE));
> +	if (bps) {
> +		if (bps >= U64_MAX - IOC_PAGE_SIZE)
> +			*page = 1;
> +		else
> +			*page = DIV64_U64_ROUND_UP(VTIME_PER_SEC,
> +					DIV_ROUND_UP_ULL(bps, IOC_PAGE_SIZE));
> +	}

This is a nitpick but wouldn't something like the following be easier to
understand?

        if (bps) {
                u64 bps_pages = DIV_ROUND_UP_ULL(bps, IOC_PAGE_SIZE);

                if (bps_pages)
                        *pages = DIV64_U64_ROUND_UP(VTIME_PER_SEC, bps_pages);
                else
                        *pages = 1;
        }

Out of scope but this seems more like a bug in the DIV macros. The fact that
it returns 0 is an implementation artifact more than anything and a
surprising one at that as it ends up returning 0 for an input that a regular
division would handle just fine and the rounded up result fits well within
the result type.

Thanks.

-- 
tejun
