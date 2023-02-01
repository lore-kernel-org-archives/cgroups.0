From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 2/2] cpuset: Call set_cpus_allowed_ptr() with appropriate
 mask for task
Date: Wed, 1 Feb 2023 10:15:30 +0100
Message-ID: <Y9otsg1ihF3LH2vG@hirez.programming.kicks-ass.net>
References: <20230131221719.3176-1-will@kernel.org>
 <20230131221719.3176-3-will@kernel.org>
 <66cdf2e8-f1aa-5dfe-cd2e-0e37dc0ae799@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WedS5la9mLRqRPcpM/LzBZJMoT6FGMbFefMNcmxrjFU=; b=iS6sWdgY75YfcjKNKqBjTtQOY+
        sXREcF73H2Sm4jSIl7T0zVjrpPusC5U/Vp5hLjmEfyY+u+fG8UUdDGeQ1TZ/fFByftxzC6u6W6Rvv
        5v1yaiNsNqaCCMe893HIdplPC4WKfMn8sbD812oBPBvR3gEoG5BuR2IX3NN7GiEJc26UXqMVxz8Cd
        kXsh6dT5Q2GLUIzb3NFj+dv4Up3dmhHBFb9hA0IWScpYMEhf36zL6lSNCcW2AuFz/HxQ3UoOfLoCQ
        S08SvIY3y3ncDlIjy3F0cferhgrW3xzjddji6QBc5HrFLj4MskvM4n16BvjB60s172mYn06jq+HkD
        /Cm9U45w==;
Content-Disposition: inline
In-Reply-To: <66cdf2e8-f1aa-5dfe-cd2e-0e37dc0ae799-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jan 31, 2023 at 09:22:44PM -0500, Waiman Long wrote:
> On 1/31/23 17:17, Will Deacon wrote:
> > set_cpus_allowed_ptr() will fail with -EINVAL if the requested
> > affinity mask is not a subset of the task_cpu_possible_mask() for the
> > task being updated. Consequently, on a heterogeneous system with cpusets
> > spanning the different CPU types, updates to the cgroup hierarchy can
> > silently fail to update task affinities when the effective affinity
> > mask for the cpuset is expanded.
> > 
> > For example, consider an arm64 system with 4 CPUs, where CPUs 2-3 are
> > the only cores capable of executing 32-bit tasks. Attaching a 32-bit
> > task to a cpuset containing CPUs 0-2 will correctly affine the task to
> > CPU 2. Extending the cpuset to CPUs 0-3, however, will fail to extend
> > the affinity mask of the 32-bit task because update_tasks_cpumask() will
> > pass the full 0-3 mask to set_cpus_allowed_ptr().
> > 
> > Extend update_tasks_cpumask() to take a temporary 'cpumask' paramater
> > and use it to mask the 'effective_cpus' mask with the possible mask for
> > each task being updated.
> > 
> > Fixes: 431c69fac05b ("cpuset: Honour task_cpu_possible_mask() in guarantee_online_cpus()")
> > Signed-off-by: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> > 
> > Note: We wondered whether it was worth calling guarantee_online_cpus()
> > if the cpumask_and() returns 0 in update_tasks_cpumask(), but given that
> > this path is only called when the effective mask changes, it didn't
> > seem appropriate. Ultimately, if you have 32-bit tasks attached to a
> > cpuset containing only 64-bit cpus, then the affinity is going to be
> > forced.
> 
> Now I see how the sched_setaffinity() change is impacting arm64. Instead of
> putting in the bandage in cpuset. I would suggest doing another cpu masking
> in __set_cpus_allowed_ptr() similar to what is now done for user_cpus_ptr.

NO! cpuset is *BROKEN* it has been for a while, it needs to get fixed.

Masking the offline CPUs is *WRONG*.
