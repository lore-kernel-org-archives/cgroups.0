From: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 1/4] memcg: Track exported dma-buffers
Date: Wed, 25 Jan 2023 17:30:43 +0000
Message-ID: <347560bc-d06a-92b7-8003-133d2b8af2df@linux.intel.com>
References: <20230123191728.2928839-1-tjmercier@google.com>
 <20230123191728.2928839-2-tjmercier@google.com>
 <Y8/ybgp2FW+e3bjc@dhcp22.suse.cz>
 <20230124194628.d44rtcfsv23fndxw@google.com>
 <Y9EX+usSpAjZ/8LS@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674667873; x=1706203873;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=b/qAzqJTvFy4xiZPmOAm7JkVbr9jZZbEQu9s5cua2Is=;
  b=AWcklGPuXD/+9cf1Hhwl+Js//5W4kdegH/s0Gsfid2lOqlLRlb+x3I2W
   +pbkW5XILBBx4R1+PNuSE8oRW4FgaWulShnBLOkKWlS+uhbh0zDiFg18b
   B0HjcV5HkJ4l49rkjRSObzCRk/cdHpbAxDpFpDh9wOMFKiS95tbPYl1Kq
   Ot2LLUNYqUoPmFYD48gejB0bRZ7kz1QxWT4du2BC+j37+/OrVu5C1QCzU
   vGmNQIWiZblHr58LJMtiiQZtjmG4bpn6uWsBsR9DRE/KcVtOiJMs/A0FN
   nj/2SCV6VpRy4QFDaAIqFZ5mJzJilrDWScKgr3pC/WGhkgPoafYyLKp3x
   w==;
Content-Language: en-US
In-Reply-To: <Y9EX+usSpAjZ/8LS-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel.vetter-/w4YWyX8dFk@public.gmane.org, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cmllamas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, jstultz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, android-mm-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, jeffv-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, selinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linaro-mm-sig-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>


Hi,

On 25/01/2023 11:52, Michal Hocko wrote:
> On Tue 24-01-23 19:46:28, Shakeel Butt wrote:
>> On Tue, Jan 24, 2023 at 03:59:58PM +0100, Michal Hocko wrote:
>>> On Mon 23-01-23 19:17:23, T.J. Mercier wrote:
>>>> When a buffer is exported to userspace, use memcg to attribute the
>>>> buffer to the allocating cgroup until all buffer references are
>>>> released.
>>>
>>> Is there any reason why this memory cannot be charged during the
>>> allocation (__GFP_ACCOUNT used)?
>>> Also you do charge and account the memory but underlying pages do not
>>> know about their memcg (this is normally done with commit_charge for
>>> user mapped pages). This would become a problem if the memory is
>>> migrated for example.
>>
>> I don't think this is movable memory.
>>
>>> This also means that you have to maintain memcg
>>> reference outside of the memcg proper which is not really nice either.
>>> This mimicks tcp kmem limit implementation which I really have to say I
>>> am not a great fan of and this pattern shouldn't be coppied.
>>>
>>
>> I think we should keep the discussion on technical merits instead of
>> personal perference. To me using skmem like interface is totally fine
>> but the pros/cons need to be very explicit and the clear reasons to
>> select that option should be included.
> 
> I do agree with that. I didn't want sound to be personal wrt tcp kmem
> accounting but the overall code maintenance cost is higher because
> of how tcp take on accounting differs from anything else in the memcg
> proper. I would prefer to not grow another example like that.
> 
>> To me there are two options:
>>
>> 1. Using skmem like interface as this patch series:
>>
>> The main pros of this option is that it is very simple. Let me list down
>> the cons of this approach:
>>
>> a. There is time window between the actual memory allocation/free and
>> the charge and uncharge and [un]charge happen when the whole memory is
>> allocated or freed. I think for the charge path that might not be a big
>> issue but on the uncharge, this can cause issues. The application and
>> the potential shrinkers have freed some of this dmabuf memory but until
>> the whole dmabuf is freed, the memcg uncharge will not happen. This can
>> consequences on reclaim and oom behavior of the application.
>>
>> b. Due to the usage model i.e. a central daemon allocating the dmabuf
>> memory upfront, there is a requirement to have a memcg charge transfer
>> functionality to transfer the charge from the central daemon to the
>> client applications. This does introduce complexity and avenues of weird
>> reclaim and oom behavior.
>>
>>
>> 2. Allocate and charge the memory on page fault by actual user
>>
>> In this approach, the memory is not allocated upfront by the central
>> daemon but rather on the page fault by the client application and the
>> memcg charge happen at the same time.
>>
>> The only cons I can think of is this approach is more involved and may
>> need some clever tricks to track the page on the free patch i.e. we to
>> decrement the dmabuf memcg stat on free path. Maybe a page flag.
>>
>> The pros of this approach is there is no need have a charge transfer
>> functionality and the charge/uncharge being closely tied to the actual
>> memory allocation and free.
>>
>> Personally I would prefer the second approach but I don't want to just
>> block this work if the dmabuf folks are ok with the cons mentioned of
>> the first approach.
> 
> I am not familiar with dmabuf internals to judge complexity on their end
> but I fully agree that charge-when-used is much more easier to reason
> about and it should have less subtle surprises.

Disclaimer that I don't seem to see patches 3&4 on dri-devel so maybe I 
am missing something, but in principle yes, I agree that the 2nd option 
(charge the user, not exporter) should be preferred. Thing being that at 
export time there may not be any backing store allocated, plus if the 
series is restricting the charge transfer to just Android clients then 
it seems it has the potential to miss many other use cases. At least 
needs to outline a description on how the feature will be useful outside 
Android.

Also stepping back for a moment - is a new memory category really 
needed, versus perhaps attempting to charge the actual backing store 
memory to the correct client? (There might have been many past 
discussions on this so it's okay to point me towards something in the 
archives.)

Regards,

Tvrtko
