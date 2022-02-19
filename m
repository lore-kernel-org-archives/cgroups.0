From: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] KVM: Move VM's worker kthreads back to the original
 cgroup before exiting.
Date: Sat, 19 Feb 2022 00:30:56 +0000
Message-ID: <YhA6QIDME2wFbgIU@google.com>
References: <20220217061616.3303271-1-vipinsh@google.com>
 <202202172046.GuW8pHQc-lkp@intel.com>
 <3113f00a-e910-2dfb-479f-268566445630@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8aZ16UFG/qN8SDATqq+xbNjeyEK8F2U4AYeI8Q7W9Mw=;
        b=HArcINaTCCHq36tGrqoEk7mWbIGxWYrZtNbvjNwmDNrmBHrKF3eJlEmgsdsTdOVnMq
         gwU0FIiZ3lb3nTu1nqY4vVwwJnHUzAC66FxLehc7wPjjnFMa8nrC2vIKci/NI+cgdx0O
         5mv4Zjt08mwVjFMhablIrVrKKZ0tJ7ZkS+DWkG6oHr8ISvrHErku953L0IAfmJ5H1IwE
         tpcPZ0e+eZl3ta4rPpfIMbwMD/rATwJYXVln33HESHVem5AggYKENrLDu9hCiM6AeD+L
         65Y6x9O5zH7k0GE7uQdIZ4ZIvC3mSThjkE1YaZhLPfx0/4C+JHfEqBOdh+HVxKvriHUS
         0uSA==
Content-Disposition: inline
In-Reply-To: <3113f00a-e910-2dfb-479f-268566445630-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dmatlack-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jiangshanlai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Feb 17, 2022, Paolo Bonzini wrote:
> On 2/17/22 13:34, kernel test robot wrote:
> > > 5859		reattach_err = cgroup_attach_task_all(current->real_parent, current);
> 
> This needs to be within rcu_dereference().

As Vipin found out the hard way, cgroup_attach_task_all() can't be inside an RCU
critical section as it might sleep due to mutex_lock().

My sched knowledge is sketchy at best, but I believe KVM just needs to guarantee
the liveliness of real_parent when passing it to cgroup_attach_task_all().
Presumably kthreadd_task can (in theory) be killed/exiting while this is going on,
but at that point I doubt anyone cares much about cgroup accuracy.

So I think this can be:

	rcu_read_lock();
	parent = rcu_dereference(current->real_parent);
	get_task_struct(parent);
	rcu_read_unlock();

	(void)cgroup_attach_task_all(parent, current);
        put_task_struct(parent);


> >    5860		if (reattach_err) {
> >    5861			kvm_err("%s: cgroup_attach_task_all failed on reattach with err %d\n",
> >    5862				__func__, reattach_err);

Eh, I wouldn't bother logging the error, userspace can't take action on it, and
if the system is OOM it's just more noise in the log to dig through.
