From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC] memcg: revert kmem.tcp accounting
Date: Tue, 16 Sep 2014 15:16:30 +0900
Message-ID: <20140916061630.GE805@mtj.dyndns.org>
References: <1410535618-9601-1-git-send-email-vdavydov@parallels.com>
 <20140912171809.GA24469@dhcp22.suse.cz>
 <20140912175516.GB6298@mtj.dyndns.org>
 <20140912144326.a8d5153d7c91d220ea89924a@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=F8LDeOzqwt3K6dlgrFC4YA5jdxb8+Yyb8M+j+Jr4axw=;
        b=qtjEZskQx6PVGfFrnX3OhFZAn5fxmhp2MUERD4t7vSUL+mh1AhDkMxhTRHeCZ02251
         52kqwlHOhd4unnv8ND+LF6o4y2Hm/c0jcS0nTyTmmBGHCdzE1O4AVSKzvAJ6onTm/+DI
         9K5LTUgrCuN7ge3lpnsq91NjG/q5GidVRJ6IIx/LxwMjxvjdHnKVj+yvw5V/c5VrhiUM
         6w2XR3dTlC15zNpp7Z7xwpWsd9VJ1yTC9ihcHxNSxicZL7SMt2ZQI5v8fOqAlgjaXyQz
         z6Yy2+Zh93tIgBc1bDBC4zyUOGoz1hdZnFGrbMtO48808P+xKvEi3Rmf00Rxo6ccVAX5
         TaaA==
Content-Disposition: inline
In-Reply-To: <20140912144326.a8d5153d7c91d220ea89924a-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelianov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>

Hello, Andrew.

On Fri, Sep 12, 2014 at 02:43:26PM -0700, Andrew Morton wrote:
> 17 files changed, 51 insertions(+), 761 deletions(-)
> 
> Sob.
> 
> Is there a convenient way of disabling the whole thing and adding a
> please-tell-us printk?  If nobody tells us for a year or two then zap.

Given that we're in the process of implementing the v2 interface, I
don't think it'd be wise to perturb v1 interface at this point.  We're
gonna have to carry around v1 code for quite some time anyway and I
don't think carrying the tcp code would make whole lot of difference
given that the code is likely to stay static from now on.

Thanks.

-- 
tejun
