From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -next v2 1/4] blk-throttle: print signed value
 'carryover_bytes/ios' for user
Date: Tue, 29 Aug 2023 12:17:52 -1000
Message-ID: <ZO5ukKSulqnCviAs@slm.duckdns.org>
References: <20230816012708.1193747-1-yukuai1@huaweicloud.com>
 <20230816012708.1193747-2-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693347474; x=1693952274; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BpZA2JcHwH/YVwVIjbgRb69BfPVjsSUKqWdoLWaX5IU=;
        b=Rn/1Js/KDV0Yr/7/oRlebVVeYNY8jb3g/STkLRFGJZ4h3NepPW8qIVA/OZI/LVrCnp
         1fSAV8boAnS6n1lRv0Niti8qBGNS6Cx0AbcGiAqQuSg4Mp2ILgJR3Y3wwloCjIQQ+Ol1
         DDNrj1PoJuYS6SvX+Apl3/I1AbpAhf8beg7+04dmvd/I+ufbx4X/SVyg2lB6rVaSezsc
         UHjrKJzWHWsUDgShL22Tz8jpNV+IWj1dvrrZbzkJvSmm/fwV9gtnJKb6Xnm5daIhsvmj
         uB2CjTkaI4D8lvClzZASiwzxN1L5DpSDffgtmtu1Fs6ZC5uBxoun7axKPHcfwflP6NB9
         /Dpw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230816012708.1193747-2-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: josef@toxicpanda.com, axboe@kernel.dk, yukuai3@huawei.com, mkoutny@suse.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com

On Wed, Aug 16, 2023 at 09:27:05AM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> 'carryover_bytes/ios' can be negative, indicate that some bio is
> dispatched in advance within slice while configuration is updated.
> Print a huge value is not user-friendly.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
