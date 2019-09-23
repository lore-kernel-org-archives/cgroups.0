From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v5 0/7] hugetlb_cgroup: Add hugetlb_cgroup reservation
 limits
Date: Mon, 23 Sep 2019 10:47:30 -0700
Message-ID: <3c73d2b7-f8d0-16bf-b0f0-86673c3e9ce3@oracle.com>
References: <20190919222421.27408-1-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=yDskfBufBcPBjCvniq+DMnbkW78ezLoVWcAK8svPf2o=;
 b=Ql5vbWG+kxg7x8Ups95HkSOCpzWtP7UKlTCD+zxH28gfZGKYH4Yz328gucDUXJT6oPmp
 sE7fD3Qg9ORS/5vusZqCpWBJ8saeGwfEc2Ukl/I3/TKJDNqMl1CR4zZQmvxLgjIxelup
 ueLksD8fC6fJO/x2UB2VAyzOmxIBGP9hVuOnBhqdWMJt2XaKKV/TBPTCcRVtaMquqUcI
 MxmYdbpnJdI7rQHCOVdyEerxDxapTPEklcIX65jlGFbnaoOud9SjKHLp+aOcmPUlFSSj
 GNrFmBAV4Vq7kil71S5KZV+zevmnZfeg8NtJtPc1EaOs39h4aYZiiZ43Qs+PIsEqNjeU AQ== 
In-Reply-To: <20190919222421.27408-1-almasrymina@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>, aneesh.kumar@linux.vnet.ibm.com
Cc: shuah@kernel.org, rientjes@google.com, shakeelb@google.com, gthelen@google.com, akpm@linux-foundation.org, khalid.aziz@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, mkoutny@suse.com

On 9/19/19 3:24 PM, Mina Almasry wrote:
> Patch series implements hugetlb_cgroup reservation usage and limits, which
> track hugetlb reservations rather than hugetlb memory faulted in. Details of
> the approach is 1/7.

Thanks for your continued efforts Mina.

One thing that has bothered me with this approach from the beginning is that
hugetlb reservations are related to, but somewhat distinct from hugetlb
allocations.  The original (existing) huegtlb cgroup implementation does not
take reservations into account.  This is an issue you are trying to address
by adding a cgroup support for hugetlb reservations.  However, this new
reservation cgroup ignores hugetlb allocations at fault time.

I 'think' the whole purpose of any hugetlb cgroup is to manage the allocation
of hugetlb pages.  Both the existing cgroup code and the reservation approach
have what I think are some serious flaws.  Consider a system with 100 hugetlb
pages available.  A sysadmin, has two groups A and B and wants to limit hugetlb
usage to 50 pages each.

With the existing implementation, a task in group A could create a mmap of
100 pages in size and reserve all 100 pages.  Since the pages are 'reserved',
nobody in group B can allocate ANY huge pages.  This is true even though
no pages have been allocated in A (or B).

With the reservation implementation, a task in group A could use MAP_NORESERVE
and allocate all 100 pages without taking any reservations.

As mentioned in your documentation, it would be possible to use both the
existing (allocation) and new reservation cgroups together.  Perhaps if both
are setup for the 50/50 split things would work a little better.

However, instead of creating a new reservation crgoup how about adding
reservation support to the existing allocation cgroup support.  One could
even argue that a reservation is an allocation as it sets aside huge pages
that can only be used for a specific purpose.  Here is something that
may work.

Starting with the existing allocation cgroup.
- When hugetlb pages are reserved, the cgroup of the task making the
  reservations is charged.  Tracking for the charged cgroup is done in the
  reservation map in the same way proposed by this patch set.
- At page fault time,
  - If a reservation already exists for that specific area do not charge the
    faulting task.  No tracking in page, just the reservation map.
  - If no reservation exists, charge the group of the faulting task.  Tracking
    of this information is in the page itself as implemented today.
- When the hugetlb object is removed, compare the reservation map with any
  allocated pages.  If cgroup tracking information exists in page, uncharge
  that group.  Otherwise, unharge the group (if any) in the reservation map.

One of the advantages of a separate reservation cgroup is that the existing
code is unmodified.  Combining the two provides a more complete/accurate
solution IMO.  But, it has the potential to break existing users.

I really would like to get feedback from anyone that knows how the existing
hugetlb cgroup controller may be used today.  Comments from Aneesh would
be very welcome to know if reservations were considered in development of the
existing code.
-- 
Mike Kravetz
