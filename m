From: Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] cpusets: Make cpus_allowed and mems_allowed masks hotplug
 invariant
Date: Fri, 10 Apr 2015 19:44:02 +0530
Message-ID: <5527DAAA.7030308@linux.vnet.ibm.com>
References: <20141008070739.1170.33313.stgit@preeti.in.ibm.com> <20141008080706.GC10832@worktop.programming.kicks-ass.net> <543505EF.7070804@linux.vnet.ibm.com> <20141008101828.GG10832@worktop.programming.kicks-ass.net> <54364564.3090305@linux.vnet.ibm.com> <20141009130611.GA14387@htj.dyndns.org> <551CE820.9090900@linux.vnet.ibm.com> <20150406174735.GG10582@htj.duckdns.org> <20150409211349.GA28729@mail.hallyn.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150409211349.GA28729-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, svaidy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bharata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org

Hi Serge,

On 04/10/2015 02:43 AM, Serge E. Hallyn wrote:
> On Mon, Apr 06, 2015 at 01:47:35PM -0400, Tejun Heo wrote:
>> Hello, Preeti.
>>
>> On Thu, Apr 02, 2015 at 12:26:32PM +0530, Preeti U Murthy wrote:
>>> By ensuring that the user configured cpusets are untouched, I don't see
>>> how we affect userspace adversely. The expectation usually is that the
>>> kernel keeps track of the user configurations. If anything we would be
>>> fixing an undesired behavior, wouldn't we?
>>
>> The problem is not really about which behavior is "righter" but rather
>> it's fairly likely that there are users / tools out there expecting
>> the current behavior and they wouldn't be too happy to see the
>> behavior flipping underneath them.
>>
>> One way forward would be implementing a knob in cpuset which makes it
>> switch sbetween the old and new behaviors in the legacy hierarchy.
>> It's yucky but doable if absoluately necessary, but what's the reason
>> for you not being able to transition to the unified hierarchy (except
> 
> If the userspace is entirely new then this should work.  The
> unified hierarchy's behavior is not backward-compatible so any old
> software which tried to create cgroups (libcgroup, lxc, etc) will
> not work with it (since it won't, for instance, know to fill in 
> the enabled controllers in every newly created cgroup).
> 
> Preeti, can you confirm that you don't have any need to run any
> legacy programs which use cgroups?  Long as that's the case, new

I don't think I can vouch for this safely. I have posted out a V2 of
this patch adhering to Tejun's first suggestion. IMO that seemed like
a better option.

Regards
Preeti U Murthy
