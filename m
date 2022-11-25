From: Andreas Herrmann <aherrmann@suse.de>
Subject: Re: [PATCH -next 1/2] blk-iocost: fix divide by 0 error in
 calc_lcoefs()
Date: Fri, 25 Nov 2022 10:52:12 +0100
Message-ID: <Y4CQTKAKmUi9pxHU@suselix>
References: <20221124140635.695205-1-linan122@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1669369934; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j5gHcv1jP7rHDv6WjXG8/kTErobBs4ljiKSMXxDZAhA=;
        b=upDFs7ucUcwcvrOxapflk6090GnTUsxyfpe7ypzG7Rw/r8LOeyJIy1PZ0gp8pKWH0BNVkb
        6VmJx3qc3oAVmklDD8qhKrZ7LV+PnBTgTB1MF90M+YPmzvsQ4hx3mAAwHBRa3efFLvRQb6
        OgeTGI1KGRk1DeZKcJhHmEtuBm2V8g4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1669369934;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j5gHcv1jP7rHDv6WjXG8/kTErobBs4ljiKSMXxDZAhA=;
        b=tLDIqVAy/1R/0p89CwgBqnxXet1EO2WHqlAWHvau5gwhkeHic1UYCZ9rBA9AprOpFj97zg
        Eu7XC8iadP/J2rCA==
Content-Disposition: inline
In-Reply-To: <20221124140635.695205-1-linan122@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Li Nan <linan122@huawei.com>
Cc: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

On Thu, Nov 24, 2022 at 10:06:34PM +0800, Li Nan wrote:
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
> ULLONG_MAX, it can cause divide by 0 error.I_LCOEF_MAX is introduced to
> prevent it.
> 
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>  block/blk-iocost.c | 5 +++++
>  1 file changed, 5 insertions(+)

Looks good.
Reviewed-by: Andreas Herrmann <aherrmann@suse.de>

> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
> index f01359906c83..a38a5324bf10 100644
> --- a/block/blk-iocost.c
> +++ b/block/blk-iocost.c
> @@ -306,6 +306,9 @@ enum {
>  	IOC_PAGE_SIZE		= 1 << IOC_PAGE_SHIFT,
>  	IOC_SECT_TO_PAGE_SHIFT	= IOC_PAGE_SHIFT - SECTOR_SHIFT,
>  
> +	/* avoid overflow */
> +	I_LCOEF_MAX		= ULLONG_MAX - IOC_PAGE_SIZE,
> +
>  	/* if apart further than 16M, consider randio for linear model */
>  	LCOEF_RANDIO_PAGES	= 4096,
>  };
> @@ -3406,6 +3409,8 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
>  			goto einval;
>  		if (match_u64(&args[0], &v))
>  			goto einval;
> +		if (v > I_LCOEF_MAX)
> +			goto einval;
>  		u[tok] = v;
>  		user = true;
>  	}
> -- 
> 2.31.1
> 

-- 
Regards,
Andreas

SUSE Software Solutions Germany GmbH
Frankenstrasse 146, 90461 Nürnberg, Germany
GF: Ivo Totev, Andrew Myers, Andrew McDonald, Martje Boudien Moerman
(HRB 36809, AG Nürnberg)
