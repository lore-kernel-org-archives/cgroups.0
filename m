From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 block-6.2] block, bfq: fix uaf for bfqq in
 bic_set_bfqq()
Date: Sun, 29 Jan 2023 20:04:15 -0700
Message-ID: <167504785585.199828.6199773692964530920.b4-ty@kernel.dk>
References: <20230130014136.591038-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BZ6yrQ8QtaF+R4KmbpHk9smJ4moMIfGYvuFm4fbV6sc=;
        b=UdmzHx0zsT7cWmAEfDg3Pvx9yJhOEKanG2EXeWgIdwce6Me6hEj2X4Fd/tukd5ugfa
         FP8S2r8lRPk1z5J5+VNGZxevrDVZ8hQQdBJkU1iCQOR4utbSuqvR6HoRSZI2huRh4iam
         erL4WKX3HEIiS/TnXDYPpDECgAmeFH8NxvxllsjTRNjSmpTW+v9LwOv3TC8bUrjszDAJ
         u+Trn4UyXbDfGqreWnCbe1E+3d0xrMh65MNPOHIyxeeMlf0khBlc4yST/M43zxSEAthC
         Nj5R1sg3OZQHWW5i49QdXUrRAQvkNATID2IOHf0C+hEQ7/EIW7AcbqIX0pmP0yWArtJz
         xh4g==
In-Reply-To: <20230130014136.591038-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, josef@toxicpanda.com, paolo.valente@linaro.org, yukuai3@huawei.com, jack@suse.cz, Yu Kuai <yukuai1@huaweicloud.com>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com


On Mon, 30 Jan 2023 09:41:36 +0800, Yu Kuai wrote:
> After commit 64dc8c732f5c ("block, bfq: fix possible uaf for 'bfqq->bic'"),
> bic->bfqq will be accessed in bic_set_bfqq(), however, in some context
> bic->bfqq will be freed, and bic_set_bfqq() is called with the freed
> bic->bfqq.
> 
> Fix the problem by always freeing bfqq after bic_set_bfqq().
> 
> [...]

Applied, thanks!

[1/1] block, bfq: fix uaf for bfqq in bic_set_bfqq()
      (no commit info)

Best regards,
-- 
Jens Axboe



