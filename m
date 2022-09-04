From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] blk-throttle: clean up codes that can't be reached
Date: Sun, 4 Sep 2022 09:25:03 -1000
Message-ID: <YxT7jwsIM/bUQYoZ@slm.duckdns.org>
References: <20220903062826.1099085-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=vXBIjsLRZ8FiBLUcto9qpEu1lVOnihGBQ6Ve3aJE1jY=;
        b=OqJKP2Gt5ey7tjAktr/15wsBYApbFPipKi5BGFOd96+FL7FSCKa1YgpfPzsT6TAjho
         yeI+CpjbNfZc3egJ5vCzt/zmBNg6ErMLhd2oyeCSbWNoOao67ZKNYkfkphecFxjzYhVk
         tHXI07E62v40fdDQjeJxb2hDdG5yIzU6Pf7bBunpYAmC9QVPG7cHYo2774KVR/lIICvp
         YqtVVVxUhSKS6aUDr8/smybJ4oNCcHvX1bAwyweWL03Rbdvu7e2xI57D6GyQILyCDIo5
         01l5kPj/sZCQ5BNvCkG7ByiQ8LLCHy4kXsQPAm9HUE8tR6cxs+VfCb1qaPoOLFL+86i4
         i5gg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220903062826.1099085-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Sat, Sep 03, 2022 at 02:28:26PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> While doing code coverage testing while CONFIG_BLK_DEV_THROTTLING_LOW is
> disabled, we found that there are many codes can never be reached.
> 
> This patch move such codes inside "#ifdef CONFIG_BLK_DEV_THROTTLING_LOW".
> 
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

.low never really worked well. We might as well try removing it.

Thanks.

-- 
tejun
