From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 01/15] blk-cgroup: don't defer blkg_free to a workqueue
Date: Sat, 28 Jan 2023 23:12:13 +0800
Message-ID: <Y9U7TZQtjnMd6snm@T590>
References: <20230124065716.152286-1-hch@lst.de>
 <20230124065716.152286-2-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674918745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g0QUGzoJoebh4v+PZGDYLFFagPOPP/ZNw/+BWJ9IUG4=;
        b=jA1Bi/0QFMudeRnQsH8J8zeTP0xVabpZkyVMVo8iVaHRaE9HAvTN9lk1OEZvd47tsnNPZ0
        4GOvROMdG27J5w2F1KSMNVN4aXVbHkYBSroDtLQMNCsLOG0mK5Sl6yndUi8WR0Pypdxjv+
        NFPESMcardyF+c+MBKF6tYv5mYeg/f0=
Content-Disposition: inline
In-Reply-To: <20230124065716.152286-2-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Andreas Herrmann <aherrmann@suse.de>, ming.lei@redhat.com

On Tue, Jan 24, 2023 at 07:57:01AM +0100, Christoph Hellwig wrote:
> Now that blk_put_queue can be called from process context, there is no

s/process/atomic?

> need for the asynchronous execution.
> 
> This effectively reverts commit d578c770c85233af592e54537f93f3831bde7e9a.

blkg_free() can be called with ->queue_lock, and:

- del_timer_sync(&tg->service_queue.pending_timer) is called from throtl_pd_free().

- queue_lock is required by throtl_pending_timer_fn

So there is deadlock risk if the above commit is reverted.

Thanks,
Ming

