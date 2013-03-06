From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2 2/5] memcg: provide root figures from system totals
Date: Wed, 6 Mar 2013 14:52:31 +0400
Message-ID: <51371FEF.3020507@parallels.com>
References: <1362489058-3455-1-git-send-email-glommer@parallels.com> <1362489058-3455-3-git-send-email-glommer@parallels.com> <51368D80.20701@jp.fujitsu.com> <5136FEC2.2050004@parallels.com> <51371E4A.7090807@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51371E4A.7090807-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>

On 03/06/2013 02:45 PM, Kamezawa Hiroyuki wrote:
> (2013/03/06 17:30), Glauber Costa wrote:
>> On 03/06/2013 04:27 AM, Kamezawa Hiroyuki wrote:
>>> (2013/03/05 22:10), Glauber Costa wrote:
>>>> +	case _MEMSWAP: {
>>>> +		struct sysinfo i;
>>>> +		si_swapinfo(&i);
>>>> +
>>>> +		return ((memcg_read_root_rss() +
>>>> +		atomic_long_read(&vm_stat[NR_FILE_PAGES])) << PAGE_SHIFT) +
>>>> +		i.totalswap - i.freeswap;
>>>
>>> How swapcache is handled ? ...and How kmem works with this calc ?
>>>
>> I am ignoring kmem, because we don't account kmem for the root cgroup
>> anyway.
>>
>> Setting the limit is invalid, and we don't account until the limit is
>> set. Then it will be 0, always.
>>
>> For swapcache, I am hoping that totalswap - freeswap will cover
>> everything swap related. If you think I am wrong, please enlighten me.
>>
> 
> i.totalswap - i.freeswap = # of used swap entries.
> 
> SwapCache can be rss and used swap entry at the same time. 
> 

Well, yes, but the rss entries would be accounted for in get_mm_rss(),
won't they ?

What am I missing ?
