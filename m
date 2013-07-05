From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH for 3.2] memcg: do not trap chargers with full callstack
 on OOM
Date: Fri, 5 Jul 2013 15:18:54 -0400
Message-ID: <20130705191854.GR17812@cmpxchg.org>
References: <20130606160446.GE24115@dhcp22.suse.cz>
 <20130606181633.BCC3E02E@pobox.sk>
 <20130607131157.GF8117@dhcp22.suse.cz>
 <20130617122134.2E072BA8@pobox.sk>
 <20130619132614.GC16457@dhcp22.suse.cz>
 <20130622220958.D10567A4@pobox.sk>
 <20130624201345.GA21822@cmpxchg.org>
 <20130628120613.6D6CAD21@pobox.sk>
 <20130705181728.GQ17812@cmpxchg.org>
 <20130705210246.11D2135A@pobox.sk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130705210246.11D2135A-Rm0zKEqwvD4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On Fri, Jul 05, 2013 at 09:02:46PM +0200, azurIt wrote:
> >I looked at your debug messages but could not find anything that would
> >hint at a deadlock.  All tasks are stuck in the refrigerator, so I
> >assume you use the freezer cgroup and enabled it somehow?
> 
> 
> Yes, i'm really using freezer cgroup BUT i was checking if it's not
> doing problems - unfortunately, several days passed from that day
> and now i don't fully remember if i was checking it for both cases
> (unremoveabled cgroups and these freezed processes holding web
> server port). I'm 100% sure i was checking it for unremoveable
> cgroups but not so sure for the other problem (i had to act quickly
> in that case). Are you sure (from stacks) that freezer cgroup was
> enabled there?

Yeah, all the traces without exception look like this:

1372089762/23433/stack:[<ffffffff81080925>] refrigerator+0x95/0x160
1372089762/23433/stack:[<ffffffff8106ab7b>] get_signal_to_deliver+0x1cb/0x540
1372089762/23433/stack:[<ffffffff8100188b>] do_signal+0x6b/0x750
1372089762/23433/stack:[<ffffffff81001fc5>] do_notify_resume+0x55/0x80
1372089762/23433/stack:[<ffffffff815cac77>] int_signal+0x12/0x17
1372089762/23433/stack:[<ffffffffffffffff>] 0xffffffffffffffff

so the freezer was already enabled when you took the backtraces.

> Btw, what about that other stacks? I mean this file:
> http://watchdog.sk/lkml/memcg-bug-7.tar.gz
> 
> It was taken while running the kernel with your patch and from
> cgroup which was under unresolveable OOM (just like my very original
> problem).

I looked at these traces too, but none of the tasks are stuck in rmdir
or the OOM path.  Some /are/ in the page fault path, but they are
happily doing reclaim and don't appear to be stuck.  So I'm having a
hard time matching this data to what you otherwise observed.

However, based on what you reported the most likely explanation for
the continued hangs is the unfinished OOM handling for which I sent
the followup patch for arch/x86/mm/fault.c.
