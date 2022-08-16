From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v7 9/9] blk-throttle: clean up flag 'THROTL_TG_PENDING'
Date: Tue, 16 Aug 2022 10:14:10 -1000
Message-ID: <Yvv6kk/RD5LT+3dk@slm.duckdns.org>
References: <20220802140415.2960284-1-yukuai1@huaweicloud.com>
 <20220802140415.2960284-10-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=On1R2Y8AoucYEJFBb7wUMfr4hWcYeJkV168ieP6Z2g4=;
        b=KCSRHVGOwuHJOs5RySQuX1ydgSX8WoQhwhNOSug+NPzjoTuHqcmpa9cH3RYLlUCMVT
         +uh87JahRJ4IuLXxnNILjXvjGSyG5KWEd+O4+tB0Nz+Ufx4YOtRwO6+nd7/lmF6SCpyT
         Q4oYoaelxxzQ4prHEyPmUK9joLJGMgVdmZZhssaZRscUjX9kxZABaACsWyI7ptN8wR+4
         BpIb4NHASyZdMM1tn9EgkSCQFJv+XuPW04lPWOUw4gZBgzVEPJX3E8jETyiYb1PF0Fkd
         1zf8OJ2VXIblEtXnpZKTxAKUbnqDt5f7CvSROs/RIvvbEw240Qe2bnbz80aOm5OrGfi/
         xh3A==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220802140415.2960284-10-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mkoutny@suse.com, axboe@kernel.dk, ming.lei@redhat.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

On Tue, Aug 02, 2022 at 10:04:15PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> All related operations are inside 'queue_lock', there is no need to use
> the flag, we only need to make sure throtl_enqueue_tg() is called when
> the first bio is throttled, and throtl_dequeue_tg() is called when the
> last throttled bio is dispatched. There are no functional changes in
> this patch.

I don't know whether this is better or not. It's minutely less lines of code
but also makes the code a bit more fragile. I'm ambivalent. At any rate,
please move these trivial patches to the head of the series or post them
separately.

Thanks.

-- 
tejun
