From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH V2 00/10] unify the interface of the proportional-share
 policy in blkio/io
Date: Fri, 30 Nov 2018 10:42:56 -0800
Message-ID: <20181130184256.GI2509588@devbig004.ftw2.facebook.com>
References: <20181119103424.3853-1-paolo.valente@linaro.org>
 <20181120162816.GV2509588@devbig004.ftw2.facebook.com>
 <25296DAE-73EC-46CC-9A98-A8B7E9017BB7@linaro.org>
 <7D7FAB43-5F62-4402-A9B3-E7C2E30AE680@linaro.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JJNi3nIVOoVbO7Y5pWDXSGG5tKiGbvOBa0lUgfaESs8=;
        b=AihkWRCXAWxzlN+ySJS48rRtyz8NKzZlPyudz8lqJTero4AR9knrHnB0mn8T7ZHUBU
         RCqlyhQYS+CRo9lRtnzzLKeU8HanMo9sJVW/2vz8rTMH+quIx7Jx204Kvq6vP0QiYCsv
         HiEWLV5Zh96TdP8j5F2OIJd2KowyL+pNHXPy5N148OVYxmbvur5+Bl4w5KPAUoZsVmtD
         NBJY4LqcrYiiGLgorcO0UMtiBtdCFDq31lxqg3OP9AtS2jxnxLuAP8E5KUrqgAoFWxdI
         UyCOEpeQqNmEU0Tzlr/v3fN9Z+qjyHQqlm9nHQ+KDA7XTFxNcjT4iCpb7CN/lgebKro9
         Pfcw==
Content-Disposition: inline
In-Reply-To: <7D7FAB43-5F62-4402-A9B3-E7C2E30AE680@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente@linaro.org>
Cc: 'Paolo Valente' via bfq-iosched <bfq-iosched@googlegroups.com>, Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org, broonie@kernel.org, oleksandr@natalenko.name, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>

Hello, Paolo.

On Fri, Nov 30, 2018 at 07:23:24PM +0100, Paolo Valente wrote:
> > Then we understood that exactly the same happens with throttling, in
> > case the latter is activated on different devices w.r.t. bfq.
> > 
> > In addition, the same may happen, in the near future, with the
> > bandwidth controller Josef is working on.  If the controller can be
> > configured per device, as with throttling, then statistics may differ,
> > for the same interface files, between bfq, throttling and that
> > controller.

So, regardless of how all these are implemented, what's presented to
user should be consistent and clear.  There's no other way around it.
Only what's relevant should be visible to userspace.

> have you had time to look into this?  Any improvement to this
> interface is ok for us. We are only interested in finally solving this
> interface issue, as, for what concerns us directly, it has been
> preventing legacy code to use bfq for years.

Unfortunately, I don't have any implementation proposal, but we can't
show things this way to userspace.

Thanks.

-- 
tejun
