From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2] cpuset: Add knob to make allowed masks hotplug
 invariant on legacy hierarchy
Date: Wed, 15 Apr 2015 11:15:35 -0500
Message-ID: <20150415161534.GA25776@mail.hallyn.com>
References: <20150410141118.11284.36206.stgit@preeti.in.ibm.com>
 <20150411083537.GR27490@worktop.programming.kicks-ass.net>
 <20150413070117.GX24151@twins.programming.kicks-ass.net>
 <552BB3A5.9060905@linux.vnet.ibm.com>
 <20150413144311.GF5029@twins.programming.kicks-ass.net>
 <552E4E41.3030008@linux.vnet.ibm.com>
 <20150415150302.GA25089@mail.hallyn.com>
 <20150415151926.GS23123@twins.programming.kicks-ass.net>
 <20150415153035.GA25390@mail.hallyn.com>
 <20150415154802.GB30337@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150415154802.GB30337-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, svaidy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, nacc-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, bharata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On Wed, Apr 15, 2015 at 11:48:02AM -0400, Tejun Heo wrote:
> On Wed, Apr 15, 2015 at 10:30:35AM -0500, Serge E. Hallyn wrote:
> > On Wed, Apr 15, 2015 at 05:19:26PM +0200, Peter Zijlstra wrote:
> > > On Wed, Apr 15, 2015 at 10:03:02AM -0500, Serge E. Hallyn wrote:
> > > 
> > > > Peter, is the question "why can't we just use the unified hierarchy for
> > > > cpusets"?
> > > 
> > > No, the question is why can't you use the unified hierarchy cpuset
> > > semantics -- without the actual unified hierarchy stuff.
> > 
> > Ok - that I don't know the answer to.  Does sound like it would
> > simplify things, reduce # of sets of semantics.
> 
> What'd be the reason for not using the unified hierarchy tho?  The

The reason would be because it breaks "legacy" software.  So that
would only matter if Preeti needs to run such software.

A particularly pernicious example would be needing to run nested
containers, with an older (stable release) container wanting to run
containers inside itself.  The host may have all-new software
capable of working with unifiied hierarchy, but the stable release
container will not.  (Honestly I don't yet know what we're going to
do about that, but it's going to be great fun for the next few months)

> adaptable required isn't that big and the patchset already proposes
> significant amount of behavior change.  Sure it'd be a bit more hassle
> but does that really justify introducing yet another operation mode?
> This is why unified hierarchy is being added in the first place.  One
> can argue "but *I* just need this specific part changed" but allowing
> combinations of all those little variations is gonna lead us to a
> hellish place.

Agreed, these things quickly get out of hand.  This patch looks
straightforward enough in itself, though and the question is, is this
a special enough case for an exception.

-serge
