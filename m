From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: provide accurate stats for userspace reads
Date: Fri, 11 Aug 2023 14:21:27 +0200
Message-ID: <ZNYnx9NqwSsXKhX3@dhcp22.suse.cz>
References: <20230809045810.1659356-1-yosryahmed@google.com>
 <ZNNTgZVPZipTL/UM@dhcp22.suse.cz>
 <CAJD7tkYhxbd2e+4HMZVKUfD4cx6oDauna3vLmttNPLCmFNtpgA@mail.gmail.com>
 <ZNONgeoytpkchHga@dhcp22.suse.cz>
 <CAJD7tkb9C77UUxAykw_uMQvkzGyaZOZhM0nwWn_kcPjV0umyuA@mail.gmail.com>
 <ZNOVS0Smp2PHUIuq@dhcp22.suse.cz>
 <CAJD7tkZFxbjas=VfhYSGU84Y5vyjuqHqGsRjiDEOSDWh2BxNAg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1691756488; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qOtkZj0ZoaKc8SSiViL/YSlnuUgKWUCJq8mnFle/qmE=;
        b=XyiYmDDjNj6tb8TFgSVz8ORc6ZNC4CGVQtpafATWX3BwqIjOD/4FR8y45fFHxXVwh3VKeb
        4BADCDpgjFjuc4xcwv1PIlqT2BM0ONWICT3mQN8f4Ju0ytTCmP7diorsL6fgZTh1p9perC
        PuFPtMmzzX3Rb6LvQd0WbxLF5C7v/bc=
Content-Disposition: inline
In-Reply-To: <CAJD7tkZFxbjas=VfhYSGU84Y5vyjuqHqGsRjiDEOSDWh2BxNAg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 09-08-23 11:33:20, Yosry Ahmed wrote:
> On Wed, Aug 9, 2023 at 6:32 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >
> > On Wed 09-08-23 06:13:05, Yosry Ahmed wrote:
> > > On Wed, Aug 9, 2023 at 5:58 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > > >
> > > > On Wed 09-08-23 05:31:04, Yosry Ahmed wrote:
> > > > > On Wed, Aug 9, 2023 at 1:51 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > > > > >
> > > > > > On Wed 09-08-23 04:58:10, Yosry Ahmed wrote:
> > > > > > > Over time, the memcg code added multiple optimizations to the stats
> > > > > > > flushing path that introduce a tradeoff between accuracy and
> > > > > > > performance. In some contexts (e.g. dirty throttling, refaults, etc), a
> > > > > > > full rstat flush of the stats in the tree can be too expensive. Such
> > > > > > > optimizations include [1]:
> > > > > > > (a) Introducing a periodic background flusher to keep the size of the
> > > > > > > update tree from growing unbounded.
> > > > > > > (b) Allowing only one thread to flush at a time, and other concurrent
> > > > > > > flushers just skip the flush. This avoids a thundering herd problem
> > > > > > > when multiple reclaim/refault threads attempt to flush the stats at
> > > > > > > once.
> > > > > > > (c) Only executing a flush if the magnitude of the stats updates exceeds
> > > > > > > a certain threshold.
> > > > > > >
> > > > > > > These optimizations were necessary to make flushing feasible in
> > > > > > > performance-critical paths, and they come at the cost of some accuracy
> > > > > > > that we choose to live without. On the other hand, for flushes invoked
> > > > > > > when userspace is reading the stats, the tradeoff is less appealing
> > > > > > > This code path is not performance-critical, and the inaccuracies can
> > > > > > > affect userspace behavior. For example, skipping flushing when there is
> > > > > > > another ongoing flush is essentially a coin flip. We don't know if the
> > > > > > > ongoing flush is done with the subtree of interest or not.
> > > > > >
> > > > > > I am not convinced by this much TBH. What kind of precision do you
> > > > > > really need and how much off is what we provide?
> > > > > >
> > > > > > More expensive read of stats from userspace is quite easy to notice
> > > > > > and usually reported as a regression. So you should have a convincing
> > > > > > argument that an extra time spent is really worth it. AFAIK there are
> > > > > > many monitoring (top like) tools which simply read those files regularly
> > > > > > just to show numbers and they certainly do not need a high level of
> > > > > > precision.
> > > > >
> > > > > We used to spend this time before commit fd25a9e0e23b ("memcg: unify
> > > > > memcg stat flushing") which generalized the "skip if ongoing flush"
> > > > > for all stat flushing. As far I know, the problem was contention on
> > > > > the flushing lock which also affected critical paths like refault.
> > > > >
> > > > > The problem is that the current behavior is indeterministic, if cpu A
> > > > > tries to flush stats and cpu B is already doing that, cpu A will just
> > > > > skip. At that point, the cgroup(s) that cpu A cares about may have
> > > > > been fully flushed, partially flushed (in terms of cpus), or not
> > > > > flushed at all. We have no idea. We just know that someone else is
> > > > > flushing something. IOW, in some cases the flush request will be
> > > > > completely ignored and userspace will read stale stats (up to 2s + the
> > > > > periodic flusher runtime).
> > > >
> > > > Yes, that is certainly true but why does that matter? Stats are always a
> > > > snapshot of the past. Do we get an inconsistent image that would be
> > > > actively harmful.
> > >
> > > That can very well be the case because we may be in a state where some
> > > cpus are flushed and some aren't. Also sometimes a few seconds is too
> > > old. We have some workloads that read the stats every 1-2 seconds to
> > > keep a fresh state, and they certainly do not expect stats to be 2+
> > > seconds old when they read them.
> >
> > I hate to repeat myself but please be more specific. This all sounds
> > just too wavy to me.
> 
> Sorry I didn't have the full story in mind, I had to do my homework.
> One example is userspace OOM killing. Our userspace OOM killer makes
> decisions based on some stats from memory.stat, and stale stats (a few
> seconds in this case) can result in an unrightful OOM kill, which can
> easily cascade.

OK, but how is this any different from having outdated data because you
have to wait for memory.stat to read (being blocked inside the rstat
code)? Either your oom killer is reading the stats directly and then you
depend on that flushing which is something that could be really harmful
itself or you rely on another thread doing the blocking and you do not
have up-to-date numbers anyway. So how does blocking actually help?

> A simplified example of that is when a hierarchy has a parent cgroup
> with multiple related children. In this case, there are usually
> file-backed resources that are shared between those children, and OOM
> killing one of them will not free those resources. Hence, the OOM
> killer only considers their anonymous usage to be reap-able when a
> memcg is nuked. For that we use the "anon" stat (or "rss" in cgroup
> v1) in memory.stat.
> 
> >
> > > > > Some workloads need to read up-to-date stats as feedback to actions
> > > > > (e.g. after proactive reclaim, or for userspace OOM killing purposes),
> > > > > and reading such stale stats causes regressions or misbehavior by
> > > > > userspace.
> > > >
> > > > Please tell us more about those and why should all others that do not
> > > > require such a precision should page that price as well.
> > >
> > > Everyone used to pay this price though and no one used to complain.
> >
> > Right, and then the overhead has been reduced and now you want to bring
> > it back and that will be seen as a regression. It doesn't really matter
> > what used to be the overhead. People always care when something gets
> > slower.
> 
> People also care when something gets less accurate :)

Accuracy will never be 100%. We have to carefully balance between
accuracy and overhead. So far we haven't heard about how much inaccuracy
you are getting. Numbers help!

In any case I do get the argument about consistency within a subtree
(children data largely not matching parents'). Examples like that would
be really helpful as well. If that is indeed the case then I would
consider it much more serious than accuracy which is always problematic
(100ms of an actively allocating context can ruin your just read numbers
and there is no way around that wihtout stopping the world).

Last note, for /proc/vmstat we have /proc/sys/vm/stat_refresh to trigger
an explicit refresh. For those users who really need more accurate
numbers we might consider interface like that. Or allow to write to stat
file and do that in the write handler.
-- 
Michal Hocko
SUSE Labs
