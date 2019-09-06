From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3 0/3] Implement BFQ per-device weight interface
Date: Fri, 6 Sep 2019 14:34:17 -0600
Message-ID: <437c831d-179e-f8a3-5687-f93459d28b53@kernel.dk>
References: <20190828035453.18129-1-zhengfeiran@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jG4+RgP/pviUKJ8QbJcP8qw2XnaK/vU+SiEUpD2jM1E=;
        b=OBMSFHpUBrpgwRkuVSPuBXbTZeB7AfzZ02OBd9Cgdn1S+8h270Jx/KJtcH8H2re6K/
         QknBx24vAAsFHkJy9KIFbcB9pHKUvQoYsGTRPYmsbO301vXvzn3C32XPJki9Yc9mYaPr
         M4RSGBUaA7CAlN6Kupdt8WteuEj7jN26aRtadlJ57R/wGEm5knMLk2IHvMlHwOhuJ/CQ
         3pMYOyWHvBo/daB2+3QR4DK7BVvaFF/QuYl/SvP4fKHkFXgMuTbiRj5QzgSU6thfzqsK
         n9lUD14fI+mG59+DGd61uprySi1oepwNw6B7eqNFFeFptt9dhedT82pelGc+watqkcWU
         TP0A==
In-Reply-To: <20190828035453.18129-1-zhengfeiran@bytedance.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Fam Zheng <zhengfeiran@bytedance.com>, linux-kernel@vger.kernel.org
Cc: paolo.valente@linaro.org, fam@euphon.net, duanxiongchun@bytedance.com, cgroups@vger.kernel.org, zhangjiachen.jc@bytedance.com, tj@kernel.org, linux-block@vger.kernel.org

On 8/27/19 9:54 PM, Fam Zheng wrote:
> v3: Pick up rev-by and ack-by from Paolo and Tejun.
>      Add commit message to patch 3.
> 
> (Revision starting from v2 since v1 was used off-list)
> 
> Hi Paolo and others,
> 
> This adds to BFQ the missing per-device weight interfaces:
> blkio.bfq.weight_device on legacy and io.bfq.weight on unified. The
> implementation pretty closely resembles what we had in CFQ and the parsing code
> is basically reused.

Applied, thanks.

-- 
Jens Axboe

