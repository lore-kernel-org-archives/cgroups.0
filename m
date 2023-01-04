From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -next 3/4] block/rq_qos: use a global mutex to protect
 rq_qos apis
Date: Wed, 4 Jan 2023 11:39:47 -1000
Message-ID: <Y7XyIzGptuqO8EAt@slm.duckdns.org>
References: <20230104085354.2343590-1-yukuai1@huaweicloud.com>
 <20230104085354.2343590-4-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=36TwtFKmLPX5g03QeCQ9QWnvENyLGQhIqbG+q6J+tC4=;
        b=MVEhz8XYVOm249fCfkTEHVUxXxB1xpW83zjnPCXy3y9PbRLRWd6eiuNsJ0Du4UU0Xg
         p1A5rhECcWYEsdm0oVKS88LpiH4XucT/7MQi9soMAzW4dDLE6BvV8XiU+9L96ahoQc+p
         lHCorRYHnuq/CfuWx5q+XkcgkZCUF8QlCk5XHfceQzuL5x5lgi/BCxXxpZIymd2LBTCU
         HIxQq2IPptjH37DYJIzU4OnwyIT8obRgMuRGDhkq6V67bdqJolenAS7dEGlxCNN1g12c
         XGIn64Ygz+EeFa7ufq62xp+qMzDYGUsE9dTi4VocfJpFE7nfx7kxwdkbsa1W7ISHEbmc
         xilQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230104085354.2343590-4-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@infradead.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com

On Wed, Jan 04, 2023 at 04:53:53PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> This patch fix following problems:
> 
> 1) rq_qos_add() and rq_qos_del() is protected, while rq_qos_exit() is
>    not.

This part makes sense.

> 2) rq_qos_add() and blkcg_activate_policy() is not atomic, if
>    rq_qos_exit() is done before blkcg_activate_policy(),
>    null-ptr-deference can be triggered.

I'm not sure this part does. I think it'd be better to guarantee that device
destruction is blocked while these configuration operations are in progress
which can be built into blkg_conf helpers.

Thanks.

-- 
tejun
