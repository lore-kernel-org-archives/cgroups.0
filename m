From: Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH V2] cpuset: Add knob to make allowed masks hotplug invariant
 on legacy hierarchy
Date: Wed, 15 Apr 2015 16:42:34 +0530
Message-ID: <552E47A2.2000909@linux.vnet.ibm.com>
References: <20150410141118.11284.36206.stgit@preeti.in.ibm.com> <20150413145052.GC2596@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150413145052.GC2596-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: svaidy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, nacc-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, bharata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org

On 04/13/2015 08:20 PM, Tejun Heo wrote:
> On Fri, Apr 10, 2015 at 07:41:52PM +0530, Preeti U Murthy wrote:
>> Moreover the default hierarchy keeps the allowed masks hotplug invariant
>> too. So the patch is not bringing about a fundamental change in the
>> design of cgroups.
> 
> This is gonna be a new behavior anyway and I don't follow why you just
> can't use the default hierarchy (well, of course except for that it
> isn't ready yet but no matter what we do this is gonna take another
> devel cycle so what's the difference?).  It's not like the default

Is it possible today to mount a specific controller on the default
hierarchy ? Or will this capability be going in the next merge window ?
I see that there are  no mount options except the __SANE__ one that the
default hierarchy takes.

We could mount the rest of the controllers in the legacy hierarchy while
mounting the cpuset controller alone in the default hierarchy and see if
this works fine.

Regards
Preeti U Murthy

> hierarchy requires invasive changes.  I'm not convinced this calls for
> yet another operation mode.
> 
> Thanks.
> 
