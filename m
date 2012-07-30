From: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cgroup: Don't drop the cgroup_mutex in cgroup_rmdir
Date: Mon, 30 Jul 2012 11:25:13 -0700
Message-ID: <20120730182513.GC20067@google.com>
References: <87ipdjc15j.fsf@skywalker.in.ibm.com>
 <1342706972-10912-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20120719165046.GO24336@google.com>
 <1342799140.2583.6.camel@twins>
 <20120720200542.GD21218@google.com>
 <501231F0.8050505@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=H0W3Oyb7ap39oAs7ZOlGdiUeYEzTjzWc3+sgcAJvTrQ=;
        b=pO2KB/OvZbAv+Sek+G4KzK+gPFfT/8sYkNnZ6garaNTbfFdDMNVodSzIuYzTIjxyGZ
         sX1MCYDoeIomeGOSfYQ5dHJAjtwLOxF7W69afKERmpO8i80HAJ7m8w4cYj7nyJnp7+BM
         zhGZk9zW7GUcBiwgMsAJzNEgzMQ9VDQHN0rWz1UkoqMI465hrYwdlY6fCzormA0WYckz
         dO7UvOTpMuUr2fVCfGc5JR0wlllv+TdAMX73YSg/GacynrhllVwikxbwZaFXq8jHD73w
         Ls5S9eWEk9UTkaj7cLJzoAc9vyXKp2lZiVFc+suOHBs+/aPI2XMST8pjIjGuoFIsrPoR
         fR6w==
Content-Disposition: inline
In-Reply-To: <501231F0.8050505-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, liwanp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org

Hello,

On Fri, Jul 27, 2012 at 02:15:12PM +0800, Li Zefan wrote:
> The cgroup core was extracted from cpuset, so they are deeply tangled.
> 
> There are several issues to resolve with regard to removing cgroup lock from cpuset.
> 
> - there are places that the cgroup hierarchy is travelled. This should be
> easy, as cpuset can be made to maintain its hierarchy.

Or we can expose limited interface for traversal while protecting
hierarchy itself with smaller lock or make the hierarchy safe to
traverse with RCU read lock.

> - cpuset disallows clearing cpuset.mems/cpuset.cpus if the cgroup is not empty,
> which can be guaranteed only by cgroup lock.
>
> - cpuset disallows a task be attached to a cgroup with empty cpuset.mems/cpuset.cpus,
> which again can be guarantted only by cgroup lock.

Why can't callbacks enforce the above two?  We can keep track of the
number of tasks in the cgroup and reject operations as necessary.
What's missing?

> - cpuset may move tasks from a cgroup to another cgroup (Glauber mentioned this).

No idea about this one.  Why / how does this happen?

Thanks.

-- 
tejun
