From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 1/9] blk-throttle: fix that io throttle can only work
 for single bio
Date: Sun, 21 Aug 2022 21:25:52 -1000
Message-ID: <YwMvgN0YxNvkC1gm@slm.duckdns.org>
References: <20220802140415.2960284-1-yukuai1@huaweicloud.com>
 <20220802140415.2960284-2-yukuai1@huaweicloud.com>
 <Yvvx+/d2+OMROUOe@slm.duckdns.org>
 <712e0f29-94ba-d3d3-ce21-cba4d6092008@huaweicloud.com>
 <Yv0qbDR+cxKeZ3nD@slm.duckdns.org>
 <83c8b253-2ebb-5af6-8ce1-6dc3b84cf182@huaweicloud.com>
 <b1791e41-4945-a0d8-8067-3841ce10fddd@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=msDkfbAvjPj8tG1+VbcyJyurZyD89z+69jjtCZT96Cw=;
        b=Wm8Ji1NHluqt74CopL6xSV0sx0lEWK55ZRr+ompfbpqjBuTbFHU8kiCO46OANmUSMP
         +I4sNY9RvnDKp3fB0C6rXVUNkiWkILHs2+xC1t+U2NHmbvSspDBomtr/f3aHzGVznzv/
         SaNQChOeWNEV1BOjEp3byhGvdsTZalvTGy9HQ9UcsA/bDVY4mIxl20ARf35ceYjgT4LI
         wKabvHKz4Bb3n66vzbfYgHaHWzE2gLVwbNq9SJrIAPwZNnA1+urGvpvqHxuFakHMQlBb
         t3P8IVcve2cLPI12k+dFsMDNBYWncQ+t0xzVus9MqggqoXYR/JadregHgH8nkRjEBUV+
         3AVw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b1791e41-4945-a0d8-8067-3841ce10fddd-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hello,

On Mon, Aug 22, 2022 at 11:06:44AM +0800, Yu Kuai wrote:
> While implementing the new method, I found that there seems to be a
> misunderstanding here, the code seems to try to add flag to split bio
> so that it won't be throttled again for bps limit, however:
> 
> 1) for blk throttle, split bio is issued directly and will never be
> throttled again, while orignal bio will go through throttle path again.
> 2) if cloned bio is directed to a new disk, the flag is cleared anyway.

Doesn't that make the current code correct then? But you were seeing
incorrect behaviors, right?

Thanks.

-- 
tejun
