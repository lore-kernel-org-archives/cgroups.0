From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/6] sched: split out css_online/css_offline from tg
 creation/destruction
Date: Thu, 24 Jan 2013 11:42:05 -0800
Message-ID: <20130124194205.GS2373@mtj.dyndns.org>
References: <5100D4FE.9080205@huawei.com>
 <5100D518.8000103@huawei.com>
 <20130124100134.GC26351@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=0jkj57ss8xvnoqJVvnhwa5xn6FwKmL17TH9gATRZ5jk=;
        b=JcUNXl8sT9yUl3xJnTlXKiGFlJmSQ/rHfh0eR3kIQ/eUmLJ8IwjUq/zzr8zVyFAHLf
         0AH2K+DxpgR6PH9XII+MekqMf/Bu7bNrfc+Ga7nnm7wz9AHS2PxOVLJ8c4Ptoebv5Idn
         xHU871mSZqQO3jweL78RpaZXK7psRR10qq1jaDZtRKZotPmiN7JxgtvqzwnpbYJVMMwq
         CBZsPOALVtEU7GQGciMuL8QB69Y/w+KMBgwJsJgWPBiUkubUFoZ3OYIcBLh6LQIPIOqW
         dl4usJHRHf3grlFTcej9sAaEyn/jljnW9MtTu9vJLTtH6I4JBocgZwP3LoaiOIL7q2yI
         D41w==
Content-Disposition: inline
In-Reply-To: <20130124100134.GC26351-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Jan 24, 2013 at 11:01:34AM +0100, Ingo Molnar wrote:
> Acked-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Ingo, if you don't objecdt, I'll take these through cgroup/for-3.9
branch with other cgroup changes.  Pleaes holler if you object.

Thanks.

-- 
tejun
