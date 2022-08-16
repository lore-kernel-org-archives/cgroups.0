From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v7 8/9] blk-throttle: cleanup tg_update_disptime()
Date: Tue, 16 Aug 2022 10:09:14 -1000
Message-ID: <Yvv5as5BVuqjw6PX@slm.duckdns.org>
References: <20220802140415.2960284-1-yukuai1@huaweicloud.com>
 <20220802140415.2960284-9-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=7SZ5VenNztRnLFMOBFO6xbar+Rfw+Z2OdJF35tqn830=;
        b=Sv5fxKlBKbSA8SlxCHfQb1M2em94RKvPRcxL/wwLsjCiAN9/eRlU2+H9PV2e2/jKmD
         FBkwSe5eyT2dPJlpma0nD6U5hNSdQgrvOMMFC6jGBSn2GAr9ui2aF8fvi2nLhtknnxKE
         vF0C5HXVsbDGUO/556VYSl6E0FcV19MaVH3gvZsuF5E2u0HMdiTo2Y1nw+aI0hUHIrTw
         fvpbvoGZHzZa9q4u0qGZ/j6sVHQQB8WbQNH+Lp5Au+zorDBqIYDqLJHT/vo1duT0llkw
         R7I7c7y0uLpd9mwmev7S3VPT9jz1MSFJT0lBN27Es5G4/kgqezl4EaGzn5edvG3mnMK7
         T46A==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220802140415.2960284-9-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mkoutny@suse.com, axboe@kernel.dk, ming.lei@redhat.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

On Tue, Aug 02, 2022 at 10:04:14PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> tg_update_disptime() only need to adjust postion for 'tg' in
> 'parent_sq', there is no need to call throtl_enqueue/dequeue_tg().
> 
> Save a little overhead in tg_update_disptime() and prepare to cleanup
> flag 'THROTL_TG_PENDING', there are no functional changes.

Does this actually help anything? Given that the heavy part of the operation
remains the same, this might not be much of an optimization. Is there even a
microbench that can show the difference?

Thanks.

-- 
tejun
