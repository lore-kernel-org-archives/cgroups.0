From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH V2 00/10] unify the interface of the proportional-share
 policy in blkio/io
Date: Tue, 18 Dec 2018 08:41:26 -0800
Message-ID: <20181218164126.GX2509588@devbig004.ftw2.facebook.com>
References: <20181119103424.3853-1-paolo.valente@linaro.org>
 <20181120162816.GV2509588@devbig004.ftw2.facebook.com>
 <25296DAE-73EC-46CC-9A98-A8B7E9017BB7@linaro.org>
 <7D7FAB43-5F62-4402-A9B3-E7C2E30AE680@linaro.org>
 <20181130184256.GI2509588@devbig004.ftw2.facebook.com>
 <5534B7D4-A5D9-4F44-9620-970A7F9EC140@linaro.org>
 <CADiTV-29TmkB5-k=TtQfoJqjP2Qv7GSsGLXAPBaTB6DoQ+6yyw@mail.gmail.com>
 <874A0232-2103-4364-BD88-F33B85D6A764@linaro.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Qxr/PEmJFsRrEklCc2G+CWcsbCOLd3hDZQ0GvBRgCew=;
        b=pvDaeC2cbDIqoVcA3a91jug0vWkjNpchLP/2I2Se4eWplDu/fuTKeXSS/VJV8ywV1q
         i9aIGZnHhCRXA6OCtBTff+pbjuA3yI/AmyteGwyk/ELfIMyGyjOd0u5u8a5SOEmS9IyO
         loJmL9R+FyAQmPEtz4V0PzR8dCuRwlkIpRyVKvJREujIeYdchZnzile8RH0l1A6BZpRI
         j68L6pqFN65vlqESWiDbK4M/bnJifR3Gc5TIrP1uASGG+6OO85l6m1TH3ogYBiDfjiyS
         V34/ZTwVwcy9A7pkAhG8JbqhOMNOXb7TEejxdnWjRpFX3IqFfOhMCPYq56irF+sNyjFe
         wQow==
Content-Disposition: inline
In-Reply-To: <874A0232-2103-4364-BD88-F33B85D6A764@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente@linaro.org>
Cc: Angelo Ruocco <angelo.ruocco.90@gmail.com>, 'Paolo Valente' via bfq-iosched <bfq-iosched@googlegroups.com>, Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org, broonie@kernel.org, oleksandr@natalenko.name, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>

Hello, Paolo.

On Tue, Dec 18, 2018 at 08:48:10AM +0100, Paolo Valente wrote:
> If Tejun cannot see any solution to his concern, then can we just
> switch to this extension, considering that
> - for non-shared names the interface is *identical* to the current
>   one;
> - by using this new interface, and getting feedback we could
>   understand how to better handle Tejun's concern?
> A lot of systems do use weights, and people don't even know that these
> systems don't work correctly in blk-mq.  And they won't work correctly
> in any available configuration from 4.21, if we don't fix this problem.

So, when seen from userland, how it should behave isn't vague or
complicated.  For a given device and policy type, there can be only
one implementation active.  It doesn't make sense to have two weight
mechanisms active on one device, right?  So, the interface should only
present what makes sense to the user for both configuration knobs and
statistics, and that'd be a hard requirement because we don't want to
present confusing spurious information to userspace.

There seemd to have been significant misunderstandings as to what the
requirements are when this was discussed way back, so idk what the
good path forward is at this point.  Just keep the current names?

Thanks.

-- 
tejun
