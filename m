From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 00/12] unify the interface of the proportional-share
 policy in blkio/io
Date: Thu, 15 Nov 2018 09:30:11 -0700
Message-ID: <79a2da26-669a-359c-3832-354ec2b47231@kernel.dk>
References: <20181112095632.69114-1-paolo.valente@linaro.org>
 <9e8adb3271680165d85994a225713391@natalenko.name>
 <E8A20452-A73C-4A31-B5EC-48EFB9937832@linaro.org>
 <e85cfae0-7743-8c51-c2c9-0855c26f868e@kernel.dk>
 <CADiTV-37tqWsbxmeZJsqq+pqSqxN-_L9+T9R+PmBBJhfO-G09g@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Tx62oY/cQGEQBatE3T+ZeNxDEUkb6ZnVjpvyQS2CbEs=;
        b=yXZ7N81O4WaHO2liYAjKeUMC7J8Ygqqmyhi6Wd03NuR5xOx0MzCvYs4eN/RfnXK1JU
         ObIqEzKIctWYhf1R9HDq4v0j1clVAMJqCTBBaBsKB+KjNwUS2Pc1e2jXdoXZeeGKvFe4
         VsCWGaqJ/6+ZQ6pTv5k2fo389eZ3lB2ZoWBf5Pb6n3z76p0Ht+pyCZlJUZE06fTaOFtw
         VGt+pnW9MeEN1cAPgoLDZv1Xt0plfUBNlga/jVx4gSdBvUS2f1AQZFxVS+V3+kPvVhOM
         GnGG4fderMfma0gQfUCtGptN9YWQiiY0l6g/I1faSvYURftxw8U3SQwVB0DCJ1u6Ypb7
         hYZw==
In-Reply-To: <CADiTV-37tqWsbxmeZJsqq+pqSqxN-_L9+T9R+PmBBJhfO-G09g@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Angelo Ruocco <angelo.ruocco.90@gmail.com>
Cc: Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, Mark Brown <broonie@kernel.org>, 'Paolo Valente' via bfq-iosched <bfq-iosched@googlegroups.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet>

On 11/15/18 4:54 AM, Angelo Ruocco wrote:
> Hi Jens,
> 
> I have rebased the patchset against the for-4.21/block branch, but I
> can't test them properly because the compiling process has an error on
> a different file. In particular:
> 
> include/net/xfrm.h:1465:3 error: unknown type 'spruct'
> include/net/xfrm.h:1465:30 error: expected ':', ',', ';', '}' or
> '__attribute__' before 'auth'
> 
> To be clear, and so that you can check I haven't made some trivial
> mistakes: I have added/fetched the remote [1] and then simply rebased
> against the for-4.21/block branch.

I think you have memory issues, a 'p' is just one bit away from a 't'.

-- 
Jens Axboe

