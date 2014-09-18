From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix unbalanced locking
Date: Thu, 18 Sep 2014 12:34:12 -0400
Message-ID: <20140918163412.GB13573@mtj.dyndns.org>
References: <541AA5CE.8040006@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=yBXga+XbN9i927m3r+YGK81MjRLbczC3vN26f9BTgak=;
        b=W/Wyr299asbyC4x9mSQk5OXXaPRtyFh9gqkoznt5NihE9XvaVCtoZEWQkXT++O0IMv
         08C2lhprRoBWI0MJwk4YUA4gUdYpSsEE8lZwXV0zoR8pizHRaB9z7AmVis23qSLurpza
         wVvSPSOfVedfkNGl7Wl/vEo20i6D5NtJdG+v3rq18Gptv1s62OW4e02a8p2I2ibp83m5
         CbYvlLpEhKmXtXySh9/LEaInMUXvKhEQgXa8XLB/sHPxxLNzWt75mm8uAZmz2BaUmI0j
         7r4c+W7tDGMsNV/hsRynpCzfQ1zST/Z/0LGRj74t4SYTAOUE2pg7nCpOHEmWbUqiqCUF
         CUyg==
Content-Disposition: inline
In-Reply-To: <541AA5CE.8040006-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Sep 18, 2014 at 05:28:46PM +0800, Zefan Li wrote:
> cgroup_pidlist_start() holds cgrp->pidlist_mutex and then calls
> pidlist_array_load(), and cgroup_pidlist_stop() releases the mutex.
> 
> It is wrong that we release the mutex in the failure path in
> pidlist_array_load(), because cgroup_pidlist_stop() will be called
> no matter if cgroup_pidlist_start() returns errno or not.
> 
> Fixes: 4bac00d16a8760eae7205e41d2c246477d42a210
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.14+
> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.17-fixes.

Thanks.

-- 
tejun
