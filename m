From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blk-iocost: avoid 64-bit division in ioc_timer_fn
Date: Wed, 18 Jan 2023 09:46:08 -0700
Message-ID: <167406036877.186970.284730787614510141.b4-ty@kernel.dk>
References: <20230118080706.3303186-1-arnd@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+CBR9KRDrU62eYiKnf3g8Hj72EMYesEhZDgA5exJMeA=;
        b=nHt419y0vPb1nXvE+D0KK8cczLBlsYBZtxZdJJbaIYW9cR35eX5BQQvdP6Xy/fulMd
         kdlC4NAQg5Wu2ZRX1OARR+qjCRs9dpUB9XttLcchvnHTfsl327jLzQenUhVHSYIwPM0v
         W0XcNEDLPNv2/8tvG05DabQD6XDjr70/URhayVJ1hbTLaYtlXLd1RnIjMpgi6IDeAKlV
         TEXC4bADeIIVDXcVjHx7Ie6VfFBRV5/UfplMEqI0zakLZvYu4xMvGcAwAvsFBW0UsLxL
         8jG8Jqk4RDpLfKyZ5Psf2AchOgUsSxsQMskhbF4ngWhD0pQQMM0aJRId8+lA+Es1z0ME
         +9yw==
In-Reply-To: <20230118080706.3303186-1-arnd@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Arnd Bergmann <arnd@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Kemeng Shi <shikemeng@huawei.com>, Andreas Herrmann <aherrmann@suse.de>, Yu Kuai <yukuai3@huawei.com>, Chengming Zhou <zhouchengming@bytedance.com>, Jinke Han <hanjinke.666@bytedance.com>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org


On Wed, 18 Jan 2023 09:07:01 +0100, Arnd Bergmann wrote:
> The behavior of 'enum' types has changed in gcc-13, so now the
> UNBUSY_THR_PCT constant is interpreted as a 64-bit number because
> it is defined as part of the same enum definition as some other
> constants that do not fit within a 32-bit integer. This in turn
> leads to some inefficient code on 32-bit architectures as well
> as a link error:
> 
> [...]

Applied, thanks!

[1/1] blk-iocost: avoid 64-bit division in ioc_timer_fn
      commit: 08a39c820686f87351b21c6cf6af76a40677d3af

Best regards,
-- 
Jens Axboe



