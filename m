From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] MAINTAINERS: relocate cpuset.c
Date: Mon, 30 Oct 2017 07:52:40 -0700
Message-ID: <20171030145240.GA3252168@devbig577.frc2.facebook.com>
References: <20171030090232.34986-1-yuchao0@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=z7+IVtBiXkkCoIxm1+daXUw2/93r/kxJG9qftfCZpyk=;
        b=hBQYleYyV9QR0IN9K0s8WsmTSbg1NvQ1cHtc6Gwy/FnMIRJ/fzj/W3WdlgdNRvZEJN
         bauj+oueg7K8rcrHhRRQBd9TgnOICPNNP9tgNZos4YhIXkP9/Fhy6CEYCaX29C4E90Tc
         r3APZbzK3rvi+Zow7YAGyAAWLzuLPRW/LLkCZBfD5Rerc5Qz+Ei2VhAD82BULz10X6je
         20S1cWpFfiRFC6oC+rx3S9WTUCIe7PVTu2yLyz40mcC4ZdlLpwGe0x9JTmGHTgMeqX+r
         hIXwS3od7DRFWzkIBl+OO45W+DoFmphrgH0qbX+/I6cwmyE9qNVRPWhSPmS0VVTpCqxM
         PLvw==
Content-Disposition: inline
In-Reply-To: <20171030090232.34986-1-yuchao0-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chao Yu <yuchao0-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On Mon, Oct 30, 2017 at 05:02:32PM +0800, Chao Yu wrote:
> Commit 201af4c0fab0 ("cgroup: move cgroup files under kernel/cgroup/")
> have renamed kernel/cpuset.c to kernel/cgroup/cpuset.c, but forgot to
> update entry of cpuset module in MAINTAINERS, fix it.
> 
> Signed-off-by: Chao Yu <yuchao0-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-4.15.

Thanks.

-- 
tejun
