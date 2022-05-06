From: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: Export memcg->watermark via sysfs for v2 memcg
Date: Fri, 6 May 2022 22:13:56 +0530
Message-ID: <CAPD3tpFx9eNUULr79xy1y7=g0zT2jMebuJMVfqyCPUZnpyx2yQ@mail.gmail.com>
References: <20220505121329.GA32827@us192.sjc.aristanetworks.com>
 <YnU3EuaWCKL5LZLy@cmpxchg.org> <CALvZod6jcdhHqFEo1r-y5QufA+LxeCDy9hnD2ag_8vkvxXtp2Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rf6MstebMe7T6JVzKugNQZXbfltXJvPfsmUp0B3hsoU=;
        b=jLKEUboD2FZQ+ozGu1TE5ymLn9dqAn0Bx9eCyPK4k4XzsSowz7l1Tu+xTPMtrNQnrJ
         5PMtkEBS2y9k7znDr40M9XVMkGT0WY4buCZXvqkzxQ24mfD3fryn7YU2x5QF9M6yiGoc
         e859cuJ8QyOyyCeHYO5nZDtFGKemBTz+mEzDFzKYJsD7uvIT6T8NzsTgxtwbKU6ZY8+o
         u8Zfs+54nAd2M7uE2a+YcgDsogj101IGxjdRFN9R90V47eU5fBkXwA7P70wkJ5sTWOPa
         33m6cWGxvXhXi9tAirtlAA/VRmQEDxJOIuxjELqRuV1spKd28xyFmPCCnUc7AMOKmknx
         rO2g==
In-Reply-To: <CALvZod6jcdhHqFEo1r-y5QufA+LxeCDy9hnD2ag_8vkvxXtp2Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Fri, May 6, 2022 at 9:26 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Fri, May 6, 2022 at 7:57 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> >
> > On Thu, May 05, 2022 at 05:13:30AM -0700, Ganesan Rajagopal wrote:
> > > v1 memcg exports memcg->watermark as "memory.mem_usage_in_bytes" in
> > > sysfs. This is missing for v2 memcg though "memory.current" is exported.
> > > There is no other easy way of getting this information in Linux.
> > > getrsuage() returns ru_maxrss but that's the max RSS of a single process
> > > instead of the aggregated max RSS of all the processes. Hence, expose
> > > memcg->watermark as "memory.watermark" for v2 memcg.
> > >
> > > Signed-off-by: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
> >
> > This wasn't initially added to cgroup2 because its usefulness is very
> > specific: it's (mostly) useless on limited cgroups, on long-running
> > cgroups, and on cgroups that are recycled for multiple jobs. And I
> > expect these categories apply to the majority of cgroup usecases.
> >
> > However, for the situation where you want to measure the footprint of
> > a short-lived, unlimited one-off cgroup, there really is no good
> > alternative. And it's a legitimate usecase. It doesn't cost much to
> > maintain this info. So I think we should go ahead with this patch.
> >
> > But please add a blurb to Documentation/admin-guide/cgroup-v2.rst.
>
> No objection from me. I do have two points: (1) watermark is not a
> good name for this interface, maybe max_usage or something. (2) a way
> to reset (i.e. write to it, reset it).

Thanks for the feedback. I'll post an updated patch with your suggestions
(including updating the description). For resetting the value I assume
setting it to memory.current would be logical?

Ganesan
