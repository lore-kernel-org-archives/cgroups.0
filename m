From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] introduce res_counter_charge_nofail() for socket
 allocations
Date: Thu, 19 Jan 2012 14:38:56 +0100
Message-ID: <20120119133856.GP24386@cmpxchg.org>
References: <1326899758-9013-1-git-send-email-glommer@parallels.com>
 <20120119124841.GL24386@cmpxchg.org>
 <4F1811C4.50204@parallels.com>
 <20120119131217.GN24386@cmpxchg.org>
 <4F1816E1.2050506@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4F1816E1.2050506-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

On Thu, Jan 19, 2012 at 05:13:05PM +0400, Glauber Costa wrote:
> On 01/19/2012 05:12 PM, Johannes Weiner wrote:
> >On Thu, Jan 19, 2012 at 04:51:16PM +0400, Glauber Costa wrote:
> >>On 01/19/2012 04:48 PM, Johannes Weiner wrote:
> >>>On Wed, Jan 18, 2012 at 07:15:58PM +0400, Glauber Costa wrote:
> >>>>There is a case in __sk_mem_schedule(), where an allocation
> >>>>is beyond the maximum, but yet we are allowed to proceed.
> >>>>It happens under the following condition:
> >>>>
> >>>>	sk->sk_wmem_queued + size>= sk->sk_sndbuf
> >>>>
> >>>>The network code won't revert the allocation in this case,
> >>>>meaning that at some point later it'll try to do it. Since
> >>>>this is never communicated to the underlying res_counter
> >>>>code, there is an inbalance in res_counter uncharge operation.
> >>>>
> >>>>I see two ways of fixing this:
> >>>>
> >>>>1) storing the information about those allocations somewhere
> >>>>    in memcg, and then deducting from that first, before
> >>>>    we start draining the res_counter,
> >>>>2) providing a slightly different allocation function for
> >>>>    the res_counter, that matches the original behavior of
> >>>>    the network code more closely.
> >>>>
> >>>>I decided to go for #2 here, believing it to be more elegant,
> >>>>since #1 would require us to do basically that, but in a more
> >>>>obscure way.
> >>>>
> >>>>I will eventually submit it through Dave for the -net tree,
> >>>>but I wanted to query you guys first, to see if this approach
> >>>>is acceptable or if you'd prefer me to try something else.
> >>>>
> >>>>Thanks
> >>>>
> >>>>Signed-off-by: Glauber Costa<glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> >>>>Cc: KAMEZAWA Hiroyuki<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> >>>>Cc: Johannes Weiner<hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> >>>>Cc: Michal Hocko<mhocko-AlSwsSmVLrQ@public.gmane.org>
> >>>>---
> >>>>  include/linux/res_counter.h |    6 ++++++
> >>>>  include/net/sock.h          |   10 ++++------
> >>>>  kernel/res_counter.c        |   25 +++++++++++++++++++++++++
> >>>>  net/core/sock.c             |    4 ++--
> >>>>  4 files changed, 37 insertions(+), 8 deletions(-)
> >>>>
> >>>>diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
> >>>>index c9d625c..32a7b02 100644
> >>>>--- a/include/linux/res_counter.h
> >>>>+++ b/include/linux/res_counter.h
> >>>>@@ -109,12 +109,18 @@ void res_counter_init(struct res_counter *counter, struct res_counter *parent);
> >>>>   *
> >>>>   * returns 0 on success and<0 if the counter->usage will exceed the
> >>>>   * counter->limit _locked call expects the counter->lock to be taken
> >>>>+ *
> >>>>+ * charge_nofail works the same, except that it charges the resource
> >>>>+ * counter unconditionally, and returns<   0 if the after the current
> >>>>+ * charge we are over limit.
> >>>>   */
> >>>
> >>>res_counter_margin() assumes usage<= limit is always true.  Just make
> >>>sure you return 0 if that is not the case, or the charge path can get
> >>>confused, thinking there is enough room and retry needlessly.
> >>>
> >>>Otherwise, looks good.
> >>
> >>You mean return zero in res_counter_charge_fail() if we exceeded the limit?
> >>
> >>I do that, since one needs to know the allocation was supposed to fail.
> >>Or are you talking about something else ?
> >
> >Yes, I mean the calculation in res_counter_margin(), which is supposed
> >to tell the margin for new charges.  Its current code will underflow
> >and return something large when the usage exceeds the limit, which is
> >not possible before your patch, so I think you need to include this:
> >
> >diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
> >index c9d625c..d06d014 100644
> >--- a/include/linux/res_counter.h
> >+++ b/include/linux/res_counter.h
> >@@ -142,7 +142,10 @@ static inline unsigned long long res_counter_margin(struct res_counter *cnt)
> >  	unsigned long flags;
> >
> >  	spin_lock_irqsave(&cnt->lock, flags);
> >-	margin = cnt->limit - cnt->usage;
> >+	if (cnt->limit>  cnt->usage)
> >+		margin = cnt->limit - cnt->usage;
> >+	else
> >+		margin = 0;
> >  	spin_unlock_irqrestore(&cnt->lock, flags);
> >  	return margin;
> >  }
> Ah, I see.
> 
> Okay, I will update my patch to include this. (Or would you think it
> would be better to add this as a preparation patch?)

Probably better to just include it as we wouldn't need this check
stand-alone.
