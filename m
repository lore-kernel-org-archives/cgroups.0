From: Aneesh Kumar K V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Subject: Re: [PATCH] mm/vmscan: respect cpuset policy during page demotion
Date: Fri, 28 Oct 2022 10:39:31 +0530
Message-ID: <7b5f533d-4b2e-b45b-ee42-5e1cc3e8a279@linux.ibm.com>
References: <20221026074343.6517-1-feng.tang@intel.com>
 <dc453287-015d-fd1c-fe7f-6ee45772d6aa@linux.ibm.com>
 <Y1jpDfwBQId3GkJC@feng-clx> <Y1j7tsj5M0Md/+Er@dhcp22.suse.cz>
 <Y1kl8VbPE0RYdyEB@feng-clx> <Y1lZV6qHp3gIINGc@dhcp22.suse.cz>
 <CAHbLzkppDPm87dx9-a7t3oP9DuZ0xCPC1UWr+E-s+vh12Gwb+w@mail.gmail.com>
 <Y1ovOeEPXT1fxCuc@feng-clx>
 <CAHbLzkqvh3ry=FjQGuG--As2yYF2NU+bfvORqk1FyfE_vvTwXw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mC2HFC3gAoqIozZrCZ1GBd6I46486FF/GbrfZbHoDJs=;
 b=sORyH0u7NNmXJ2xhjH2ho9CGfQC2uXTTsV6CCo/wUNjh93gWjsOOergxQFNQ0dGJ+brs
 Sk6ThQx3eCPe0YtR0s/fvl2YLEW4Pb095jSEbrVjXEG5wJ0NVIwkCI7GCLEz/QetJtYF
 q9Yn6cvxHNMTsFgojdXw7jBRBgY89a3aXoRMsdeAoQFrmP0FyI+/ndrpcT/6Fg8k6+Az
 FNLGrmbdQSSW+qhAmSWP9E2Foqa5+MAz3T4g2qPzCD5t+9iL0sZBmVZugSwsMOrwL/NZ
 tvbr6nv4A2EAS7p1Nq8EIvRDMOF4TR+Fmq40JGckJnJGoGaMGYdweYMIM6DRk0pJrF8O vQ== 
Content-Language: en-US
In-Reply-To: <CAHbLzkqvh3ry=FjQGuG--As2yYF2NU+bfvORqk1FyfE_vvTwXw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Hocko, Michal" <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hansen, Dave" <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Yin, Fengwei" <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On 10/27/22 11:25 PM, Yang Shi wrote:
> On Thu, Oct 27, 2022 at 12:12 AM Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>
>> On Thu, Oct 27, 2022 at 01:57:52AM +0800, Yang Shi wrote:
>>> On Wed, Oct 26, 2022 at 8:59 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>> [...]
>>>>>> This all can get quite expensive so the primary question is, does the
>>>>>> existing behavior generates any real issues or is this more of an
>>>>>> correctness exercise? I mean it certainly is not great to demote to an
>>>>>> incompatible numa node but are there any reasonable configurations when
>>>>>> the demotion target node is explicitly excluded from memory
>>>>>> policy/cpuset?
>>>>>
>>>>> We haven't got customer report on this, but there are quite some customers
>>>>> use cpuset to bind some specific memory nodes to a docker (You've helped
>>>>> us solve a OOM issue in such cases), so I think it's practical to respect
>>>>> the cpuset semantics as much as we can.
>>>>
>>>> Yes, it is definitely better to respect cpusets and all local memory
>>>> policies. There is no dispute there. The thing is whether this is really
>>>> worth it. How often would cpusets (or policies in general) go actively
>>>> against demotion nodes (i.e. exclude those nodes from their allowes node
>>>> mask)?
>>>>
>>>> I can imagine workloads which wouldn't like to get their memory demoted
>>>> for some reason but wouldn't it be more practical to tell that
>>>> explicitly (e.g. via prctl) rather than configuring cpusets/memory
>>>> policies explicitly?
>>>>
>>>>> Your concern about the expensive cost makes sense! Some raw ideas are:
>>>>> * if the shrink_folio_list is called by kswapd, the folios come from
>>>>>   the same per-memcg lruvec, so only one check is enough
>>>>> * if not from kswapd, like called form madvise or DAMON code, we can
>>>>>   save a memcg cache, and if the next folio's memcg is same as the
>>>>>   cache, we reuse its result. And due to the locality, the real
>>>>>   check is rarely performed.
>>>>
>>>> memcg is not the expensive part of the thing. You need to get from page
>>>> -> all vmas::vm_policy -> mm -> task::mempolicy
>>>
>>> Yeah, on the same page with Michal. Figuring out mempolicy from page
>>> seems quite expensive and the correctness can't be guranteed since the
>>> mempolicy could be set per-thread and the mm->task depends on
>>> CONFIG_MEMCG so it doesn't work for !CONFIG_MEMCG.
>>
>> Yes, you are right. Our "working" psudo code for mem policy looks like
>> what Michal mentioned, and it can't work for all cases, but try to
>> enforce it whenever possible:
>>
>> static bool  __check_mpol_demotion(struct folio *folio, struct vm_area_struct *vma,
>>                 unsigned long addr, void *arg)
>> {
>>         bool *skip_demotion = arg;
>>         struct mempolicy *mpol;
>>         int nid, dnid;
>>         bool ret = true;
>>
>>         mpol = __get_vma_policy(vma, addr);
>>         if (!mpol) {
>>                 struct task_struct *task;
>>                 if (vma->vm_mm)
>>                         task = vma->vm_mm->owner;
> 
> But this task may not be the task you want IIUC. For example, the
> process has two threads, A and B. They have different mempolicy. The
> vmscan is trying to demote a page belonging to thread A, but the task
> may point to thread B, so you actually get the wrong mempolicy IIUC.
> 

But if we swap out this page and fault back in via thread B the page would
get allocated as per thread B mempolicy. So if we demote based on thread B
policy are we breaking anything? 

-aneesh


