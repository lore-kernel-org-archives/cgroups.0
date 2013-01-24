From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 6/6] cgroup: remove bogus comments in cgroup_diput()
Date: Thu, 24 Jan 2013 13:49:17 -0800
Message-ID: <20130124214917.GU2373@mtj.dyndns.org>
References: <5100D4FE.9080205@huawei.com>
 <5100D562.6050407@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=KhWy2Jl/Yqcs7IdTmSZYhB3Y7/NxLX+KeBDH6b92lyY=;
        b=XSfHMP/9lrNP1oQu3Iz5RDgdLHmku66WholqmpZLk964Id8otuUh3flRfVlCmhDn7S
         OmUAJ0JoATZwGYfgqaZHl4pejpMvpuq4NyNsE6KKQQO5romI7x3uIEyYjQsJb8t8ZAV/
         GSNAiIclFc6TXIqBMA7zCvviOMnBqhSxQuqSn25MecBQtDxntht7RZLLcgHLgQ6CdLO8
         KXF0FAw0xi6Iso4fsIacv5soreGSRyL1cENpiASaNmdUUQEIYU+1oBW+Z2tvqGq6XlGB
         TmW2JGCZavCbckAKinzEwEEtLbGF+d6GpF2Gt86BD0nDg8h1XSeEfimnJkIfqJrgp9Tg
         VTSw==
Content-Disposition: inline
In-Reply-To: <5100D562.6050407-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Li.

On Thu, Jan 24, 2013 at 02:32:02PM +0800, Li Zefan wrote:
> Since commit 48ddbe194623ae089cc0576e60363f2d2e85662a
> ("cgroup: make css->refcnt clearing on cgroup removal optional"),
> each css holds a ref on cgroup's dentry, so cgroup_diput() won't be
> called until all css' refs go down to 0, which invalids the comments.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  kernel/cgroup.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index f18b0d9..368cff1 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -899,12 +899,6 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
>  		struct cgroup *cgrp = dentry->d_fsdata;
>  
>  		BUG_ON(!(cgroup_is_removed(cgrp)));
> -		/* It's possible for external users to be holding css
> -		 * reference counts on a cgroup; css_put() needs to
> -		 * be able to access the cgroup after decrementing
> -		 * the reference count in order to know if it needs to
> -		 * queue the cgroup to be handled by the release
> -		 * agent */

The latter half is still true tho.  I applied the patch anyway as the
comment isn't all that useful without covering everything intended to
be covered with RCU.  Can you please write up another patch
documenting what's covered by RCU (stuff that we intend to keep
guaranteeing to be safe to access only w/ RCU)?

Thanks.

-- 
tejun
