From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 5/5] blk-iocost: change div64_u64 to
 DIV64_U64_ROUND_UP in ioc_refresh_params()
Date: Wed, 4 Jan 2023 11:48:43 -1000
Message-ID: <Y7X0O910GBm/zB9r@slm.duckdns.org>
References: <20221226085859.2701195-1-yukuai1@huaweicloud.com>
 <20221226085859.2701195-6-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Kn0mw+HyY9jD6nVegketh+9oP4bvjOwnt4T3S5lMN4k=;
        b=oSBIFS3lQw/ho5ZV8fR2DJe2VfEGp02hP+GWAFf49EAu7rer/fkCo+EeozXc+N+9ae
         7BoOHdRhElv5q7X1mgvnmc0PyZgyg++4lbc0rM4UiUtHJC3iC6Eqt3dbVtHaw6MRd/KR
         /xWfnhB5cc4inU72pw02pHZTM2yW93JG24AC6NRHVDmzAJkTV4VOmLl19o290Zh9tqrC
         kCPFD5+eEX9dszZKjL2yufzj4DVfLCQBvjz4vWOsS4Z4X3lTNguY2XXSG147ra2dfupa
         JxxOKCMlp4KVDE/cq/HxQ28rBil/x5XvSCIzkJeeT7Hw+rRh/mi5OXateR6g6x0wnmhO
         GShA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221226085859.2701195-6-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Mon, Dec 26, 2022 at 04:58:59PM +0800, Yu Kuai wrote:
> From: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> vrate_min is calculated by DIV64_U64_ROUND_UP, but vrate_max is calculated
> by div64_u64. Vrate_min may be 1 greater than vrate_max if the input
> values min and max of cost.qos are equal.
> 
> Signed-off-by: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
