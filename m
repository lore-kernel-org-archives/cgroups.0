From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] rename MEM_CGROUP_STAT_SWAPOUT as MEM_CGROUP_STAT_NR_SWAP
Date: Mon, 04 Jun 2012 09:24:00 +0900
Message-ID: <4FCC0020.5080801@jp.fujitsu.com>
References: <4FC89BC4.9030604@jp.fujitsu.com> <20120601165320.GA1761@cmpxchg.org> <alpine.LSU.2.00.1206011047430.9814@eggly.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LSU.2.00.1206011047430.9814-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

(2012/06/02 2:54), Hugh Dickins wrote:
> On Fri, 1 Jun 2012, Johannes Weiner wrote:
>> On Fri, Jun 01, 2012 at 07:39:00PM +0900, Kamezawa Hiroyuki wrote:
>>> MEM_CGROUP_STAT_SWAPOUT represents the usage of swap rather than
>>> the number of swap-out events. Rename it to be MEM_CGROUP_STAT_NR_SWAP.
>>>
>>> Signed-off-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>>
>> Wouldn't MEM_CGROUP_STAT_SWAP be better?  It's equally descriptive but
>> matches the string.  And we also don't have NR_ for cache, rss, mapped
>> file etc.
>
> That's just what I thought too.
>
> You can attach Acked-by: Hugh Dickins<hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> to MEM_CGROUP_STAT_SWAP and MEM_CGROUP_CHARGE_TYPE_ANON.
>
> Oh, and to a patch deleting MEM_CGROUP_CHARGE_TYPE_FORCE!
>
Sure, I'll prepare v2.

Thanks,
-Kame

