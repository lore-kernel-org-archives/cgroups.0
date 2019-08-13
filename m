From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [RFC PATCH v2 0/5] hugetlb_cgroup: Add hugetlb_cgroup reservation
 limits
Date: Tue, 13 Aug 2019 16:40:39 -0700
Message-ID: <ce087279-7235-e579-4aec-bc3792b6c09c@oracle.com>
References: <20190808231340.53601-1-almasrymina@google.com>
 <f0a5afe9-2586-38c9-9a6d-8a2b7b288b50@oracle.com>
 <CAHS8izOKmaOETBd_545Zex=KFNjYOvf3dCzcMRUEXnnhYCK5bw@mail.gmail.com>
 <71a29844-7367-44c4-23be-eff26ac80467@oracle.com>
 <CAHS8izPGhHS+=qnf7Vy=C8kXQ=7v7XH3uEVitrW6ARRYU6iDdg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=4sbmczonSDq7hMSzD5d9nB/WEujCYY2Kbl0OVowZy30=;
 b=Mg48PWRCx/UGmdQ+LhxE0ApUMA7usmcn1IT6wfUB5oESpjaJU95lAFUuOP+lrXza5i2O
 nGjnhjYB1nLdwSAsLGfRqAq8GrzokGXFZs0QyU0dvnO25FfoQSwyRbC4yZj4Kj+btcxY
 iFDLLUdN0+FyulEzyuGWuf/4Uk5OVbkO/OgUfapiZZCyLFvHEWCP27leFn22m0y+gsTe
 1hFbzXXR0oHlRKmZRbIywzASgEONv5aerYMH2thpsejQ1zdhiSlWJQB2LohBqfS86SNE
 QXvMxHJGlBGyz/09dAR9paxjdwWJIj/k0n0MNZ74YFw8ZhDH2Ypm0s/vFLr6h48ARUUz XQ== 
In-Reply-To: <CAHS8izPGhHS+=qnf7Vy=C8kXQ=7v7XH3uEVitrW6ARRYU6iDdg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>
Cc: shuah <shuah@kernel.org>, David Rientjes <rientjes@google.com>, Shakeel Butt <shakeelb@google.com>, Greg Thelen <gthelen@google.com>, akpm@linux-foundation.org, khalid.aziz@oracle.com, open list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, cgroups@vger.kernel.org

On 8/10/19 3:01 PM, Mina Almasry wrote:
> On Sat, Aug 10, 2019 at 11:58 AM Mike Kravetz <mike.kravetz@oracle.com> wrote:
>>
>> On 8/9/19 12:42 PM, Mina Almasry wrote:
>>> On Fri, Aug 9, 2019 at 10:54 AM Mike Kravetz <mike.kravetz@oracle.com> wrote:
>>>> On 8/8/19 4:13 PM, Mina Almasry wrote:
>>>>> Problem:
>>>>> Currently tasks attempting to allocate more hugetlb memory than is available get
>>>>> a failure at mmap/shmget time. This is thanks to Hugetlbfs Reservations [1].
>>>>> However, if a task attempts to allocate hugetlb memory only more than its
>>>>> hugetlb_cgroup limit allows, the kernel will allow the mmap/shmget call,
>>>>> but will SIGBUS the task when it attempts to fault the memory in.
>> <snip>
>>>> I believe tracking reservations for shared mappings can get quite complicated.
>>>> The hugetlbfs reservation code around shared mappings 'works' on the basis
>>>> that shared mapping reservations are global.  As a result, reservations are
>>>> more associated with the inode than with the task making the reservation.
>>>
>>> FWIW, I found it not too bad. And my tests at least don't detect an
>>> anomaly around shared mappings. The key I think is that I'm tracking
>>> cgroup to uncharge on the file_region entry inside the resv_map, so we
>>> know who allocated each file_region entry exactly and we can uncharge
>>> them when the entry is region_del'd.
>>>
>>>> For example, consider a file of size 4 hugetlb pages.
>>>> Task A maps the first 2 pages, and 2 reservations are taken.  Task B maps
>>>> all 4 pages, and 2 additional reservations are taken.  I am not really sure
>>>> of the desired semantics here for reservation limits if A and B are in separate
>>>> cgroups.  Should B be charged for 4 or 2 reservations?
>>>
>>> Task A's cgroup is charged 2 pages to its reservation usage.
>>> Task B's cgroup is charged 2 pages to its reservation usage.
>>
>> OK,
>> Suppose Task B's cgroup allowed 2 huge pages reservation and 2 huge pages
>> allocation.  The mmap would succeed, but Task B could potentially need to
>> allocate more than 2 huge pages.  So, when faulting in more than 2 huge
>> pages B would get a SIGBUS.  Correct?  Or, am I missing something?
>>
>> Perhaps reservation charge should always be the same as map size/maximum
>> allocation size?
> 
> I'm thinking this would work similar to how other shared memory like
> tmpfs is accounted for right now. I.e. if a task conducts an operation
> that causes memory to be allocated then that task is charged for that
> memory, and if another task uses memory that has already been
> allocated and charged by another task, then it can use the memory
> without being charged.
> 
> So in case of hugetlb memory, if a task is mmaping memory that causes
> a new reservation to be made, and new entries to be created in the
> resv_map for the shared mapping, then that task gets charged. If the
> task is mmaping memory that is already reserved or faulted, then it
> reserves or faults it without getting charged.
> 
> In the example above, in chronological order:
> - Task A mmaps 2 hugetlb pages, gets charged 2 hugetlb reservations.
> - Task B mmaps 4 hugetlb pages, gets charged only 2 hugetlb
> reservations because the first 2 are charged already and can be used
> without incurring a charge.
> - Task B accesses 4 hugetlb pages, gets charged *4* hugetlb faults,
> since none of the 4 pages are faulted in yet. If the task is only
> allowed 2 hugetlb page faults then it will actually get a SIGBUS.
> - Task A accesses 4 hugetlb pages, gets charged no faults, since all
> the hugetlb faults is charged to Task B.
> 
> So, yes, I can see a scenario where userspace still gets SIGBUS'd, but
> I think that's fine because:
> 1. Notice that the SIGBUS is due to the faulting limit, and not the
> reservation limit, so we're not regressing the status quo per say.
> Folks using the fault limit today understand the SIGBUS risk.
> 2. the way I expect folks to use this is to use 'reservation limits'
> to partition the available hugetlb memory on the machine using it and
> forgo using the existing fault limits. Using both at the same time I
> think would be a superuser feature for folks that really know what
> they are doing, and understand the risk of SIGBUS that comes with
> using the existing fault limits.
> 3. I expect userspace to in general handle this correctly because
> there are similar challenges with all shared memory and accounting of
> it, even in tmpfs, I think.

Ok, that helps explain your use case.  I agree that it would be difficult
to use both fault and reservation limits together.  Especially in the case
of shared mappings.
-- 
Mike Kravetz
