From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] blk-cgroup: set blkg iostat after percpu stat aggregation
Date: Mon, 14 Feb 2022 08:59:26 -1000
Message-ID: <Ygqmjsbu96+UZDw+@slm.duckdns.org>
References: <20220213085902.88884-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b9IZjTswnZ1iUB9QT+cr1Wj9o8flIHUShxrRz7LR2AY=;
        b=hq4XAe/+8zUJOL7TaevyVlyRAm0inKyh0npqK/CTm41Cd4954DnlPK/JP2Pf+d2Zlz
         ec+rIRhHieKvs8YzlFJ8I7Q3Bbd1daycnvc2MB5yQCQGkvJyX9eggG7E9VRYWrMKZfl0
         7xGINYcqaJOdATGQyx+FgOkhdCi5iPKDgOv8DSKuhOOLKBYAiYRHqlsohInZN++DNr3V
         ciVownfJPlGcIQwi6GZH5T0b7UnAX0OvcMsdXfmaBuFD1V0xVrPLhqVFLgz2ruwHflin
         2C7BxdkSlgAXUBEI7Mo38KYeMczl2swk0w+dbefn4GbwIuidwHH+yKAbu0xK+q0vSjQI
         5LHg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220213085902.88884-1-zhouchengming@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming@bytedance.com>
Cc: axboe@kernel.dk, boris@bur.io, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, Feb 13, 2022 at 04:59:02PM +0800, Chengming Zhou wrote:
> Don't need to do blkg_iostat_set for top blkg iostat on each CPU,
> so move it after percpu stat aggregation.
> 
> Fixes: ef45fe470e1e ("blk-cgroup: show global disk stats in root cgroup
> io.stat")

I'm not sure Fixes tag is necessary here.

> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>

but other than that,

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
