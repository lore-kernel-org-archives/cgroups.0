From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] blkcg: add plugging support for punt bio
Date: Thu, 6 Aug 2020 10:30:30 -0400
Message-ID: <20200806143030.GB4520@mtj.thefacebook.com>
References: <1596722082-31817-1-git-send-email-xianting_tian@126.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LteJlP8Yogs33/2uiEGaGLM6yuhYrOVPJn4ZtRs/VAY=;
        b=l4QJ+RmI532zvjM5xWTnembw7sAHBExPkpfcibAnwteNcSCn8+o18CA9tyM5SyqYkA
         D97lt1UEgCP9gZdJXb2toIh0k08nTp/MnQaFMgSGtYZswjn+WmHuGLHGAhC2Yl7qHV04
         LAmBgQ2DkLermDebM23pPpfr5S1akiR3cXZkt8rXS3KBiXuaP0XgawjaNbkGjXW16m+T
         kuART3o962Obu0Ct/gZXgqiZRFAJ9+3S/0zrtuI69BtPIYug4kUCT8aqhGMpgt1QFM21
         j4j2DPyhulDwUy6r+hjcPf8hfRJyMXbviv21mXo+3jNhf/U6xWMbcAg0rF3vXfNRZDRV
         w8HQ==
Content-Disposition: inline
In-Reply-To: <1596722082-31817-1-git-send-email-xianting_tian-KN7UnAbNpbg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xianting Tian <xianting_tian-KN7UnAbNpbg@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Aug 06, 2020 at 09:54:42AM -0400, Xianting Tian wrote:
> Try to merge continuous bio to current task's plug fisrt.
> 
> Signed-off-by: Xianting Tian <xianting_tian-KN7UnAbNpbg@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks!

-- 
tejun
