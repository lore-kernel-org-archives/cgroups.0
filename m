From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -next] blk-throttle: enable io throttle for root in
 cgroup v2
Date: Wed, 26 Jan 2022 07:29:24 -1000
Message-ID: <YfGE9L4i7DtNTo08@slm.duckdns.org>
References: <20220114093000.3323470-1-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o7yVQ6gsvTTab9fYp8q+lCU+rLwohNUxOjiCLgJGdGM=;
        b=O6zfBzmd+BywBFqXzIfiy3ycqMOwjnMfDYKV8Xlu61A5NUaAdxjhLjXRk91Zxmp379
         0Zfjblp8ROfH7rGfRhEtsP/JWG6yw+G/qBGkEN722dXIW53FMFuWEu01agN9bdHb9we0
         XOfCUvJMOBV/VWzq7SmjsTPdvjJ7m8E7DPaqPCR2KdqEhdKUcN20ZgDnwHGrUrZ6+I3h
         8R/tO/SPoduJvlIslRZbhDKzQDuMNWYkbGxVq/ggvEDK6IeFnDzjVzrDuCHhUptS6yE3
         zTZNooS0kFSqw6KKe8jJQpHWqMqYs1PMrHkCKAl3tpRiDJB4Eimn0LqYUPgEWvGJZSkJ
         kK4w==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220114093000.3323470-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3@huawei.com>
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

On Fri, Jan 14, 2022 at 05:30:00PM +0800, Yu Kuai wrote:
> RFC patch: https://lkml.org/lkml/2021/9/9/1432
> 
> There is a proformance problem in our environment:
> 
> A host can provide a remote device to difierent client. If one client is
> under high io pressure, other clients might be affected.
> 
> Limit the overall iops/bps(io.max) from the client can fix the problem,
> however, config files do not exist in root cgroup currently, which makes
> it impossible.
> 
> This patch enables io throttle for root cgroup:
>  - enable "io.max" and "io.low" in root
>  - don't skip root group in tg_iops_limit() and tg_bps_limit()
>  - don't skip root group in tg_conf_updated()
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Yeah, I'm kinda split. It's a simple change with some utility, but it's also
something which doesn't fit with the cgroup feature or interface. It's
regulating the whole system behavior. There's no reason for any of the
control "groups" to be involved here and semantically the interface would
fit a lot better under /proc, /sys or some other system-wide location. Here
are some points to consider:

* As a comparison, it'd be rather absurd to enable memory.max at system root
  in terms of interface and most likely break whole lot of mm operations.

* Resource control knobs of a cgroup belong to the parent as the parent is
  responsible for divvying up the available resources to its children. Here
  too, the knobs are making sense because there's a higher level parent
  (whether that's hypervisor or some network server).

Is your use case VMs or network attached storage?

Thanks.

-- 
tejun
