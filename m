From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
Date: Fri, 22 Mar 2013 14:25:23 +0400
Message-ID: <514C3193.9010609@parallels.com>
References: <20130321090849.GF6094@dhcp22.suse.cz> <20130321102257.GH6094@dhcp22.suse.cz> <514BB23E.70908@huawei.com> <20130322080749.GB31457@dhcp22.suse.cz> <514C1388.6090909@huawei.com> <514C14BF.3050009@parallels.com> <20130322093141.GE31457@dhcp22.suse.cz> <514C2754.4080701@parallels.com> <20130322094832.GG31457@dhcp22.suse.cz> <514C2C72.5090402@parallels.com> <20130322100609.GI31457@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130322100609.GI31457-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On 03/22/2013 02:06 PM, Michal Hocko wrote:
> On Fri 22-03-13 14:03:30, Glauber Costa wrote:
>> On 03/22/2013 01:48 PM, Michal Hocko wrote:
>>> On Fri 22-03-13 13:41:40, Glauber Costa wrote:
>>>> On 03/22/2013 01:31 PM, Michal Hocko wrote:
>>>>> On Fri 22-03-13 12:22:23, Glauber Costa wrote:
>>>>>> On 03/22/2013 12:17 PM, Li Zefan wrote:
>>>>>>>> GFP_TEMPORARY groups short lived allocations but the mem cache is not
>>>>>>>>> an ideal candidate of this type of allocations..
>>>>>>>>>
>>>>>>> I'm not sure I'm following you...
>>>>>>>
>>>>>>> char *memcg_cache_name()
>>>>>>> {
>>>>>>> 	char *name = alloc();
>>>>>>> 	return name;
>>>>>>> }
>>>>>>>
>>>>>>> kmem_cache_dup()
>>>>>>> {
>>>>>>> 	name = memcg_cache_name();
>>>>>>> 	kmem_cache_create_memcg(name);
>>>>>>> 	free(name);
>>>>>>> }
>>>>>>>
>>>>>>> Isn't this a short lived allocation?
>>>>>>>
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> Thanks for identifying and fixing this.
>>>>>>
>>>>>> Li is right. The cache name will live long, but this is because the
>>>>>> slab/slub caches will strdup it internally. So the actual memcg
>>>>>> allocation is short lived.
>>>>>
>>>>> OK, I have totally missed that. Sorry about the confusion. Then all the
>>>>> churn around the allocation is pointless, no?
>>>>> What about:
>>>>
>>>> If we're really not concerned about stack, then yes. Even if always
>>>> running from workqueues, a PAGE_SIZEd stack variable seems risky to me.
>>>
>>> This is not on stack. It is static
>>>
>> Ah, right, I totally missed that. And then you're taking the mutex.
>>
>> But actually, you don't need to take the mutex. All calls to
>> kmem_cache_dup are protected by the memcg_cache_mutex.
> 
> Yes and I am not taking that mutex. I've just added lockdep assert to
> make sure that this still holds true.
> 
It is impressive what a busy week does to our brains...

I read the code as lockdep_assert(memcg_cache_mutex), and then later on
mutex_lock(&memcg_mutex). But reading again, that was a just an
rcu_read_lock(). Good thing it is Friday

You guys can add my Acked-by, and thanks again
