From: Sandipan Das <sandipan@linux.ibm.com>
Subject: Re: [PATCH v10 7/8] hugetlb_cgroup: Add hugetlb_cgroup reservation
 tests
Date: Thu, 30 Jan 2020 11:41:15 +0530
Message-ID: <98c83a41-b864-5950-488c-443f6ef60b91@linux.ibm.com>
References: <20200115012651.228058-1-almasrymina@google.com>
 <20200115012651.228058-7-almasrymina@google.com>
 <7ce6d59f-fd73-c529-2ad6-edda9937966d@linux.ibm.com>
 <alpine.DEB.2.21.2001291257510.175731@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.2001291257510.175731@chino.kir.corp.google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: David Rientjes <rientjes@google.com>
Cc: Mina Almasry <almasrymina@google.com>, mike.kravetz@oracle.com, shakeelb@google.com, shuah@kernel.org, gthelen@google.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com

Hi David,

On 30/01/20 2:30 am, David Rientjes wrote:
> On Thu, 23 Jan 2020, Sandipan Das wrote:
> 
>> For powerpc64, either 16MB/16GB or 2MB/1GB huge pages are supported depending
>> on the MMU type (Hash or Radix). I was just running these tests on a powerpc64
>> system with Hash MMU and ran into problems because the tests assume that the
>> hugepage size is always 2MB. Can you determine the huge page size at runtime?
>>
> 
> I assume this is only testing failures of the tools/testing/selftests 
> additions that hardcode 2MB paths and not a kernel problem?  In other 
> words, you can still boot, reserve, alloc, and free hugetlb pages on ppc 
> after this patchset without using the selftests?
> 

Yes, its just the hardcoded paths. I didn't run into any kernel problems.

- Sandipan

