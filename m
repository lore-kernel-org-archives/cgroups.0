From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 5/6] sched/deadline: Create DL BW alloc, free & check
 overflow interface
Date: Thu, 4 May 2023 08:23:59 +0200
Message-ID: <20230504062359.GE1734100@hirez.programming.kicks-ass.net>
References: <20230503072228.115707-1-juri.lelli@redhat.com>
 <20230503072228.115707-6-juri.lelli@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=j16Bh52nzyJO9VnirYe2+W5J9gGnfrNEg+DqgmtGTK4=; b=o39RDzof6y4haLdWTv/dU4Ezo1
        00lekUFPh1bpwrIBOFfrFQtxvnmNYxA+cPAl3zBtS5pnDMARzaEnn+hmjQGcfjyrMrafdnp56iHaB
        jCU4qImPx1pTrvi3mVZQIVDHBvy/8bmRNgI3TQa0qOK3AH3GMSynPqiy7ueCFYCjgW3u/AOhW/SHl
        1KCW0DPlxbZcmJSFtRGXN2sPMGjdh3wyyP68Ly28Da3f6DAp1AKKXuyDvLWV6vq75DXF4J5eOyH+r
        GCcSGtu4wI3BzOk2U/Yz1J2rnxpbodfdOOwaOT/rg8p0YjccZWbaRM/gyWRIqIutipwdiXuRhyIi2
        hMejCuGA==;
Content-Disposition: inline
In-Reply-To: <20230503072228.115707-6-juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>

On Wed, May 03, 2023 at 09:22:27AM +0200, Juri Lelli wrote:
> From: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>
> 
> Rework the existing dl_cpu_busy() interface which offers DL BW overflow
> checking and per-task DL BW allocation.
> 
> Add dl_bw_free() as an interface to be able to free DL BW.
> It will be used to allow freeing of the DL BW request done during
> cpuset_can_attach() in case multiple controllers are attached to the
> cgroup next to the cpuset controller and one of the non-cpuset
> can_attach() fails.
> 
> dl_bw_alloc() (and dl_bw_free()) now take a `u64 dl_bw` parameter
> instead of `struct task_struct *p` used in dl_cpu_busy().  This allows
> to allocate DL BW for a set of tasks too rater than only for a single
> task.
> 

Changlog fails the 'why' test.
