From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] blk-throtl: optimize IOPS throttle for large IO
 scenarios
Date: Fri, 30 Jul 2021 06:07:01 -1000
Message-ID: <YQQjpQEBbdAgMUM7@mtj.duckdns.org>
References: <40915233274d31bb0659ff9f3be8900a5a0e81ba.1627462548.git.brookxu@tencent.com>
 <YQLhRrkZrmKTzfbP@mtj.duckdns.org>
 <1ce9bcbb-8eea-f51f-f80a-22caf5f2e0d8@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3CUKiPjVhRqbcpNjTZQwL56wlHZezFNK9/SuBkCMsYo=;
        b=Vitr0fqnQypj1qamhMaglBiB17MtNukUrISqQJQNwvJadI4SCPnZhFi5tVzRGDziQL
         TzZG/rVZrnvwJfYIY7xVlSslwlEWcoIQl1bnmZLvpmUQExTJ7SmC5cI7Tm7l+nxlcbax
         McUoJYyyJLoaFecRt8ixolN7evBlu7UTi+yRS5E3stLpmQNPgyd+MAzfxPyS9e3LxRca
         eYAUm7mr0WFq9XGmpHtFu5eKuRF6SCw1Mmc5QEJnkrj/jNRGXoX9mzSmq/GZsMc1ikh2
         rVj66/ueTDslhkUmgwR1VnvDvPE7wNwj4StGN/KdPrDF1PgpDFzFt6lMx/5gCpBw+dFo
         JeKQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1ce9bcbb-8eea-f51f-f80a-22caf5f2e0d8-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jul 30, 2021 at 10:09:34AM +0800, brookxu wrote:
> >> @@ -877,10 +900,19 @@ static inline void throtl_trim_slice(struct throtl_grp *tg, bool rw)
> >>  	else
> >>  		tg->bytes_disp[rw] = 0;
> >>  
> >> -	if (tg->io_disp[rw] >= io_trim)
> >> +	if (tg_io_disp(tg, rw) >= io_trim) {
> > 
> > Instead of checking this in multiple places, would it be simpler to transfer
> > the atomic counters to the existing counters whenever we enter blk-throtl
> > and leave the rest of the code as-is?
> 
> If we do this, we need to do similar processing on the bio submission path and the bio
> resubmission path in pending_timer. It seems that the code is more complicated?

Yeah, basically whenever we enter blk-throtl. Factored to a function,
calling it on entry should be fairly clean, right? I wonder whether it'd be
better to consolidate all atomic counter handling in a single location and
all it does is transferring whatever's accumulated to the usual counters.
Also, when you're reading & resetting the atomic counters, can you use a
pattern like the following?

  main_counter += atomic_xchg(counter, 0);

Right now, there's a race window between reading and resetting.

Thanks.

-- 
tejun
