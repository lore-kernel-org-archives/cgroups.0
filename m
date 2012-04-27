From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC][PATCH 7/9 v2] cgroup: avoid attaching task to a cgroup
 under rmdir()
Date: Fri, 27 Apr 2012 13:33:36 -0700
Message-ID: <20120427203336.GM26595@google.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
 <4F9A366E.9020307@jp.fujitsu.com>
 <20120427203159.GL26595@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=AqvHSOuznnCjVpkqOPwAe2shcBGJ6cfTUh82zY61UZ0=;
        b=E5ssdZhF8O8Lzm1J48dzkwR2diXDNaqH2AbUEsSXRBDOb2ya9fsIo+XnWulYs9Hc78
         8id2+DmuMS4q79JkIpu+CFYlF6UjDUILvUbm3a+wpdt97ntIHP0Ox5nj2+igS/T5X7Ct
         CZVwqdQyhLjo4/EIfDa26R0yidxuwG4rf1Q5nrtiqQGudu9THTk5/J9VQjgf227liq13
         SluEqpzuSd6iC+jZIN0UaN2BVQNYPr/FmVqdkRY4/lYA6hagLdpWeP5woZzOQ6kVJIgJ
         Bp4lV5RVnYyLFN86taC464vEOfzZxdT1iOz+rr1FpgplkmoZ12kNkM8Y2bCjOf/yMZ3O
         qvWw==
Content-Disposition: inline
In-Reply-To: <20120427203159.GL26595-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Fri, Apr 27, 2012 at 01:31:59PM -0700, Tejun Heo wrote:
> On Fri, Apr 27, 2012 at 03:02:22PM +0900, KAMEZAWA Hiroyuki wrote:
> > attach_task() is done under cgroup_mutex() but ->pre_destroy() callback
> > in rmdir() isn't called under cgroup_mutex().
> > 
> > It's better to avoid attaching a task to a cgroup which
> > is under pre_destroy(). Considering memcg, the attached task may
> > increase resource usage after memcg's pre_destroy() confirms that
> > memcg is empty. This is not good.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> 
> Hmm... once memcg's pre_destroy() can't fail, I think what we should
> do is marking a cgroup DEAD before calling pre_destroy() and the
> existing cgroup_is_removed() check should be enough.  Patches upto
> this point already make ->pre_destroy() not fail, right?

Ooh, I was confused about patch order.  This patch, probably with the
update suggested by Frederic looks good as an interim solution for
now.

Thanks.

-- 
tejun
