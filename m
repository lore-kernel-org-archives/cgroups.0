From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] blk-iocost: avoid 64-bit division in ioc_timer_fn
Date: Wed, 18 Jan 2023 06:42:19 -1000
Message-ID: <Y8gha8kL5yG3RQ2w@slm.duckdns.org>
References: <20230118080706.3303186-1-arnd@kernel.org>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KQ5UR3/Xa0Iypn0NjAFlzAel5UzlsAahE0Mxf3hKvNI=;
        b=HtEWoLc8/L8ms4jJfUX7yuSxC/Ev6BsvXo78m11rO02Mzvft0bqOU5nHJgEf2x1UOF
         /frnN6FGr41Nzz9l7f4WNhNmhFM+Hfgqp8pt3ow80dUdKeRavboRhpPEoyCbap8j3Fxy
         wEocSwLplENYxRNL0PmIkZOLr9oWalRRzl2+xOKKJawaoTvVPMks6Qc17rxKKr3B5d0V
         qss+BaOxZucT4h29rQah3MOgKACtPm5b+WhTWvXH7xQqoz2v7+pDlfBBlECIGW2XTIIG
         dx5jRtIW6M5uiMLHssv7ZCc8/7Yre8vncxwYpn2gyCTGVEYlUzpml7Flz0KFVJ1gBlwY
         zwpg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230118080706.3303186-1-arnd@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arnd Bergmann <arnd@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>, Kemeng Shi <shikemeng@huawei.com>, Andreas Herrmann <aherrmann@suse.de>, Yu Kuai <yukuai3@huawei.com>, Chengming Zhou <zhouchengming@bytedance.com>, Jinke Han <hanjinke.666@bytedance.com>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Jan 18, 2023 at 09:07:01AM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The behavior of 'enum' types has changed in gcc-13, so now the
> UNBUSY_THR_PCT constant is interpreted as a 64-bit number because
> it is defined as part of the same enum definition as some other
> constants that do not fit within a 32-bit integer. This in turn
> leads to some inefficient code on 32-bit architectures as well
> as a link error:
> 
> arm-linux-gnueabi/bin/arm-linux-gnueabi-ld: block/blk-iocost.o: in function `ioc_timer_fn':
> blk-iocost.c:(.text+0x68e8): undefined reference to `__aeabi_uldivmod'
> arm-linux-gnueabi-ld: blk-iocost.c:(.text+0x6908): undefined reference to `__aeabi_uldivmod'
> 
> Split the enum definition to keep the 64-bit timing constants in
> a separate enum type from those constants that can clearly fit
> within a smaller type.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
