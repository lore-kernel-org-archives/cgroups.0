From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH v2 0/3] blk-cgroup: some cleanup
Date: Thu, 06 Apr 2023 16:17:59 -0600
Message-ID: <168081947971.7640.13634484209341526558.b4-ty@kernel.dk>
References: <20230406145050.49914-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1680819481; x=1683411481;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FR0qElr6GKo/8lkQEKKCuizg5Rqf+FVH+Y9MEeaocBc=;
        b=CTDk8fXkSi/2fH0SOj+GXvVRH5S6QA5imppnrt/gwouT5W76pTHwZ2OV1K8esejpns
         TffeSpkqOtZP2Z5mZjGsLyzV6VoFwUpYdcj7qS98MYnvtbxy6HSg0PTolPQxsigIO8eg
         4CAnHnFzMsEINxDQzCJkexnixAiUsTiW0MvKIj6J5+E1a/czSnpoHP6c8DrlW0oyqZVH
         sjoh6AP2ScqUNr7aPoSMs1qwcOQ/juvCZ3A3EwZTWdQ6XRZNAp1p+ymIA04jqyqzCN+H
         amOl6FTl3SqAE4B2kVVMWWZvtJkvPrRhiumf7BeCGBT8MjB00nQVz5d8Ri1wF0740flP
         8Zhg==
In-Reply-To: <20230406145050.49914-1-zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On Thu, 06 Apr 2023 22:50:47 +0800, Chengming Zhou wrote:
> These are some cleanup patches of blk-cgroup. Thanks for review.
> 
> v2:
>  - Add Acked tags from Tejun.
> 
> Chengming Zhou (3):
>   block, bfq: remove BFQ_WEIGHT_LEGACY_DFL
>   blk-cgroup: delete cpd_bind_fn of blkcg_policy
>   blk-cgroup: delete cpd_init_fn of blkcg_policy
> 
> [...]

Applied, thanks!

[1/3] block, bfq: remove BFQ_WEIGHT_LEGACY_DFL
      commit: e9f2f3f590289681c71d0137d4e5e88421f934c6
[2/3] blk-cgroup: delete cpd_bind_fn of blkcg_policy
      commit: d1023165eef83dace7cc6299af904f26272baaca
[3/3] blk-cgroup: delete cpd_init_fn of blkcg_policy
      commit: 650e2cb50f3fc45d0585ed8609db9519f6c9bcd8

Best regards,
-- 
Jens Axboe



