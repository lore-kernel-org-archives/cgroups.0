From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC][PATCH 7/9 v2] cgroup: avoid attaching task to a cgroup
 under rmdir()
Date: Fri, 27 Apr 2012 13:31:59 -0700
Message-ID: <20120427203159.GL26595@google.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
 <4F9A366E.9020307@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Ft3LPhHttlF5CH2jvqk+CRMeZEtIUEZZR0XgVmJr8l0=;
        b=CykKi+dIxZXqeYM3ysQiWBhG7Cq9jjj+BQq53pxPP8pQ3mRKEV7fgJybSwIf6dvM0O
         EOPHnwO46ZUKXVHpf9K/3xZt8qyKdYpyQDzhR1Mea/KWjT9L6x5YpBRZ9x1wWViMe9b8
         4ciQSoRc+fmJL4C9k7zJB2wzwGy/FFf6vM4yj8ixjKX7c7jki5bZsfifSie6Ma/YW3L/
         et2D68+/7hxWwBD8Ly+k7y/JFS/qhJPy3IYQtjXq+8cgcqAdSPWU3oNZYT9ykqcNiRgW
         W+SB7nAc05dN+9cQQIHvjZt5yzZN2sfy6Br1q16ERNN+yQGGJRiImT1Pbl/ziIEqXJ1B
         MySw==
Content-Disposition: inline
In-Reply-To: <4F9A366E.9020307-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Fri, Apr 27, 2012 at 03:02:22PM +0900, KAMEZAWA Hiroyuki wrote:
> attach_task() is done under cgroup_mutex() but ->pre_destroy() callback
> in rmdir() isn't called under cgroup_mutex().
> 
> It's better to avoid attaching a task to a cgroup which
> is under pre_destroy(). Considering memcg, the attached task may
> increase resource usage after memcg's pre_destroy() confirms that
> memcg is empty. This is not good.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

Hmm... once memcg's pre_destroy() can't fail, I think what we should
do is marking a cgroup DEAD before calling pre_destroy() and the
existing cgroup_is_removed() check should be enough.  Patches upto
this point already make ->pre_destroy() not fail, right?

Thanks.

-- 
tejun
