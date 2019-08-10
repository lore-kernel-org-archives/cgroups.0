From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [RFC PATCH v2 0/5] hugetlb_cgroup: Add hugetlb_cgroup reservation
 limits
Date: Sat, 10 Aug 2019 11:58:17 -0700
Message-ID: <71a29844-7367-44c4-23be-eff26ac80467@oracle.com>
References: <20190808231340.53601-1-almasrymina@google.com>
 <f0a5afe9-2586-38c9-9a6d-8a2b7b288b50@oracle.com>
 <CAHS8izOKmaOETBd_545Zex=KFNjYOvf3dCzcMRUEXnnhYCK5bw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=9Kvou7nXU35uL9YTviEvgLeoRHiA9PhMGEANGocDyTQ=;
 b=XNvddTvuSX42e9Bx6XI7qBNi6FdGuvw6eDcxPeN1dZEeq398Lg9ds1v+NBkz33ekJe7f
 fIM9MI37VDjrDEZ7ka8s6VqIAYkBiC8m3excUvNRWdOz3HHednTY8cGbC7qn5NREF2bt
 IQfOH+SlafYp/lSVcpqDrBlNJyWhgDQVemijSe6Bo66M8bLn2LGNADzuVHtw+X/AGbLg
 vuciZKPpFoZWMZKv8ku19r8PGX8d1tFOkcKhGrH+yVlPU7stAkAwLu8RZ4gBxwu4HHGG
 Rc8SrS3AoCaT2avj1b3lcls2SbKsOgUTfNvDH+gb82fw0vdGII7tbTq8+rSIRbZYdu5Y DA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=9Kvou7nXU35uL9YTviEvgLeoRHiA9PhMGEANGocDyTQ=;
 b=3mM++sKZGEyvNYSdOX/GSKo+KkyrsMOPKlb50IE2wtVkX6sFZCl2HcNZWU1pwukw3ivo
 9rtXp7iVHNXLcJn37OiVJkv4+pyl7Dq3kP6q7IVQ5qdvvmFCGsCNb5C5zdqdXxONWRl2
 lMaZ74cOjZRtavVOkLDUuAyJg3GjoW6ESf3l1dYGT96/giNjl/+A85CIH9gwSOEjbl1w
 XQCyDoPaK/iwrp1Ik8j/iySHQBuHf0ElT8DAu8xa9zmdJ9qiMKuqYyyfUraV9OPHdah9
 ufZyfnyLaF4ohL6FMEo+TVqwVsG7XyXhP1w/MevZI5OpPsRrKQViJG1MCgWlQcnGAGQY UA== 
In-Reply-To: <CAHS8izOKmaOETBd_545Zex=KFNjYOvf3dCzcMRUEXnnhYCK5bw@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>
Cc: shuah <shuah@kernel.org>, David Rientjes <rientjes@google.com>, Shakeel Butt <shakeelb@google.com>, Greg Thelen <gthelen@google.com>, akpm@linux-foundation.org, khalid.aziz@oracle.com, open list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, cgroups@vger.kernel.org

On 8/9/19 12:42 PM, Mina Almasry wrote:
> On Fri, Aug 9, 2019 at 10:54 AM Mike Kravetz <mike.kravetz@oracle.com> wrote:
>> On 8/8/19 4:13 PM, Mina Almasry wrote:
>>> Problem:
>>> Currently tasks attempting to allocate more hugetlb memory than is available get
>>> a failure at mmap/shmget time. This is thanks to Hugetlbfs Reservations [1].
>>> However, if a task attempts to allocate hugetlb memory only more than its
>>> hugetlb_cgroup limit allows, the kernel will allow the mmap/shmget call,
>>> but will SIGBUS the task when it attempts to fault the memory in.
<snip>
>> I believe tracking reservations for shared mappings can get quite complicated.
>> The hugetlbfs reservation code around shared mappings 'works' on the basis
>> that shared mapping reservations are global.  As a result, reservations are
>> more associated with the inode than with the task making the reservation.
> 
> FWIW, I found it not too bad. And my tests at least don't detect an
> anomaly around shared mappings. The key I think is that I'm tracking
> cgroup to uncharge on the file_region entry inside the resv_map, so we
> know who allocated each file_region entry exactly and we can uncharge
> them when the entry is region_del'd.
> 
>> For example, consider a file of size 4 hugetlb pages.
>> Task A maps the first 2 pages, and 2 reservations are taken.  Task B maps
>> all 4 pages, and 2 additional reservations are taken.  I am not really sure
>> of the desired semantics here for reservation limits if A and B are in separate
>> cgroups.  Should B be charged for 4 or 2 reservations?
> 
> Task A's cgroup is charged 2 pages to its reservation usage.
> Task B's cgroup is charged 2 pages to its reservation usage.

OK,
Suppose Task B's cgroup allowed 2 huge pages reservation and 2 huge pages
allocation.  The mmap would succeed, but Task B could potentially need to
allocate more than 2 huge pages.  So, when faulting in more than 2 huge
pages B would get a SIGBUS.  Correct?  Or, am I missing something?

Perhaps reservation charge should always be the same as map size/maximum
allocation size?
-- 
Mike Kravetz
