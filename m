From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 0/6] sched/deadline: cpuset: Rework DEADLINE bandwidth
 restoration
Date: Thu, 4 May 2023 08:25:25 +0200
Message-ID: <20230504062525.GF1734100@hirez.programming.kicks-ass.net>
References: <20230503072228.115707-1-juri.lelli@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0/lxZ8I0MqaXMk8+g9Fw5CznOe/fTSlnGEVclllXyGY=; b=Nmoo9DOynuVqyJyVqry90thHKV
        Z+yPBe6q31aq5C6MMqg5enWpGfzLFtFtUEbOADD6Ata6S6MaGcfkurnjQTri1b5KFMXNrmhKeclYX
        fT1aGJ7SYPluxWOS4VB/G3zsloLe08DAymZDKigbYLtFBwza7o4+bMgqey1hTpAOsa9KO4YD5eRjE
        z8DtaptWM+YgWtMhEPnhaK7LkLnj20eXT409FJpreMrB9vQYMepvQ6zcCGv+vUTARCmNHdebFaNXt
        qImtBxyuAwZvvhKPrpNErVKMISyH+FKBlICudJY885hjLPY98Z6tBNC11gq3FXfFO8hKFya1ymZVF
        MVZk602g==;
Content-Disposition: inline
In-Reply-To: <20230503072228.115707-1-juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>

On Wed, May 03, 2023 at 09:22:22AM +0200, Juri Lelli wrote:

> Dietmar Eggemann (2):
>   sched/deadline: Create DL BW alloc, free & check overflow interface
>   cgroup/cpuset: Free DL BW in case can_attach() fails
> 
> Juri Lelli (4):
>   cgroup/cpuset: Rename functions dealing with DEADLINE accounting
>   sched/cpuset: Bring back cpuset_mutex
>   sched/cpuset: Keep track of SCHED_DEADLINE task in cpusets
>   cgroup/cpuset: Iterate only if DEADLINE tasks are present
> 
>  include/linux/cpuset.h  |  12 +-
>  include/linux/sched.h   |   4 +-
>  kernel/cgroup/cgroup.c  |   4 +
>  kernel/cgroup/cpuset.c  | 242 ++++++++++++++++++++++++++--------------
>  kernel/sched/core.c     |  41 +++----
>  kernel/sched/deadline.c |  67 ++++++++---
>  kernel/sched/sched.h    |   2 +-
>  7 files changed, 244 insertions(+), 128 deletions(-)

Aside from a few niggles, these look fine to me. Who were you expecting
to merge these, tj or me?


