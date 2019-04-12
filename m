From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 3/4] mm: memcontrol: fix recursive statistics correctness
 & scalabilty
Date: Fri, 12 Apr 2019 13:50:02 -0700
Message-ID: <CALvZod6jPxRb=ZEtErvZ4nJnObhQN05ECO9d_=HF0UWsCZExNw@mail.gmail.com>
References: <20190412151507.2769-1-hannes@cmpxchg.org> <20190412151507.2769-4-hannes@cmpxchg.org>
 <CALvZod4xu10+E41YyaamigysZAnDcdA09f5m-hGd72LeJ9VmEg@mail.gmail.com> <20190412201534.GB24377@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j7qwsRw5IVivpTyLBIatOTcD/RB+ixEMBFLpFto3jKc=;
        b=FNfanZT+pHyXePPyxtbvwcA0HSyUlLfO69/0C0yMTEEwkqZGMDKqTnsD34jUcSJwSW
         H+rD2xu0SDTdcw2PMP5wOdnzg2MxqLtDyXmgf+SrP+4HztAQxIIZxBF+bICluUkir/pY
         c8cRuA0THxpAqVC/043WDsTwSO7azcuGV8s3Vue48TZYoJ5syonT16R4SA6/Mj9qtuXt
         5KndgfyXwhPPDpn/a2Z3w1WxKVQRod5rlcVAAlA/Um8fPjD//D1ASejBz38ApivCap2q
         aXtwz0gMjra9X61DONZSTYp0024btZjJXF98c64BfCEZ2hl5rI6OgykrOJAXItWBazR8
         8n0A==
In-Reply-To: <20190412201534.GB24377@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Fri, Apr 12, 2019 at 1:16 PM Roman Gushchin <guro@fb.com> wrote:
>
> On Fri, Apr 12, 2019 at 12:55:10PM -0700, Shakeel Butt wrote:
> > On Fri, Apr 12, 2019 at 8:15 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > >
> > > Right now, when somebody needs to know the recursive memory statistics
> > > and events of a cgroup subtree, they need to walk the entire subtree
> > > and sum up the counters manually.
> > >
> > > There are two issues with this:
> > >
> > > 1. When a cgroup gets deleted, its stats are lost. The state counters
> > > should all be 0 at that point, of course, but the events are not. When
> > > this happens, the event counters, which are supposed to be monotonic,
> > > can go backwards in the parent cgroups.
> > >
> >
> > We also faced this exact same issue as well and had the similar solution.
> >
> > > 2. During regular operation, we always have a certain number of lazily
> > > freed cgroups sitting around that have been deleted, have no tasks,
> > > but have a few cache pages remaining. These groups' statistics do not
> > > change until we eventually hit memory pressure, but somebody watching,
> > > say, memory.stat on an ancestor has to iterate those every time.
> > >
> > > This patch addresses both issues by introducing recursive counters at
> > > each level that are propagated from the write side when stats change.
> > >
> > > Upward propagation happens when the per-cpu caches spill over into the
> > > local atomic counter. This is the same thing we do during charge and
> > > uncharge, except that the latter uses atomic RMWs, which are more
> > > expensive; stat changes happen at around the same rate. In a sparse
> > > file test (page faults and reclaim at maximum CPU speed) with 5 cgroup
> > > nesting levels, perf shows __mod_memcg_page state at ~1%.
> > >
> >
> > (Unrelated to this patchset) I think there should also a way to get
> > the exact memcg stats. As the machines are getting bigger (more cpus
> > and larger basic page size) the accuracy of stats are getting worse.
> > Internally we have an additional interface memory.stat_exact for that.
> > However I am not sure in the upstream kernel will an additional
> > interface is better or something like /proc/sys/vm/stat_refresh which
> > sync all per-cpu stats.
>
> I was thinking about eventually consistent counters: sync them periodically
> from a worker thread. It should keep the cost of reading small, but
> should increase the accuracy. Will it work for you?

Worker thread based solution seems fine to me but Johannes said it
would be best to not traverse the whole tree every few seconds.
