From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/6] cgroup: initialize cgrp->dentry before css_alloc()
Date: Thu, 24 Jan 2013 12:06:09 -0800
Message-ID: <20130124200609.GT2373@mtj.dyndns.org>
References: <5100D4FE.9080205@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=iRpUj+cLtL/Gn1figFLOD9fPUzkcNyiXvU8lJp4B1zw=;
        b=0gixfVKN7ot0ztAW5Zowb3rDC72q/b1iD1kxFVxVMKRJ0QWJLm0YN3xJqzKXbIgdnP
         JSoHZ1vnBmdKf9C3/de9O+hecg1b+z5YS9fjNYnVu0vyWg/4Xk9gZPHt45Mj+cOYZTFA
         HdEkiF1DHQ6QTRIQZH1o57x3BreYRbZNQth/8ej5obBJIZiC1aT//U1ORbH9CqB1gKBE
         t8tiyYx5d6OaMM15ogUng+5EVufX0ogdzuUfdZU/9Q8DM8zAWwPdyAKZpWPlhvqh12D5
         YHigU4hFw35m57mfZuIa0uWipT70j/YX2qiQl1rgCIcVe4Wb1nFBwuRn2r1x2QuECX6t
         nPnw==
Content-Disposition: inline
In-Reply-To: <5100D4FE.9080205-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Jan 24, 2013 at 02:30:22PM +0800, Li Zefan wrote:
> With this change, we're guaranteed that cgroup_path() won't see NULL
> cgrp->dentry, and thus we can remove the NULL check in it.
> 
> (Well, it's not true, because dummptop.dentry is always NULL)
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Appled 1-6 to cgroup/for-3.9.

Thanks.

-- 
tejun
