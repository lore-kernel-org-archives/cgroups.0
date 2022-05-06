From: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: Export memcg->watermark via sysfs for v2 memcg
Date: Fri, 6 May 2022 20:34:34 +0530
Message-ID: <CAPD3tpEStjm02QXE=vpUKhttc3RroJ8LNdX7iBaAgCOpdcy8-A@mail.gmail.com>
References: <20220505121329.GA32827@us192.sjc.aristanetworks.com> <YnU3EuaWCKL5LZLy@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2LpI0DImiuDC2UzRqfJHQ2qAza8P08IbEZJSnDfETww=;
        b=C3DmY9zqQpuSybTFOak9V+J6u4wDYDHiArS7riORo4yB6KdqsWLxhsWFUXdp5Zs75r
         KlULlrzTb6vVdS+TmD/jo/bV8PW3aZ5GW7HeytlG87S0bd1BJT21JxJdPWnjs0hSF3SU
         zV/hZEYf+9AtoPpN49UXruQAhUzGe606FESKKBMPigXxbhAw9OFDNrCDZXxjxGJZYD/A
         VBaa9IqZP05rI4wxT6MUkVDoNQOipok6hfIKKdi9UVogn/sEkGZSRfzgP16cJnQki1Il
         D8XmaVr2p3CeL/fFfwnlhIqGTkcSaaLAssco5zlEM4tyNawoaqQiJXtR6lcRyYHVaZPU
         +lbw==
In-Reply-To: <YnU3EuaWCKL5LZLy-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri, May 6, 2022 at 8:27 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Thu, May 05, 2022 at 05:13:30AM -0700, Ganesan Rajagopal wrote:
> > v1 memcg exports memcg->watermark as "memory.mem_usage_in_bytes" in
> > sysfs. This is missing for v2 memcg though "memory.current" is exported.
> > There is no other easy way of getting this information in Linux.
> > getrsuage() returns ru_maxrss but that's the max RSS of a single process
> > instead of the aggregated max RSS of all the processes. Hence, expose
> > memcg->watermark as "memory.watermark" for v2 memcg.
> >
> > Signed-off-by: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
>
> This wasn't initially added to cgroup2 because its usefulness is very
> specific: it's (mostly) useless on limited cgroups, on long-running
> cgroups, and on cgroups that are recycled for multiple jobs. And I
> expect these categories apply to the majority of cgroup usecases.
>
> However, for the situation where you want to measure the footprint of
> a short-lived, unlimited one-off cgroup, there really is no good
> alternative. And it's a legitimate usecase. It doesn't cost much to
> maintain this info. So I think we should go ahead with this patch.
>
> But please add a blurb to Documentation/admin-guide/cgroup-v2.rst.

Thank you for the review. I'll refresh the patch with the documentation blurb.

Ganesan
