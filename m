From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 0/6] sched/deadline: cpuset: Rework DEADLINE bandwidth
 restoration
Date: Fri, 5 May 2023 09:31:01 -1000
Message-ID: <ZFVZdbdZTLGhqYp4@slm.duckdns.org>
References: <20230503072228.115707-1-juri.lelli@redhat.com>
 <20230504062525.GF1734100@hirez.programming.kicks-ass.net>
 <ZFNqJf+BQ0GMdr+y@localhost.localdomain>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683315064; x=1685907064;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sVSEn0zAZchU0XRfzSqIlgEVmcktBBmYwcVkhQoE8m0=;
        b=NYCDjIhbaqBiOSrZ/jgxJYM++MvXfz+PziXmSOtlKBWR+5G4THFS2J6lKMYUL1ZtQp
         /+n4GUaL/F1C/Hv7nTbtNqmpV5z7VXvQWx9UHrXUzwrHiw35fgnlVMsX4I0PBAgfwjUG
         2ooHt7ZJh9wgSGvg/SHA6DtoJe/kiJ3Goxylyyfi6fMcMRmKbUeOvYZthBVzGkBWoj9k
         uJVgHOEUm/rNXBynMU5Y//6lgXN9sg3cgtVtBR10M3kAWppabMcp+hGVLYpdWeVHjVxM
         ZN1GgSLgrsNe6E6j4l34bTX+odwC3ez7lEInB6MbvS/FpUYjCDfl5Hx8sxVirIb5x3N4
         kDbQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ZFNqJf+BQ0GMdr+y-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agor>

On Thu, May 04, 2023 at 10:17:41AM +0200, Juri Lelli wrote:
> On 04/05/23 08:25, Peter Zijlstra wrote:
> > On Wed, May 03, 2023 at 09:22:22AM +0200, Juri Lelli wrote:
> > 
> > > Dietmar Eggemann (2):
> > >   sched/deadline: Create DL BW alloc, free & check overflow interface
> > >   cgroup/cpuset: Free DL BW in case can_attach() fails
> > > 
> > > Juri Lelli (4):
> > >   cgroup/cpuset: Rename functions dealing with DEADLINE accounting
> > >   sched/cpuset: Bring back cpuset_mutex
> > >   sched/cpuset: Keep track of SCHED_DEADLINE task in cpusets
> > >   cgroup/cpuset: Iterate only if DEADLINE tasks are present
> > > 
> > >  include/linux/cpuset.h  |  12 +-
> > >  include/linux/sched.h   |   4 +-
> > >  kernel/cgroup/cgroup.c  |   4 +
> > >  kernel/cgroup/cpuset.c  | 242 ++++++++++++++++++++++++++--------------
> > >  kernel/sched/core.c     |  41 +++----
> > >  kernel/sched/deadline.c |  67 ++++++++---
> > >  kernel/sched/sched.h    |   2 +-
> > >  7 files changed, 244 insertions(+), 128 deletions(-)
> > 
> > Aside from a few niggles, these look fine to me. Who were you expecting
> > to merge these, tj or me?
> 
> Thanks for reviewing!
> 
> Not entirely sure, it's kind of split, but maybe the cgroup changes are
> predominant (cpuset_mutex is probably contributing the most). So, maybe
> tj? Assuming this looks good to him as well of course. :)

Yeah, they all look sane to me and both Waiman and Peter seem okay with
them. If you post an updated version with the minor suggestions applied,
I'll route the series through the cgroup tree.

Thanks.

-- 
tejun
