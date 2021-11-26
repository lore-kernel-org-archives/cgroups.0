From: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: reduce spinlock contention in release_pages()
Date: Fri, 26 Nov 2021 16:26:23 +0000
Message-ID: <20211126162623.GA10277@haolee.io>
References: <20211124151915.GA6163@haolee.io>
 <YZ5o/VmU59evp65J@dhcp22.suse.cz>
 <CA+PpKPmy-u_BxYMCQOFyz78t2+3uM6nR9mQeX+MPyH6H2tOOHA@mail.gmail.com>
 <YZ8DZHERun6Fej2P@casper.infradead.org>
 <20211125080238.GA7356@haolee.io>
 <YZ9e3pzHKmn5nev0@dhcp22.suse.cz>
 <20211125123133.GA7758@haolee.io>
 <YZ+bI1fNpKar0bSU@dhcp22.suse.cz>
 <CA+PpKP=hsuBmvv09OcD2Nct8B8Cqa03UfKFHAHzKxwE0SXGP4g@mail.gmail.com>
 <YaC7BcTSijFj+bxR@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=q/HRGw2r5wG7sszT9Fb1vk0NIxwkVXLQR9pjE/nA1Tc=;
        b=hZXEtwgIgWBHlarUnLTfnMEddvX1ZvCgyKfbW91zU5qVw4BWPEk6h2BeN9eKocOl/5
         iG1H9wm6oQQbaTqDQpw1p+zMdg1suCwqLCY/vnG5DYCGq6ZzwyVFZvB2Bs4p61bvyAwE
         Hryp4nPZZV2AKt6xkJYPE0MnXv87asXXdQcdf9Kz/oQwrAgC/gMe4/YUVxiWY7Rd67qf
         g04fTUHIM77oZ4dZa0Z8QqUGqBo/wihmAFXnw0+Hz4Ub/GHawVCN/6vuyEqlZP8rKY9V
         pM9enbAwzLwDrbZyd8qpj7L3ye4okDSJ6kEgPAuyvqe1bDdJJmGxnE8Sv6J2ee4aHrOc
         rzIQ==
Content-Disposition: inline
In-Reply-To: <YaC7BcTSijFj+bxR-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Nov 26, 2021 at 11:46:29AM +0100, Michal Hocko wrote:
> On Fri 26-11-21 14:50:44, Hao Lee wrote:
> > On Thu, Nov 25, 2021 at 10:18 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> [...]
> > > Could you share more about requirements for those? Why is unmapping in
> > > any of their hot paths which really require low latencies? Because as
> > > long as unmapping requires a shared resource - like lru lock - then you
> > > have a bottle necks.
> > 
> > We deploy best-effort (BE) jobs (e.g. bigdata, machine learning) and
> > latency-critical (LC) jobs (e.g. map navigation, payments services) on the
> > same servers to improve resource utilization. The running time of BE jobs are
> > very short, but its memory consumption is large, and these jobs will run
> > periodically. The LC jobs are long-run services and are sensitive to delays
> > because jitters may cause customer churn.
> 
> Have you tried to isolate those workloads by memory cgroups? That could
> help for lru lock at least.

Sure. LC and BE jobs are in different memory cgroups (containers). memcg
indeed avoids lru contentions between LC and BE, although it can't reduce
contentions between jobs in the same cgroup. BE jobs' memory contentions
could cause cpu jitters and then interfere LC jobs.

> You are likely going to hit other locks on
> the way though. E.g. zone lock in the page allocator but that might be
> less problematic in the end.

Yes, but we haven't encountered lock contentions in the allocation path for
now. Maybe this is because the memory allocations of BE jobs are still
gradual and are not clustered into a very short time period.

> If you isolate your long running services
> to a different NUMA node then you can get even less interaction.

Agree.

> 
> > If a batch of BE jobs are finished simultaneously, lots of memory are freed,
> > and spinlock contentions happen. BE jobs don't care about these contentions,
> > but contentions cause them to spend more time in kernel mode, and thus, LC
> > jobs running on the same cpu cores will be delayed and jitters occur. (The
> > kernel preemption is disabled on our servers, and we try not to separate
> > LC/BE using cpuset in order to achieve "complete mixture deployment"). Then
> > LC services people will complain about the poor service stability. This
> > scenario has occurred several times, so we want to find a way to avoid it.
> 
> It will be hard and a constant fight to get reasonably low latencies on
> a non preemptible kernel. It would likely be better to partition CPUs
> between latency sensitive and BE jobs. I can see how that might not be
> really practical but especially with non-preemptible kernels you have a
> large space for priority inversions that is hard to forsee or contain.

Agree. It's really hard. Maybe we will eventually use cpuset to separate LC
and BE if we can't find a better way to mix them on the same set of cpus.

I will try Matthew's idea to use semaphore or mutex to limit the number of BE
jobs that are in the exiting path. This sounds like a feasible approach for
our scenario...

Thanks

> -- 
> Michal Hocko
> SUSE Labs
