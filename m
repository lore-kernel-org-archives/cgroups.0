From: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Don't filter offline CPUs in
 cpuset_cpus_allowed() for top cpuset tasks
Date: Mon, 6 Feb 2023 11:05:41 +0000
Message-ID: <20230206110540.GA11024@willie-the-truck>
References: <20230203164040.213437-1-longman@redhat.com>
 <Y94s8mzrE9VyUJLa@hirez.programming.kicks-ass.net>
 <f356b916-1c10-1565-73fb-34027c6c510a@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675681546;
        bh=3ssH3tyyX9Wb/OOZG7J5+HJgVkFrClE5hsZSLWktyNM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VMIa50dZ3HGJEZYNP2DN7M2vNBlXnI3ip7kSC5LkVLi2rS5u1MffbjVgbjrgO6JEj
         6jD7041iJkFWALRFMCi8CY3dVzG4NpnRIiP29SVxrMDJeESW8qLO1rjyWKoanWnYV8
         VABXRQwZlOfL27DjJjVy7oqHOEinD0/IxWZlWBxsBct0Ohpob3uF9YgK3iFCMeZJXh
         bHbQyTbmSMDe8iO/QM5QmAASCEHcw2LFxSNG9hDWHWQ3JK3mSpNnFoI1IYR7AllRE+
         MWZospnEVhToI9PYoSZK9+1vIRGjqQSTxrpJ5XaAUnSTQYMCyXsQJ+eTSrlrOBO/P3
         gO1c2xJrjlJZA==
Content-Disposition: inline
In-Reply-To: <f356b916-1c10-1565-73fb-34027c6c510a-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

On Sun, Feb 05, 2023 at 12:00:25AM -0500, Waiman Long wrote:
> On 2/4/23 05:01, Peter Zijlstra wrote:
> > On Fri, Feb 03, 2023 at 11:40:40AM -0500, Waiman Long wrote:
> > > Since commit 8f9ea86fdf99 ("sched: Always preserve the user
> > > requested cpumask"), relax_compatible_cpus_allowed_ptr() is calling
> > > __sched_setaffinity() unconditionally. This helps to expose a bug in
> > > the current cpuset hotplug code where the cpumasks of the tasks in
> > > the top cpuset are not updated at all when some CPUs become online or
> > > offline. It is likely caused by the fact that some of the tasks in the
> > > top cpuset, like percpu kthreads, cannot have their cpu affinity changed.
> > > 
> > > One way to reproduce this as suggested by Peter is:
> > >   - boot machine
> > >   - offline all CPUs except one
> > >   - taskset -p ffffffff $$
> > >   - online all CPUs
> > > 
> > > Fix this by allowing cpuset_cpus_allowed() to return a wider mask that
> > > includes offline CPUs for those tasks that are in the top cpuset. For
> > > tasks not in the top cpuset, the old rule applies and only online CPUs
> > > will be returned in the mask since hotplug events will update their
> > > cpumasks accordingly.
> > So you get the task_cpu_possible_mask() interaction vs cpusets horribly
> > wrong here, but given the very sorry state of task_cpu_possible_mask()
> > correctness of cpuset as a whole that might just not matter at this
> > point.
> > 
> > I do very much hate how you add exceptions on exceptions instead of
> > looking to do something right :-(
> > 
> > Fixing that parition case in my patch is 1 extra line and then I think
> > it fundamentally does the right thing and can serve as a basis for
> > fixing cpuset as a whole.
> 
> I am not saying that your patch is incorrect other than handling the
> partition case. However, it is rather complex and is hard to understand
> especially for those that are not that familiar with the cpuset code. From
> the maintainability point of view, a simpler solution that is easier to
> understand is better.
> 
> If we want to get it into the next merge windows, there isn't much time left
> for linux-next testing. So a lower risk solution is better from that
> perspective too.

This needs to land for 6.2 to fix the regression. The next merge window is
too late. That's why I cooked the reverts [1] as an alternative.

Will

[1] https://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git/log/?h=ssa-reverts
