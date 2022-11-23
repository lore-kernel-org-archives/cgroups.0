From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 11/11] blk-throttle: Use more siutable time_after check
 for update slice_start
Date: Wed, 23 Nov 2022 08:29:49 -1000
Message-ID: <Y35mnXMNg8HeHXbb@slm.duckdns.org>
References: <20221123060401.20392-1-shikemeng@huawei.com>
 <20221123060401.20392-12-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DQVPLKYFSJ4QgW7SluwF8mIfyxsYEuGishngmx0s4yI=;
        b=EBWluekWbdhZB0XWgYo6kN7mgHPwsTZJrKzgmUs8vlIN+toDkOZB3gh8SghcH4Pdw9
         aetVZ1tDqRGd1wbMXS1qQYE5bitUukYhkFNFOimSTAziveZAdtvbr5L9NemY/FbCbSz1
         XNX+coHGs2w8DymzXAPofEJU3+sZ7WHwveRNlINCZXNlZyourTP1tXxgi3DJrifrLPhP
         4CucWDTHDSMTcDjSvcOw07KUm4WSMcMQMhnhdzg+/WDShWJ0l6gh2Lsbua6JJNZnj0+d
         DWXHTdA13OqZkuSNA7/VfpvnLJ/CwTxdFJLGyj9oFQnz5u6RGexuKuyRixkee+IppZNv
         VNog==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221123060401.20392-12-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Nov 23, 2022 at 02:04:01PM +0800, Kemeng Shi wrote:
> Use more siutable time_after check for update slice_start

Why is it more suitable?

-- 
tejun
