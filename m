From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH] blk-throttle: dispatch more sync writes in block
 throttle layer
Date: Mon, 8 Jan 2018 04:07:42 -0800
Message-ID: <20180108120742.GJ3668920@devbig577.frc2.facebook.com>
References: <f6f59e3c-456a-8275-8af0-32e4f2e5cdd6@gmail.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=W20sQLDvzZrZQulfIWBiwl/K34cjIr8zLpmZOdG8Waw=;
        b=EbtMJi9jElZbegrq5PO+hbhAMzIl+afPt0Wr8HpmkvdGh6EAEXXiBjcB1MYBxuW52L
         PXMEkkvrIeEaczwgQv9Wd5QQdGl5CVUMdfozPUtKV/fQM4txVALA7Sa22EgCv47GFyFQ
         BrgSRZyrnQv1V6IguaXj7Mhp+a/qZNXnsXlpLYrrUWMOqAsGzngEJtKFp510wy/rya+M
         +W0Hg7udrcuCrS/gZ9n50aXsP4jccnO/r1QUH3EB2YtcKmtUfRC4Yhsj+KVuQqMGDjcm
         /N+nx0Qa1EwWFY1FjHXrYGpI2WLD6UPmzvxlybORIrIIZuYa/PPkAbDnfCVmsK3v8P67
         JZWg==
Content-Disposition: inline
In-Reply-To: <f6f59e3c-456a-8275-8af0-32e4f2e5cdd6@gmail.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: xuejiufei <xuejiufei@gmail.com>
Cc: Jens Axboe <axboe@fb.com>, Shaohua Li <shli@kernel.org>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, jinli.zjl@alibaba-inc.com, qijiang.qj@alibaba-inc.com

Hello,

On Fri, Jan 05, 2018 at 01:16:26PM +0800, xuejiufei wrote:
> From: Jiufei Xue <jiufei.xjf@alibaba-inc.com>
> 
> Cgroup writeback is supported since v4.2. But there exists a problem
> in the following case.
> 
> A cgroup may send both buffer and direct/sync IOs. The foreground
> thread will be stalled when periodic writeback IOs is flushed because
> the service queue in block throttle layer already has a plenty of
> writeback IOs, then foreground IOs should be enqueued with its FIFO
> policy. The current policy is dispatching 6 reads and 2 writes during
> each round, sync writes will be significantly delayed.
> 
> This patch adds another queue in block throttle. Now there are 3 queues
> in a service queue: read, sync write, async write, and we can dispatch
> more sync writes than aync writes.

We usually handle sync writes together with reads instead of
introducing a separate queue for sync writes.

Thanks.

-- 
tejun
