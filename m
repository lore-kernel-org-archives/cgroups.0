From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 06/11] blk-throttle: fix typo in comment of
 throtl_adjusted_limit
Date: Wed, 23 Nov 2022 08:26:54 -1000
Message-ID: <Y35l7pbl6L5xksfl@slm.duckdns.org>
References: <20221123060401.20392-1-shikemeng@huawei.com>
 <20221123060401.20392-7-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ExI+gqwMwbbQGJtDcMkFI1iGM13TFlKZnknvNLszb/A=;
        b=J/C5kMhyMAvP6iYfcxmfKxz0cDRWDZMuBogH8Tl/MJrBTJMQNCSFeNy55eOlhBbcRu
         5CI/dw95TZFrNUjLWYdSrGz8dkL1lDQ8KkTdMJAFwWdM9FSA5o1P7H0uHgJ0bQBvwPPk
         Iy/JWUnixVn4/+COYZHzCJoAVFOWBrAsZC46J+9TW4g15rmPTePHv5rh4PiHe+Qd6R7u
         1EOgCQCHCCk5bX0BOTtYGeGn9ifVlgxgYBQCSFvPEAgPmnpxe2c6Dwtt+0Owef2fAWCZ
         PafveCoWYKs8eyh9YBTFgCrv+Wi1qpuD12PCv+fXWvPED37vvKHSGxh3SGd2LYv5RA4h
         yizg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221123060401.20392-7-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Nov 23, 2022 at 02:03:56PM +0800, Kemeng Shi wrote:
> lapsed time -> elapsed time
> 
> Signed-off-by: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
