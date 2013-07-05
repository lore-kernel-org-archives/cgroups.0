From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH for 3.2] memcg: do not trap chargers with full callstack
 on OOM
Date: Fri, 5 Jul 2013 14:17:28 -0400
Message-ID: <20130705181728.GQ17812@cmpxchg.org>
References: <20130211112240.GC19922@dhcp22.suse.cz>
 <20130222092332.4001E4B6@pobox.sk>
 <20130606160446.GE24115@dhcp22.suse.cz>
 <20130606181633.BCC3E02E@pobox.sk>
 <20130607131157.GF8117@dhcp22.suse.cz>
 <20130617122134.2E072BA8@pobox.sk>
 <20130619132614.GC16457@dhcp22.suse.cz>
 <20130622220958.D10567A4@pobox.sk>
 <20130624201345.GA21822@cmpxchg.org>
 <20130628120613.6D6CAD21@pobox.sk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130628120613.6D6CAD21-Rm0zKEqwvD4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

Hi azurIt,

On Fri, Jun 28, 2013 at 12:06:13PM +0200, azurIt wrote:
> >It's not a kernel thread that does it because all kernel-context
> >handle_mm_fault() are annotated properly, which means the task must be
> >userspace and, since tasks is empty, have exited before synchronizing.
> >
> >Can you try with the following patch on top?
> 
> 
> Michal and Johannes,
> 
> i have some observations which i made: Original patch from Johannes
> was really fixing something but definitely not everything and was
> introducing new problems. I'm running unpatched kernel from time i
> send my last message and problems with freezing cgroups are occuring
> very often (several times per day) - they were, on the other hand,
> quite rare with patch from Johannes.

That's good!

> Johannes, i didn't try your last patch yet. I would like to wait
> until you or Michal look at my last message which contained detailed
> information about freezing of cgroups on kernel running your
> original patch (which was suppose to fix it for good). Even more, i
> would like to hear your opinion about that stucked processes which
> was holding web server port and which forced me to reboot production
> server at the middle of the day :( more information was in my last
> message. Thank you very much for your time.

I looked at your debug messages but could not find anything that would
hint at a deadlock.  All tasks are stuck in the refrigerator, so I
assume you use the freezer cgroup and enabled it somehow?

Sorry about your production server locking up, but from the stacks I
don't see any connection to the OOM problems you were having... :/
