From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] sched, cpuset: Fix dl_cpu_busy() panic due to empty
 cs->cpus_allowed
Date: Fri, 19 Aug 2022 01:35:59 +0200
Message-ID: <Yv7M3/L9SarNI56c@blackbook>
References: <20220803015451.2219567-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660865760; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H6/rgO9HvIpeNmrFhx/uSlbjwCoyaLrdacgDNOTFngc=;
        b=crwVJ8RpWCeHQxaFPbR63Suq6jo0KM/vc6yg567EIKjjInbysUmmLeMFIRidgKPPqHU4WZ
        UFGXIP+90Xi2cmKHe24plOJCTyRQyUCWcJI7h4tSC9Zae5AMpNX1TUA2VfcZgTl99Giiav
        C8ojR0N4WunTALT68TBda/cee4kyMmE=
Content-Disposition: inline
In-Reply-To: <20220803015451.2219567-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Aug 02, 2022 at 09:54:51PM -0400, Waiman Long <longman-H+wXaHxf7aLQ=
T0dZR+AlfA@public.gmane.org> wrote:
> Fixes: 7f51412a415d ("sched/deadline: Fix bandwidth check/update when mig=
rating tasks between exclusive cpusets")
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.o=
rg>
> ---
>  include/linux/sched.h  | 2 +-
>  kernel/cgroup/cpuset.c | 2 +-
>  kernel/sched/core.c    | 8 +++++---
>  3 files changed, 7 insertions(+), 5 deletions(-)

Good catch,
Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
