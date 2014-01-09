From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current
 needs access to memory reserves
Date: Thu, 9 Jan 2014 14:47:57 -0800
Message-ID: <20140109144757.e95616b4280c049b22743a15@linux-foundation.org>
References: <20131210103827.GB20242@dhcp22.suse.cz>
	<alpine.DEB.2.02.1312101655430.22701@chino.kir.corp.google.com>
	<20131211095549.GA18741@dhcp22.suse.cz>
	<alpine.DEB.2.02.1312111434200.7354@chino.kir.corp.google.com>
	<20131212103159.GB2630@dhcp22.suse.cz>
	<alpine.DEB.2.02.1312131551220.28704@chino.kir.corp.google.com>
	<20131217162342.GG28991@dhcp22.suse.cz>
	<alpine.DEB.2.02.1312171240541.21640@chino.kir.corp.google.com>
	<20131218200434.GA4161@dhcp22.suse.cz>
	<alpine.DEB.2.02.1312182157510.1247@chino.kir.corp.google.com>
	<20131219144134.GH10855@dhcp22.suse.cz>
	<20140107162503.f751e880410f61a109cdcc2b@linux-foundation.org>
	<alpine.DEB.2.02.1401091324120.31538@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1401091324120.31538-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>

On Thu, 9 Jan 2014 13:34:24 -0800 (PST) David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> On Tue, 7 Jan 2014, Andrew Morton wrote:
> 
> > I just spent a happy half hour reliving this thread and ended up
> > deciding I agreed with everyone!  I appears that many more emails are
> > needed so I think I'll drop
> > http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves.patch
> > for now.
> > 
> > The claim that
> > mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves.patch
> > will impact existing userspace seems a bit dubious to me.
> > 
> 
> I'm not sure why this was dropped since it's vitally needed for any sane 
> userspace oom handler to be effective.

It was dropped because the other memcg developers disagreed with it.

I'd really prefer not to have to spend a great amount of time parsing
argumentative and repetitive emails to make a tie-break decision which
may well be wrong anyway.

Please work with the other guys to find an acceptable implementation. 
There must be *something* we can do?
