From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH V2] cpuset: Add knob to make allowed masks hotplug
 invariant on legacy hierarchy
Date: Sat, 11 Apr 2015 15:42:02 +0200
Message-ID: <20150411134202.GS27490@worktop.programming.kicks-ass.net>
References: <20150410141118.11284.36206.stgit@preeti.in.ibm.com>
 <20150411083537.GR27490@worktop.programming.kicks-ass.net>
 <552903BC.3050103@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <552903BC.3050103-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, svaidy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, nacc-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, bharata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org

On Sat, Apr 11, 2015 at 04:51:32PM +0530, Preeti U Murthy wrote:
> On 04/11/2015 02:05 PM, Peter Zijlstra wrote:
> > On Fri, Apr 10, 2015 at 07:41:52PM +0530, Preeti U Murthy wrote:
> > What you've not explained is why you can use this knob but not use the
> > other new mode?
> 
> It is claimed that the existing software which work with the legacy
> hierarchy break when cgroups are mounted on the default hierarchy due to
> poor backward compatibility. I will include this point in the changelog.

But you don't have to mount the new thing in the unified hierarchy
nonsense. You can mount if separate but still with the new semantics.

Unless of course system disease disallows this, but that's not a kernel
problem.
