From: Nikolay Borisov <n.borisov-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
Subject: Re: Access rules for current->memcg
Date: Fri, 17 Jul 2015 10:16:25 +0300
Message-ID: <55A8ABC9.7090701@siteground.com>
References: <55A7B2D0.1030506@siteground.com> <20150716145902.GA10758@dhcp22.suse.cz> <55A7C9B4.3010907@siteground.com> <20150716152239.GA22529@dhcp22.suse.cz> <CAJFSNy6sLX82+3ZW_COr__pDTd9aSGgL1bjryMKKcVPhEN0F9g@mail.gmail.com> <20150717071339.GA24787@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150717071339.GA24787-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 07/17/2015 10:13 AM, Michal Hocko wrote:
> On Fri 17-07-15 00:21:51, Nikolay Borisov wrote:
>> On Thu, Jul 16, 2015 at 6:22 PM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>> On Thu 16-07-15 18:11:48, Nikolay Borisov wrote:
>>>>
>>>>
>>>> On 07/16/2015 05:59 PM, Michal Hocko wrote:
>>>>> On Thu 16-07-15 16:34:08, Nikolay Borisov wrote:
>>>>>> Hello,
>>>>>>
>>>>>> I'd like to ask what are the locking rules when using
>>>>>> mem_cgroup_from_task(current)? Currently I'm doing this under
>>>>>> rcu_read_lock which I believe is sufficient. However, I've seen patches
>>>>>> where reference is obtained via mem_cgroup_from_task and then
>>>>>> css_tryget_online is used on the resulting cgroup?
>>>>>
>>>>> RCU will guarantee that the memcg will not go away. The rest depends on
>>>>> what you want to do with it. If you want to use it outside of RCU you
>>>>> have to take a reference. And then it depends what the memcg is used
>>>>> for - some operations can be done also on the offline memcg.
>>>>>
>>>>> Btw. mem_cgroup_from_task is not the proper interface for you. You
>>>>> really want to do
>>>>> memcg = get_mem_cgroup_from_mm(current->mm)
>>>>> [...]
>>>>> css_put(&memcg)
>>>>
>>>> Unfortunately this function is static, do you think there might be any
>>>> value of a patch that exposes it upstream?
>>>
>>> Ohh, you are right! I thought I made it visible with my recent changes
>>> but nope. There are no external users currently.
>>>
>>> Could you tell us more why it would be useful for you?
>>
>> In my particular use case I have to query the memcg's various counters to expose
>> them to the user in a different way than via the cgroup files
>> (memory.limit_in_bytes etc).
> 
> Why is the regular interface not sufficient?

In my particular case I'm interested in playing with the contents of
/proc/meminfo, so that processes running inside a cgroup only see the
the system as defined by the memcg restrictions
