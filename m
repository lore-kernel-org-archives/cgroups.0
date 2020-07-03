From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [RFC PROPOSAL] memcg: per-memcg user space reclaim interface
Date: Fri, 3 Jul 2020 08:50:21 -0700
Message-ID: <20200703155021.GB114903@carbon.dhcp.thefacebook.com>
References: <20200702152222.2630760-1-shakeelb@google.com>
 <20200703063548.GM18446@dhcp22.suse.cz>
 <CALvZod5gthVX5m6o50OiYsXa=0_NpXK-tVvjTF42Oj4udr4Nuw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=DOcCYCRB4XfTEDIs7MNiR/yhRdd2F+O90NRnnfO9C2c=;
 b=pJFhCArgRqeDZ/NqhIoEaZG0CDaA0hN7HiMWBT3ri4KroCCcW57iJ6Apf5QfVvtaPubz
 9eORplTaRh3xI0USCnM7h0YbPpWTmJisIer41MV5zFVnj53TIPJ9jtdXN5Q6psuLvyXA
 kDIEYf0lnZrqJpVnqxjXaITh6gDoRKI1VB8= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DOcCYCRB4XfTEDIs7MNiR/yhRdd2F+O90NRnnfO9C2c=;
 b=dADx657th+/HWQyt7uhNfD2tGwIeJhmC4X1wQG46y7tHi7NCjFM0OgnPuZH4nJSDTAIw2TlzjlqOEGdiws0N3V+WtPZTemWNvgrNLgYflhOh60YNclQvXGYNHrlXwAwEBbDxETt62shl1yBJ6+AxbOB+p/AO+6b6P5JENPIpHbY=
Content-Disposition: inline
In-Reply-To: <CALvZod5gthVX5m6o50OiYsXa=0_NpXK-tVvjTF42Oj4udr4Nuw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Jul 03, 2020 at 07:23:14AM -0700, Shakeel Butt wrote:
> On Thu, Jul 2, 2020 at 11:35 PM Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Thu 02-07-20 08:22:22, Shakeel Butt wrote:
> > [...]
> > > Interface options:
> > > ------------------
> > >
> > > 1) memcg interface e.g. 'echo 10M > memory.reclaim'
> > >
> > > + simple
> > > + can be extended to target specific type of memory (anon, file, kmem).
> > > - most probably restricted to cgroup v2.
> > >
> > > 2) fadvise(PAGEOUT) on cgroup_dir_fd
> > >
> > > + more general and applicable to other FSes (actually we are using
> > > something similar for tmpfs).
> > > + can be extended in future to just age the LRUs instead of reclaim or
> > > some new use cases.
> >
> > Could you explain why memory.high as an interface to trigger pro-active
> > memory reclaim is not sufficient. Also memory.low limit to protect
> > latency sensitve workloads?

I initially liked the proposal, but after some thoughts I've realized
that I don't know a good use case where memory.high is less useful.
Shakeel, what's the typical use case you thinking of?
Who and how will use the new interface?

> 
> Yes, we can use memory.high to trigger [proactive] reclaim in a memcg
> but note that it can also introduce stalls in the application running
> in that memcg. Let's suppose the memory.current of a memcg is 100MiB
> and we want to reclaim 20MiB from it, we can set the memory.high to
> 80MiB but any allocation attempt from the application running in that
> memcg can get stalled/throttled. I want the functionality of the
> reclaim without potential stalls.

But reclaiming some pagecache/swapping out anon pages can always
generate some stalls caused by pagefaults, no?

Thanks!
