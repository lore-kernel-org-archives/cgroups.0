From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: [PATCH 00/12] unify the interface of the proportional-share
 policy in blkio/io
Date: Thu, 15 Nov 2018 16:42:04 +0100
Message-ID: <03b320ba47a0b2567f9135d17d5d93bd@natalenko.name>
References: <20181112095632.69114-1-paolo.valente@linaro.org>
 <9e8adb3271680165d85994a225713391@natalenko.name>
 <E8A20452-A73C-4A31-B5EC-48EFB9937832@linaro.org>
 <e85cfae0-7743-8c51-c2c9-0855c26f868e@kernel.dk>
 <CADiTV-37tqWsbxmeZJsqq+pqSqxN-_L9+T9R+PmBBJhfO-G09g@mail.gmail.com>
 <CADiTV-3tSpEMG7EHz3XGvfekNdtN8k_KQiDMtyykgOb81cvO0g@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1542296524;
        h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZUQbZVTpYqrz/LfYbA0NgZXCAeJR1wLkt7HtSNw1xHs=;
        b=tEAQMwLjfCex8QhzvYs8mjI3SrfMoaiXX6UCESjg6ut6j94q6hR8//aZnnMz1XcsLGSXLi
        MuJqY6JlR4UxxMIEClTaW04CuEIvW+OU0dJ7cNl1GUOgUoZbJAXjNF2cpqty9rKwj73S6e
        43QvSrX6CMkA3dg3g12sxZGbOIsyqAM=
In-Reply-To: <CADiTV-3tSpEMG7EHz3XGvfekNdtN8k_KQiDMtyykgOb81cvO0g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Angelo Ruocco <angelo.ruocco.90@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Paolo Valente <paolo.valente@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, Mark Brown <broonie@kernel.org>, 'Paolo Valente' via bfq-iosched <bfq-iosched@googlegroups.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Lennart Poettering <lennart@poettering.net>

Hi.

On 15.11.2018 16:33, Angelo Ruocco wrote:
> I have realized that I didn't clearly explain my actions. I did do a
> rebase, but that is not the cause of the problem I reported. I mean,
> this is enough to trigger the issue:
> 
> git add remote block [1]
> git fetch block
> git checkout for-4.21/block
> 
> make
> 
> [1] git://git.kernel.dk/linux-block [1]

Checking this:

http://git.kernel.dk/cgit/linux-block/tree/include/net/xfrm.h?h=for-4.21/block#n1465

and `git blame`, I don't see any `spruct` there.

Is your storage OK? Or, maybe, that was some accidental edit?

-- 
   Oleksandr Natalenko (post-factum)
