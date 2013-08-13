From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH][3.11] cpuset: fix the return value of cpuset_write_u64()
Date: Tue, 13 Aug 2013 10:57:33 -0400
Message-ID: <20130813145733.GD26596@mtj.dyndns.org>
References: <52099487.8010601@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=4XtGUa5ZF1pDf6bzsNt7sM6PFOMVFwuaFgPJiFsQoWw=;
        b=Vh+MpHXOI9we+NTolE7KCNPkdlIyuQAgylZk4cxWpvY6ZhUsPrK3FZQaYigtm4p+V6
         tz7XT9fTiXky8MIfq5WbyC1JCj3g+ViPuLxxeCuS+icymMluWpStysKZvdTqGESxmw2c
         yUKHub9pO7SwmWJ7SAgzpwJuxDpCKbvGSTVtu4H8035KEAo9P65Pw5KQzt5J0tIQW7xV
         SMf2fwdd4W0o34hnSXTxPlrHlLoR0g10X7M9Frf1Q5++wfPIFF2jiXKrhHvHqYFnwymT
         +o1hXxyzj2hWzCgJw6EaA1xCvhpEYS4Byt54jr/+UbIxWVyMKPGsGPMsh28ak1hpWIr6
         k2JA==
Content-Disposition: inline
In-Reply-To: <52099487.8010601@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>

On Tue, Aug 13, 2013 at 10:05:59AM +0800, Li Zefan wrote:
> Writing to this file always returns -ENODEV:
> 
>   # echo 1 > cpuset.memory_pressure_enabled
>   -bash: echo: write error: No such device
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> Cc: <stable@vger.kernel.org> # 3.9+

Applied to cgroup/for-3.11-fixes.  Thanks.

-- 
tejun
