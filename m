From: Aneesh Kumar K V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Subject: Re: [PATCH] mm/vmscan: respect cpuset policy during page demotion
Date: Wed, 26 Oct 2022 18:05:46 +0530
Message-ID: <22590f74-ec91-e673-32df-8a04b4ab3931@linux.ibm.com>
References: <20221026074343.6517-1-feng.tang@intel.com>
 <dc453287-015d-fd1c-fe7f-6ee45772d6aa@linux.ibm.com>
 <Y1jpDfwBQId3GkJC@feng-clx> <Y1j7tsj5M0Md/+Er@dhcp22.suse.cz>
 <d17698d2-c1b5-9aa3-6271-838830d36cc5@linux.ibm.com>
 <Y1kTz1qjfsY1UBPf@dhcp22.suse.cz>
 <44e485d4-acf5-865d-17fe-13be1c1b430b@linux.ibm.com>
 <Y1kmOaXvzwRv/tza@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=LoNYjlvw7n7AAaxNgSQnxhM7o1qFq0VL7RM3za1O2Yo=;
 b=hm+19J7JgVA0+Lihb+CZfSSiRdzSrxBX9XCM/+hbFMxA7MMCdht3dhn4KzJE3wIGDO+n
 HEbdsQTOfUePta5ZFDtwOpoEJ2+e9jQtxp9fvtklFLU9hR93NfZBB8vuc8KvtDnhoAhO
 XJagtI0c93lj6KerCHSXf4hVrefPyZ17BhisD0WHLEOST//rMRdTQGTGeRzMB/Yi0v9O
 YabPvIU5SblaT+dTvY3/UGq4J/MNSMXB30AeGqoEerg97zYujoKYmfo0iy0YKw1H9TKX
 Yd0zSEDvhs3N6NnZ4ZJRhyF5cTHmSjvxgD82aRG8FP9obnmE08/suvzz8qwPjzF2v9uf UQ== 
Content-Language: en-US
In-Reply-To: <Y1kmOaXvzwRv/tza-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hansen, Dave" <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Yin, Fengwei" <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On 10/26/22 5:51 PM, Michal Hocko wrote:
> On Wed 26-10-22 17:38:06, Aneesh Kumar K V wrote:
>> On 10/26/22 4:32 PM, Michal Hocko wrote:
>>> On Wed 26-10-22 16:12:25, Aneesh Kumar K V wrote:
>>>> On 10/26/22 2:49 PM, Michal Hocko wrote:
>>>>> On Wed 26-10-22 16:00:13, Feng Tang wrote:
>>>>>> On Wed, Oct 26, 2022 at 03:49:48PM +0800, Aneesh Kumar K V wrote:
>>>>>>> On 10/26/22 1:13 PM, Feng Tang wrote:
>>>>>>>> In page reclaim path, memory could be demoted from faster memory tier
>>>>>>>> to slower memory tier. Currently, there is no check about cpuset's
>>>>>>>> memory policy, that even if the target demotion node is not allowd
>>>>>>>> by cpuset, the demotion will still happen, which breaks the cpuset
>>>>>>>> semantics.
>>>>>>>>
>>>>>>>> So add cpuset policy check in the demotion path and skip demotion
>>>>>>>> if the demotion targets are not allowed by cpuset.
>>>>>>>>
>>>>>>>
>>>>>>> What about the vma policy or the task memory policy? Shouldn't we respect
>>>>>>> those memory policy restrictions while demoting the page? 
>>>>>>  
>>>>>> Good question! We have some basic patches to consider memory policy
>>>>>> in demotion path too, which are still under test, and will be posted
>>>>>> soon. And the basic idea is similar to this patch.
>>>>>
>>>>> For that you need to consult each vma and it's owning task(s) and that
>>>>> to me sounds like something to be done in folio_check_references.
>>>>> Relying on memcg to get a cpuset cgroup is really ugly and not really
>>>>> 100% correct. Memory controller might be disabled and then you do not
>>>>> have your association anymore.
>>>>>
>>>>
>>>> I was looking at this recently and I am wondering whether we should worry about VM_SHARE
>>>> vmas. 
>>>>
>>>> ie, page_to_policy() can just reverse lookup just one VMA and fetch the policy right?
>>>
>>> How would that help for private mappings shared between parent/child?
>>
>>
>> this is MAP_PRIVATE | MAP_SHARED?
> 

Sorry, I meant MAP_ANONYMOUS | MAP_SHARED. 

> This is not a valid combination IIRC. What I meant is a simple
> MAP_PRIVATE|MAP_ANON that is CoW shared between parent and child.
> 
> [...]


-aneesh
