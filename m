From: Aneesh Kumar K V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Subject: Re: [PATCH] mm/vmscan: respect cpuset policy during page demotion
Date: Wed, 26 Oct 2022 17:38:06 +0530
Message-ID: <44e485d4-acf5-865d-17fe-13be1c1b430b@linux.ibm.com>
References: <20221026074343.6517-1-feng.tang@intel.com>
 <dc453287-015d-fd1c-fe7f-6ee45772d6aa@linux.ibm.com>
 <Y1jpDfwBQId3GkJC@feng-clx> <Y1j7tsj5M0Md/+Er@dhcp22.suse.cz>
 <d17698d2-c1b5-9aa3-6271-838830d36cc5@linux.ibm.com>
 <Y1kTz1qjfsY1UBPf@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=0rJQ/6J/iAuAghzMH2H1VY1tj1eMIaXDuK47l5fCiHI=;
 b=WPItwFK951AcqgUHkXPYrro1TsotRWSRuvlT5KouMPXRYv6dYn2vaPVoUZ+ODpEA3WsW
 GHMmoS1RtS6JuM7MTFvzZ0ObPy8L/o3MmFRHSBoFXH1h0R94Cpy0YhlxaAnguHyK6CM7
 OXqH8PiHthhVvnYq0eaYrJQFVeNUMzINQbq305/B3nu22qle9v+buajQr/CayAyKqlyP
 oI0vIdi/u1XFovQUB5b168anO0IxY1BPfervjbp7CNE2JpVR/FJ5R9mJhyiz0yOdcenP
 ZZuveNQLA4LAh+j7YEuMNjFMkqdvgAv2OYNqclnjMm/v1njDIP/dN/I5aBHhPAAezG8X kQ== 
Content-Language: en-US
In-Reply-To: <Y1kTz1qjfsY1UBPf-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hansen, Dave" <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Yin, Fengwei" <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On 10/26/22 4:32 PM, Michal Hocko wrote:
> On Wed 26-10-22 16:12:25, Aneesh Kumar K V wrote:
>> On 10/26/22 2:49 PM, Michal Hocko wrote:
>>> On Wed 26-10-22 16:00:13, Feng Tang wrote:
>>>> On Wed, Oct 26, 2022 at 03:49:48PM +0800, Aneesh Kumar K V wrote:
>>>>> On 10/26/22 1:13 PM, Feng Tang wrote:
>>>>>> In page reclaim path, memory could be demoted from faster memory tier
>>>>>> to slower memory tier. Currently, there is no check about cpuset's
>>>>>> memory policy, that even if the target demotion node is not allowd
>>>>>> by cpuset, the demotion will still happen, which breaks the cpuset
>>>>>> semantics.
>>>>>>
>>>>>> So add cpuset policy check in the demotion path and skip demotion
>>>>>> if the demotion targets are not allowed by cpuset.
>>>>>>
>>>>>
>>>>> What about the vma policy or the task memory policy? Shouldn't we respect
>>>>> those memory policy restrictions while demoting the page? 
>>>>  
>>>> Good question! We have some basic patches to consider memory policy
>>>> in demotion path too, which are still under test, and will be posted
>>>> soon. And the basic idea is similar to this patch.
>>>
>>> For that you need to consult each vma and it's owning task(s) and that
>>> to me sounds like something to be done in folio_check_references.
>>> Relying on memcg to get a cpuset cgroup is really ugly and not really
>>> 100% correct. Memory controller might be disabled and then you do not
>>> have your association anymore.
>>>
>>
>> I was looking at this recently and I am wondering whether we should worry about VM_SHARE
>> vmas. 
>>
>> ie, page_to_policy() can just reverse lookup just one VMA and fetch the policy right?
> 
> How would that help for private mappings shared between parent/child?


this is MAP_PRIVATE | MAP_SHARED? and won't they get converted to shared policy for the backing shmfs? via

	} else if (vm_flags & VM_SHARED) {
		error = shmem_zero_setup(vma);
		if (error)
			goto free_vma;
	} else {
		vma_set_anonymous(vma);
	}



> Also reducing this to a single VMA is not really necessary as
> folio_check_references already does most of that work. What is really
> missing is to check for other memory policies (i.e. cpusets and per-task
> mempolicy). The later is what can get quite expensive.
> 


I agree that walking all the related vma is already done in folio_check_references. I was
checking do we really need to check all the vma in case of memory policy.


>> if it VM_SHARE it will be a shared policy we can find using vma->vm_file? 
>>
>> For non anonymous and anon vma not having any policy set  it is owning task vma->vm_mm->owner task policy ? 
> 
> Please note that mm can be shared even outside of the traditional thread
> group so you would need to go into something like mm_update_next_owner
> 
>> We don't worry about multiple tasks that can be possibly sharing that page right? 
> 
> Why not?
> 

On the page fault side for non anonymous vma we only respect the memory policy of the
task faulting the page in. With that restrictions we could always say if demotion
node is allowed by the policy of any task sharing this vma, we can demote the
page to that specific node? 

>>> This all can get quite expensive so the primary question is, does the
>>> existing behavior generates any real issues or is this more of an
>>> correctness exercise? I mean it certainly is not great to demote to an
>>> incompatible numa node but are there any reasonable configurations when
>>> the demotion target node is explicitly excluded from memory
>>> policy/cpuset?
>>
>> I guess vma policy is important. Applications want to make sure that they don't
>> have variable performance and they go to lengths to avoid that by using MEM_BIND.
>> So if they access the memory they always know access is satisfied from a specific
>> set of NUMA nodes. Swapin can cause performance impact but then all continued
>> access will be from a specific NUMA nodes. With slow memory demotion that is
>> not going to be the case. Large in-memory database applications are observed to
>> be sensitive to these access latencies. 
> 
> Yes, I do understand that from the correctness POV this is a problem. My
> question is whether this is a _practical_ problem worth really being
> fixed as it is not really a cheap fix. If there are strong node locality
> assumptions by the userspace then I would expect demotion to be disabled
> in the first place.

Agreed. Right now these applications when they fail to allocate memory from
the Node on which they are running, they fallback to nearby NUMA nodes rather than
failing the database query. They would want to prevent fallback of some allocation
to slow cxl memory to avoid hot database tables getting allocated from the cxl
memory node. In that case one way they can consume slow cxl memory is to partition
the data structure using membind and allow cold pages to demoted back to
slow cxl memory making space for hot page allocation in the running NUMA node. 

Other option is to run the application using fsdax.

I am still not clear which option will get used finally. 


-aneesh


 

