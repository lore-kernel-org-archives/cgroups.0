From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] block, bfq: delete "bfq" prefix from cgroup filenames
Date: Wed, 18 Sep 2019 08:19:48 -0700
Message-ID: <20190918151948.GL3084169@devbig004.ftw2.facebook.com>
References: <20190917165148.19146-1-paolo.valente@linaro.org>
 <20190917165148.19146-3-paolo.valente@linaro.org>
 <20190917213209.GK3084169@devbig004.ftw2.facebook.com>
 <4D39D2FA-A487-4FAD-A67E-B90750CE0BD4@linaro.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4/ozkoPe7I7HBcRNmLxlm9zJ7nl+dZfk4PcCpSwHEE0=;
        b=T2V++haNtE/r+StT15PyzM8Pcx6eaP5oSwCQUlyICnkOO9OKmWUetxLSpJ+zeMMVm4
         Umui41NlalpMH08oCwjhUB8rcPoPnvb4O75FaSLSpzXsOC8AeDcEFpcwKgGoIrv8svQG
         Rq6lvlestuw80aSnQEx6Bp8hEcJzMpt1xbUH732DypsleAg7F1jnT0gy2aTwuAuVwG5i
         vG3D/JY8NyPMDOrlPAk9MoiOF/4w7Er3TI3dDYvtUxWooplJYAbrWZwmnWkbKkv2kZNJ
         O9knfGLSvhfjDSDSr3jLBMun+UVHVSZO/V4bM/o9XlBnZMKtacHwgn6vG8Zd4liINg+A
         vcKg==
Content-Disposition: inline
In-Reply-To: <4D39D2FA-A487-4FAD-A67E-B90750CE0BD4@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente@linaro.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org, bfq-iosched@googlegroups.com, oleksandr@natalenko.name, cgroups@vger.kernel.org, Angelo Ruocco <angeloruocco90@gmail.com>

Hello,

On Wed, Sep 18, 2019 at 07:18:50AM +0200, Paolo Valente wrote:
> A solution that both fulfills userspace request and doesn't break
> anything for hypothetical users of the current interface already made
> it to mainline, and Linus liked it too.  It is:

Linus didn't like it.  The implementation was a bit nasty.  That was
why it became a subject in the first place.

> 19e9da9e86c4 ("block, bfq: add weight symlink to the bfq.weight cgroup parameter")
> 
> But it was then reverted on Tejun's request to do exactly what we
> don't want do any longer now:
> cf8929885de3 ("cgroup/bfq: revert bfq.weight symlink change")

Note that the interface was wrong at the time too.

> So, Jens, Tejun, can we please just revert that revert?

I think presenting both io.weight and io.bfq.weight interfaces are
probably the best course of action at this point but why does it have
to be a symlink?  What's wrong with just creating another file with
the same backing function?

Thanks.

-- 
tejun
