From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH 0/2] block, bfq: minor cleanups
Date: Wed, 14 Dec 2022 09:56:55 -0700
Message-ID: <167103701587.7871.17006883057809106433.b4-ty@kernel.dk>
References: <20221214033155.3455754-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+IqN/UFmzZrEibODg3m/L1J+2MIkf8gPpvi4AhxE0rI=;
        b=Tr9KjKxPfOrvyg/SlAr3G0wYWAk1UreVI+Jp0ogHuK9sYGPI6TLN2bdwSO7JE9YN5P
         ksq36k620RJublNfl2UgV0rcqufHvRy3WPZ1/DwJY5mEzTkXsKBQpFeYNSQafVJs/g5m
         bddWHvyIRkWIjk6XLgscQ22NQRzC1MS/db8GVzT3NAYZmp4T13GzoGp9XmQLdGHWALMt
         0WokKjmKiiOxdGDB4hkRHUOCnT/AeUKWtXKcLAEmpX/i/FeNibZqDKuK34fXQ4DdD9lX
         kMHALlS4FAY2jJZj/5A9zLlipomJ24/3huviN/0VKdXs7IKs+uzS51RYhIZDc3VLHkem
         1LiA==
In-Reply-To: <20221214033155.3455754-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org


On Wed, 14 Dec 2022 11:31:53 +0800, Yu Kuai wrote:
> Yu Kuai (2):
>   block, bfq: don't return bfqg from __bfq_bic_change_cgroup()
>   block, bfq: replace 0/1 with false/true in bic apis
> 
> block/bfq-cgroup.c  | 16 +++++++---------
>  block/bfq-iosched.c |  4 ++--
>  2 files changed, 9 insertions(+), 11 deletions(-)
> 
> [...]

Applied, thanks!

[1/2] block, bfq: don't return bfqg from __bfq_bic_change_cgroup()
      commit: 452af7dc59033a76372d51a24682503377872b11
[2/2] block, bfq: replace 0/1 with false/true in bic apis
      commit: 337366e02b370d2800110fbc99940f6ddddcbdfa

Best regards,
-- 
Jens Axboe


