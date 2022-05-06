From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: Export memcg->watermark via sysfs for v2 memcg
Date: Fri, 6 May 2022 08:56:31 -0700
Message-ID: <CALvZod6jcdhHqFEo1r-y5QufA+LxeCDy9hnD2ag_8vkvxXtp2Q@mail.gmail.com>
References: <20220505121329.GA32827@us192.sjc.aristanetworks.com> <YnU3EuaWCKL5LZLy@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m81d4j0n4jrU8+EkDRIdTToCet26p62xWOxrVZBvafg=;
        b=S1iVkf0yZxiaHzRBF42XNyBBVYQtqIWrWcb4akJVYnJMmXnItPsVLmg4coDg8m/z67
         zbApxIKZInjNBYxMJw8GIMzyj7M3bgKFUnKdDhR/ihqiUbAQkrfwyXdCvuTc/G/2I+4h
         dWxhx4OhlpzjbIwrxJblu6/FndBQSKOCVwpoCXNUsiWW/IMOJmsWE/bLctyGJdeaJOCb
         aRQE95Jbf47BWzr6ax2qXBxI7K+cBRdcaxoFdUKc5y16WUBwk0VM2M5GNhyCZqOk4Wkw
         F9Bvu8K6Ft+b68SNWYjQMKhxpzKetTu3oAOcHDoSa/7tlueVVUgn83GnY5mOciJpzE0O
         Y9gQ==
In-Reply-To: <YnU3EuaWCKL5LZLy-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Fri, May 6, 2022 at 7:57 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
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

No objection from me. I do have two points: (1) watermark is not a
good name for this interface, maybe max_usage or something. (2) a way
to reset (i.e. write to it, reset it).
