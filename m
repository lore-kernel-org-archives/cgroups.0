From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v4 0/5] blk-iocost: random bugfix
Date: Fri, 20 Jan 2023 08:40:44 -0700
Message-ID: <167422924424.669768.14436700036484270833.b4-ty@kernel.dk>
References: <20230117070806.3857142-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WWZZyEASnVJeDNF1yNLqxhUJXWQQRy8pnWrzIYnrXKE=;
        b=v2V3ahcwOyuebwYuu9dRu7UT8QxS8g94SXGFFKxIyCBqAbk2llyobeFPWj5Awzp1qK
         hyFTDrKlLj0HTzsuVN0Ycdxcns3gvZ7iqlYGkwPE2i5qvSixBE4o0cfm+EEi1B5j0JK6
         ri82Hp2zJUo/yb/sbEGQLhndTz2ilFTLxLp4O1EpOrAyXL/ALrRKupl+oJM1y3NRFE9w
         uKjWYSkQL4ktfGdUg9UY01GzXNAu42C2JMxhoW87zWGYXh3QEyHSrhPd46XOC8A+z9GY
         eDuwuA9oIBHqazOS+DFeQff3wzNLoBTwTZ+LeSOqKS9M1AVp0XJ8FxZuFv7tDnv25Sqq
         3nSg==
In-Reply-To: <20230117070806.3857142-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, josef@toxicpanda.com, Yu Kuai <yukuai1@huaweicloud.com>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com


On Tue, 17 Jan 2023 15:08:01 +0800, Yu Kuai wrote:
> changes in v4:
>  - a litter code optimization to make it easier to understand in patch
>  4.
> 
> changes in v3:
>  - move some patches into separate patchset
>  - don't return other error number for match_u64() in patch 1
>  - instead of checking user input separately, set page directly if
>  'bps + IOC_PAGE_SIZE' will overflow.
> 
> [...]

Applied, thanks!

[1/5] blk-iocost: check return value of match_u64()
      commit: 7b6a2c89052bfaf750260691dee29c2e457c0929
[2/5] blk-iocost: don't allow to configure bio based device
      commit: 204a9e1eeb4b72cd260274f14e521162b130a978
[3/5] blk-iocost: read params inside lock in sysfs apis
      commit: 7b810b50390b53c2a81051adce8fcbff3200fc74
[4/5] blk-iocost: fix divide by 0 error in calc_lcoefs()
      commit: 4e952a32301a77faea0d36c540ae16847cf2a8ee
[5/5] blk-iocost: change div64_u64 to DIV64_U64_ROUND_UP in ioc_refresh_params()
      commit: ad5572498be17b800e75bc36f7d810dd3b673802

Best regards,
-- 
Jens Axboe



