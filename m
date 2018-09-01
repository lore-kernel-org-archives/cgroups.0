From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 10/15] blkcg: remove bio->bi_css and instead use
 bio->bi_blkg
Date: Fri, 31 Aug 2018 17:13:05 -0700
Message-ID: <20180901001305.GH1488037@devbig004.ftw2.facebook.com>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
 <20180831015356.69796-11-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eS6f5x9QRtUQLe+IeCikEV1hkReNWR6GYSjT0Lq+71Y=;
        b=M8xttScUFJyuvz1zHO1NTKccoau1IuP3u72/cTX+2pGScsRExcnI92fDJ0vI1kh22Q
         5VAWP+vV37QxVk4udfvndj9gWc77HaTnPdefqoOlkmc2QGYAH3eou6dObovxs7Jvs1Yf
         cx/3Zk/hRdzqsB3zEnSaT27+9IpVkDS9+qWdjoOg0tgLmwuQysMIrY1xwSWKSqlDz1E7
         YxZHVUeVn1gnlkHegN1BVFnkOpVqA1Rm24HwO3Zf7E5akn04GewsaH1eXEz9gxDhBAF/
         nB9cinF2ERcBawLBMbpN9NO3spQpqEzunzKzMaCNhUMmoXI5bt0tJMDja1VqHbEClfbL
         XaHw==
Content-Disposition: inline
In-Reply-To: <20180831015356.69796-11-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Aug 30, 2018 at 09:53:51PM -0400, Dennis Zhou wrote:
> From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>
> 
> Prior patches ensured that all bios are now associated with some blkg.
> This now makes bio->bi_css unnecessary as blkg maintains a reference to
> the blkcg already.
> 
> This patch removes the field bi_css and transfers corresponding uses to
> access via bi_blkg.
> 
> Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
