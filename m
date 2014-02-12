From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: protect modifications to cgroup->idr with
 cgroup_mutex
Date: Wed, 12 Feb 2014 01:37:13 -0500
Message-ID: <20140212063713.GA7984@mtj.dyndns.org>
References: <52FB14A5.9030307@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=otsrqcvXMUX+6cQ934fBSxeK6ILB1GhWwBatQVBCOSo=;
        b=qQmS4PNm9WUxPm0FaziZzO39ZutKf7kjvdTHMmKkvUWrKDUz6i67pM/rixdhG41F3z
         XkOJYiv2Tg8/hxRhZOKHuIJdBgN5Aeo2/TErfJKnFKqnMssE2IULabF/R3xv/XICpJ9l
         0CHDMwR23w9/O4YiK3g2hALN24wiONfoRnrnU0lUkmHlHMwkFCm1odIVqOmOoHkM9ibh
         O0tmfM1RAVIBPw8Yv0vY4CNp8kWhF6/hiXIOEWm8AGMykaBO8L7ddJro66nernX/WTkE
         uIuuvhTaypFT89k43g5eWecbmqtKrCm3Ls8AcK6E9kaHnADa4mTobzKcwwbkeyZY5V8V
         QBvQ==
Content-Disposition: inline
In-Reply-To: <52FB14A5.9030307-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Li.

On Wed, Feb 12, 2014 at 02:28:53PM +0800, Li Zefan wrote:
> v2:
> - Don't call deactivate_super() inside cgroup_mutex, as cgroup_kill_sb()
> will be called if sb refcnt reaches 0. I don't think this can happen,
> as cgroup_create() is called through vfs, so vfs should guarantee the
> superblock won't disappear. Still better not depend on it even my guess
> is probably correct.

If the deadlock can't actually happen, I don't really care either way
as the code goes away after kernfs conversion anyway.  I've already
applied v1, so if you think this change is important, can you send an
incremental patch?

Thanks!

-- 
tejun
