From: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Subject: Re: [RFC][PATCH] oom: Be less verbose if the oom_control event fd
 has listeners
Date: Thu, 05 Jun 2014 23:58:49 +0200
Message-ID: <5390E819.2070709@nod.at>
References: <1401976841-3899-1-git-send-email-richard@nod.at> <1401976841-3899-2-git-send-email-richard@nod.at> <20140605150025.GB15939@dhcp22.suse.cz> <5390930A.8050504@nod.at> <20140605161807.GD15939@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140605161807.GD15939-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Am 05.06.2014 18:18, schrieb Michal Hocko:
> On Thu 05-06-14 17:55:54, Richard Weinberger wrote:
>> Am 05.06.2014 17:00, schrieb Michal Hocko:
>>> On Thu 05-06-14 16:00:41, Richard Weinberger wrote:
>>>> Don't spam the kernel logs if the oom_control event fd has listeners.
>>>> In this case there is no need to print that much lines as user space
>>>> will anyway notice that the memory cgroup has reached its limit.
>>>
>>> But how do you debug why it is reaching the limit and why a particular
>>> process has been killed?
>>
>> In my case it's always because customer's Java application gone nuts.
>> So I don't really have to debug a lot. ;-)
>> But I can understand your point.
> 
> If you know that handling memcg-OOM condition is easy then maybe you can
> not only listen for the OOM notifications but also handle OOM conditions
> and kill the offender. This would mean that kernel doesn't try to kill
> anything and so wouldn't dump anything to the log.

Basically I don't care what customers run in their containers.
But almost every OOM is because their Java apps consume too much memory.
Mostly because they don't know exactly how much memory they need or
because of completely broken JVM heap settings.

All my OOM listener does is sending a mail a la "Your container ran out of memory, go figure...".

>>> If we are printing too much then OK, let's remove those parts which are
>>> not that useful but hiding information which tells us more about the oom
>>> decision doesn't sound right to me.
>>
>> What about adding a sysctl like "vm.oom_verbose"?
>> By default it would be 1.
>> If set to 0 the full OOM information is only printed out if nobody listens
>> to the event fd.
> 
> If we have a knob then I guess it should be global and shared by memcg
> as well. I can imagine that somebody might be interested only in the
> tasks dump, while somebody would like to see LRU states and other memory
> counters. So it would be ideally a bitmask of things to output. I do not
> think that a memcg specific solution is good, though.

I'm not sure if such a fine grained setting is really useful.

Thanks,
//richard
