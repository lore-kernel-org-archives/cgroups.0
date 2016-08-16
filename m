From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Tue, 16 Aug 2016 12:30:45 -0400
Message-ID: <20160816163045.GA16427@cmpxchg.org>
References: <20160805170752.GK2542@mtj.duckdns.org>
 <1470474291.4117.243.camel@gmail.com>
 <20160810220944.GB3085@cmpxchg.org>
 <20160816140738.GW6879@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CSedKfPz5ROueSXKt4VBjg2NuDy5vrudpJkFMKqeX0I=; b=ZagDvwn3F771Vo7Xxk+s9R6Dq7
	JlgCB1L4hjyOC/V07bOQEETm4yxdJF4xJ+4fhF2HnKJLLLhWAP4l79IjkOHmlWYmxr7Pr6JI0wTbx
	mv5zAZT9P1CfEimjA9v4PfeJIizRtrYLewIMkzqjoPXgTzF0omfA6vUCmipIFSPT71+E=;
Content-Disposition: inline
In-Reply-To: <20160816140738.GW6879-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Aug 16, 2016 at 04:07:38PM +0200, Peter Zijlstra wrote:
> On Wed, Aug 10, 2016 at 06:09:44PM -0400, Johannes Weiner wrote:
> 
> > [ That, and a disturbing number of emotional outbursts against
> >   systemd, which has nothing to do with any of this. ]
> 
> Oh, so I'm entirely dreaming this then:
> 
>   https://github.com/systemd/systemd/pull/3905
> 
> Completely unrelated.

Yes and no. We certainly do use systemd (kind of hard not to at this
point if you're using any major distribution), and we do feed back the
changes we make to it upstream. But this is updating systemd to work
with the resource control design choices we made in the kernel, not
the other way round.

As I wrote to Mike before, we have been running into these resource
control issues way before systemd, when we used a combination of
libcgroup and custom hacks to coordinate the jobs on the system. The
cgroup2 design choices fell out of experiences with those setups.

Neither the problem statement nor the proposed solutions depend on
systemd, which is why I had hoped we could focus these cgroup2 debates
around the broader resource control issues we are trying to address,
rather than get hung up on one contentious user of the interface.

> Also, the argument there seems unfair at best, you don't need cpu-v2 for
> buffered write control, you only need memcg and block co-mounted.

Yes, memcg and block agreeing is enough for that case. But I mentioned
a whole bunch of these examples, to make the broader case for a common
controller model.
