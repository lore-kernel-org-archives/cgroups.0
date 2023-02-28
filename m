From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH v4] blk-iocost: Pass gendisk to ioc_refresh_params
Date: Tue, 28 Feb 2023 05:51:53 -0700
Message-ID: <167758871388.8785.9077411400332712392.b4-ty@kernel.dk>
References: <20230228111654.1778120-1-leitao@debian.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1677588715;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F6bVcZFE0HqAVo8qfWn/M3ByKpGU6+Lc1KXSuspx5lo=;
        b=uBP8y0KEudDm9buTiNU2aHEUByfTEd7uJJX36ri4HmxFFsoYkiHFJzReJ3mx75gVYV
         WTPbKyBnhRr2eJ8Rt0vUlSvHSnJ+Di21agCQTonnedhxrLQGKyMLs9xl7sNWrQKwhW8F
         147/0/iHd9r1v6l5igLC90stz9n9ezHoTzvRO5fGOnF/OyfR0EsRFFWbhvbH5HtzyREf
         WU9x2yz4/qD86Mxh1f29lyE6PMayDvH9RaIkuWfMilM6pr/VMfYWKQ6dOSLtK3k4Ghzz
         gxnFm8gFw2dm1rsgeMyd3C5HpfmZ2JmWheE3g8p34giU36F/QsznGLcYKIkjj5Q1JlAn
         CKoA==
In-Reply-To: <20230228111654.1778120-1-leitao-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Breno Leitao <leitao-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Cc: aherrmann-l3A5Bk7waGM@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, leit-b10kYP2dOMg@public.gmane.org


On Tue, 28 Feb 2023 03:16:54 -0800, Breno Leitao wrote:
> Current kernel (d2980d8d826554fa6981d621e569a453787472f8) crashes
> when blk_iocost_init for `nvme1` disk.
> 
> 	BUG: kernel NULL pointer dereference, address: 0000000000000050
> 	#PF: supervisor read access in kernel mode
> 	#PF: error_code(0x0000) - not-present page
> 
> [...]

Applied, thanks!

[1/1] blk-iocost: Pass gendisk to ioc_refresh_params
      commit: e33b93650fc5364f773985a3e961e24349330d97

Best regards,
-- 
Jens Axboe



