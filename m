From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: Limiting CPU resources of a cgroup (how do I) HELP REQUESTED
Date: Fri, 10 Aug 2012 08:50:23 +0800
Message-ID: <50245ACF.1000202@huawei.com>
References: <CACivvv0G3CspFnFud569vgdh=_2sofb4P3f2sfdFRuu2XSvRaQ@mail.gmail.com> <ECF03057-612C-4544-8174-1F6FF0E9FAB7@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ECF03057-612C-4544-8174-1F6FF0E9FAB7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Udayan Bapat <uvbapat-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Vecu BOSSEUR <vecu.bosseur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2012/8/9 21:11, Udayan Bapat wrote:
> Unless, I am mistaken cgroup does not provide max guarantee. It can be used to provide min guarantee by setting CPU.shares value.

Yes it does, by setting cpu.cfs_quota_us and cpu.cfs_period_us.

> 
> Besides, what is the use case where you would want to limit the usage even when other threads/cores are idle? Wouldn't you want to give 100 percent to finish your task earlier than giving say 30 percent only?
> 
> 
> On Aug 8, 2012, at 8:24 AM, Vecu BOSSEUR <vecu.bosseur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
>> Dear Friends or Foes ;-)
>>
>>
>> It is quite some time now that I first tried to find an adequate
>> solution to my problem; none managed to get me right yet :=-(
>>
>> Basically, I would like to limit CPU resource usage (i.e. ~= time
>> share) allocated to a said cgroup to let's say 30% of the machine
>> processing power, or 30 % of time.
>> ( SMP and HyperThreading technologies will change the interpretation
>> of that goal; regardless, please read on. )
>>
>> I am in the very need to throttle some cgroup's CPU usage, regardless
>> the overall machine CPU utilisation. I mean that I need to cap the
>> processing power dedicated and allowed to some cgroup, whether the
>> CPU(s) is(are) otherwise IDLE or BUSY (with respect to other tasks or
>> groups).
>>
>> Any hint on how to accomplish this?
>>
>> All that I happend to do was to create a renice-boosted daemon that
>> alternately froze then unfroze the said cgroup (using a calculated
>> time ratio between running/frozen states) to keep the cgroup's CPU
>> usage under control.
>>
>> You can ea
