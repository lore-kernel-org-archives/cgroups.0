From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 01/15] blk-cgroup: don't defer blkg_free to a workqueue
Date: Mon, 30 Jan 2023 08:01:24 -1000
Message-ID: <Y9gF9DEx8zDKVDTE@slm.duckdns.org>
References: <20230124065716.152286-1-hch@lst.de>
 <20230124065716.152286-2-hch@lst.de>
 <Y9U7TZQtjnMd6snm@T590>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I4D1Ztp5PXdnjePzURg65Mwo279xYxNPa3f1/sKE5u4=;
        b=P28ybXbqk2lUQqqrphJjk3zFN2/7Ucbw6CuzRIwJahxQ7K4MRZhALIYagoVDPYFWjO
         2Q51er32H9qfSTZNepRmTyVQVLX0Rm+jkg7cfMgfc0qSjN4hapg6vklx6rESi+CO2fXb
         0BbWtRy04i1kxXbSo2XE+PuSBJ61G5jC1vtiOfX8sFv/VUOtNnOr3pu9UiLNAL1Ee+k5
         purXcAwlBZ7hzw7sq/D5XmM3rA2DXDf+PVaGnP98DKpIv81uKcSpQLxmHPSw9rPWdtm/
         7cGZkdwSqjpQKym7TFguaUgvz5qaW/UdQ8e8z0OatL+23U6Hi50W1eG4ngJa84Iryd0k
         /o/g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Y9U7TZQtjnMd6snm@T590>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>

On Sat, Jan 28, 2023 at 11:12:13PM +0800, Ming Lei wrote:
> On Tue, Jan 24, 2023 at 07:57:01AM +0100, Christoph Hellwig wrote:
> > Now that blk_put_queue can be called from process context, there is no
> 
> s/process/atomic?
> 
> > need for the asynchronous execution.
> > 
> > This effectively reverts commit d578c770c85233af592e54537f93f3831bde7e9a.
> 
> blkg_free() can be called with ->queue_lock, and:
> 
> - del_timer_sync(&tg->service_queue.pending_timer) is called from throtl_pd_free().
> 
> - queue_lock is required by throtl_pending_timer_fn
> 
> So there is deadlock risk if the above commit is reverted.

Ah, good catch. Looks like we'd have to leave this async.

Thanks.

-- 
tejun
