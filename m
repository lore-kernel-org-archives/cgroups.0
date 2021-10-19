From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [BUG] blk-throttle panic on 32bit machine after startup
Date: Tue, 19 Oct 2021 07:45:57 -1000
Message-ID: <YW8EVVmrQpuiwyEC@slm.duckdns.org>
References: <CAEKhA2x1Qi3Ywaj9fzdsaChabqDSMe2m2441wReg_V=39_Cuhg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2MlySN5JbrqzxF/Em4ggjCL2GMkbXRbHLm4CFSB5M5I=;
        b=cNd6/BHJIRYcPDuXiiaGgGr4U3V9uE4qNprUYOv81pfog4kXAogbLT8Soi9Q5nMjyA
         3sEnP7x22YmWxIbl8dgVaHcT+99BrRLMrQQ/wd/FfiH9Q8WmGCHjq9q8esWhid5E7hws
         0SYmG/UVbn6H0J3YGQbXmWNCCCzOBnS0E3BN4du6DdvRVx5uW52BwLuGUW5c/Z8DDqvp
         IFrCKb/2BW9EYdF0EiiXz+xY63OC1DFoKna6vLrCaoOMO3HjUxWbh+K8DpRV235S7Bca
         tata+q2H+0kz2Lo9xTopCiziDO4CGZLfX1hzmLPCr1y/P+MTxnLcr8H0XyWp9axC7LOP
         1cNA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAEKhA2x1Qi3Ywaj9fzdsaChabqDSMe2m2441wReg_V=39_Cuhg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Youfu Zhang <zhangyoufu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Oct 18, 2021 at 03:08:53PM +0800, Youfu Zhang wrote:
> Hi,
> 
> I ran into a kernel bug related to blk-throttle on CentOS 7 AltArch for i386.
> Userspace programs may panic the kernel if they hit the I/O limit
> within 5 minutes after startup.
> 
> Root cause:
> 1. jiffies was initialized to -300HZ during boot on 32bit machines
> 2. enable blkio cgroup hierarchy
>    __DEVEL__sane_behavior for cgroup v1 or default hierarchy for cgroup v2
>    EL7 kernel modified throtl_pd_init and always enable hierarchical throttling
> 3. enable & trigger blkio throttling within 5 minutes after startup
>    bio propagated from child tg to parent
> 4. enter throtl_start_new_slice_with_credit
>    if(time_after_eq(start, tg->slice_start[rw]))
>    aka. time_after_eq(0xFFFxxxxx, 0) does not hold
>    parent tg->slice_start[rw] was zero-initialized and not updated
> 5. enter throtl_trim_slice
>    BUG_ON(time_before(tg->slice_end[rw], tg->slice_start[rw]))
>    aka. time_before(0xFFFxxxxx, 0) triggers a panic

This doesn't reproduce on 5.14.

Thanks.

-- 
tejun
