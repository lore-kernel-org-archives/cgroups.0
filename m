From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [question] Is it possible for userspace program to control cpu
 usage time of RT process through cgroup2 now?
Date: Mon, 26 Sep 2022 09:12:08 -1000
Message-ID: <YzH5iM0hy58f0tjd@slm.duckdns.org>
References: <0a83dcd5-b7fd-811c-b8d2-062115fa8c94@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=Dyqc18f7tvm496eP3xU3ct8tqy6/7/TepuJUSfhcP1Y=;
        b=pMeDGfIZ6SzFPBlN73M0ajQB/RGF4w2o+TyqK7pty1VyKbu13iZcGmLUl9Bi8c2hPZ
         eKhAKnp3n2f08OHQVHBk0cq8xo4bA/d/+AWNzbMxyzInJS+HoYC1k7Akvf8aYWF6y/LW
         wi5drJ1GstBDZBqr7IBiPDOXPWIee6npCJJtfvXUM1tAnalK/5YXC3k/HJB20y8gAufg
         gOXNdlPoOhFdxQ42BdVqVm8eYolU6FyOpYZN/YR3iqp5eEfmcYK6nWnTM6xergGyXbOQ
         +yOOkfw952go/oFjAV9ndq0eQKqhzSt7kVN5eWnT2Lv0KNiACRPbhJoopFAZY8RnRRAn
         0gsw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0a83dcd5-b7fd-811c-b8d2-062115fa8c94-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "lujialin (A)" <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Sat, Sep 24, 2022 at 05:26:20PM +0800, lujialin (A) wrote:
> Cgroup2 dose not support controling real-time processes and the cpu
> controller can only be enabled when all RT processes are in the root cgroup.
> 
> RT stuff was being overhauled when cpu controller interface for cgroup
> unified hierarchy was being implemented in 2017. It was decided that we
> would like to wait till the RT side settles down and proceed with an
> interface that better matches RT.
> 
> Is it possible for userspace program to control cpu usage time of RT process
> through cgroup2 now? If not, how is the current state looking and is there
> any proposed solution?

Not right now. The hard allocation model is pretty challenging to work with
on cgroup1 - they get enabled when cpu controller gets enabled and being
hard allocations, not allocating any prevents the cgroups from using RT at
all while allocating by default takes away from what others can use whether
that allocation is used or not, so some distros turned them off last I
checked. Overall, I'm not sure hard allocations done this way is all that
useful to manage hierarchically given that the resource has to be hard
partitioned anyway.

Can you describe your usecase?

Thanks.

-- 
tejun
