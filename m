From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.15] cgroup, sched: Move basic cpu stats from
 cgroup.stat to cpu.stat
Date: Thu, 26 Oct 2017 19:43:07 +0200
Message-ID: <20171026174307.GU3165@worktop.lehotels.local>
References: <20171023231827.GA8598@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=QVnkL9dBg3a5CXNwioFj1W0Chmpwkqc1Lba74saAD/4=; b=zYfkLR5oKgqycNa4dsi8bVZEw
        GbUVqWaOp9mBmRkr/mN/bWEBvDIuEEBUEP5/pdUXVESU6/mPvODHYLHTBHpTJSkS33vpo+gxjAmrF
        WxpyPOrVsLZ/1LMV5eOVntIHgxP2TMXZdl0CrqCwTWEsPLJHKUEhMOeSh/x/TRGYMElHcg3rtW0P1
        hJ7rUY+Y1GEsSVIsivlJLQfv4IlXHzsEFRP5rQW/uAN88CiRD94nc+PZe3fgVpH0dYg+KsA6+uD2S
        ooOPYYios+IlBnBn/5gq75RTGTq9y+VvUHPqOmeg/4ftsSWqBT5ZymsOZjbtyoeaLlgIDrmjqjDkW
      
Content-Disposition: inline
In-Reply-To: <20171023231827.GA8598-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, Oct 23, 2017 at 04:18:27PM -0700, Tejun Heo wrote:
> The basic cpu stat is currently shown with "cpu." prefix in
> cgroup.stat, and the same information is duplicated in cpu.stat when
> cpu controller is enabled.  This is ugly and not very scalable as we
> want to expand the coverage of stat information which is always
> available.
> 
> This patch makes cgroup core always create "cpu.stat" file and show
> the basic cpu stat there and calls the cpu controller to show the
> extra stats when enabled.  This ensures that the same information
> isn't presented in multiple places and makes future expansion of basic
> stats easier.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

>  Documentation/cgroup-v2.txt     |   15 +++-------
>  include/linux/cgroup-defs.h     |    2 +
>  include/linux/cgroup.h          |    2 -
>  kernel/cgroup/cgroup-internal.h |    1 
>  kernel/cgroup/cgroup.c          |   60 ++++++++++++++++++++++++++++++++++++++--
>  kernel/cgroup/stat.c            |   10 +++---
>  kernel/sched/core.c             |   13 ++------
>  7 files changed, 75 insertions(+), 28 deletions(-)

Acked-by: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
