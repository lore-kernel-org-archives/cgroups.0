From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 03/27] blk-iocost: use local[64]_t for percpu stat
Date: Fri, 20 Nov 2020 17:13:57 -0500
Message-ID: <X7g/pTLLJEQXdbD7@mtj.duckdns.org>
References: <20200901185257.645114-1-tj@kernel.org>
 <20200901185257.645114-4-tj@kernel.org>
 <20201120215147.GB961977@lianli.shorne-pla.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z1pyZKUt70+7Oah4brRuaKPswnwh6VHan/l11sMx/Yg=;
        b=ljsWDBMqGzGOgdCS3yCLBdUS4tlf5XcKxFGdE2y5hnGDPlHFCJvgNgONmquepZKXm3
         gA3I75WL0l/JV+dAYNQwIwXg/ito2mPyy3WMIeEno7t+bzQLXNa+y1vhfB2r9f7Osb2/
         Rc/lpcKXHbQGiSD1QNy3tpmxLvtnTVo+4G7XFjVtBL8QCCQUoKfYoD4A7cLOXlw20f3M
         qGyxp/h6erD4hnK6wMCjix/lF3sUsQozSnQX6aSYEMelVacfe22lymxKLrTNQSMNK25I
         a4JDZtUmf4RU4wuufHvcAW46kKpj++bgP5VpvRvQ047kFD7cyGCF54+mVNun1zsbvTdu
         QSsA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20201120215147.GB961977-Uk7Bhu+bUQgm0WYXfsLZQReHL2rgt/dS@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stafford Horne <shorne-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, newella-b10kYP2dOMg@public.gmane.org

Hello,

On Sat, Nov 21, 2020 at 06:51:47AM +0900, Stafford Horne wrote:
> FYI, I am just noticing this but this breaks my allyesconfig build
> on OpenRISC; as 32-bit arch/openrisc doesn't define local64.h
> 
> In general local64 is slow on 32-bit architectures, would that
> be a problem with the usage here?  Are the calls to local64_*
> below on critical paths?

It gets hot when running on really high iops devices but that hopefully
isn't a problem for 32bit openrisc.

> Either way I will submit a patch in include generic local64.h
> on OpenRISC, I confirmed it fixes the build.  I do not know of anyone
> using cgroups on OpenRISC systems.

Yeah, sounds like the right fix.

Thanks.

-- 
tejun
