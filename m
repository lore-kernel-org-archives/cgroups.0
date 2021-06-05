From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg: periodically flush the memcg stats
Date: Fri, 4 Jun 2021 21:45:28 -0700
Message-ID: <CALvZod6AydanksvciHuxRPoOddFX3ov0Pp511RkzO8nLn3TJUQ@mail.gmail.com>
References: <20210604015640.2586269-1-shakeelb@google.com> <20210604061816.3110-1-hdanton@sina.com>
 <20210605015421.5096-1-hdanton@sina.com> <YLriZxiWo+2hMI7g@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vow0w7T/H4Ok4yA/drin7CQKErICdzTcTT/vrNcM5Q4=;
        b=cQpKNyLMQiiglbrRjutBB1ddOTJ0H8uhnwCNG/LXy9JI6NoO9lzdOy1HZVNF2AUCgp
         +p+rCr2qv9jP3GKnpc3t1Irvf17uRHj9MpYhzTGpzCI39q9t/0ZbxDL/kzuO7O2OE07c
         QD0ofIbb5nPJaakITyoiShuR/SLGOVJC/BN/LDf4cID895GGCjl4AQqtCFK3HGIL5GOf
         lCrsT6FzE+7Rd18A1PE02wg0GVG+nqn/DWpMgA+f0ryLKukck/9GhajbiUt1BNUe9Wqe
         szncH+Or4xHWi9+JvrTkdXFEqbOrpxKFnGctU+/59p3/6PKIoRW6xmt7mxsIdmarHhOK
         c7ug==
In-Reply-To: <YLriZxiWo+2hMI7g-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Jun 4, 2021 at 7:33 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Sat, Jun 05, 2021 at 09:54:21AM +0800, Hillf Danton wrote:
> > The cond_resched() in cgroup_rstat_flush_locked() matches its appearence in
> > your post [1]. So does unbound IMHO.
>
> Ah yeah, this either needs CPU_INTENSIVE or UNBOUND, prolly the latter is
> better.
>

I will change the next version to the system_unbound_wq.
