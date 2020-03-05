From: Vincenzo Frascino <vincenzo.frascino-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] mm: Make mem_cgroup_id_get_many dependent on MMU and
 MEMCG_SWAP
Date: Thu, 5 Mar 2020 09:49:23 +0000
Message-ID: <8c489836-b824-184e-7cfe-25e55ab73000@arm.com>
References: <20200304142348.48167-1-vincenzo.frascino@arm.com>
 <20200304165336.GO16139@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200304165336.GO16139-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hi Michal,

On 3/4/20 4:53 PM, Michal Hocko wrote:
> On Wed 04-03-20 14:23:48, Vincenzo Frascino wrote:
>> mem_cgroup_id_get_many() is currently used only when MMU or MEMCG_SWAP
>> configuration options are enabled. Having them disabled triggers the
>> following warning at compile time:
>>
>> linux/mm/memcontrol.c:4797:13: warning: ‘mem_cgroup_id_get_many’ defined
>> but not used [-Wunused-function]
>>  static void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned
>>  int n)
>>
>> Make mem_cgroup_id_get_many() dependent on MMU and MEMCG_SWAP to address
>> the issue.
> 
> A similar patch has been proposed recently
> http://lkml.kernel.org/r/87fthjh2ib.wl-kuninori.morimoto.gx-zM6kxYcvzFDowKkBSvOlow@public.gmane.org
> The conclusion was that the warning is not really worth adding code.
> 

Thank you for pointing this out, I was not aware of it. I understand that you
are against "#ifdeffery" in this case, but isn't it the case of adding at least
__maybe_unused? This would prevent people from reporting it over and over again
and you to have to push them back :) Let me know what do you think, in case I am
happy to change my patch accordingly.

[...]

-- 
Regards,
Vincenzo
