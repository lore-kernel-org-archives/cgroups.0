From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2] cpuset: Add knob to make allowed masks hotplug
 invariant on legacy hierarchy
Date: Wed, 15 Apr 2015 10:03:02 -0500
Message-ID: <20150415150302.GA25089@mail.hallyn.com>
References: <20150410141118.11284.36206.stgit@preeti.in.ibm.com>
 <20150411083537.GR27490@worktop.programming.kicks-ass.net>
 <20150413070117.GX24151@twins.programming.kicks-ass.net>
 <552BB3A5.9060905@linux.vnet.ibm.com>
 <20150413144311.GF5029@twins.programming.kicks-ass.net>
 <552E4E41.3030008@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <552E4E41.3030008-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, svaidy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, nacc-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, bharata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org

On Wed, Apr 15, 2015 at 05:10:49PM +0530, Preeti U Murthy wrote:
> On 04/13/2015 08:13 PM, Peter Zijlstra wrote:
> > On Mon, Apr 13, 2015 at 05:46:37PM +0530, Preeti U Murthy wrote:
> >> On 04/13/2015 12:31 PM, Peter Zijlstra wrote:
> > 
> >>> Would it not make sense to make that a mount option and limit the amount
> >>> of semantic variants of cpusets?
> >>
> >> I spent some time analyzing if this would be a better option than the
> >> sysfs knob and I think not for the following reasons:
> >>
> >> 1. Mount options tend to be generic across the controllers of a cgroup.
> >> But use case addressed by this patch is specific to the cpuset controller.
> > 
> > Surely we can get around that somehow.
> > 
> >> 2. The behavior that this patch is trying to bring about is not a
> >> drastic one to call for a mount option equivalent to the __SANE_BEHAVIOR
> >> one that existed earlier. This option was used to switch the legacy
> >> design to the default one.
> >>
> >> However this patch is not *wholly* mimicking the default hierarchy
> >> behavior. The behavior when cpusets become empty is left untouched for
> >> instance. The patch borrows one of the behaviors from the default
> >> hierarchy only and hence just not justify the use of a mount flag.
> > 
> > So the 'problem' I have is that you introduce a 3rd semantic for the
> > cpuset thing.
> > 
> > You also do not answer if you can live with the default hierarchy
> > behaviour, only that your patch mimicks a subset of it.
> > 
> > Why not all of it?
> 
> This was assuming that the existing software will break if we mimick the
> entire design given that we were informed that it does not work well
> with the default hierarchy. But I think now, that its worth finding out
> why if so and switch over to the new design, atleast for cpusets.

Peter, is the question "why can't we just use the unified hierarchy for
cpusets"?
