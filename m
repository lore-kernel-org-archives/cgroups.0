From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v9 1/8] hugetlb_cgroup: Add hugetlb_cgroup reservation
 counter
Date: Mon, 13 Jan 2020 16:45:41 -0800 (PST)
Message-ID: <alpine.DEB.2.21.2001131624240.164268@chino.kir.corp.google.com>
References: <20191217231615.164161-1-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=taoDDoIQd/KDhx/ME1q1/0HEQhaZ03k7OPfFEXTFTWI=;
        b=qdWq8+7ssthCT4ZwYEBV3D7z/AN+fBXHEEyXGCSncOju1fE9W4iIPkkwOOB5UtgY8R
         P5g56E8RpmjWzq7S/YNrb1PyvkpQTIFk77pfELIi9danh9A1eqh/tt3xxgcLolZpH6Yj
         kbkMI75NdT+jKVlH0Fzl1KGJzM2JlESa2RkHsXd41rBKUSakzpaY9MBuO+1zp5PiSdAV
         XP7HySQSrDXb4EXAzSTgAluzOF16em5odoZAJxkE2R+A0hIIQUsy9KroM+FNMjAOzw4B
         lzD6NMomNkQjnwsZZEStVKY65XRgCJ8sFGxxGHOCjuffQPQmOcYaqlkH/kE/oJd1j/XJ
         lHfA==
In-Reply-To: <20191217231615.164161-1-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>

On Tue, 17 Dec 2019, Mina Almasry wrote:

> These counters will track hugetlb reservations rather than hugetlb
> memory faulted in. This patch only adds the counter, following patches
> add the charging and uncharging of the counter.
> 
> This is patch 1 of an 8 patch series.
> 
> Problem:
> Currently tasks attempting to allocate more hugetlb memory than is available get
> a failure at mmap/shmget time. This is thanks to Hugetlbfs Reservations [1].
> However, if a task attempts to allocate hugetlb memory only more than its
> hugetlb_cgroup limit allows, the kernel will allow the mmap/shmget call,
> but will SIGBUS the task when it attempts to fault the memory in.
> 

I think it's subtle, but the use of the word "allocate" instead of using 
"reserve" might be confusing here.  Might want to reword it.

> We have developers interested in using hugetlb_cgroups, and they have expressed
> dissatisfaction regarding this behavior. We'd like to improve this
> behavior such that tasks violating the hugetlb_cgroup limits get an error on
> mmap/shmget time, rather than getting SIGBUS'd when they try to fault
> the excess memory in.
> 

I'm not sure the developers are interested in being restricted by 
hugetlb_cgroups :)  I think users get constrained by hugetlb_cgroup so the 
developers are interested in the failure more: do we want to SIGBUS at 
fault and not be allowed an opportunity to influence that (today) or do we 
want to fallback to non-hugetlbfs memory and just keep going (tomorrow, 
after your patchset).

> The underlying problem is that today's hugetlb_cgroup accounting happens
> at hugetlb memory *fault* time, rather than at *reservation* time.
> Thus, enforcing the hugetlb_cgroup limit only happens at fault time, and
> the offending task gets SIGBUS'd.
> 
> Proposed Solution:
> A new page counter named hugetlb.xMB.reservation_[limit|usage]_in_bytes. This
> counter has slightly different semantics than
> hugetlb.xMB.[limit|usage]_in_bytes:
> 

Is there a max_usage_in_bytes equivalent?  It's a page_counter so I assume 
it's easy to support.

I'll defer the naming to Mike here, "rsvd" seems to be the hugetlb way of 
saying "reserved".

> - While usage_in_bytes tracks all *faulted* hugetlb memory,
> reservation_usage_in_bytes tracks all *reserved* hugetlb memory and
> hugetlb memory faulted in without a prior reservation.
> 
> - If a task attempts to reserve more memory than limit_in_bytes allows,
> the kernel will allow it to do so. But if a task attempts to reserve
> more memory than reservation_limit_in_bytes, the kernel will fail this
> reservation.
> 
> This proposal is implemented in this patch series, with tests to verify
> functionality and show the usage. We also added cgroup-v2 support to
> hugetlb_cgroup so that the new use cases can be extended to v2.
> 
> Alternatives considered:
> 1. A new cgroup, instead of only a new page_counter attached to
>    the existing hugetlb_cgroup. Adding a new cgroup seemed like a lot of code
>    duplication with hugetlb_cgroup. Keeping hugetlb related page counters under
>    hugetlb_cgroup seemed cleaner as well.
> 
> 2. Instead of adding a new counter, we considered adding a sysctl that modifies
>    the behavior of hugetlb.xMB.[limit|usage]_in_bytes, to do accounting at
>    reservation time rather than fault time. Adding a new page_counter seems
>    better as userspace could, if it wants, choose to enforce different cgroups
>    differently: one via limit_in_bytes, and another via
>    reservation_limit_in_bytes. This could be very useful if you're
>    transitioning how hugetlb memory is partitioned on your system one
>    cgroup at a time, for example. Also, someone may find usage for both
>    limit_in_bytes and reservation_limit_in_bytes concurrently, and this
>    approach gives them the option to do so.
> 
> Testing:
> - Added tests passing.
> - Used libhugetlbfs for regression testing.
> 
> [1]: https://www.kernel.org/doc/html/latest/vm/hugetlbfs_reserv.html
> 
> Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Acked-by: Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>
