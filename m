From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
Date: Wed, 27 Mar 2013 19:19:58 +0400
Message-ID: <51530E1E.3010100@parallels.com>
References: <1364373399-17397-1-git-send-email-mhocko@suse.cz> <20130327145727.GD29052@cmpxchg.org> <20130327151104.GK16579@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130327151104.GK16579-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 03/27/2013 07:11 PM, Michal Hocko wrote:
> On Wed 27-03-13 10:58:25, Johannes Weiner wrote:
>> On Wed, Mar 27, 2013 at 09:36:39AM +0100, Michal Hocko wrote:
> [...]
>>> +	/*
>>> +	 * kmem_cache_create_memcg duplicates the given name and
>>> +	 * cgroup_name for this name requires RCU context.
>>> +	 * This static temporary buffer is used to prevent from
>>> +	 * pointless shortliving allocation.
>>> +	 */
>>> +	if (!tmp_name) {
>>> +		tmp_name = kmalloc(PAGE_SIZE, GFP_KERNEL);
>>> +		WARN_ON_ONCE(!tmp_name);
>>
>> Just use the page allocator directly and get a free allocation failure
>> warning. 
> 
> WARN_ON_ONCE is probably pointless.
> 
>> Then again, order-0 pages are considered cheap enough that they never
>> even fail in our current implementation.
>>
>> Which brings me to my other point: why not just a simple single-page
>> allocation?
> 
> No objection from me. I was previously thinking about the "proper"
> size for something that is a file name. So I originally wanted to use
> PATH_MAX instead but ended up with PAGE_SIZE for reasons I do not
> remember now.

theoretically, this is PATH_MAX + max cache name.

