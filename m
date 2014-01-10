From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Date: Fri, 10 Jan 2014 17:14:32 -0500
Message-ID: <20140110221432.GD6963@cmpxchg.org>
References: <alpine.DEB.2.02.1312171240541.21640@chino.kir.corp.google.com>
 <20131218200434.GA4161@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312182157510.1247@chino.kir.corp.google.com>
 <20131219144134.GH10855@dhcp22.suse.cz>
 <20140107162503.f751e880410f61a109cdcc2b@linux-foundation.org>
 <alpine.DEB.2.02.1401091324120.31538@chino.kir.corp.google.com>
 <20140109144757.e95616b4280c049b22743a15@linux-foundation.org>
 <alpine.DEB.2.02.1401091551390.20263@chino.kir.corp.google.com>
 <20140109161246.57ea590f00ea5b61fdbf5f11@linux-foundation.org>
 <alpine.DEB.2.02.1401091613560.22649@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=vtSJwTWLRio5iNAeqCmp/bupcFgLPuGGRCdGc7Q5vpc=;
	b=BP8mYsxolqxTVI6alduwsOllNhFFGKdg15PGc6yQLUTWUsQcuNYj7aDMX21XVoT9ty5Dt2goG3u3LPcq9GOHj9wjo6NL6GdIRTBfMLKZBR+5/AHE8UYaKvxfPXIViQ0Q6l0bK2TFoB0RXIVwk7Gzr8ZopO8oCr1Vi8WfX0brz40=;
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401091613560.22649-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>

On Thu, Jan 09, 2014 at 04:23:50PM -0800, David Rientjes wrote:
> On Thu, 9 Jan 2014, Andrew Morton wrote:
> 
> > > > It was dropped because the other memcg developers disagreed with it.
> > > > 
> > > 
> > > It was acked-by Michal.

Michal acked it before we had most of the discussions and now he is
proposing an alternate version of yours, a patch that you are even
discussing with him concurrently in another thread.  To claim he is
still backing your patch because of that initial ack is disingenuous.

> > And Johannes?
> > 
> 
> Johannes is arguing for the same semantics that VMPRESSURE_CRITICAL and/or 
> memory thresholds provides, which disagrees from the list of solutions 
> that Documentation/cgroups/memory.txt gives for userspace oom handler 
> wakeups and is required for any sane implementation.

No, he's not and I'm sick of you repeating refuted garbage like this.

You have convinced neither me nor Michal that your problem is entirely
real and when confronted with doubt you just repeat the same points
over and over.

The one aspect of your change that we DO agree is valid is now fixed
by Michal in a separate attempt because you could not be bothered to
incorporate feedback into your patch.
