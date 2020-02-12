From: Sandipan Das <sandipan@linux.ibm.com>
Subject: Re: [PATCH v12 8/9] hugetlb_cgroup: Add hugetlb_cgroup reservation
 tests
Date: Wed, 12 Feb 2020 14:20:41 +0530
Message-ID: <37a49c35-567f-1663-33cd-3dac150020a0@linux.ibm.com>
References: <20200211213128.73302-1-almasrymina@google.com>
 <20200211213128.73302-8-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200211213128.73302-8-almasrymina@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>, mike.kravetz@oracle.com
Cc: shuah@kernel.org, rientjes@google.com, shakeelb@google.com, gthelen@google.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org



On 12/02/20 3:01 am, Mina Almasry wrote:
> The tests use both shared and private mapped hugetlb memory, and
> monitors the hugetlb usage counter as well as the hugetlb reservation
> counter. They test different configurations such as hugetlb memory usage
> via hugetlbfs, or MAP_HUGETLB, or shmget/shmat, and with and without
> MAP_POPULATE.
> 
> Also add test for hugetlb reservation reparenting, since this is
> a subtle issue.
> 
> Signed-off-by: Mina Almasry <almasrymina@google.com>
> Cc: sandipan@linux.ibm.com
> 
> 
> ---
> 
> Changes in v12:
> - Fixed tests on machines with non-2MB default hugepage size.
> Changes in v11:
> - Modify test to not assume 2MB hugepage size.
> - Updated resv.* to rsvd.*
> Changes in v10:
> - Updated tests to resv.* name changes.
> Changes in v9:
> - Added tests for hugetlb reparenting.
> - Make tests explicitly support cgroup v1 and v2 via script argument.
> Changes in v6:
> - Updates tests for cgroups-v2 and NORESERVE allocations.
> 

For powerpc64,

Tested-by: Sandipan Das <sandipan@linux.ibm.com>

