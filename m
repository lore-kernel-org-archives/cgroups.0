From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH RFC 1/2] mm: kmem: optimize get_obj_cgroup_from_current()
Date: Tue, 20 Dec 2022 13:15:16 -0800
Message-ID: <Y6Il5L00NIviTIe4@P9FQF9L96D.corp.robot.car>
References: <20221220182745.1903540-1-roman.gushchin@linux.dev>
 <20221220182745.1903540-2-roman.gushchin@linux.dev>
 <CALvZod5q0koAckpTr4VBq-_KiQpsmC86bE4eP9gzX71PzRdicA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1671570922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YR2G1tfnt1QeRb9BvoQh2xZ0Hit39TayrVYxM23Ti5o=;
        b=cBJO2EIe6oiGh2ENr1dP4PUWluxLFCOQnl1rnqFwsqvzqef+3Rd/UJmBPLbq5IL4/dcQEn
        gN4B8V37nJGryYOHvpTd23Gf5nrA6ZTRW9dEdQKd/He/k9s9kK8CV0Agq/XwjtfIEVbjoQ
        ujr36SB+a8Yw8C6daF2iwukLgcHSDDY=
Content-Disposition: inline
In-Reply-To: <CALvZod5q0koAckpTr4VBq-_KiQpsmC86bE4eP9gzX71PzRdicA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Tue, Dec 20, 2022 at 11:55:34AM -0800, Shakeel Butt wrote:
> On Tue, Dec 20, 2022 at 10:28 AM Roman Gushchin
> <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> >
> > Manually inline memcg_kmem_bypass() and active_memcg() to speed up
> > get_obj_cgroup_from_current() by avoiding duplicate in_task() checks
> > and active_memcg() readings.
> >
> > Also add a likely() macro to __get_obj_cgroup_from_memcg():
> > obj_cgroup_tryget() should succeed at almost all times except
> > a very unlikely race with the memcg deletion path.
> >
> > Signed-off-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> 
> Can you please add your performance experiment setup and result of
> this patch in the commit description of this patch as well?

Sure. I used a small hack to just do a bunch of allocations in a raw
and measured the time. Will include it into the commit message.

Also will fix the #ifdef thing from the second patch, thanks for spotting
it.

> 
> Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Thank you for taking a look!
