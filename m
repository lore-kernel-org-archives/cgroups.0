From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] block, bfq: delete "bfq" prefix from cgroup filenames
Date: Tue, 17 Sep 2019 14:32:09 -0700
Message-ID: <20190917213209.GK3084169@devbig004.ftw2.facebook.com>
References: <20190917165148.19146-1-paolo.valente@linaro.org>
 <20190917165148.19146-3-paolo.valente@linaro.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6cdjH5M5cwq0sm332RdYEPiqfQpF2RR9LsPCpbZYDwQ=;
        b=IHkrkyrTjqmtC97bG84hTy/5TfojbkwbxNX5Z7uREwvPtxFj/px0ZiyGIn1bJjByWB
         x1ecC8HiuApwY5CvSfB5gDPN1az2OY0iUc+/6d+lY4u9HW0lsKcyNz76olwUJAJIVs0Y
         3Li8WS9rLHfQw63VdijGqDhnEJvHg1itxFegJr0FsZKXldWyRaQ7tfcQVazjYi8byce4
         WsIBOadrzh6E2Rsbv7/KqvUghALMKnW6guJ4npItSpsJzUl2Vuo1XMssafXzY4ztboOV
         ejrg9wzd8b8zOYNZ1whxd+fhPIRYd7sO35Xlysx6IyF06TVbkLIWFYfZ4y7lY75KI+t3
         oFUQ==
Content-Disposition: inline
In-Reply-To: <20190917165148.19146-3-paolo.valente@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente@linaro.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org, bfq-iosched@googlegroups.com, oleksandr@natalenko.name, cgroups@vger.kernel.org, Angelo Ruocco <angeloruocco90@gmail.com>

Hello,

On Tue, Sep 17, 2019 at 06:51:48PM +0200, Paolo Valente wrote:
> When bfq was merged into mainline, there were two I/O schedulers that
> implemented the proportional-share policy: bfq for blk-mq and cfq for
> legacy blk. bfq's interface files in the blkio/io controller have the
> same names as cfq. But the cgroups interface doesn't allow two
> entities to use the same name for their files, so for bfq we had to
> prepend the "bfq" prefix to each of its files. However no legacy code
> uses these modified file names. This naming also causes confusion, as,
> e.g., in [1].
> 
> Now cfq has gone with legacy blk, so there is no need any longer for
> these prefixes in (the never used) bfq names. In view of this fact, this
> commit removes these prefixes, thereby enabling legacy code to truly
> use the proportional share policy in blk-mq.

So, I wrote the iocost switching patch and don't have a strong
interest in whether bfq prefix should get dropped or not.  However, I
gotta point out that flipping interface this way is way out of the
norm.

In the previous release cycle, the right thing to do was dropping the
bfq prefix but that wasn't possible because bfq's interface wasn't
compatible at that point and didn't made to be compatible in time.
Non-obviously different interface with the same name is a lot worse
than giving it a new name, so the only acceptable course of action at
that point was keeping the bfq prefix.

Now that the interface has already been published in a released
kernel, dropping the prefix would be something extremely unusual as
there would already be users who will be affected by the interface
flip-flop.  We sometimes do change interfaces but I'm having a
difficult time seeing the overriding rationales in this case.

Thanks.

-- 
tejun
