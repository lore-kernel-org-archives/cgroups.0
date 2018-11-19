From: Angelo Ruocco <angelo.ruocco.90@gmail.com>
Subject: Re: [PATCH 00/12] unify the interface of the proportional-share
 policy in blkio/io
Date: Mon, 19 Nov 2018 10:46:24 +0100
Message-ID: <CADiTV-0Yxo=WagKPGcJebk+XQvPNxFjpyvVZmOKE2PPjFzv7pQ@mail.gmail.com>
References: <20181112095632.69114-1-paolo.valente@linaro.org>
 <9e8adb3271680165d85994a225713391@natalenko.name> <E8A20452-A73C-4A31-B5EC-48EFB9937832@linaro.org>
 <e85cfae0-7743-8c51-c2c9-0855c26f868e@kernel.dk> <CADiTV-37tqWsbxmeZJsqq+pqSqxN-_L9+T9R+PmBBJhfO-G09g@mail.gmail.com>
 <79a2da26-669a-359c-3832-354ec2b47231@kernel.dk>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=/5KBi0cm0UZGRmOnPPYVeGoLrG4FVrLsOwakUAWUfVg=;
        b=T0iPU07/Em0+Vs+RlaPd7CSr9UZiOuq9GoKrTOodZ5EA2fkmqJn/rP00kc979aPRwF
         fds1qPJJNmwMaFAd/6u/tobMkVJlaOApkSHCLMoGLqA7ZvULavCcUSmERSjB5BI3tp9F
         j21OL1KixuYPCJPQyZ8mHb1OetiaEinRNDnG2b1VFGz7tfKc9OEgr+Ldxm6vkac0JUCi
         NhhMtPErIfFeuA17gSbGOPF4T+25jVXHhdLSbwMqOD90XWh+D0d07ASbJXgezpL4lAqz
         XtWJMkrVxTPSeTS4UQF5Ka1YDdYD2SKswKDh7qIjS+Tkl9UI/nWspHqfMLx8wSmXU5bY
         regQ==
In-Reply-To: <79a2da26-669a-359c-3832-354ec2b47231@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, Mark Brown <broonie@kernel.org>, 'Paolo Valente' via bfq-iosched <bfq-iosched@googlegroups.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbe>

2018-11-15 17:30 GMT+01:00, Jens Axboe <axboe@kernel.dk>:
> On 11/15/18 4:54 AM, Angelo Ruocco wrote:
>> Hi Jens,
>>
>> I have rebased the patchset against the for-4.21/block branch, but I
>> can't test them properly because the compiling process has an error on
>> a different file. In particular:
>>
>> include/net/xfrm.h:1465:3 error: unknown type 'spruct'
>> include/net/xfrm.h:1465:30 error: expected ':', ',', ';', '}' or
>> '__attribute__' before 'auth'
>>
>> To be clear, and so that you can check I haven't made some trivial
>> mistakes: I have added/fetched the remote [1] and then simply rebased
>> against the for-4.21/block branch.
>
> I think you have memory issues, a 'p' is just one bit away from a 't'.

That was indeed the problem.

Thank you,
Angelo

>
> --
> Jens Axboe
>
