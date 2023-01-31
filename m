From: David Hildenbrand <david@redhat.com>
Subject: Re: [RFC PATCH 00/19] mm: Introduce a cgroup to limit the amount of
 locked and pinned memory
Date: Tue, 31 Jan 2023 15:06:10 +0100
Message-ID: <2e78d261-9ae9-d203-446e-eaa3c652ca6e@redhat.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <Y9A7kDjm3ZFAttRR@nvidia.com>
 <6369225e-3522-341b-cd20-d95b1f11ea71@redhat.com>
 <Y9kfn4YX59PIxj7+@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675173980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9t7OLLXi4skInjN2+18+qU6/sB4l5NfmMr6BbX3yli0=;
        b=SfV7L+D3GCuHorb+fygp1XAGn+jhI8Ji3IIxVdIe7K0DzM0DjXGr4Pfn/1KdZmRJYuVfEe
        eXwBGPbeeuxThZ0+FNg0PmJiLMI2iA/8jo1hXHNzJBbRQwWf5hL8krgf7MxJdSra8YbOIx
        5lYvvx1M1prQ5iZONAZBBN381m33wwM=
Content-Language: en-US
In-Reply-To: <Y9kfn4YX59PIxj7+@nvidia.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, jhubbard@nvidia.com, tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com, mkoutny@suse.com, daniel@ffwll.ch

On 31.01.23 15:03, Jason Gunthorpe wrote:
> On Tue, Jan 31, 2023 at 02:57:20PM +0100, David Hildenbrand wrote:
> 
>>> I'm excited by this series, thanks for making it.
>>>
>>> The pin accounting has been a long standing problem and cgroups will
>>> really help!
>>
>> Indeed. I'm curious how GUP-fast, pinning the same page multiple times, and
>> pinning subpages of larger folios are handled :)
> 
> The same as today. The pinning is done based on the result from GUP,
> and we charge every returned struct page.
> 
> So duplicates are counted multiple times, folios are ignored.
> 
> Removing duplicate charges would be costly, it would require storage
> to keep track of how many times individual pages have been charged to
> each cgroup (eg an xarray indexed by PFN of integers in each cgroup).
> 
> It doesn't seem worth the cost, IMHO.
> 
> We've made alot of investment now with iommufd to remove the most
> annoying sources of duplicated pins so it is much less of a problem in
> the qemu context at least.

Wasn't there the discussion regarding using vfio+io_uring+rdma+$whatever 
on a VM and requiring multiple times the VM size as memlock limit? Would 
it be the same now, just that we need multiple times the pin limit?

-- 
Thanks,

David / dhildenb

