From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH 09/23] kmem slab accounting basic infrastructure
Date: Thu, 26 Apr 2012 09:08:39 +0900
Message-ID: <4F989207.5080208@jp.fujitsu.com>
References: <1334959051-18203-1-git-send-email-glommer@parallels.com> <1334959051-18203-10-git-send-email-glommer@parallels.com> <4F975430.4090107@jp.fujitsu.com> <4F980C81.5060802@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F980C81.5060802-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

(2012/04/25 23:38), Glauber Costa wrote:

> On 04/24/2012 10:32 PM, KAMEZAWA Hiroyuki wrote:
>> (2012/04/21 6:57), Glauber Costa wrote:
>>
>>> This patch adds the basic infrastructure for the accounting of the slab
>>> caches. To control that, the following files are created:
>>>
>>>   * memory.kmem.usage_in_bytes
>>>   * memory.kmem.limit_in_bytes
>>>   * memory.kmem.failcnt
>>>   * memory.kmem.max_usage_in_bytes
>>>
>>> They have the same meaning of their user memory counterparts. They reflect
>>> the state of the "kmem" res_counter.
>>>
>>> The code is not enabled until a limit is set. This can be tested by the flag
>>> "kmem_accounted". This means that after the patch is applied, no behavioral
>>> changes exists for whoever is still using memcg to control their memory usage.
>>>
>>
>> Hmm, res_counter never goes naeative ?
> 
> Why would it?
> 
> This one has more or less the same logic as the sock buffers.
> 
> If we are not accounted, the caches don't get created. If the caches
> don't get created, we don't release them. (this is modulo bugs, of course)

Okay. Please note how the logic works in description or Doc. 
It's a bit complicated part.

Thanks,
-Kame

