From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH] blk-cgroup: Reinit blkg_iostat_set after clearing in
 blkcg_reset_stats()
Date: Wed, 07 Jun 2023 07:52:33 -0600
Message-ID: <168614595386.134969.17908041000836291196.b4-ty@kernel.dk>
References: <20230606180724.2455066-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686145955; x=1688737955;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8pWjfG7YX2PU6lTg87BQzQgK5gQrtCZuLosIt3qtFrw=;
        b=QMGMlVX9pT4+APXXvlD2HGaGEg55QMH0btBqGqRw+dtdVOGo1kh5q+IRJfikBCjoAZ
         vafj+YrmGCGYaOtKcFzs/g7GriOKBIzWtZZeh8BfNxsIDJ7VseMMJPYoiNuQt7caTcMI
         fbzdenPFcryIzgWI+zcXPps0vDUIFsZMliLzzzo2NMTbOU8IV+6GRTdzS4etu2E7bG1G
         zZy5GDzKAFGL863kgCYdqdlrRhzG8ovq7gNP99KiwoUnVzy58N3hDEkaisdrZi9QqDvh
         12nHG5VND02dBavngpMxFq36XYe5fvooIddYSP6a8+XPAVtLp/lIB0YMBjMBb3y/nBpV
         Px9w==
In-Reply-To: <20230606180724.2455066-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


On Tue, 06 Jun 2023 14:07:24 -0400, Waiman Long wrote:
> When blkg_alloc() is called to allocate a blkcg_gq structure
> with the associated blkg_iostat_set's, there are 2 fields within
> blkg_iostat_set that requires proper initialization - blkg & sync.
> The former field was introduced by commit 3b8cc6298724 ("blk-cgroup:
> Optimize blkcg_rstat_flush()") while the later one was introduced by
> commit f73316482977 ("blk-cgroup: reimplement basic IO stats using
> cgroup rstat").
> 
> [...]

Applied, thanks!

[1/1] blk-cgroup: Reinit blkg_iostat_set after clearing in blkcg_reset_stats()
      commit: 3d2af77e31ade05ff7ccc3658c3635ec1bea0979

Best regards,
-- 
Jens Axboe



