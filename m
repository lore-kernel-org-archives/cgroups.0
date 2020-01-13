From: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v9 1/8] hugetlb_cgroup: Add hugetlb_cgroup reservation
 counter
Date: Mon, 13 Jan 2020 10:43:12 -0800
Message-ID: <817e2c4b-4c72-09f9-22ea-bbaf97584161@oracle.com>
References: <20191217231615.164161-1-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=58bZpuiFAks0nyTSTapJdzHryQVmx7OwYqtXIuvSXB4=;
 b=TEFnciVLOWX1iv14uTDL8MJpviCcdFoR7s5SF/pkyIHJbsjDrBA43BxejJUzkyMsqYo2
 3BNGaD6rBHVKjN1eeWN3d3SvxY5MlynKEI8hPWrYD89c2qawHaaJFWHxtgGwcelSNtwo
 CxvRdHxgB9UBA1yJ/qFmyGjkVXcI0mvERL3mnmhzC/C7y+C53Q96d4kwWKrhYLwP8rxo
 eCIS8QTjlBr27FDDINdjhvYGgRSQb14fPIWQLl92Frf3HFsVDGU/SOji65IuLZms2rt1
 BIVGnYVaDAgYJ4PQGqSA9DIiHaYUT0anDaPgMjWRVlDR3zwoWUSQhl4XgjGxSnKXmprb NA== 
In-Reply-To: <20191217231615.164161-1-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>

On 12/17/19 3:16 PM, Mina Almasry wrote:
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
> We have developers interested in using hugetlb_cgroups, and they have expressed
> dissatisfaction regarding this behavior. We'd like to improve this
> behavior such that tasks violating the hugetlb_cgroup limits get an error on
> mmap/shmget time, rather than getting SIGBUS'd when they try to fault
> the excess memory in.
> 
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
> - While usage_in_bytes tracks all *faulted* hugetlb memory,
> reservation_usage_in_bytes tracks all *reserved* hugetlb memory and
> hugetlb memory faulted in without a prior reservation.

To me, this implies that 'faults without reservations' could cause
reservation usage to exceed reservation limit?  Or, does the faulting
process get a SIGBUS because of the reservation limit even though it
is not using reservations?

We shall see in subsequent patches.

> 
> - If a task attempts to reserve more memory than limit_in_bytes allows,
> the kernel will allow it to do so. But if a task attempts to reserve
> more memory than reservation_limit_in_bytes, the kernel will fail this
> reservation.
> 
> This proposal is implemented in this patch series, with tests to verify
> functionality and show the usage. We also added cgroup-v2 support to
> hugetlb_cgroup so that the new use cases can be extended to v2.

As previously discussed, cgroup-v2 support for hugetlb_cgroup will exist
before this patch series.

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

I think the ACK by Hillf happened some time back.  You may want to check
to see if it still applies.

> 
> ---
>  include/linux/hugetlb.h |   4 +-
>  mm/hugetlb_cgroup.c     | 116 +++++++++++++++++++++++++++++++++++-----
>  2 files changed, 106 insertions(+), 14 deletions(-)

Only one minor nit in the code.

You made this cleanup,
@@ -472,7 +519,7 @@ static void __init __hugetlb_cgroup_file_dfl_init(int idx)
        struct hstate *h = &hstates[idx];

        /* format the size */
-       mem_fmt(buf, 32, huge_page_size(h));
+       mem_fmt(buf, sizeof(buf), huge_page_size(h));

        /* Add the limit file */
        cft = &h->cgroup_files_dfl[0];

But did not make the same cleanup in __hugetlb_cgroup_file_legacy_init()
-- 
Mike Kravetz
