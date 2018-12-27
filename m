From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH V2 00/10] unify the interface of the proportional-share
 policy in blkio/io
Date: Thu, 27 Dec 2018 15:41:44 -0800
Message-ID: <20181227234144.GE2509588@devbig004.ftw2.facebook.com>
References: <20181120162816.GV2509588@devbig004.ftw2.facebook.com>
 <25296DAE-73EC-46CC-9A98-A8B7E9017BB7@linaro.org>
 <7D7FAB43-5F62-4402-A9B3-E7C2E30AE680@linaro.org>
 <20181130184256.GI2509588@devbig004.ftw2.facebook.com>
 <5534B7D4-A5D9-4F44-9620-970A7F9EC140@linaro.org>
 <CADiTV-29TmkB5-k=TtQfoJqjP2Qv7GSsGLXAPBaTB6DoQ+6yyw@mail.gmail.com>
 <874A0232-2103-4364-BD88-F33B85D6A764@linaro.org>
 <20181218164126.GX2509588@devbig004.ftw2.facebook.com>
 <EC4F9B54-2352-4D85-B56C-5800CFEBCCB8@linaro.org>
 <A360EBDC-B297-4754-AF5C-0A6C30D725B4@linaro.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xXBTIXHVAax3PJVgWEmGAt722IyPRVkq/7ftu76zskQ=;
        b=nHfNQX9WXbd4v1mYIWQy9AJqEYEykYb6VEtomgVx398VGjNDSzl1QME1bez7OOt2Vw
         wSqtfmtGl2Gc9HatZWi/yVq3upLi8AJolttyrb0KzXCS+OGY+dsUPieA7cy199UNekp4
         pPzQcLgMIGp1H+wAlId3XaC5phb2GrqvWxY1ZIOjP23OxnhDaIA9C1IPYlXkYoNBwQar
         u97YBGsc2chKeilI6xnMZ2oVYWXKbWOi3ucrHJkfmRlc/JnJHq8WVIyDoQwGTM3iGhbM
         Q5PIgAeFdI4adTRai6O64MmXbIFRr0EhhZ06navKwHiU5mFIpXG+ofq4TJkz89aleImg
         XvsQ==
Content-Disposition: inline
In-Reply-To: <A360EBDC-B297-4754-AF5C-0A6C30D725B4@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente@linaro.org>
Cc: bfq-iosched@googlegroups.com, Angelo Ruocco <angelo.ruocco.90@gmail.com>, Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, broonie@kernel.org, oleksandr@natalenko.name, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>

Hello, Paolo.

On Sun, Dec 23, 2018 at 12:00:14PM +0100, Paolo Valente wrote:
> 4.21 is coming ...  and the legacy proportional share interface will
> be gone with cfq.  This will break legacy code using the
> proportional-share interface on top of bfq.  This code may just fail
> when trying to use interface files that don't exist any longer.

Sounds like inheriting .cfq namespace would be the easiest.  Would
that work?

Thanks.

-- 
tejun
