From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 3/3] bfq: Add per-device weight
Date: Wed, 21 Aug 2019 08:44:02 -0700
Message-ID: <20190821154402.GI2263813@devbig004.ftw2.facebook.com>
References: <20190805063807.9494-1-zhengfeiran@bytedance.com>
 <20190805063807.9494-4-zhengfeiran@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WsaM9eIl3JXCekJs4SyvVa1WU1qEuim85t6paiIn/CI=;
        b=gBwwCIlRoRsncPrLfulxtiNtBqDslrrk01qoUakj7ROxgUCe2Z1Jkie5QrOYx6cy1t
         ittH90Nf5mi+zTDNL+DT/YD22t+Gq4e4G1xT2KXF/IWYBadFqyiJVb1YtkbDxqokGJbz
         2FUoS6prtlCz8ZqXUlLW/C+7dfISWWedqHkc26+Sgeb1Mqp2ByRaRx/BYT26Raskd9fG
         dZjhnF77bE+uuLLYKItQJogKGqIj7IlYf1ScdYDDqpVrQjz0D4D0XBpaB0hrYBHvxLq/
         4vetyes91YzvtHonebCbwxVB9w4U7blReA094/muNGax4e8R6EiuBSsk9XlEvN3/ON/Q
         mn7Q==
Content-Disposition: inline
In-Reply-To: <20190805063807.9494-4-zhengfeiran@bytedance.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Fam Zheng <zhengfeiran@bytedance.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, fam@euphon.net, paolo.valente@linaro.org, duanxiongchun@bytedance.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, zhangjiachen.jc@bytedance.com

On Mon, Aug 05, 2019 at 02:38:07PM +0800, Fam Zheng wrote:
> Signed-off-by: Fam Zheng <zhengfeiran@bytedance.com>

Looks good to me.

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
