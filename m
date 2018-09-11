From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 09/12] blkcg: remove additional reference to the css
Date: Tue, 11 Sep 2018 16:51:50 -0700
Message-ID: <20180911235150.GD2966370@devbig004.ftw2.facebook.com>
References: <20180911184137.35897-1-dennisszhou@gmail.com>
 <20180911184137.35897-10-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0rCgQO6XgVZi1lpxhVm/fJTejrvktbRjuN4qfvXFmE8=;
        b=KgH3HA9uLhe3ncZ8+5SZsBNQ2wsOOVyiPczLdlZrTEXRPHf4MIo0MHmd/8r46F6l0h
         GALy4DIRIkt+Fo3aj/yXMK+Hz/ZhZeX41Ue1eW2cDPfOO56221tHQ+Gzcpv7/zbvz+zz
         BuKpEoKA401kJNliLsVNszgpTumHJ/1JkB+IvAmetq1MPAtFGRi5ji24daYVmMo9SVBt
         wpUzN4SDvNN3qSPh+nmJE3veuWOUDovR0L5k26EdJGIqCMf7w4s+hK6XYdwJHy9fBBXk
         BhRs9rftICDTIEC/QXO83TXBxURUgTCUCHfRhBJ0CjFy7aNN47XEysIHj42BLzE8e0Za
         WkjA==
Content-Disposition: inline
In-Reply-To: <20180911184137.35897-10-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Sep 11, 2018 at 02:41:34PM -0400, Dennis Zhou wrote:
> From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>
> 
> The previous patch in this series removed carrying around a pointer to
> the css in blkg. However, the blkg association logic still relied on
> taking a reference on the css to ensure we wouldn't fail in getting a
> reference for the blkg.
> 
> Here the implicit dependency on the css is removed. The association
> continues to rely on the tryget logic walking up the blkg tree. This
> streamlines the three ways that association can happen: normal, swap,
> and writeback.
> 
> Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
