From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH V1] mm: Disable demotion from proactive reclaim
Date: Wed, 23 Nov 2022 13:35:13 -0800
Message-ID: <CAJD7tkZNW=u1TD-Fd_3RuzRNtaFjxihbGm0836QHkdp0Nn-vyQ@mail.gmail.com>
References: <20221122203850.2765015-1-almasrymina@google.com>
 <Y35fw2JSAeAddONg@cmpxchg.org> <CAHS8izN+xqM67XLT4y5qyYnGQMUWRQCJrdvf2gjTHd8nZ_=0sw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EX+iSv5Kmy5pWCU6qHN1XnjDJL0rBeY3pl3KxgAVckk=;
        b=b10RFWNVd2zdnGJldXFMotlCMISNPpbAzPXwCC5XB8K/O/Qbxo1Ykr+Zuquy4KnQSk
         lKbKgLl4YVXUUIbNQcg1k2vfYUL/kXk9P2ZAUFfJQo3Px5Y0bCin92+iywsxg10EQVt7
         0FY75zZqhlN3tWEw3A3qYZ2TRd/08fVttj4P/scn6P1bnladNhDGTWayjha7X6U+CpJN
         b38YMKfSeRVcLfp9Y37JUNqic5+IbvKMNR43YOReL++Rv01/RMyGSZIgXIwn4rHPEoeC
         YH+VtwM2w0aqHPvjnAb+X4HkbzzlmL9i5ZqCTZWX3xB1s434D+chabHVk6p7xjglB4bA
         9Y6A==
In-Reply-To: <CAHS8izN+xqM67XLT4y5qyYnGQMUWRQCJrdvf2gjTHd8nZ_=0sw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fvdl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, Nov 23, 2022 at 1:21 PM Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Wed, Nov 23, 2022 at 10:00 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> >
> > Hello Mina,
> >
> > On Tue, Nov 22, 2022 at 12:38:45PM -0800, Mina Almasry wrote:
> > > Since commit 3f1509c57b1b ("Revert "mm/vmscan: never demote for memcg
> > > reclaim""), the proactive reclaim interface memory.reclaim does both
> > > reclaim and demotion. This is likely fine for us for latency critical
> > > jobs where we would want to disable proactive reclaim entirely, and is
> > > also fine for latency tolerant jobs where we would like to both
> > > proactively reclaim and demote.
> > >
> > > However, for some latency tiers in the middle we would like to demote but
> > > not reclaim. This is because reclaim and demotion incur different latency
> > > costs to the jobs in the cgroup. Demoted memory would still be addressable
> > > by the userspace at a higher latency, but reclaimed memory would need to
> > > incur a pagefault.
> > >
> > > To address this, I propose having reclaim-only and demotion-only
> > > mechanisms in the kernel. There are a couple possible
> > > interfaces to carry this out I considered:
> > >
> > > 1. Disable demotion in the memory.reclaim interface and add a new
> > >    demotion interface (memory.demote).
> > > 2. Extend memory.reclaim with a "demote=<int>" flag to configure the demotion
> > >    behavior in the kernel like so:
> > >       - demote=0 would disable demotion from this call.
> > >       - demote=1 would allow the kernel to demote if it desires.
> > >       - demote=2 would only demote if possible but not attempt any
> > >         other form of reclaim.
> >
> > Unfortunately, our proactive reclaim stack currently relies on
> > memory.reclaim doing both. It may not stay like that, but I'm a bit
> > wary of changing user-visible semantics post-facto.
> >
> > In patch 2, you're adding a node interface to memory.demote. Can you
> > add this to memory.reclaim instead? This would allow you to control
> > demotion and reclaim independently as you please: if you call it on a
> > node with demotion targets, it will demote; if you call it on a node
> > without one, it'll reclaim. And current users will remain unaffected.
>
> Hello Johannes, thanks for taking a look!
>
> I can certainly add the "nodes=" arg to memory.reclaim and you're
> right, that would help in bridging the gap. However, if I understand
> the underlying code correctly, with only the nodes= arg the kernel
> will indeed attempt demotion first, but the kernel will also merrily
> fall back to reclaiming if it can't demote the full amount. I had
> hoped to have the flexibility to protect latency sensitive jobs from
> reclaim entirely while attempting to do demotion.
>
> There are probably ways to get around that in the userspace. I presume
> the userspace can check if there is available memory on the node's
> demotion targets, and if so, the kernel should demote-only. But I feel
> that wouldn't be reliable as the demotion logic may change across
> kernel versions. The userspace may think the kernel would demote but
> instead demotion failed due to whatever heuristic introduced into the
> new kernel version.
>
> The above is just one angle of the issue. Another angle (which Yosry
> would care most about I think) is that at Google we call
> memory.reclaim mainly when memory.current is too close to memory.max
> and we expect the memory usage of the cgroup to drop as a result of a
> success memory.reclaim call. I suspect once we take in commit
> 3f1509c57b1b ("Revert "mm/vmscan: never demote for memcg reclaim""),
> we would run into that regression, but I defer to Yosry here, he may
> have a solution for that in mind already.

We don't exactly rely on memory.current, but we do have a separate
proactive reclaim policy today from demotion, and we do expect
memory.reclaim to reclaim memory and not demote it. So it is important
that we can control reclaim vs. demotion separately. Having
memory.reclaim do demotions by default is not ideal for our current
setup, so at least having a demote= argument to control it (no
demotions, may demote, only demote) is needed.

>
> For these reasons, what do you think about adding both the "nodes="
> and "demote=" args from my patch series to memory.reclaim? With these
> args the default memory.reclaim behavior would suit meta as-is (no
> change) but we would be able to configure it to address our use cases
> as well.
>
> As always, thanks for taking the time to review!
