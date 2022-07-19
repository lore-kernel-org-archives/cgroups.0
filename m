From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] block: don't allow the same type rq_qos add more than
 once
Date: Tue, 19 Jul 2022 05:50:16 -1000
Message-ID: <YtbSuMqmrwGmAZti@slm.duckdns.org>
References: <20220719070258.25721-1-hanjinke.666@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1KmDVlh31ZPGT/1gu3CgqryQOvMMNoshEj5LmQLClLE=;
        b=CF2Yl7/YP6QIiN+4C38UCBemOvDUzg7jlB4d1bqOkoD5yqqrJB+CRjWnNPHNlMgnu+
         sEHUhgCfdAlKwXHI/PmOSb1YvCYyiwG1O6dWPjunb+ExP0lN64xjqmEH93/2nrrD5XZ6
         N+pHWdcCKLfvI1mDWoLpIASJOORCjdgYfVpZzvo7/4exGllQykD5IexOfM+o02tkzLE/
         OIbRgvakahk0q70n3fYO/zz2Vsjd2Q23JtRKHT4gS24Xmo874q9vUSkafxEMuQ5UgR+1
         arPPp2PTOhN9BEo3i3LBk+xEy81ckUNH3Ck74QxAUAykiY5kjrK2ZIud4cL7Q9iNvME6
         yyYQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220719070258.25721-1-hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jul 19, 2022 at 03:02:58PM +0800, Jinke Han wrote:
> From: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> 
> In our test of iocost, we encounttered some list add/del corrutions of
> inner_walk list in ioc_timer_fn.
> 
> The reason can be descripted as follow:
> cpu 0						cpu 1
> ioc_qos_write					ioc_qos_write
> 
> ioc = q_to_ioc(bdev_get_queue(bdev));
> if (!ioc) {
>         ioc = kzalloc();			ioc = q_to_ioc(bdev_get_queue(bdev));
> 						if (!ioc) {
> 							ioc = kzalloc();
> 							...
> 							rq_qos_add(q, rqos);
> 						}
>         ...
>         rq_qos_add(q, rqos);
>         ...
> }
> 
> When the io.cost.qos file is written by two cpu concurrently, rq_qos may
> be added to one disk twice. In that case, there will be two iocs enabled
> and running on one disk. They own different iocgs on their active list.
> In the ioc_timer_fn function, because of the iocgs from two ioc have the
> same root iocg, the root iocg's walk_list may be overwritten by each
> other and this lead to list add/del corrutions in building or destorying
> the inner_walk list.
> 
> And so far, the blk-rq-qos framework works in case that one instance for
> one type rq_qos per queue by default. This patch make this explicit and
> also fix the crash above.
> 
> Signed-off-by: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
