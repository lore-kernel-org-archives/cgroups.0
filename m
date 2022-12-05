From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH v3 1/9] blk-throttle: correct stale comment in
 throtl_pd_init
Date: Mon, 5 Dec 2022 13:43:26 -0700
Message-ID: <be8563d8-1992-f9bc-928f-e9e5f3227c1c@kernel.dk>
References: <20221205115709.251489-1-shikemeng@huaweicloud.com>
 <20221205115709.251489-2-shikemeng@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QllzgBmKfeFLd2Tk+Su9MVLerqnhHMQ0mpp6R6EDUXA=;
        b=mKvQCyVr71vjuMH69/4lkzgJiGF88wXIISBmVb+39eLRquY/w9CfmCxsVQU6U2qnv7
         HVV7LsRKb/hwJtni3Bwk7o2yKUYdHUHm9WwEZbh9eTfMZP92J5kfYnBphxhJ9maf5Xyg
         hShv0t6sZeoHAfadns2kCGyDLXYqxPzkY6Z6T2WSSH056KMwtzUnBjkzPYrFmSGqQGYL
         iaLSU1idIPd1OFX38X4J9cNzp0rm8g0nPCy6f+RIxgnVWwz5NoDgSvbCwSRwnI6kITIq
         AylZNXoHhJJc0UKD3uhrkDsdoe1bk633bTf8O2U2DAP0PUGY0mBKLX6Qjp02/dUpYOaT
         A8bQ==
Content-Language: en-US
In-Reply-To: <20221205115709.251489-2-shikemeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kemeng Shi <shikemeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linfeilong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuzhiqiang26-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On 12/5/22 4:57?AM, Kemeng Shi wrote:
> From: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> On the default hierarchy (cgroup2), the throttle interface files don't
> exist in the root cgroup, so the ablity to limit the whole system
> by configuring root group is not existing anymore. In general, cgroup
> doesn't wanna be in the business of restricting resources at the
> system level, so correct the stale comment that we can limit whole
> system to we can only limit subtree.
> 
> Signed-off-by: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Kemeng Shi <shikemeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>

Which one should be used? You have duplicate SOBs in each of the
commits. It's marked as being from Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> so
that is what I'll use.

-- 
Jens Axboe
