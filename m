From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] cpusets: Make cpus_allowed and mems_allowed masks
 hotplug invariant
Date: Thu, 9 Oct 2014 10:30:46 +0200
Message-ID: <20141009083046.GP10832@worktop.programming.kicks-ass.net>
References: <20141008070739.1170.33313.stgit@preeti.in.ibm.com>
 <20141008080706.GC10832@worktop.programming.kicks-ass.net>
 <543505EF.7070804@linux.vnet.ibm.com>
 <20141008101828.GG10832@worktop.programming.kicks-ass.net>
 <54364564.3090305@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54364564.3090305-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, svaidy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Oct 09, 2014 at 01:50:52PM +0530, Preeti U Murthy wrote:
> We observed this on ubuntu kernel, in which systemd explicitly mounts

Using systemd is your first fail.. total crapfest that.
