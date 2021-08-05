From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] blk-iolatency: error out if blk_get_queue() failed in
 iolatency_set_limit()
Date: Thu, 5 Aug 2021 07:17:24 -1000
Message-ID: <YQwdJJGyfps4LOr2@mtj.duckdns.org>
References: <20210805124645.543797-1-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aeznxgD24jZUGLqeC6ba+2bQU799mhJW42UJ+HP+wes=;
        b=vdk72yFgYSJ1Mbr4WNf8h9/wyfm2yTsTlyxEzcqA3AGvLh34N8Zt0GGOTRLdP4PZi+
         Z+Pj7jUuADp4733zTRExd6Iwsu5QZVwvnygRTce7ppWowaM83Uh0aaNCdJZ+dzhvT63O
         sswiKUF5AOPR23+v70UdvD3Nb09LucbaIrofEonDWZ3a/fTvc5JR9U4i9R1bqQLmJey0
         X0iCa8RWRlFwxfl5kIlvIZbNFqGGWUzn236dYUpqenAzpSAUwIS0JLGPUxoTN57vqaSa
         N3xviedoW42ihel+eqTjEEp54OnfGeHnyog76XI/k+wf37GxkZQrlP5JSSXSz/bLWYQy
         UP7Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210805124645.543797-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, bo.liu-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Thu, Aug 05, 2021 at 08:46:45PM +0800, Yu Kuai wrote:
> If queue is dying while iolatency_set_limit() is in progress,
> blk_get_queue() won't increment the refcount of the queue. However,
> blk_put_queue() will still decrement the refcount later, which will
> cause the refcout to be unbalanced.
> 
> Thus error out in such case to fix the problem.
> 
> Fixes: 8c772a9bfc7c ("blk-iolatency: fix IO hang due to negative inflight counter")
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
