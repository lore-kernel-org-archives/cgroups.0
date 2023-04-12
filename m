From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] blk-stat: fix QUEUE_FLAG_STATS clear
Date: Wed, 12 Apr 2023 07:12:53 -1000
Message-ID: <ZDbmlYIrRpkWRZla@slm.duckdns.org>
References: <20230412160754.1981705-1-chengming.zhou@linux.dev>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681319575; x=1683911575;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dSVn8k9Iy2lv6cYKmPXJRFy7/1j4dCRyeMR+P+kHP9s=;
        b=Vm0yTlaxfj0mkM1OMk6w702fv0lCHyPPKK1wFDHLEBg8wEDgQKYaM7uQwJ/2HxKZly
         pnBYN17K6zKbuOn64ERSrTiD33ydFcCQVN+GSvQURR6Nzyx+9zvl6qFr3iLe0MhziFjt
         SvcivMdT1Ei+O77Gw6Ccr+e/G2ZC5ZnwWuwLgZ3a1rhpxRwG6Z9oFGhgJ2+03KKQEQYL
         UH1XNv23JqW6eWhbS+ozo1swoyo/+vyvqCaEjI0XgvZoPfbrVrGfVyX+OBnZLhEpmTjd
         E/YGui7kLu8X1l35IMFhGSs3LYfIQZYjv5DeLUUM6WMHkdSt5LD1fmzXHTYxVNZ1NM1E
         0Xfw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230412160754.1981705-1-chengming.zhou@linux.dev>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: chengming.zhou@linux.dev
Cc: axboe@kernel.dk, josef@toxicpanda.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Chengming Zhou <zhouchengming@bytedance.com>

On Thu, Apr 13, 2023 at 12:07:53AM +0800, chengming.zhou@linux.dev wrote:
> From: Chengming Zhou <zhouchengming@bytedance.com>
> 
> We need to set QUEUE_FLAG_STATS for two cases:
> 1. blk_stat_enable_accounting()
> 2. blk_stat_add_callback()
> 
> So we should clear it only when ((q->stats->accounting == 0) &&
> list_empty(&q->stats->callbacks)).
> 
> blk_stat_disable_accounting() only check if q->stats->accounting
> is 0 before clear the flag, this patch fix it.
> 
> Also add list_empty(&q->stats->callbacks)) check when enable, or
> the flag is already set.
> 
> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>

Acked-by: Tejun Heo <tj@kernel.org>

It'd be useful to explicitly illustrate the buggy behavior in the
description (e.g. if you do X, Y and then Z, then X incorrectly loses
accounting). Can you also please add the appropriate stable cc?

Thanks.

-- 
tejun
