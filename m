From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Date: Mon, 18 Nov 2013 10:41:15 -0500
Message-ID: <20131118154115.GA3556@cmpxchg.org>
References: <alpine.DEB.2.02.1310301838300.13556@chino.kir.corp.google.com>
 <20131031054942.GA26301@cmpxchg.org>
 <alpine.DEB.2.02.1311131416460.23211@chino.kir.corp.google.com>
 <20131113233419.GJ707@cmpxchg.org>
 <alpine.DEB.2.02.1311131649110.6735@chino.kir.corp.google.com>
 <20131114032508.GL707@cmpxchg.org>
 <alpine.DEB.2.02.1311141447160.21413@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1311141525440.30112@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=M4kPUX7V5MeH8PFDZVisygbw+k/8IUu+rOQcfsaZkvw=;
	b=s7v1McTiF9A1MlwJI2cXc3rr/8We3ru9JamSZRNe11Cy3xMuvVBjWb/U/fB3CocJ2XakJWZotjwzhnC9tJ2vhVKO9dGreBdcem3zMFUf1k1h319FY7Svx78uAIzeNaKB6w82YyNEmypnP/u1GKS6dB3iA2jBGx6VoRU4AFuqn7w=;
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311141525440.30112-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Nov 14, 2013 at 03:26:51PM -0800, David Rientjes wrote:
> When current has a pending SIGKILL or is already in the exit path, it
> only needs access to memory reserves to fully exit.  In that sense, the
> memcg is not actually oom for current, it simply needs to bypass memory
> charges to exit and free its memory, which is guarantee itself that
> memory will be freed.
> 
> We only want to notify userspace for actionable oom conditions where
> something needs to be done (and all oom handling can already be deferred
> to userspace through this method by disabling the memcg oom killer with
> memory.oom_control), not simply when a memcg has reached its limit, which
> would actually have to happen before memcg reclaim actually frees memory
> for charges.

Even though the situation may not require a kill, the user still wants
to know that the memory hard limit was breached and the isolation
broken in order to prevent a kill.  We just came really close and the
fact that current is exiting is coincidental.  Not everybody is having
OOM situations on a frequent basis and they might want to know when
they are redlining the system and that the same workload might blow up
the next time it's run.

The emergency reserves are there to prevent the system from
deadlocking.  We only dip into them to avert a more imminent disaster
but we are no longer in good shape at this point.  But by not even
announcing this situation to userspace anymore you are making this the
new baseline and declaring that everything is fine when the system is
already clutching at straws.

I maintain that we should signal OOM when our healthy and
always-available options are exhausted.
