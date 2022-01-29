From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH v3 0/3] block, bfq: minor cleanup and fix
Date: Fri, 28 Jan 2022 18:51:42 -0700
Message-ID: <7cb40388-02e9-712a-6a40-ccabd5605880@kernel.dk>
References: <20220129015924.3958918-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3HAETZklYMRHOBMF4nZqSUVtbfOCXRHz+7u9x6rdHNk=;
        b=KdotavDnl39ndT7clf/ig6ckZcizJxpNLOerW7ygxH6m8J6LOd+Y69okHEcP764r5P
         dwq2DNviRFubvvn/eCYqrjpbkdg7JtZueRxpFK67Lj9+H5LB8tdiG4y0LosjH89ED0Fa
         /VGdGOuwT121ACmm+0o+QFBukGwqZqpmXP73IYCdPTb2dL/Ay2fCyTGFijwv2cXky5vJ
         6uQTU6iVTYa8ePLqI5Ijjne0AFuNPouLMMXzbJZ/+litaEcSV72lQeOub9t6EGdHmC0e
         3EHwPtb23R2Smae00Eg6//vzR5n2E0Nbm9Xf0cXbEqxhWC8hpRln8XeGaGiq9r858tWC
         vQbA==
In-Reply-To: <20220129015924.3958918-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On 1/28/22 6:59 PM, Yu Kuai wrote:
> Changes in v3:
>  - fix a clerical error in patch 2
> 
> Chagnes in v2:
>  - add comment in patch 2
>  - remove patch 4, since the problem do not exist.
> 
> Yu Kuai (3):
>   block, bfq: cleanup bfq_bfqq_to_bfqg()
>   block, bfq: avoid moving bfqq to it's parent bfqg
>   block, bfq: don't move oom_bfqq
> 
>  block/bfq-cgroup.c  | 16 +++++++++++++++-
>  block/bfq-iosched.c |  4 ++--
>  block/bfq-iosched.h |  1 -
>  block/bfq-wf2q.c    | 15 ---------------
>  4 files changed, 17 insertions(+), 19 deletions(-)

I'm not even looking at this until you tell me that:

a) you've actually compiled this one. which, btw, I can't believe
   needs mentioning, particularly when you had enough time to keep
   pinging about this patchset.

b) it's actually be run. last one was clearly not.

-- 
Jens Axboe

