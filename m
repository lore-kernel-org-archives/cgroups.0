From: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v10 1/8] hugetlb_cgroup: Add hugetlb_cgroup reservation
 counter
Date: Thu, 16 Jan 2020 14:44:45 -0800
Message-ID: <bbc968ae-b379-c207-268e-16004d9cff96@oracle.com>
References: <20200115012651.228058-1-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=jlzdnATHqqaoRnZjE+SFSnSnRkAzXmaHY4RqPn2GR14=;
 b=Hb3TDPh83eiTfrX6Rmpx/FtUaekfBHuaXEkqSQU3gyu4w+ATUwFA9Z6N8AdSNh/mfyJ/
 XKSNvGJ6mOHHCrwI9Dq0fHCsLbg6Z/guPvZlAqt+Q+1p6BY8Wz7cGuDiAr9kmmG19tss
 kDzNdcWehvTlQ53be0RNk1ZxEYvVo03BQeCQ7dAnA+JEGfMxSv+PAffV1eQTcbZ8ADSQ
 hbET9KgS1x/+fDtnS+JxuXAlcEVwgp3UvQv/B7JMW7l8ItY+FJDHzdleu3E57tozfGGE
 hYDS+uA3y6Y20pq/21gAeMm477K7JJkwgEGgQnZqJTxANQjOda6Rq3dLaSugaf+c0qDa gA== 
In-Reply-To: <20200115012651.228058-1-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org

On 1/14/20 5:26 PM, Mina Almasry wrote:
> These counters will track hugetlb reservations rather than hugetlb
> memory faulted in. This patch only adds the counter, following patches
> add the charging and uncharging of the counter.
> 
> This is patch 1 of an 8 patch series.
> 
> Problem:
> Currently tasks attempting to reserve more hugetlb memory than is available get
> a failure at mmap/shmget time. This is thanks to Hugetlbfs Reservations [1].
> However, if a task attempts to reserve hugetlb memory only more than its

*reword*
However, if a task attempts to reserve more hugetlb memory than its

> hugetlb_cgroup limit allows, the kernel will allow the mmap/shmget call,
> but will SIGBUS the task when it attempts to fault the memory in.

*reword*
but will SIGBUS the task when it attempts to fault in the  excess memory.

> 
> We have users hitting their hugetlb_cgroup limits and thus we've been
> looking at this failure mode. We'd like to improve this behavior such that users
> violating the hugetlb_cgroup limits get an error on mmap/shmget time, rather
> than getting SIGBUS'd when they try to fault the excess memory in. This
> gives the user an opportunity to fallback more gracefully to
> non-hugetlbfs memory for example.
> 
> The underlying problem is that today's hugetlb_cgroup accounting happens
> at hugetlb memory *fault* time, rather than at *reservation* time.
> Thus, enforcing the hugetlb_cgroup limit only happens at fault time, and
> the offending task gets SIGBUS'd.
> 
> Proposed Solution:
> A new page counter named
> 'hugetlb.xMB.reservation_[limit|usage|max_usage]_in_bytes'. This counter has
> slightly different semantics than

You changed the name to 'hugetlb.xMB.resv_[limit|usage|max_usage]_in_bytes'
in the code, but left this description.

Also, David suggested 'rsvd' as the abbreviation to use here.  I would also
prefer that name to be consistent with other hugetlb interfaces.

> 'hugetlb.xMB.[limit|usage|max_usage]_in_bytes':
> 
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
> functionality and show the usage.
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
> 
> ---
> Changes in v10:
> - Renamed reservation_* to resv.*
> 
> ---
>  include/linux/hugetlb.h |   4 +-
>  mm/hugetlb_cgroup.c     | 115 +++++++++++++++++++++++++++++++++++-----
>  2 files changed, 104 insertions(+), 15 deletions(-)

The code looks fine to me.

With the commit message and naming updates, I will add a Reviewed-by:

Please do wait a few/several days before sending a revised edition to
make sure we get all feedback.  I really would like to get comments from
people more familiar with cgroups.

-- 
Mike Kravetz
