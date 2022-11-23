From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 07/11] blk-throttle: remove incorrect comment for
 tg_last_low_overflow_time
Date: Wed, 23 Nov 2022 08:27:17 -1000
Message-ID: <Y35mBVQgYgCvmZhz@slm.duckdns.org>
References: <20221123060401.20392-1-shikemeng@huawei.com>
 <20221123060401.20392-8-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jkuJbkh43Co2UTSXb2C1Aswe4Vf/cx6MZjOFratu/Lw=;
        b=hfWyPvgKFj2qty6cIV8tWczPoJ4XrP/IZZ1+V4y5pp8rSQGcIDdvFreSqpWEBv5CQ4
         vWL2hd6JPKq9sP+uI8BDjxBqMtSWlW0weiK/inhIiTSc0tjRWRCRKtsOCyDpLpqNu+1W
         vxmUZBu/1+E/CjQ3sJrA4efID7j/03XQmq9HFXGB+7Y8gQlnL+16spK6JaC8j/kg0FYk
         kWElj4INXjenT6DPZTE+883OchrAYlz+xRgEqrf1f91aT01XjsgWZjr60bKHngT7eeWv
         yMeJGF9Hy0Yyx/ylZjuUEQrWrJ0UJPf0sgGmz8071zpKHfRHDq6PtyTipIjwsrGi9J8X
         Ddug==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221123060401.20392-8-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Nov 23, 2022 at 02:03:57PM +0800, Kemeng Shi wrote:
> Function tg_last_low_overflow_time is called with intermediate node as
> following:
> throtl_hierarchy_can_downgrade
>   throtl_tg_can_downgrade
>     tg_last_low_overflow_time
> 
> throtl_hierarchy_can_upgrade
>   throtl_tg_can_upgrade
>     tg_last_low_overflow_time
> 
> throtl_hierarchy_can_downgrade/throtl_hierarchy_can_upgrade will traverse
> from leaf node to sub-root node and pass traversed intermediate node
> to tg_last_low_overflow_time.
> 
> No such limit could be found from context and implementation of
> tg_last_low_overflow_time, so remove this limit in comment.
> 
> Signed-off-by: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

-- 
tejun
