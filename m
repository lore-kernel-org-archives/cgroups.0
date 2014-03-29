From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: fix spurious lockdep warning in cgroup_exit()
Date: Sat, 29 Mar 2014 09:18:12 -0400
Message-ID: <20140329131812.GC5553@htj.dyndns.org>
References: <53352243.80805@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=yKU0SvZdmzgHMFZkBzWQc2Q7kdSso0RVPLnNOebJ+I4=;
        b=qG9lTlbXhdf912EpqWoNfzqPtYL5iPqw6GUe0kc3wX6EMWQtkavRAfpcv8vxEEYBQa
         CYfA3PMMRfWONWPVriOzkcs8hHdU1XhFXwUoeBqdlFu3kKmVrS7mRWL3C3o/IR1g69Si
         ZXWlBlEHVlzL5ji2tdhTBe63osMnTvV0F6B0ufmzjIwdNGGX66Rj1ICe2GJlzGV5Be+y
         o1cd6a+SyC0Q6/rBfzDDHAlKSLgKJhL53d9gh3sDVY40tBQ3hjiM1Xrc588pszsuR0EB
         K7ka1Xs13dmYIMbw1I0dyjORKP9tzqV+HOkJVmQEzKjj9rgBxnSedOmvNC6TX2wh/Ssp
         twSw==
Content-Disposition: inline
In-Reply-To: <53352243.80805-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Mar 28, 2014 at 03:18:27PM +0800, Li Zefan wrote:
> cgroup_exit() is called in fork and exit path. If it's called in the
> failure path during fork, PF_EXITING isn't set, and then lockdep will
> complain.
> 
> Fix this by removing cgroup_exit() in that failure path. cgroup_fork()
> does nothing that needs cleanup.
> 
> Reported-by: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied 1-2 to cgroup/for-3.15.

Thanks!

-- 
tejun
