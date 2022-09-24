From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH 0/2] blk-throttle: improve bypassing bios checkings
Date: Sat, 24 Sep 2022 09:00:10 -0600
Message-ID: <166403161084.5171.274436515046613194.b4-ty@kernel.dk>
References: <20220921095309.1481289-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date;
        bh=/ZxmoZGavmWNlrZnawkbXveh01Wn367vmE/VNkXmIdw=;
        b=s25ZCs1tSDwZADqqqf1Vm4xt2zv7eMrlkQYv4xQaqPF3mPJzzvhB2mzxAqxPkb32pK
         NHAqqy/qx4pNcfeO5zqFmmWF2ufBVP1cOVbbxVTdLQvPTSHxLDM+xweoWGa34eoy6rDG
         dyyruF1ntIIDA6CvCIvQDTZADmji0DJAHX5s0Vhfrhdfq4gt11Qo5ttrdt7FnYlOgmiM
         g8G3lY1JxPY4sBzH8MwvY9x6UDIuc8ekZ8AqGfJh5wk+r/EmtPVkEnjYkiP/kHjK9ETv
         OYDkJBXcuZFyiUKv4Aw+s8K/uMug7rbzVAcHajZOqT5eH86LKpfotHSrJsWWt7a+AOji
         zcSA==
In-Reply-To: <20220921095309.1481289-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Wed, 21 Sep 2022 17:53:07 +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Currently, "tg->has_rules" and "tg->flags & THROTL_TG_HAS_IOPS_LIMIT"
> both try to bypass bios that don't need to be throttled, however, they are
> a little redundant and both not perfect:
> 
> 1) "tg->has_rules" only distinguish read and write, but not iops and bps
>    limit.
> 2) "tg->flags & THROTL_TG_HAS_IOPS_LIMIT" only check if iops limit
>    exist, read and write is not distinguished, and bps limit is not
>    checked.
> 
> [...]

Applied, thanks!

[1/2] blk-throttle: remove THROTL_TG_HAS_IOPS_LIMIT
      commit: 85496749904016f36b69332f73a1cf3ecfee828f
[2/2] blk-throttle: improve bypassing bios checkings
      commit: 81c7a63abc7c0be572b4f853e913ce93a34f6e1b

Best regards,
-- 
Jens Axboe


