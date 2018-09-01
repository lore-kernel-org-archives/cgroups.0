From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 13/15] blkcg: change blkg reference counting to use
 percpu_ref
Date: Fri, 31 Aug 2018 17:31:59 -0700
Message-ID: <20180901003159.GK1488037@devbig004.ftw2.facebook.com>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
 <20180831015356.69796-14-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ojr44WcL9JloHkAG32yJd+JB5DekUlgrznnwrkKSSJ0=;
        b=HIwL1EDOpifB9LPjiuImCUovu6gdxbO+p9an9ARPJNqoGshbDu0kLq7M1U5nbtI+jM
         xw97Wx1fUqg4ppq0gda9FqNeJzrRi0cIjxWkEALuD1qqbl+CXSKAQN4KIjBYmASn7KtZ
         V2lm2+Ss+4PSFaBRMN3hOv6T+ne3B5Bijyt3toTvkiFE5T5Ljgdqw51An4x+QU3S2k2X
         vy30jqTcUtXCL9HomopiwKxASpmjEQds29er0ICLgrSDMUoSWEHyZwoHLgiUoEsP+OJh
         X/WM9GJQmP6o4SsKqn/7YAJuzsTi7onTF5bdA9tWDVaWkyn3bWdEI182l/DOFBl2tdXx
         2Wfw==
Content-Disposition: inline
In-Reply-To: <20180831015356.69796-14-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 30, 2018 at 09:53:54PM -0400, Dennis Zhou wrote:
> @@ -217,6 +240,10 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
>  		blkg_get(blkg->parent);
>  	}
>  
> +	ret = percpu_ref_init(&blkg->refcnt, __blkg_release, 0, GFP_KERNEL);

So, while this would work in some configs, you can't depend on RCU
grace period inside percpu_ref.  blkg is now percpu-reference counted
and rcu protected object - it has to explicitly go through a rcu grace
period before release.

Thanks.

-- 
tejun
