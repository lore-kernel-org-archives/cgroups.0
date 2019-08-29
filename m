From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET v3 block/for-linus] IO cost model based
 work-conserving porportional controller
Date: Thu, 29 Aug 2019 08:56:53 -0700
Message-ID: <20190829155653.GW2263813@devbig004.ftw2.facebook.com>
References: <20190828220600.2527417-1-tj@kernel.org>
 <50384CF8-39F1-461C-9EC0-7314671E5604@linaro.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ebjcblE+kxdokmjeo9JfTde5NEZGUN+yLxUfBY00nF0=;
        b=D6977bRWi1U1MlPh/embKVUWFf1b3dSi7HwF68a6Mxi7L1SX4VR41iIkKqE9csKH21
         lSTOObC3A8BZMuxVngiF5uG4UyUVcCAB5sDGK7ymiIBLNoXs5c0d2Vlyp/Rpn+TbemRE
         xgNPEP34ZOt8Io4+LBH0ANDzoMVi0qykZJre8+VSiMd8R+c3HFAc0la2j7tnXrQq3Pdp
         diSk/fkxCKAl2xIPI1MUBFfEFZS9nKz0Noa95bmVacsOIDsgWfmdQ4MidxyALvP6HtUd
         mmb14y5r20iOBDzFHghRCvYy0T2+O5vDGGgeQw5lKkA/KpPZSCfJxWq/tPkxug6hR9iB
         K+Cg==
Content-Disposition: inline
In-Reply-To: <50384CF8-39F1-461C-9EC0-7314671E5604@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente@linaro.org>
Cc: Jens Axboe <axboe@kernel.dk>, newella@fb.com, clm@fb.com, Josef Bacik <josef@toxicpanda.com>, dennisz@fb.com, Li Zefan <lizefan@huawei.com>, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org

On Thu, Aug 29, 2019 at 05:54:38PM +0200, Paolo Valente wrote:
> I see an important interface problem.  Userspace has been waiting for
> io.weight to become eventually the file name for setting the weight
> for the proportional-share policy [1,2].  If you use that name, how
> will we solve this?

So, my plan is just disabling iocost if bfq is selected as the io
scheduler.  It makes no sense to use them together anyway.  What do
you wanna do about the existing interface files prefixed with bfq?
Just rename them?

Thanks.

-- 
tejun
