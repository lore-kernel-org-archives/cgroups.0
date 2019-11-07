From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v8 1/9] hugetlb_cgroup: Add hugetlb_cgroup reservation
 counter
Date: Thu, 7 Nov 2019 15:42:12 -0800
Message-ID: <78f07acf-47ba-4fa5-34c2-78a17eb7c16f@oracle.com>
References: <20191030013701.39647-1-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=InetN9fzWsCQ0YpEFg6c78mbU6HXpKe5KOlB6t943pA=;
 b=ApVBk5eGbpVHOMv4eaD+JuWf3N29yB4PpVpD5vlkrJiRi8StN6GXZ6i9vLxu8uUx+9bo
 NZSQp3OSjEh5Hot/K9xp9xT6+SiKCyAzGclg5UOBJFjFo8rl6qsP6RA9mKPcsmGELrhR
 ljtq+F/1MKlwZ4ljxtfUQFcby8BQNFgn9OmhxceStcd1E4uo3JbHnIEHdf78a/udDkWl
 AhUXF3qcWS+DfRzS4U05HAqgq/pKY9rlGexkZIzEwD145tRoJI4vV8rzrPr9fZzqDfqt
 iBTfXWDUP5bpUEJvxseGNS5taKYXdMMt7bHuJddpumGzcq+tkdhciCTbs5b8bigQk/wy hw== 
In-Reply-To: <20191030013701.39647-1-almasrymina@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>
Cc: shuah@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com, Hillf Danton <hdanton@sina.com>, Andrew Morton <akpm@linux-foundation.org>

Cc: Andrew
This series is getting closer to consideration for the mm tree.
Mina,
Be sure to cc Andrew with next version of series.

On 10/29/19 6:36 PM, Mina Almasry wrote:
> These counters will track hugetlb reservations rather than hugetlb
> memory faulted in. This patch only adds the counter, following patches
> add the charging and uncharging of the counter.

I honestly am not sure the preferred method for including the overall
design in a commit message.  Certainly it should be in the first patch.
Perhaps, say this is patch 1 of a 9 patch series here.

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

I think that simply mentioning the use of hugetlbfs for regression testing
would be sufficient here.

> - Added tests passing.
> - libhugetlbfs tests mostly passing, but some tests have trouble with and
>   without this patch series. Seems environment issue rather than code:
>   - Overall results:
>     ********** TEST SUMMARY
>     *                      2M
>     *                      32-bit 64-bit
>     *     Total testcases:    84      0
>     *             Skipped:     0      0
>     *                PASS:    66      0
>     *                FAIL:    14      0
>     *    Killed by signal:     0      0
>     *   Bad configuration:     4      0
>     *       Expected FAIL:     0      0
>     *     Unexpected PASS:     0      0
>     *    Test not present:     0      0
>     * Strange test result:     0      0
>     **********

It is curious that you only ran the tests for 32 bit applications.  Certainly
the more common case today is 64 bit.  I don't think there are any surprises
for you as I also have been running hugetlbfs on this series.
-- 
Mike Kravetz

>   - Failing tests:
>     - elflink_rw_and_share_test("linkhuge_rw") segfaults with and without this
>       patch series.
>     - LD_PRELOAD=libhugetlbfs.so HUGETLB_MORECORE=yes malloc (2M: 32):
>       FAIL    Address is not hugepage
>     - LD_PRELOAD=libhugetlbfs.so HUGETLB_RESTRICT_EXE=unknown:malloc
>       HUGETLB_MORECORE=yes malloc (2M: 32):
>       FAIL    Address is not hugepage
>     - LD_PRELOAD=libhugetlbfs.so HUGETLB_MORECORE=yes malloc_manysmall (2M: 32):
>       FAIL    Address is not hugepage
>     - GLIBC_TUNABLES=glibc.malloc.tcache_count=0 LD_PRELOAD=libhugetlbfs.so
>       HUGETLB_MORECORE=yes heapshrink (2M: 32):
>       FAIL    Heap not on hugepages
>     - GLIBC_TUNABLES=glibc.malloc.tcache_count=0 LD_PRELOAD=libhugetlbfs.so
>       libheapshrink.so HUGETLB_MORECORE=yes heapshrink (2M: 32):
>       FAIL    Heap not on hugepages
>     - HUGETLB_ELFMAP=RW linkhuge_rw (2M: 32): FAIL    small_data is not hugepage
>     - HUGETLB_ELFMAP=RW HUGETLB_MINIMAL_COPY=no linkhuge_rw (2M: 32):
>       FAIL    small_data is not hugepage
>     - alloc-instantiate-race shared (2M: 32):
>       Bad configuration: sched_setaffinity(cpu1): Invalid argument -
>       FAIL    Child 1 killed by signal Killed
>     - shmoverride_linked (2M: 32):
>       FAIL    shmget failed size 2097152 from line 176: Invalid argument
>     - HUGETLB_SHM=yes shmoverride_linked (2M: 32):
>       FAIL    shmget failed size 2097152 from line 176: Invalid argument
>     - shmoverride_linked_static (2M: 32):
>       FAIL shmget failed size 2097152 from line 176: Invalid argument
>     - HUGETLB_SHM=yes shmoverride_linked_static (2M: 32):
>       FAIL shmget failed size 2097152 from line 176: Invalid argument
>     - LD_PRELOAD=libhugetlbfs.so shmoverride_unlinked (2M: 32):
>       FAIL shmget failed size 2097152 from line 176: Invalid argument
>     - LD_PRELOAD=libhugetlbfs.so HUGETLB_SHM=yes shmoverride_unlinked (2M: 32):
>       FAIL    shmget failed size 2097152 from line 176: Invalid argument
> 
> [1]: https://www.kernel.org/doc/html/latest/vm/hugetlbfs_reserv.html
> 
> Signed-off-by: Mina Almasry <almasrymina@google.com>
> Acked-by: Hillf Danton <hdanton@sina.com>
