From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/5] cpuacct, cgroup: Kill cgroup_subsys.active
Date: Tue, 9 Apr 2013 09:29:49 +0800
Message-ID: <51636F0D.5060000@huawei.com>
References: <51553813.10004@huawei.com> <1364553360.5053.84.camel@laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1364553360.5053.84.camel@laptop>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Ingo,

Any chance for this patchset and the other one to be queued for 3.10?

Both of them has been acked by Peter.

On 2013/3/29 18:36, Peter Zijlstra wrote:
> On Fri, 2013-03-29 at 14:43 +0800, Li Zefan wrote:
>> cpuacct is the only user of cgroup_subsys.active flag.
>>
>> The flag is needed because cpuacct_charge() and
>> cpuacct_account_field() can
>> be called when cpuacct hasn't been initialized during system bootup.
>>
>> This patch initializes cpuacct earlier, and the result is we don't
>> have
>> to check the flag in scheduler hot path.
>>
>> Note, this patchset is based on "[PATCH v2 0/7] sched: Split cpuacct"
>>
>>         http://lkml.org/lkml/2013/3/28/1
>>
>> 0001-cpuacct-allocate-per_cpu-cpuusage-for-root-cpuacct-s.patch
>> 0002-cpuacct-Initialize-root-cpuacct-earlier.patch
>> 0003-cpuacct-Initialize-cpuacct-subsystem-earlier.patch
>> 0004-cpuacct-No-need-to-check-subsys-active-state.patch
>> 0005-cgroup-Remove-subsys.active-flag.patch
> 
> 
> Seems sane enough
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
> 
