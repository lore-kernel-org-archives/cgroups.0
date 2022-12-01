From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH v2 0/5] A few cleanup and bugfix patches for blk-iocost
Date: Wed, 30 Nov 2022 18:47:04 -0700
Message-ID: <166985922489.517656.7936907108096958272.b4-ty@kernel.dk>
References: <20221018121932.10792-1-shikemeng@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wG1FRF6NvvTrQgh7hkGSM1RofK5aGr38w3ooW7oI78w=;
        b=nue/1SmJ1LCPfvm3ohnTASWGXwKcSs3WqqLHKlqlyaFhuQ1+BPaoBv38LB/i/Mm6x+
         kgdpsRx520nsbxizSIgZdsSF94bQdGEG7rKZ+nzgfedNWWYuY8btrChtXNxbgwj6G1EU
         EP9dR0OW85GOBoxGKYXThtht9b/kVgQJA760EHWDfN+2xoRaQ9lzmgVZ9AAdDbqqenqj
         WcMNXZXx21mAm5js47qVwwZr2OU2QaWTojn12g85PxwmurYyyezYF3ItaVhTTRtMK2hT
         kFtHStmx1pC/xPqSYSQN6fQW2tlywRzXKaeONI45fZvV4Ia9oQr/5swgQU45jLaKZcxU
         2Viw==
In-Reply-To: <20221018121932.10792-1-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 18 Oct 2022 20:19:27 +0800, Kemeng Shi wrote:
> This series contain a few patch to correct comment, correct trace of
> vtime_rate and so on. More detail can be found in the respective
> changelogs.
> 

Applied, thanks!

[1/5] blk-iocost: Fix typo in comment
      commit: e12d34fce7652a870fac62e9749a6623883d6fd8
[2/5] blk-iocost: Reset vtime_base_rate in ioc_refresh_params
      commit: c81d97a61c8c3c25a576c3db4c4dd34316256f05
[3/5] blk-iocost: Trace vtime_base_rate instead of vtime_rate
      commit: 0c0d362dc97d19d898219c13a357e167a9ee77ee
[4/5] blk-iocost: Remove vrate member in struct ioc_now
      commit: f44ed8722034ef7d214fa121ae2402100a3590e1
[5/5] blk-iocost: Correct comment in blk_iocost_init
      commit: b4c0482bfe89cd6c4f030314c86aae35642c44a5

Best regards,
-- 
Jens Axboe


