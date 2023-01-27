From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 01/15] blk-cgroup: don't defer blkg_free to a workqueue
Date: Fri, 27 Jan 2023 12:33:39 -1000
Message-ID: <Y9RRQ9Ct5mjuDKq0@slm.duckdns.org>
References: <20230124065716.152286-1-hch@lst.de>
 <20230124065716.152286-2-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rSdAw5E+KQxTCwUtNIvKfHgNvmREZsFWtoKFr/X4fy8=;
        b=LEHvm5GH7a+hPuBabmJkDfk6RS0MfiLYbQszQTh1bik4tjbgiHIhqbbOx47udlnq7S
         qJCo4vSOeTQ1L8onby3CZ0gCiS+NemJhwGj4EVXyvRy8ro71sOkxfhc79cOmY69UM+x4
         Cohpz7ip1eNwpmz1IWseA8ax2zisxdEp1+brPvxf4s0q6bqKppxSEhGJZw4pMkis2rOA
         pmRkbJB/UnTy3oZBkt/9wDHhan6B4rDGMBEXZenVwMrYyvBYRBLqhssAug3ooPjG4OuU
         vl1jB+VLuZ/ZSJeWovFlzSn8NaKDTMAS5qlxE3ZFaizNX3kLdkUtdufjEfMVsfPuqUpi
         lwVw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230124065716.152286-2-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Andreas Herrmann <aherrmann@suse.de>

On Tue, Jan 24, 2023 at 07:57:01AM +0100, Christoph Hellwig wrote:
> Now that blk_put_queue can be called from process context, there is no
> need for the asynchronous execution.
> 
> This effectively reverts commit d578c770c85233af592e54537f93f3831bde7e9a.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Andreas Herrmann <aherrmann@suse.de>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
