From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v7 1/9] blk-throttle: fix that io throttle can only work
 for single bio
Date: Wed, 17 Aug 2022 07:50:36 -1000
Message-ID: <Yv0qbDR+cxKeZ3nD@slm.duckdns.org>
References: <20220802140415.2960284-1-yukuai1@huaweicloud.com>
 <20220802140415.2960284-2-yukuai1@huaweicloud.com>
 <Yvvx+/d2+OMROUOe@slm.duckdns.org>
 <712e0f29-94ba-d3d3-ce21-cba4d6092008@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=pY3XHrB+Wi3bKxfBpJp50GFS99FF73DUvD5Y05CzuoI=;
        b=IHO0SHseMzeS46BS8DB8qYHNx/9K9Po2jDjannSsFW2u2SxIKIlUWdtLYliYqIwuAL
         RSHh9vvEhqVGPqkSk96CH9Z26mDMkYksVRag3woPYyGSI+AWvc/XeeEFsznYNqhTWPjx
         G01h0D/sR6Mz1fDC0eIZM4N4oID0PT/CS75Rg0jXj+Bjl8W8J6ymnhozLu9BdIVnZkKN
         tBZzWaKRxMnu22tL6TNYFspubTCbaM1VaVMEqhw4pw6LNCKtq6x4kaL7MP3PTw72htYo
         Y6XS0hjYg6M/LBS/V4fMQ56/tQdgJPS3WiGpXVgPZDFn4EAsjB0kXxKt8UAK0mQ5uxlk
         12PQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <712e0f29-94ba-d3d3-ce21-cba4d6092008@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mkoutny@suse.com, axboe@kernel.dk, ming.lei@redhat.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hello,

On Wed, Aug 17, 2022 at 09:13:38AM +0800, Yu Kuai wrote:
> > So, as a fix for the immediate problem, I guess this might do but this feels
> > really fragile. How can we be certain that re-entering only happens because
> > of splitting? What if future core development changes that? It seems to be
> > solving the problem in the wrong place. Shouldn't we flag the bio indicating
> > that it's split when we're splitting the bio so that we only limit them for
> > iops in the first place?
>
> Splited bio is tracked in __bio_clone:

As the word is used in commit messages and comments, the past perfect form
of the verb "split" is "split". It looks like "splitted" is used in rare
cases but dictionary says it's an archaic form.

> if (bio_flagged(bio_src, BIO_THROTTLED))
> 	bio_set_flag(bio, BIO_THROTTLED);
> 
> And currenty, the iops limit and bps limit are treated differently,
> however there are only one flag 'BIO_THROTTLED' and they can't be
> distinguished.
> 
> Perhaps I can use two flags, for example BIO_IOPS_THROTTLED and
> BIO_BPS_THROTTLED, this way only iops limit can be handled and bps
> limit can be skipped for splited bio.
> 
> What do you think?

I think the code would be a lot more intuitive and less fragile if we used
two flags but the bits in the bi_flags field are a scarce resource
unfortunately. Even then, I think the right thing to do here is using two
flags.

Thanks.

-- 
tejun
