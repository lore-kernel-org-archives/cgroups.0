From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v3] memcg: schedule high reclaim for remote memcgs on
 high_work
Date: Sun, 13 Jan 2019 19:34:02 +0100
Message-ID: <20190113183402.GD1578@dhcp22.suse.cz>
References: <20190110174432.82064-1-shakeelb@google.com>
 <20190111205948.GA4591@cmpxchg.org>
 <CALvZod7O2CJuhbuLUy9R-E4dTgL4WBg8CayW_AFnCCG6KCDjUA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALvZod7O2CJuhbuLUy9R-E4dTgL4WBg8CayW_AFnCCG6KCDjUA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Fri 11-01-19 14:54:32, Shakeel Butt wrote:
> Hi Johannes,
> 
> On Fri, Jan 11, 2019 at 12:59 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > Hi Shakeel,
> >
> > On Thu, Jan 10, 2019 at 09:44:32AM -0800, Shakeel Butt wrote:
> > > If a memcg is over high limit, memory reclaim is scheduled to run on
> > > return-to-userland.  However it is assumed that the memcg is the current
> > > process's memcg.  With remote memcg charging for kmem or swapping in a
> > > page charged to remote memcg, current process can trigger reclaim on
> > > remote memcg.  So, schduling reclaim on return-to-userland for remote
> > > memcgs will ignore the high reclaim altogether. So, record the memcg
> > > needing high reclaim and trigger high reclaim for that memcg on
> > > return-to-userland.  However if the memcg is already recorded for high
> > > reclaim and the recorded memcg is not the descendant of the the memcg
> > > needing high reclaim, punt the high reclaim to the work queue.
> >
> > The idea behind remote charging is that the thread allocating the
> > memory is not responsible for that memory, but a different cgroup
> > is. Why would the same thread then have to work off any high excess
> > this could produce in that unrelated group?
> >
> > Say you have a inotify/dnotify listener that is restricted in its
> > memory use - now everybody sending notification events from outside
> > that listener's group would get throttled on a cgroup over which it
> > has no control. That sounds like a recipe for priority inversions.
> >
> > It seems to me we should only do reclaim-on-return when current is in
> > the ill-behaved cgroup, and punt everything else - interrupts and
> > remote charges - to the workqueue.
> 
> This is what v1 of this patch was doing but Michal suggested to do
> what this version is doing. Michal's argument was that the current is
> already charging and maybe reclaiming a remote memcg then why not do
> the high excess reclaim as well.

Johannes has a good point about the priority inversion problems which I
haven't thought about.

> Personally I don't have any strong opinion either way. What I actually
> wanted was to punt this high reclaim to some process in that remote
> memcg. However I didn't explore much on that direction thinking if
> that complexity is worth it. Maybe I should at least explore it, so,
> we can compare the solutions. What do you think?

My question would be whether we really care all that much. Do we know of
workloads which would generate a large high limit excess?
-- 
Michal Hocko
SUSE Labs
