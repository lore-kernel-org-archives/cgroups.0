From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v4 05/25] memcg: Always free struct memcg through schedule_work()
Date: Tue, 19 Jun 2012 09:11:20 +0900
Message-ID: <4FDFC3A8.7010301@jp.fujitsu.com>
References: <1340015298-14133-1-git-send-email-glommer@parallels.com> <1340015298-14133-6-git-send-email-glommer@parallels.com> <4FDF1A0D.6080204@jp.fujitsu.com> <4FDF1AAE.4080209@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FDF1AAE.4080209-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Cristoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

(2012/06/18 21:10), Glauber Costa wrote:
> On 06/18/2012 04:07 PM, Kamezawa Hiroyuki wrote:
>> (2012/06/18 19:27), Glauber Costa wrote:
>>> Right now we free struct memcg with kfree right after a
>>> rcu grace period, but defer it if we need to use vfree() to get
>>> rid of that memory area. We do that by need, because we need vfree
>>> to be called in a process context.
>>>
>>> This patch unifies this behavior, by ensuring that even kfree will
>>> happen in a separate thread. The goal is to have a stable place to
>>> call the upcoming jump label destruction function outside the realm
>>> of the complicated and quite far-reaching cgroup lock (that can't be
>>> held when calling neither the cpu_hotplug.lock nor the jump_label_mutex)
>>>
>>> Signed-off-by: Glauber Costa<glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>>> CC: Tejun Heo<tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>> CC: Li Zefan<lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>> CC: Kamezawa Hiroyuki<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>>> CC: Johannes Weiner<hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>>> CC: Michal Hocko<mhocko-AlSwsSmVLrQ@public.gmane.org>
>>
>> How about cut out this patch and merge first as simple cleanu up and
>> to reduce patch stack on your side ?
>>
>> Acked-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> 
> I believe this is already in the -mm tree (from the sock memcg fixes)
> 
> But actually, my main trouble with this series here, is that I am basing
> it on Pekka's tree, while some of the fixes are in -mm already.
> If I'd base it on -mm I would lose some of the stuff as well.
> 
> Maybe Pekka can merge the current -mm with his tree?
> 
> So far I am happy with getting comments from people about the code, so I
> did not get overly concerned about that.
> 

Sure. thank you.
-Kame

