From: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v11 1/9] hugetlb_cgroup: Add hugetlb_cgroup reservation
 counter
Date: Wed, 5 Feb 2020 11:36:31 -0800
Message-ID: <74036711-be90-a56c-3c7f-f85c30417e6e@oracle.com>
References: <20200203232248.104733-1-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=5lIfWmCzlu1SYiOdBrJ1JdoDVBv+JbA9Q1rCthzGY1A=;
 b=xmImP+oM1soTl7cXRyV9L5Qgrk5M7aEsUw7a+g1Kr0eSwnkV/Zz75iWR1vWrx6/qHxWa
 sr7lpjYOmfyEcsYjBFMeQjy9TafIvMXoW1WZYUvCIsE0gkW+xs0TtIUnQh3ZJBA6LwFo
 UloZl6+/Jfexakhfpx8XHQ7UwSMnmSIvkwsvk5k8Hv2wRMkq/z/0tuYljZwzjXby/MSM
 YwY8yR9GwDAGwu1erWvAz/JimM/7ZgQP+Mhm4sgVeNuKouUPV9/swQeEIcjUBpYERToL
 VHQvBElBGEiMSE8mVNE75cUtNlGd+Esk3YO2Do0+UEopD6fj/UeqkupHOGr4/p07/Cq3 hA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=5lIfWmCzlu1SYiOdBrJ1JdoDVBv+JbA9Q1rCthzGY1A=;
 b=A5DFmSFyoDCf97mX7oJcdjO5Wde6OfFD4YMZrQ41J0fxXf8YiKVtTttgmOa6psy1jSPL
 tWT+j4YbMATS/2247UHrjXmk0wfxgz54jg+J26EgxHfjntR2SxJEEmaDq+dc2L1gSzWv
 PYjv3cGVidmfEnYe8qR55YVeas/OvnK5K0BD3LnDyE4YpqZottv1nsY9wjFSmBWqINj8
 FgD/8PqJzWVnq6nBaOf28yqY65x+QH6aPRmd6LfVuVTcM6YGEvm0Iukko8Ktn/J/cZMs
 qxwMH7z+CTNCMCWzol/QxNQF0pQTNyH/VvYXW8UlJzo1QJRwtEQJAGt7O94fII2WIfhh SA== 
In-Reply-To: <20200203232248.104733-1-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2/3/20 3:22 PM, Mina Almasry wrote:
> These counters will track hugetlb reservations rather than hugetlb
> memory faulted in. This patch only adds the counter, following patches
> add the charging and uncharging of the counter.
> 
> This is patch 1 of an 9 patch series.
> 
> Problem:
> Currently tasks attempting to reserve more hugetlb memory than is available get
> a failure at mmap/shmget time. This is thanks to Hugetlbfs Reservations [1].
> However, if a task attempts to reserve more hugetlb memory than its
> hugetlb_cgroup limit allows, the kernel will allow the mmap/shmget call, but
> will SIGBUS the task when it attempts to fault in the excess memory.
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
> 'hugetlb.xMB.rsvd.[limit|usage|max_usage]_in_bytes'. This counter has
> slightly different semantics than
> 'hugetlb.xMB.[limit|usage|max_usage]_in_bytes':
> 
> - While usage_in_bytes tracks all *faulted* hugetlb memory,
> rsvd.usage_in_bytes tracks all *reserved* hugetlb memory and
> hugetlb memory faulted in without a prior reservation.
> 
> - If a task attempts to reserve more memory than limit_in_bytes allows,
> the kernel will allow it to do so. But if a task attempts to reserve
> more memory than rsvd.limit_in_bytes, the kernel will fail this
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
>    differently: one via limit_in_bytes, and another via rsvd.limit_in_bytes.
>    This could be very useful if you're transitioning how hugetlb memory is
>    partitioned on your system one cgroup at a time, for example. Also, someone
>    may find usage for both limit_in_bytes and rsvd.limit_in_bytes concurrently,
>    and this approach gives them the option to do so.
> 
> Testing:
> - Added tests passing.
> - Used libhugetlbfs for regression testing.
> 
> [1]: https://www.kernel.org/doc/html/latest/vm/hugetlbfs_reserv.html
> 
> Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> ---
> Changes in v11:
> - Renamed resv.* or 'reservation' or 'reserved' to rsvd.*
> - Renamed hugetlb_cgroup_get_counter() to

Thanks!
I was mostly concerned about using 'resv' in cgroup file names visible to
users.  Changing variable names is good as well.

Small nit, some lines of commit message wrap.

Reviewed-by: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
-- 
Mike Kravetz
