From: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/4] cpusets,isolcpus: add file to show isolated cpus
 in cpuset
Date: Wed, 18 Mar 2015 21:54:16 -0400
Message-ID: <550A2C48.6080807@redhat.com>
References: <1425917530-1771-1-git-send-email-riel@redhat.com> <1425917530-1771-4-git-send-email-riel@redhat.com> <20150318164745.GA21564@htj.duckdns.org> <550A0CDF.1060709@redhat.com> <550A2B4C.5030705@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <550A2B4C.5030705-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 03/18/2015 09:50 PM, Zefan Li wrote:
> On 2015/3/19 7:40, Rik van Riel wrote:
>> On 03/18/2015 12:47 PM, Tejun Heo wrote:
>>> On Mon, Mar 09, 2015 at 12:12:09PM -0400, riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
>>>> From: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>>
>>>> The previous patch makes it so the code skips over isolcpus when
>>>> building scheduler load balancing domains. This makes it hard to
>>>> see for a user which of the CPUs in a cpuset are participating in
>>>> load balancing, and which ones are isolated cpus.
>>>>
>>>> Add a cpuset.isolcpus file with info on which cpus in a cpuset are
>>>> isolated CPUs.
>>>>
>>>> This file is read-only for now. In the future we could extend things
>>>> so isolcpus can be changed at run time, for the root (system wide)
>>>> cpuset only.
>>>
>>> Didn't Li say that this is trivially computable from userland?  I'm
>>> not sure this knob actually belongs to cpuset.
>>
>> I don't know whether the information to compute this is
>> always visible from userland.  I am happy to drop this
>> patch if Li prefers things that way, though.
>>
> 
> What I proposed is adding /sys/devices/system/cpu/isolated. Sysfs is
> visible in containers, unless specially configured not so.

OK, are you willing to take patches 1, 2, and the first hunk of patch
4 now? I can submit a patch to add /sys/devices/system/cpu/isolated
on Friday, to the appropriate maintainer.

(taking tomorrow off to go hiking on the last full day of winter)

-- 
All rights reversed
