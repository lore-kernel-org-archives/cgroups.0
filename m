From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] cpuset: Enforce that a child's cpus must be a subset of
 the parent
Date: Thu, 31 May 2018 09:43:27 +0200
Message-ID: <20180531074327.GD12180@hirez.programming.kicks-ass.net>
References: <1527687991-1431-1-git-send-email-longman@redhat.com>
 <5B0F4F09.9050100@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=XlTMzILn0Av3tkqRGXlOme8cC2e2AclD2RKkn0lbL6c=; b=L4L/OGW0isbfnpqqQt7FnhfE9
        d//o+yzMLEZc1oBSnf1D9JDK7KAccn+oYyFZ6fnL8o24prW5TY8zZZvmM5YdICj5JmnGjlBNjgtcA
        wWvO9aaieM9arquFVp9isxr2I3WUIyYgnzZdADm82Yjvc9PzqqpMYbEskBPg4qHcrfe32raBXsdum
        H4kZeMbjEI29mUzROuHIu+TtpwW1Xd3wm8XaoXC1pygJ//KkfRllerWGH7okFo0kt1YXj0fn3+/4D
        /SL7jWd8qQsrEU+J7MEKs7jmIuMh4EI4hxMyIfK+xunt+eIyM0U3zXF8DOFy8PA7Qbvyb2hPLLQMW
    
Content-Disposition: inline
In-Reply-To: <5B0F4F09.9050100@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan@huawei.com>
Cc: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On Thu, May 31, 2018 at 09:25:29AM +0800, Zefan Li wrote:
> Hi Waiman,
> 
> On 2018/5/30 21:46, Waiman Long wrote:
> > It was found that the cpuset.cpus could contain CPUs that are not listed
> > in their parent's cpu list as shown by the command sequence below:
> > 
> >   # echo "+cpuset" >cgroup.subtree_control
> >   # mkdir g1
> >   # echo 0-5 >g1/cpuset.cpus
> >   # mkdir g1/g11
> >   # echo "+cpuset" > g1/cgroup.subtree_control
> >   # echo 6-11 >g1/g11/cpuset.cpus
> >   # grep -R . g1 | grep "\.cpus"
> >   g1/cpuset.cpus:0-5
> >   g1/cpuset.cpus.effective:0-5
> >   g1/g11/cpuset.cpus:6-11
> >   g1/g11/cpuset.cpus.effective:0-5
> > 
> > As the intersection of g11's cpus and that of g1 is empty, the effective
> > cpus of g11 is just that of g1. The check in update_cpumask() is now
> > corrected to make sure that cpus in a child cpus must be a subset of
> > its parent's cpus. The error "write error: Invalid argument" will now
> > be reported in the above case.
> > 
> 
> We made the distinction between user-configured CPUs and effective CPUs
> in commit 7e88291beefbb758, so actually it's not a bug.

Why though; that makes no sense what so ever.
