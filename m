From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH V2 00/10] unify the interface of the proportional-share
 policy in blkio/io
Date: Wed, 2 Jan 2019 17:28:05 +0100
Message-ID: <CAFEB3AA-1E80-4A75-8B93-D3E4A46C30DB@linaro.org>
References: <7D7FAB43-5F62-4402-A9B3-E7C2E30AE680@linaro.org>
 <20181130184256.GI2509588@devbig004.ftw2.facebook.com>
 <5534B7D4-A5D9-4F44-9620-970A7F9EC140@linaro.org>
 <CADiTV-29TmkB5-k=TtQfoJqjP2Qv7GSsGLXAPBaTB6DoQ+6yyw@mail.gmail.com>
 <874A0232-2103-4364-BD88-F33B85D6A764@linaro.org>
 <20181218164126.GX2509588@devbig004.ftw2.facebook.com>
 <EC4F9B54-2352-4D85-B56C-5800CFEBCCB8@linaro.org>
 <A360EBDC-B297-4754-AF5C-0A6C30D725B4@linaro.org>
 <20181227234144.GE2509588@devbig004.ftw2.facebook.com>
 <F2A4E669-8C79-46D7-8A97-2C561FF5346B@linaro.org>
 <20190102160328.GR2509588@devbig004.ftw2.facebook.com>
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=zoEN4e7FVLBdSCM0JYwFQBKnXFgM1dT6w5T9AKkbJH8=;
        b=BiIw0OXCrudcQU0jcN1txwA/8FRcTFQA1AxQR5YzktjRsEHIJIAbu5rYwEbu3m+CZ6
         YTm+fuD1qtRH9p3dY9OQrb3tzMg6q4R66WcI4x8WmgRVEpN7CEhjujAsotpvheB3dpLn
         OOqibQOGfEFtJRSqXhsOPJ2zDYrUPRHV6y1MY=
In-Reply-To: <20190102160328.GR2509588@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: 'Paolo Valente' via bfq-iosched <bfq-iosched@googlegroups.com>, Angelo Ruocco <angelo.ruocco.90@gmail.com>, Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, broonie@kernel.org, oleksandr@natalenko.name, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>



> Il giorno 2 gen 2019, alle ore 17:03, Tejun Heo <tj@kernel.org> ha scritto:
> 
> Hello, Paolo.
> 
> On Sun, Dec 30, 2018 at 11:25:25AM +0100, Paolo Valente wrote:
>> What's the benefit of throwing away months of work, on which we agreed
>> before starting it, and that solves a problem already acknowledged by
>> interested parties?
> 
> Showing multiple conflicting numbers definitely isn't anything which
> is agreed upon.
> 

Sorry, of course you din't realize that sharing interface files had
this consequence, otherwise you'd have protested beforehand.

The problem is that this consequence seems unavoidable: if two
policies have different numbers to convey, through a shared interface
file, then they must be allowed to write their different numbers.  To
me, this doesn't sound like a problem.

The only other natural option is no unification, unless you have a
third way.

What do you prefer, or propose?

Thanks,
Paolo

> Thanks.
> 
> -- 
> tejun

