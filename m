From: David Hildenbrand <david@redhat.com>
Subject: Re: [RFC PATCH 00/19] mm: Introduce a cgroup to limit the amount of
 locked and pinned memory
Date: Tue, 31 Jan 2023 14:57:20 +0100
Message-ID: <6369225e-3522-341b-cd20-d95b1f11ea71@redhat.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <Y9A7kDjm3ZFAttRR@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675173444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KLzrEVNF/I06hEyCLzFWZ+B0+c4Uy25WE0TJqoTLRzw=;
        b=QZhPvOsekA/DBfoNj2jeVyTVltGiqTznKirizv35Yu+eXGM2UwO4/gWDXK+l07lDkX6Rxh
        3GD6hIzrZFGpWP3zQY9TEjM80su8/cSZTdUVih6LjDnAc5ot4ycAzfAd7kvgo7KVzIc9Us
        PuYBvtkzOBdp7nV1X5ClVmRnyjPZkWQ=
Content-Language: en-US
In-Reply-To: <Y9A7kDjm3ZFAttRR@nvidia.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Jason Gunthorpe <jgg@nvidia.com>, Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, jhubbard@nvidia.com, tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com, mkoutny@suse.com, daniel@ffwll.ch

On 24.01.23 21:12, Jason Gunthorpe wrote:
> On Tue, Jan 24, 2023 at 04:42:29PM +1100, Alistair Popple wrote:
>> Having large amounts of unmovable or unreclaimable memory in a system
>> can lead to system instability due to increasing the likelihood of
>> encountering out-of-memory conditions. Therefore it is desirable to
>> limit the amount of memory users can lock or pin.
>>
>>  From userspace such limits can be enforced by setting
>> RLIMIT_MEMLOCK. However there is no standard method that drivers and
>> other in-kernel users can use to check and enforce this limit.
>>
>> This has lead to a large number of inconsistencies in how limits are
>> enforced. For example some drivers will use mm->locked_mm while others
>> will use mm->pinned_mm or user->locked_mm. It is therefore possible to
>> have up to three times RLIMIT_MEMLOCKED pinned.
>>
>> Having pinned memory limited per-task also makes it easy for users to
>> exceed the limit. For example drivers that pin memory with
>> pin_user_pages() it tends to remain pinned after fork. To deal with
>> this and other issues this series introduces a cgroup for tracking and
>> limiting the number of pages pinned or locked by tasks in the group.
>>
>> However the existing behaviour with regards to the rlimit needs to be
>> maintained. Therefore the lesser of the two limits is
>> enforced. Furthermore having CAP_IPC_LOCK usually bypasses the rlimit,
>> but this bypass is not allowed for the cgroup.
>>
>> The first part of this series converts existing drivers which
>> open-code the use of locked_mm/pinned_mm over to a common interface
>> which manages the refcounts of the associated task/mm/user
>> structs. This ensures accounting of pages is consistent and makes it
>> easier to add charging of the cgroup.
>>
>> The second part of the series adds the cgroup and converts core mm
>> code such as mlock over to charging the cgroup before finally
>> introducing some selftests.
>>
>> As I don't have access to systems with all the various devices I
>> haven't been able to test all driver changes. Any help there would be
>> appreciated.
> 
> I'm excited by this series, thanks for making it.
> 
> The pin accounting has been a long standing problem and cgroups will
> really help!

Indeed. I'm curious how GUP-fast, pinning the same page multiple times, 
and pinning subpages of larger folios are handled :)

-- 
Thanks,

David / dhildenb

