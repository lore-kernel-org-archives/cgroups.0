From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 13/14] blkcg: change blkg reference counting to use
 percpu_ref
Date: Tue, 4 Dec 2018 14:54:38 -0500
Message-ID: <20181204195437.cqixsk265n6dyetv@MacBook-Pro-91.local>
References: <20181204183600.99746-1-dennis@kernel.org>
 <20181204183600.99746-14-dennis@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KEmiKoLuZH21McZzbS+ZG3EgftTYemLlSyZsFUMBzK0=;
        b=CE3eM1wH8tK+rtHYU5qpr6P7pNFWJvVDn/n+QQY1lAYyhgD3pKLRyEjKULYFeTcCsa
         02D3UKuzHpNL0z7Jtt1FjqUP+ATABkn2VVhdRD8KrH3LlIiRBfVs9vTZ9vhcKywL/ndM
         9w0kvUmz4E9zJFkZM+N+dm3LWmAy1hd7+AK3rbGTGKPvEllgsE4IT6Bcg5OZxPzSGmFN
         nmJOtFeR0d7FHMxdFi5bxYkVQ2IDe9kqAQ1hg55blK5+B67rLA68/vl57cT1sXW58cG6
         lJYAPYKAor3GdHpwTzsD82EmhQb4edjuKY6o5YZOtb04dz4ArtbGxmy2zbUxtQLOgMhS
         hJbA==
Content-Disposition: inline
In-Reply-To: <20181204183600.99746-14-dennis@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennis@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Dec 04, 2018 at 01:35:59PM -0500, Dennis Zhou wrote:
> Every bio is now associated with a blkg putting blkg_get, blkg_try_get,
> and blkg_put on the hot path. Switch over the refcnt in blkg to use
> percpu_ref.
> 
> Signed-off-by: Dennis Zhou <dennis@kernel.org>
> Acked-by: Tejun Heo <tj@kernel.org>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
