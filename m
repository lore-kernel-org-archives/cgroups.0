From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 8/9] vmscan: memcg: sleep when flushing stats during reclaim
Date: Tue, 28 Mar 2023 12:01:59 -0700
Message-ID: <CAJD7tkaKh4w3roqau4V93Q022BG280yzdsh1YSVenZCLm0qVow@mail.gmail.com>
References: <20230328061638.203420-1-yosryahmed@google.com>
 <20230328061638.203420-9-yosryahmed@google.com> <CALvZod7wJ-e-dHEhMynquiqQWFU2j+05wUyUe_yv_rBqJLu2rw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680030156;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sg40HJuMXcACzrQyQIiyBgX+jk4GkAV6HLHPK6bGfcI=;
        b=F94AXc7U8n866HMI7L7KjxQgYXVxKEX1ufZhLwHPtFEsEhbsNJOSdVF8YWOeQ5aLM0
         HoT7pL2IYk/Ka8HSv4wRc8DPoT9LKGU6kC4eUXtYi4KUjsKzWtw4NZ0JaC2zi57+SF9k
         PZDqO2+41We+vRG0DYNvfpsaofVI5scLONmPNLIPDmXr/Foh6mQni79zrX9y5N5of5mh
         5ruvaxWuRzvpwbFzcBYAzS0m72Fpi2h8g9X9p1A8DJ19cKXspZUb0AuiRNq2QOi8K+0j
         Jqq1L/VZN5Xy8eCU5G6hlRGZ7juOLMyupEtnc+rDhXRk3QeAqm8+9lQ6D3XqDbxU9TST
         VUwA==
In-Reply-To: <CALvZod7wJ-e-dHEhMynquiqQWFU2j+05wUyUe_yv_rBqJLu2rw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Mar 28, 2023 at 8:19=E2=80=AFAM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> =
wrote:
>
> On Mon, Mar 27, 2023 at 11:16=E2=80=AFPM Yosry Ahmed <yosryahmed@google.c=
om> wrote:
> >
> > Memory reclaim is a sleepable context. Allow sleeping when flushing
> > memcg stats to avoid unnecessarily performing a lot of work without
> > sleeping. This can slow down reclaim code if flushing stats is taking
> > too long, but there is already multiple cond_resched()'s in reclaim
> > code.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> > ---
> >  mm/vmscan.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index a9511ccb936f..9c1c5e8b24b8 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2845,7 +2845,7 @@ static void prepare_scan_count(pg_data_t *pgdat, =
struct scan_control *sc)
> >          * Flush the memory cgroup stats, so that we read accurate per-=
memcg
> >          * lruvec stats for heuristics.
> >          */
> > -       mem_cgroup_flush_stats_atomic();
> > +       mem_cgroup_flush_stats();
>
> I wonder if we should just replace this with
> mem_cgroup_flush_stats_ratelimited().

Thanks for taking a look!

I was hesitant about doing this because the flush call is inside the
retry loop, and it seems like we want to get fresh stats on each
retry. It seems very likely that we end up not flushing between
retries with mem_cgroup_flush_stats_ratelimited().

Maybe change it if we observe problems with non-atomic flushing?
