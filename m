From: Tejun Heo <tj@kernel.org>
Subject: Re: blk-cgroup cleanups
Date: Mon, 10 Jun 2019 11:23:02 -0700
Message-ID: <20190610182302.GD3341036@devbig004.ftw2.facebook.com>
References: <20190606102624.3847-1-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZFqoQ1NOYvg67NnTQGvHpFt++wU3sOt+xafTmUoMtA4=;
        b=CIrSvqbul3dKDqKmx+MXHnrt0zVRSlnMXD02VsGK1E13v46iS6NppURtuIxPH2XPu9
         IZvPszVw8H/KZqu8IEYoPvFsADsS7ZRarU6YHsQSkyIJ+qQdhxQegDMH/Kx6D1+/bd86
         fACkoLbL3BmDxXzAm74qMiXgr4ZaaXA5yVsrq8w9P2X1+C7M76WzjcjueUdelaVY9hbx
         JWoM5eCxO3p6S92vov3M5DHfVyLr7FOk8PImyvqc0Oa5PaBZHs/tuxSXKFvv5pZ/MnSE
         A+bTyvlYeQhSwoPvbj7Ei5f4Q8MC8FD8NZdqiL9e5/sZNpv3fxNxRdLF756TXLlCIc62
         6Pkg==
Content-Disposition: inline
In-Reply-To: <20190606102624.3847-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Paolo Valente <paolo.valente@linaro.org>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Jun 06, 2019 at 12:26:18PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> below are a couple of cleanups I came up with when trying to understand
> the blk-cgroup code.

For the whole patchset,

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
