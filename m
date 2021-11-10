From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] psi: Add additional PSI counters for each type of memory pressure
Date: Wed, 10 Nov 2021 09:48:10 -0800
Message-ID: <CAJuCfpFP2VP_t_tP27w=k4HDhm=jv=G2C56mM_kbs6wqux+DhA@mail.gmail.com>
References: <1636558597-248294-1-git-send-email-quic_c_gdjako@quicinc.com>
 <20211110161402.GB174703@worktop.programming.kicks-ass.net> <1fd2d97b-7c83-3a82-ada3-46ec5025c3b1@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kNHVVa6gv7z3dFlgEcituEPBx6aIWi4uliGKTG3gzjI=;
        b=qLmXdLt4YOVMgrzsS5BXEUYiJevmzqMjguHecWqoDcWTEsy74/p4NvsXb/LRZFkqGJ
         KhCWxNDSNHskY6KB2iMjRPfe5Y3fqFyPGxIytmN+X0UAayfYz6lOPXpDfqtRvdGdHmzi
         FtF0aZ5WCHIP3ioTdmDGtdqhYagHRZjSY8+p0rMVnVsMSfymyS/fXWqdGZnsf42PNfgE
         mNQw8LAQCVeiTEquV2CIvo9/bLSPNT0zxilW25HhKQu21qKwI/DTvxEWCzOQidlHTyY3
         RL5T2R6A2hNmaBfGnO3ZDvB7UGeuWCeqOy7HkG1FKg7y+9C69m7/xZJGTyPrdXquocIS
         NFIA==
In-Reply-To: <1fd2d97b-7c83-3a82-ada3-46ec5025c3b1-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Georgi Djakov <djakov-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Georgi Djakov <quic_c_gdjako-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Nov 10, 2021 at 8:46 AM Georgi Djakov <djakov-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
>
> On 10.11.21 18:14, Peter Zijlstra wrote:
> > On Wed, Nov 10, 2021 at 07:36:37AM -0800, Georgi Djakov wrote:
> >> @@ -21,7 +19,18 @@ enum psi_task_count {
> >>       * don't have to special case any state tracking for it.
> >>       */
> >>      NR_ONCPU,
> >> -    NR_PSI_TASK_COUNTS = 4,
> >> +    NR_BLK_CGROUP_THROTTLE,
> >> +    NR_BIO,
> >> +    NR_COMPACTION,
> >> +    NR_THRASHING,
> >> +    NR_CGROUP_RECLAIM_HIGH,
> >> +    NR_CGROUP_RECLAIM_HIGH_SLEEP,
> >> +    NR_CGROUP_TRY_CHARGE,
> >> +    NR_DIRECT_COMPACTION,
> >> +    NR_DIRECT_RECLAIM,
> >> +    NR_READ_SWAPPAGE,
> >> +    NR_KSWAPD,
> >> +    NR_PSI_TASK_COUNTS = 16,
> >>   };
> >>
> >
> >> @@ -51,9 +80,20 @@ enum psi_states {
> >>      PSI_MEM_FULL,
> >>      PSI_CPU_SOME,
> >>      PSI_CPU_FULL,
> >> +    PSI_BLK_CGROUP_THROTTLE,
> >> +    PSI_BIO,
> >> +    PSI_COMPACTION,
> >> +    PSI_THRASHING,
> >> +    PSI_CGROUP_RECLAIM_HIGH,
> >> +    PSI_CGROUP_RECLAIM_HIGH_SLEEP,
> >> +    PSI_CGROUP_TRY_CHARGE,
> >> +    PSI_DIRECT_COMPACTION,
> >> +    PSI_DIRECT_RECLAIM,
> >> +    PSI_READ_SWAPPAGE,
> >> +    PSI_KSWAPD,
> >>      /* Only per-CPU, to weigh the CPU in the global average: */
> >>      PSI_NONIDLE,
> >> -    NR_PSI_STATES = 7,
> >> +    NR_PSI_STATES = 18,
> >>   };
> >
> > Have you considered what this does to psi_group_cpu's size and layout
> > and the impact thereof on performance?
>
> Thanks, i will definitely add some numbers in case there are no other
> major arguments against this RFC patch.

Please CC me too in the future postings.
Thanks,
Suren.

>
> BR,
> Georgi
>
