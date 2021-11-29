From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next] blk-throttle: Set BIO_THROTTLED when bio has been
 throttled
Date: Mon, 29 Nov 2021 08:16:51 -1000
Message-ID: <YaUZExR6v8IdZUeM@slm.duckdns.org>
References: <20211118131551.810931-1-qiulaibin@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U/lV8E1L2sRsBwRPS+If7j1bCTz7XAKccet53yRJUbM=;
        b=E/V2jd5RtTT4t+mQMJCGTXfQJ5vhNpgk9p5ctLDOVJ2smfpN9GfGuTsgwFgP6gSR4q
         9isZVjEZ4A6h4kyVfNn0GB8jbgo1EFcyVyIrmGH9jWdFfwTgQcbIcQMtYYM8tPZJKoIN
         ZhNbUdFhmq4JZv4Om/B9nwLYWZabIjp+QtpSpnm7HYDTrwAPg9dqulgC13L61gpdYkVI
         HOR82Zo6pY5INibMkwItuLjQ0tlA+qEp21FDsrc0acq1oJb8nNKruIARFunKoJ56rMu4
         FfXc4XbveK3z2cLWl9LX+SiG6pC72bGbLrz6Q/OY0//UcVQqTcNeyxDXYQQL5P68KvRH
         OCFA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20211118131551.810931-1-qiulaibin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Laibin Qiu <qiulaibin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Thu, Nov 18, 2021 at 09:15:51PM +0800, Laibin Qiu wrote:
> 1.In current process, all bio will set the BIO_THROTTLED flag
> after __blk_throtl_bio().
> 
> 2.If bio needs to be throttled, it will start the timer and
> stop submit bio directly. Bio will submit in blk_throtl_dispatch_work_fn()
> when the timer expires. But in the current process, if bio is throttled.
> The BIO_THROTTLED will be set to bio after timer start. If the bio
> has been completed, it may cause use-after-free.
> 
> Fix this by move BIO_THROTTLED set before timer set.

Have you tried reproducing and confirming the above in any way?

> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 39bb6e68a9a2..ddfbff4465d5 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -2149,6 +2149,7 @@ bool __blk_throtl_bio(struct bio *bio)
>  	td->nr_queued[rw]++;
>  	throtl_add_bio_tg(bio, qn, tg);
>  	throttled = true;
> +	bio_set_flag(bio, BIO_THROTTLED);
>  
>  	/*
>  	 * Update @tg's dispatch time and force schedule dispatch if @tg
> @@ -2163,7 +2164,6 @@ bool __blk_throtl_bio(struct bio *bio)
>  
>  out_unlock:
>  	spin_unlock_irq(&q->queue_lock);
> -	bio_set_flag(bio, BIO_THROTTLED);

Because it seems wrong in two ways:

* This function is called synchronously on the issue path. The bio isn't
  seen by the queue and device driver yet and nothing can race to issue it
  before this function returns.

* Now we're not setting BIO_THROTTLED when we're taking a different return
  path through the out_unlock label and risks calling back into blk_throtl
  again on the same bio.

In general, if you think you spotted an issue, please try to trigger it in
however way possible to confirm that the issue is real.

Thanks.

-- 
tejun
