From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH] blk-throttle: clean up codes that can't be reached
Date: Sun, 04 Sep 2022 14:38:38 -0600
Message-ID: <166232391804.14690.3824114675220691549.b4-ty@kernel.dk>
References: <20220903062826.1099085-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date;
        bh=iXJZ4e881QRCBkDXXM7HwesUdR/gpeowGn9TKqyGYKo=;
        b=EVe3pF0/CsWQKEAWlyJR8pGHuTyqDH5LhBPIHI52FhmvSGeZmoF3+70qU2vWg4puDS
         eDbbrdY0wVQsgnumzEPu5kYfM3ADGbCtO2BVyn7rYWfASFda6rHWjiHf/WJy26hu3q6u
         oUbcbmvzEAzv2TK44hdfcBoF+XNG6S4EC86kjh/mcdajsy6fBJhRt1I1I9asVxkRLZgX
         U47AmIiNO9qOVTAs1+daIjH8vq1O0oEvXXxcSqP7ILnDnMJWuJqU7zXrtXuztM3nlM1r
         ysWvAwvu6userSDiz4sOgHSdePMQbVpOXw0X0gzvvmyGyVoyJov+DlWpfFpaL1D6jQp5
         BzMw==
In-Reply-To: <20220903062826.1099085-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Sat, 3 Sep 2022 14:28:26 +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> While doing code coverage testing while CONFIG_BLK_DEV_THROTTLING_LOW is
> disabled, we found that there are many codes can never be reached.
> 
> This patch move such codes inside "#ifdef CONFIG_BLK_DEV_THROTTLING_LOW".
> 
> [...]

Applied, thanks!

[1/1] blk-throttle: clean up codes that can't be reached
      commit: 2d8f7a3b9fb31d2566b24fd94d5a533f9322c53c

Best regards,
-- 
Jens Axboe


