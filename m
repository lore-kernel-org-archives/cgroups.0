From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.15] cgroup, sched: Move basic cpu stats from
 cgroup.stat to cpu.stat
Date: Tue, 24 Oct 2017 10:35:04 +0200
Message-ID: <20171024083504.GM3165@worktop.lehotels.local>
References: <20171023231827.GA8598@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nofu+t6wcHCeazxfv/8F+9ziamkT6WG+5CqWG7sI2Vk=; b=Tln3l+SNbQDvej0gFU+kqVDVv
        smW0OJ+VbMPpVESv68/9dxycxC3vLOi7tZWTj2TZ0HZc4GZUDoed5u8OnIHliKKNTiTsVhaWIPlvc
        pq2pEVIcXfoykoobDW7iPExE1ED9ttmKSXmdgblW2CenJfvykPlYPcwCVWW81+t1hJGNwnjjLWTli
        m+s0b7GjmA+HbEUUO9lE8shOy+fUy928uOpnMqbs/bPcGMbKTc4kuQnQF5D0gt0z6sa535izALs/4
        KKbVnD7ZUp51PxFae2E+/AhRlFiqZVjExzu1XX+6RBH/O3EP7wkUv5CQs7YiYt8y31K0Fm64TISYK
      
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
> ---
> Hello,
> 
> The more I think about showing cpu stat in cgroup.stat, the uglier it
> seems. 

I've not been paying much attention to this, could you elaborate on the
problems there?

> This patch flips it so that "cpu.stat" is always available
> with basic cpu stat instead.  It only changes the presentation and
> changes to the scheduler code is minimal.  Will route with the other
> cpu controller changes through cgroup/for-4.15 unless there are
> objections.

And this is -v2 only? I'm a little lost on how all that connects.
