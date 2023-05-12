From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH -next v2 0/6] blk-wbt: minor fix and cleanup
Date: Fri, 12 May 2023 08:58:11 -0600
Message-ID: <2b18e6ed-bce0-44f5-5ec4-8903f3c85cfe@kernel.dk>
References: <20230512093554.911753-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683903494; x=1686495494;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zGuO9uAkYQgkNZy7b91jsKYegy6TbOpfslNkTDY+8ac=;
        b=1WVL72ya6qP7dGrPu7BNlkLeAizIvkdbU8SZrfj2rNUaajZGhH5j+aRAqiRDTgAyEC
         G01rOMNEGf01xwDcwtnNtvXJEcSP/sb/cUQ6KOn0kOiJb7STskLaiVUhLD/Xuufq2mkN
         FoHxF1nshyFhZtC6oqXhZmYkGDq9jdilM89fwAXuqYnTylcmcejSMBatZ03GKhl9qZ17
         Etal008fc/HStLgLA8JYEzR5DZQF99LjqFcxHyzuUg375D4y5IepKMbRIfOh7TkxXiG+
         d+VJxXq3G+bU5wOJ37xGsdVj+j9kK+uVt4E2n6uydwMRFnNrrfWekqs5Ukom3HHB/VxY
         GM5Q==
Content-Language: en-US
In-Reply-To: <20230512093554.911753-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@lst.de, tj@kernel.org, josef@toxicpanda.com, yukuai3@huawei.com
Cc: lukas.bulwahn@gmail.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com

On 5/12/23 3:35=E2=80=AFAM, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
>=20
> Changes in v2:
>  - make the code more readable for patch 1
>  - add a new attr_group that is only visible for rq based device
>  - explain in detail for patch 4
>  - add review tag for patch 2,3,5
>=20
> Yu Kuai (6):
>   blk-wbt: fix that wbt can't be disabled by default
>   blk-wbt: don't create wbt sysfs entry if CONFIG_BLK_WBT is disabled
>   blk-wbt: remove dead code to handle wbt enable/disable with io
>     inflight
>   blk-wbt: cleanup rwb_enabled() and wbt_disabled()
>   blk-iocost: move wbt_enable/disable_default() out of spinlock
>   blk-sysfs: add a new attr_group for blk_mq
>=20
>  block/blk-iocost.c |   7 +-
>  block/blk-sysfs.c  | 181 ++++++++++++++++++++++++++-------------------
>  block/blk-wbt.c    |  33 +++------
>  block/blk-wbt.h    |  19 -----
>  4 files changed, 117 insertions(+), 123 deletions(-)

We need a 6.4 version of the fix to get rid of the regression. If you
want to do cleanups on top of that, then that's fine and that can go into
6.5. But don't mix them up.

--=20
Jens Axboe


