From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 09/15] blkcg: associate writeback bios with a blkg
Date: Fri, 31 Aug 2018 16:53:28 -0700
Message-ID: <20180831235328.GG1488037@devbig004.ftw2.facebook.com>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
 <20180831015356.69796-10-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3Dzh6X1LeduszbJqJBX4HPFELRK/l+JfoD9XBMT39dE=;
        b=f/9mMmrONaw3756VsZHYnD9lPNuRAIpZXV5H2BlWr1Xr6igLZ0FpFHlXCRbBtojtNy
         GpwCwKuL+uqd1AcMMFO/SobXCvuw+yVasiYZb18HOAVNCjywWYAcPEKmExEU45i6SOFz
         9iGQsDmX5CoWvyN0m+MGtOVn57yLekRTuVuLDwMA/6NUAS7FCic6Y6OKLr880N/AYBTY
         qQmtebskBCnx5OkjmxXx6ULGZHTTJaq63ejOGWqxpP2tvkNbw6azdyTOIYHyI3Iw6q+T
         C4Kx42hI6O1JkzQZJKVarvuraMyc6PLMWDzJaH47OVfYKZPh2DT95y5TaFPHPa5GBa6S
         8hfg==
Content-Disposition: inline
In-Reply-To: <20180831015356.69796-10-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Aug 30, 2018 at 09:53:50PM -0400, Dennis Zhou wrote:
> From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>
> 
> One of the goals of this series is to remove a separate reference to
> the css of the bio. This can and should be accessed via bio_blkcg. In
> this patch, the wbc_init_bio call is changed such that it must be called
> after a queue has been associated with the bio.
> 
> Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
