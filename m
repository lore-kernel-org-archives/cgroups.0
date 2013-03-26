From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
Date: Tue, 26 Mar 2013 13:02:08 +0400
Message-ID: <51516410.2000007@parallels.com>
References: <20130321090849.GF6094@dhcp22.suse.cz> <20130321102257.GH6094@dhcp22.suse.cz> <514BB23E.70908@huawei.com> <20130322080749.GB31457@dhcp22.suse.cz> <514C1388.6090909@huawei.com> <514C14BF.3050009@parallels.com> <20130322093141.GE31457@dhcp22.suse.cz> <514EAC41.5050700@huawei.com> <20130325090629.GN2154@dhcp22.suse.cz> <51515DEE.70105@parallels.com> <20130326084348.GJ2295@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130326084348.GJ2295-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On 03/26/2013 12:43 PM, Michal Hocko wrote:
> On Tue 26-03-13 12:35:58, Glauber Costa wrote:
>>>>
>>>> I doubt it's a win to add 4K to kernel text size instead of adding
>>>> a few extra lines of code... but it's up to you.
>>>
>>> I will leave the decision to Glauber. The updated version which uses
>>> kmalloc for the static buffer is bellow.
>>>
>> I prefer to allocate dynamically here. But although I understand why we
>> need to call cgroup_name, I don't understand what is wrong with
>> kasprintf if we're going to allocate anyway. It will allocate a string
>> just big enough. A PAGE_SIZE'd allocation is a lot more likely to fail.
>>
>> Now, if we really want to be smart here, we can do something like what
>> I've done for the slub attribute buffers, that can actually have very
>> long values.
>>
>> allocate a small buffer that will hold 80 % > of the allocations (256
>> bytes should be enough for most cache names), and if the string is
>> bigger than this, we allocate. Once we allocate, we save it in a static
>> pointer and leave it there. The hope here is that we may be able to
>> live without ever allocating in many systems.
>>
>>> +
>>> +	/*
>>> +	 * kmem_cache_create_memcg duplicates the given name and
>>> +	 * cgroup_name for this name requires RCU context.
>>> +	 * This static temporary buffer is used to prevent from
>>> +	 * pointless shortliving allocation.
>>> +	 */
>> The comment is also no longer true if you don't resort to a static buffer.
> 
> The buffer _is_ static (read global variable hidden with the function
> scope).
> 

Although correct, it is a bit misleading. It is static in the sense it
is held by a static variable. But it is acquired by kmalloc...

In any way, this is a tiny detail.

FWIW, I am fine with the patch you provided:

Acked-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

We  could go seeing how big those allocations are in practice, but I
doubt it is worth the trouble.
