From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] blk-throttle: improve bypassing bios checkings
Date: Fri, 23 Sep 2022 17:32:11 -1000
Message-ID: <Yy56O9NbiyBogSLD@slm.duckdns.org>
References: <20220921095309.1481289-1-yukuai1@huaweicloud.com>
 <20220921095309.1481289-3-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=6ie65mmUX7k2h2mobWPlWsffXk7OzouDQ0Bfk3M0MI0=;
        b=YcQRQDG3wliRsfpTrJV9HWJOu75ovx7pV9imXwjWYU82Ib3R4WOEC6s1Xm9NvHfdmD
         1jaOX9sJo7ytEjcafhg8PmEvLfMYCTL1X3P/RNhnbHZsNmOsmfRfsUIkUIMo3DysC4LG
         KbppjXtOulf0E5s06vwtdd1SDx+0HVHG8zVgcfQBaBKtSr90lW7NVpiX2MVA5Tq/IpZC
         GZyBtBDB8M/qZGmPfKyAN3F5r+2gi/Cabq2aceYGQkU6rI8yROOnZ8aenzfPcJsDynCg
         ziHkgKYb1MvZabDayhfI0rqQFqM58/yCLRFJ8nW4gOmKgCuBFNfvdFjXj9lvhqgiUiYV
         9Inw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220921095309.1481289-3-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

On Wed, Sep 21, 2022 at 05:53:09PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> "tg->has_rules" is extended to "tg->has_rules_iops/bps", thus bios that
> don't need to be throttled can be checked accurately.
> 
> With this patch, bio will be throttled if:
> 
> 1) Bio is read/write, and corresponding read/write iops limit exist.
> 2) If corresponding doesn't exist, corresponding bps limit exist and
> bio is not throttled before.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
