From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v5 0/7] hugetlb_cgroup: Add hugetlb_cgroup reservation
 limits
Date: Mon, 23 Sep 2019 14:27:06 -0700
Message-ID: <a8e9c533-1593-35ee-e65d-1f2fc2b0fb48@oracle.com>
References: <20190919222421.27408-1-almasrymina@google.com>
 <3c73d2b7-f8d0-16bf-b0f0-86673c3e9ce3@oracle.com>
 <CAHS8izOj2AT4tX-+Hcb8LB2TOUKJDHScDtJ80u4M6OWpwktq0g@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=83jxGKqAi9Yk4jDwgF6P4FCc3JGos7ZpoO61f8oV08k=;
 b=i/ZJrc4YyWymOVjBHKVonztA+Qn77uS5ZklHaHlsaJsDt4VrFR+7NCP8O2CF6u6IEzgZ
 ZomLUvzCbGU1lW48gWBtWwCc4AG+dnAaJe/gig5jRK87MGEhjBzF37bhxP+evJsdKisE
 tw6B2gGmj4ysAZFWpv3HwTCj4E9f45364AhgeLp3xjL0S/qTWk5m6ww94oFpRe4Hhel/
 o7VWbvx51qC785DDxQd+69Dz2hqEiTBz/LZKB8cDdwBuPfeMTwyOxMkbIv0jGCurpC7J
 ouHOTbOg3qncq/ZiEIUIQxfaqZGsqSQa2YNYPjS6lo9RFHKuOzGBK+ylBD42w824LS2y sQ== 
In-Reply-To: <CAHS8izOj2AT4tX-+Hcb8LB2TOUKJDHScDtJ80u4M6OWpwktq0g@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: shuah <shuah@kernel.org>, David Rientjes <rientjes@google.com>, Shakeel Butt <shakeelb@google.com>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, khalid.aziz@oracle.com, open list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>

On 9/23/19 12:18 PM, Mina Almasry wrote:
> On Mon, Sep 23, 2019 at 10:47 AM Mike Kravetz <mike.kravetz@oracle.com> wrote:
>>
>> On 9/19/19 3:24 PM, Mina Almasry wrote:
>>> Patch series implements hugetlb_cgroup reservation usage and limits, which
>>> track hugetlb reservations rather than hugetlb memory faulted in. Details of
>>> the approach is 1/7.
>>
>> Thanks for your continued efforts Mina.
>>
> 
> And thanks for your reviews so far.
> 
>> One thing that has bothered me with this approach from the beginning is that
>> hugetlb reservations are related to, but somewhat distinct from hugetlb
>> allocations.  The original (existing) huegtlb cgroup implementation does not
>> take reservations into account.  This is an issue you are trying to address
>> by adding a cgroup support for hugetlb reservations.  However, this new
>> reservation cgroup ignores hugetlb allocations at fault time.
>>
>> I 'think' the whole purpose of any hugetlb cgroup is to manage the allocation
>> of hugetlb pages.  Both the existing cgroup code and the reservation approach
>> have what I think are some serious flaws.  Consider a system with 100 hugetlb
>> pages available.  A sysadmin, has two groups A and B and wants to limit hugetlb
>> usage to 50 pages each.
>>
>> With the existing implementation, a task in group A could create a mmap of
>> 100 pages in size and reserve all 100 pages.  Since the pages are 'reserved',
>> nobody in group B can allocate ANY huge pages.  This is true even though
>> no pages have been allocated in A (or B).
>>
>> With the reservation implementation, a task in group A could use MAP_NORESERVE
>> and allocate all 100 pages without taking any reservations.
>>
>> As mentioned in your documentation, it would be possible to use both the
>> existing (allocation) and new reservation cgroups together.  Perhaps if both
>> are setup for the 50/50 split things would work a little better.
>>
>> However, instead of creating a new reservation crgoup how about adding
>> reservation support to the existing allocation cgroup support.  One could
>> even argue that a reservation is an allocation as it sets aside huge pages
>> that can only be used for a specific purpose.  Here is something that
>> may work.
>>
>> Starting with the existing allocation cgroup.
>> - When hugetlb pages are reserved, the cgroup of the task making the
>>   reservations is charged.  Tracking for the charged cgroup is done in the
>>   reservation map in the same way proposed by this patch set.
>> - At page fault time,
>>   - If a reservation already exists for that specific area do not charge the
>>     faulting task.  No tracking in page, just the reservation map.
>>   - If no reservation exists, charge the group of the faulting task.  Tracking
>>     of this information is in the page itself as implemented today.
>> - When the hugetlb object is removed, compare the reservation map with any
>>   allocated pages.  If cgroup tracking information exists in page, uncharge
>>   that group.  Otherwise, unharge the group (if any) in the reservation map.
>>
>> One of the advantages of a separate reservation cgroup is that the existing
>> code is unmodified.  Combining the two provides a more complete/accurate
>> solution IMO.  But, it has the potential to break existing users.
>>
>> I really would like to get feedback from anyone that knows how the existing
>> hugetlb cgroup controller may be used today.  Comments from Aneesh would
>> be very welcome to know if reservations were considered in development of the
>> existing code.
>> --
> 
> FWIW, I'm aware of the interaction with NORESERVE and my thoughts are:
> 
> AFAICT, the 2 counter approach we have here is strictly superior to
> the 1 upgraded counter approach. Consider these points:
> 
> - From what I can tell so far, everything you can do with the 1
> counter approach, you can do with the two counter approach by setting
> both limit_in_bytes and reservation_limit_in_bytes to the limit value.
> That will limit both reservations and at fault allocations.
> 
> - The 2 counter approach preserves existing usage of hugetlb cgroups,
> so no need to muck around with reverting the feature some time from
> now because of broken users. No existing users of hugetlb cgroups need
> to worry about the effect of this on their usage.
> 
> - Users that use hugetlb memory strictly through reservations can use
> only reservation_limit_in_bytes and enjoy cgroup limits that never
> SIGBUS the application. This is our usage for example.
> 
> - The 2 counter approach provides more info to the sysadmin. The
> sysadmin knows exactly how much reserved bytes there are via
> reservation_usage_in_bytes, and how much actually in use bytes there
> are via usage_in_bytes. They can even detect NORESERVE usage if
> usage_in_bytes > reservation_usage_in_bytes. failcnt shows failed
> reservations *and* failed allocations at fault, etc. All around better
> debuggability when things go wrong. I think this is particularly
> troubling for the 1 upgraded counter approach. That counter's
> usage_in_bytes doesn't tell you if the usage came from reservations or
> allocations at fault time.
> 
> - Honestly, I think the 2 counter approach is easier to document and
> understand by the userspace? 1 counter that vaguely tracks both the
> reservations and usage and decides whether or not to charge at fault
> time seems hard to understand what really happened after something
> goes wrong. 1 counter that tracks reservations and 1 counter that
> tracks actual usage seem much simpler to digest, and provide better
> visibility to what the cgroup is doing as I mentioned above.
> 
> I think it may be better if I keep the 2 counter approach but
> thoroughly document the interaction between the existing counters and
> NORESERVE. What do you think?

I personally prefer the one counter approach only for the reason that it
exposes less information about hugetlb reservations.  I was not around
for the introduction of hugetlb reservations, but I have fixed several
issues having to do with reservations.  IMO, reservations should be hidden
from users as much as possible.  Others may disagree.

I really hope that Aneesh will comment.  He added the existing hugetlb
cgroup code.  I was not involved in that effort, but it looks like there
might have been some thought given to reservations in early versions of
that code.  It would be interesting to get his perspective.

Changes included in patch 4 (disable region_add file_region coalescing)
would be needed in a one counter approach as well, so I do plan to
review those changes.
-- 
Mike Kravetz
