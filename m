From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH RFC] memcg: revert kmem.tcp accounting
Date: Fri, 12 Sep 2014 19:18:09 +0200
Message-ID: <20140912171809.GA24469@dhcp22.suse.cz>
References: <1410535618-9601-1-git-send-email-vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=vfMytVwCACOH8gkFFDC3QlWKQm2YB2SuZ6J6SiUQv80=;
        b=K+zFoS5UGsARUyZTnAxpxwAYNoc+UPWOw5M0WH5uAdcwT8c2PC7mAKh47sAVt805AY
         RD5+cW9XC07ESGJjdoMZ4gLEg5DWm5eSqpEw+Xfn1B1bFFWKQjUz9w7O1S2FRi7hBwSY
         uuuPe1IHdAU5tk5d6/FpPP5bF9KC3zV9dBP6yO1in1LpsuJcKvUQUcmfUCzRBHp4a1fx
         KT0PlvCpEvxv0cZa+eoWEx425u1iSVJh+eC/fD/n/bGGGhTqDwKv/VNlk5sy+w7UonaD
         j55kHIZsXQ6S0lkVnJ2TcHErSrJXxiELx4haCulepAUGfps/wPvQ0vfg8iRJ+zg7KTl8
         bAaA==
Content-Disposition: inline
In-Reply-To: <1410535618-9601-1-git-send-email-vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelianov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>

On Fri 12-09-14 19:26:58, Vladimir Davydov wrote:
> memory.kmem.tcp.limit_in_bytes works as the system-wide tcp_mem sysctl,
> but per memory cgroup. While the existence of the latter is justified
> (it prevents the system from becoming unusable due to uncontrolled tcp
> buffers growth) the reason why we need such a knob in containers isn't
> clear to me.

Parallels was the primary driver for this change. I haven't heard of
anybody using the feature other than Parallels. I also remember there
was a strong push for this feature before it was merged besides there
were some complains at the time. I do not remember details (and I am
one half way gone for the weekend now) so I do not have pointers to
discussions.

I would love to get rid of the code and I am pretty sure that networking
people would love this go even more. I didn't plan to provide kmem.tcp.*
knobs for the cgroups v2 interface but getting rid of it altogether
sounds even better. I am just not sure whether some additional users
grown over time.
Nevertheless I am really curious. What has changed that Parallels is not
interested in kmem.tcp anymore?

[...]

Anyway, more than welcome
Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

In case we happened to grow more users, which I hope hasn't happened, we
would need to keep this around at least with the legacy cgroups API.
-- 
Michal Hocko
SUSE Labs
