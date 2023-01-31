From: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 00/19] mm: Introduce a cgroup to limit the amount of
 locked and pinned memory
Date: Tue, 31 Jan 2023 15:15:49 +0100
Message-ID: <1a2417bc-f3ac-3e63-a930-bdefaab2578e@redhat.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <Y9A7kDjm3ZFAttRR@nvidia.com>
 <6369225e-3522-341b-cd20-d95b1f11ea71@redhat.com>
 <Y9kfn4YX59PIxj7+@nvidia.com>
 <2e78d261-9ae9-d203-446e-eaa3c652ca6e@redhat.com>
 <Y9khYwunmC/xdXT9@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675174553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DlcHXaQO4YJH3Te+lxRyNGl+ktaDXyBM2nbmHql0yqk=;
        b=MIKl9uWbqj9xBP3ys3vf2ljohv9hcP8PLPqIjFEs8fbcUGVzRy1TD0AcEL6C6mM2x9Fu0t
        ADxAnDMhCaj4BYZ7idf5WZAho5fNVghFx1FwxGf6fJ9qHppKNCxPn+LU2oLxwatK0LpIoL
        EPCFvajf65uFZvTtcTDLMuS+CVUC6nY=
Content-Language: en-US
In-Reply-To: <Y9khYwunmC/xdXT9-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org

On 31.01.23 15:10, Jason Gunthorpe wrote:
> On Tue, Jan 31, 2023 at 03:06:10PM +0100, David Hildenbrand wrote:
>> On 31.01.23 15:03, Jason Gunthorpe wrote:
>>> On Tue, Jan 31, 2023 at 02:57:20PM +0100, David Hildenbrand wrote:
>>>
>>>>> I'm excited by this series, thanks for making it.
>>>>>
>>>>> The pin accounting has been a long standing problem and cgroups will
>>>>> really help!
>>>>
>>>> Indeed. I'm curious how GUP-fast, pinning the same page multiple times, and
>>>> pinning subpages of larger folios are handled :)
>>>
>>> The same as today. The pinning is done based on the result from GUP,
>>> and we charge every returned struct page.
>>>
>>> So duplicates are counted multiple times, folios are ignored.
>>>
>>> Removing duplicate charges would be costly, it would require storage
>>> to keep track of how many times individual pages have been charged to
>>> each cgroup (eg an xarray indexed by PFN of integers in each cgroup).
>>>
>>> It doesn't seem worth the cost, IMHO.
>>>
>>> We've made alot of investment now with iommufd to remove the most
>>> annoying sources of duplicated pins so it is much less of a problem in
>>> the qemu context at least.
>>
>> Wasn't there the discussion regarding using vfio+io_uring+rdma+$whatever on
>> a VM and requiring multiple times the VM size as memlock limit?
> 
> Yes, but iommufd gives us some more options to mitigate this.
> 
> eg it makes some of logical sense to point RDMA at the iommufd page
> table that is already pinned when trying to DMA from guest memory, in
> this case it could ride on the existing pin.

Right, I suspect some issue is that the address space layout for the 
RDMA device might be completely different. But I'm no expert on IOMMUs 
at all :)

I do understand that at least multiple VFIO containers could benefit by 
only pinning once (IIUC that mgiht have been an issue?).

> 
>> Would it be the same now, just that we need multiple times the pin
>> limit?
> 
> Yes

Okay, thanks.


It's all still a big improvement, because I also asked for TDX 
restrictedmem to be accounted somehow as unmovable.

-- 
Thanks,

David / dhildenb

