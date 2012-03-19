From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC][PATCH] cgroup: fix race between fork and cgroup freezing
Date: Mon, 19 Mar 2012 16:05:09 +0100
Message-ID: <20120319150507.GD2660@somewhere>
References: <4F587199.6050404@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=2mwYxobXTIjTgNHPrkwQ39QruTjlbIk/ACzcflh6wZ8=;
        b=sJNNLfidSTdBDgiM8WC/M8Sc5hP3wU32IphIGu09R+SqnsPx6jx79omNVgTRzgNHum
         hv4s+tTuyG89F5oe06+nSXgI6cOB4scXQH9nNFa7O8NTUp6vf1NUSDW2J6fVwaaymekb
         swcX74MEkJ5iKnwCLxFwryN0zd/1mVeC/2uAsGA122zpqfvuahYa1rpRs94oP3B0SWbQ
         yTnueyOk2mSFiIochOAi41/Y/7Khs6xFTg4vsBPQeFpbSIGGMkdViPKgsLSD6yOuSRjo
         aFk6A6tnu+Ls3YbmqCHnJA9IBp0G/zZRv3j5B3QWUAaX37gTJ25duBN/ceWF/qS7gQ2l
         uXLA==
Content-Disposition: inline
In-Reply-To: <4F587199.6050404-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?utf-8?B?57yqIOWLsA==?= <miaox-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Thu, Mar 08, 2012 at 04:45:13PM +0800, Li Zefan wrote:
> A similar bug exists in cpuset, and those are long-standing bugs.
> 
> As reported by Frederic:
> 
> > When a user freezes a cgroup, the freezer sets the subsystem state
> > to CGROUP_FREEZING and then iterates over the tasks in the cgroup links.
> > 
> > But there is a possible race here, although unlikely, if a task
> > forks and the parent is preempted between write_unlock(tasklist_lock)
> > and cgroup_post_fork(). If we freeze the cgroup while the parent
> > is sleeping and the parent wakes up thereafter, its child will
> > be missing from the set of tasks to freeze because:
> > 
> > - The child was not yet linked to its css_set->tasks, as is done
> > from cgroup_post_fork(). cgroup_iter_start() has thus missed it.
> > 
> > - The cgroup freezer's fork callback can handle that child but
> > cgroup_fork_callbacks() has been called already.
> 
> I try to fix it by using seqcount. We read the counter before calling
> cgroup_fork_callbacks(), and we check the counter after cgroup_post_fork().
> If the seq numbers don't match, we know the forking task's cgroup
> has been/is being frozen, so we freeze the child task.
> 
> cpuset can be fixed accordingly.
> 
> Reported-by: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

I feel we are a bit stuck here. All these complications come from the
fact we are conditionally setting this css_set link.

I wish we could set it unconditionally on cgroup_fork() time.
This unfortunately implies at least locking the css_set and to do
a list_add() unconditionally. And at times where cgroup is often
critisized for the overhead it involves, I guess this is not welcome.

This ->post_fork() based solution is not pretty, unfortunately I can't
come with a better idea.
