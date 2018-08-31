From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 10/15] blkcg: remove bio->bi_css and instead use
 bio->bi_blkg
Date: Fri, 31 Aug 2018 11:46:21 -0400
Message-ID: <20180831154620.ivdpptlo7o6ipebu@destiny>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
 <20180831015356.69796-11-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GjuXbKG3zC5ZeoI1mrigFO88zTTATgokvREWmhDfYH0=;
        b=z122gRW94GqDvKrJxmwDyv5Yusp1xa5fclzTmIQdDt+xlqlJVnwo86dn+SAUJ8M1uf
         mriz637qSZ02mntaT7CCylWykPAI0bp58M164P9MjYJzeiIE1b13EfaoKF7Evfq3Nema
         x4+eFJJG7GrJMAakUVaARQmj3v8QPCR9vjfu9L2Wf6MnTgBjYVleAW3XiHa0xOOMFAo/
         lZlNDsQWPtcmVmKRBQGMDb3VQ5lUrGzIndyyYDuBTwKcuXy1QWF4J/oogPKYntHbdRu3
         7X7lVy4tkzPJiKyov5qVX3bxwz9IJUc6o6G33V+5sO+W+zYs4Cf4v9OZ6RepEjOrs0o/
         mJjQ==
Content-Disposition: inline
In-Reply-To: <20180831015356.69796-11-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

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

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
