From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3 0/3] block, bfq: minor cleanup and fix
Date: Fri, 18 Feb 2022 06:13:40 -0700
Message-ID: <164519002068.11187.11125581863819344403.b4-ty@kernel.dk>
References: <20220129015924.3958918-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=GK4rz9+seFn4xdxHvPLjlObHSp4PzOJAfGpbgOOGnDc=;
        b=X0yxpy0FpsFY7ZLcYL/hyLZTcm0tOjEZLx7X2m/1SjWaDiXAxsGjQ3/RVtMsybX1vD
         eUM4FKRSXHyTu2bsmY9dXOfKtxk6g8ka27l8MYEVjuweCvpCSeUW4UzRXSCnZQQ+pfIU
         JtbpenlRpDiplHlpX+TUFxxs2aOg+dZC2RxDFoAFK3kmkY9FunGo9ockke4UU8MM+gJZ
         2I2LNOuslQVGnctx/w+Zpz3/8yTUFqzfahTN9FFImDypH63XrQHgLszBX8NNBFm0tnew
         Xymx+whVxA8NHk7ooSDbJrHQRFalkm53OPCNNXS8CLisZbMRgXl4JQ5lnZqqPzngJpJK
         S9Og==
In-Reply-To: <20220129015924.3958918-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack@suse.cz, Yu Kuai <yukuai3@huawei.com>, paolo.valente@linaro.org
Cc: linux-block@vger.kernel.org, yi.zhang@huawei.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Sat, 29 Jan 2022 09:59:21 +0800, Yu Kuai wrote:
> Changes in v3:
>  - fix a clerical error in patch 2
> 
> Chagnes in v2:
>  - add comment in patch 2
>  - remove patch 4, since the problem do not exist.
> 
> [...]

Applied, thanks!

[1/3] block, bfq: cleanup bfq_bfqq_to_bfqg()
      commit: 43a4b1fee098bd38eed9c334d0e0df221ecdf719
[2/3] block, bfq: avoid moving bfqq to it's parent bfqg
      commit: c5e4cb0fcbbaa5ad853818c4a2383e9bd147fad6
[3/3] block, bfq: don't move oom_bfqq
      commit: 8410f70977734f21b8ed45c37e925d311dfda2e7

Best regards,
-- 
Jens Axboe


