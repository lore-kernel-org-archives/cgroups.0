From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 3/5] tests/cgroup: use cgroup.kill in cg_killall()
Date: Wed, 5 May 2021 09:42:08 -0700
Message-ID: <CALvZod6nTDc4Jx4UG3HKaugA1F_2N-rG+xqACAKVkKJjqxWOXg@mail.gmail.com>
References: <20210503143922.3093755-1-brauner@kernel.org> <20210503143922.3093755-3-brauner@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CZSxOum7tgcfufyRQ0ud4aq7JR1hA71f4tT5tJF5bAk=;
        b=Y2ETgANl3oMRKwl6lTT7wNph2JFAn/CkXrVJyf9nplhyQV+ERSGAfGrbICtcc3Pk79
         p2lfZZY816/lXdrvktWAGAerrc2sqMixaIzcCbHqZlhG2vnfMHN3hxvQaQxYdrwN1Koh
         Bw3HP2t+fmXF+uwtKQBJbzcf7Ptu6pFNTKjXuglYMC6Z/Eay9e/08lohNc8Z2CqoMzJw
         zcfBlcg828zoW052cHxSeu4wfWtk+WqxjJJ3d723hYhGLmSiQR0+rk207FC34o3W512D
         ToH8DVmgr3e/xYORr361TMepy4sigreWXlGhxRR58UffKENoodP/rjeBmd7L4spy/DC3
         Mr/g==
In-Reply-To: <20210503143922.3093755-3-brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, containers-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

On Mon, May 3, 2021 at 7:40 AM Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
>
> If cgroup.kill file is supported make use of it.
>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Signed-off-by: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

> ---
> /* v2 */
> - Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>:
>   - Fix whitespace.
> ---
>  tools/testing/selftests/cgroup/cgroup_util.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
> index 027014662fb2..f60f7d764690 100644
> --- a/tools/testing/selftests/cgroup/cgroup_util.c
> +++ b/tools/testing/selftests/cgroup/cgroup_util.c
> @@ -252,6 +252,10 @@ int cg_killall(const char *cgroup)
>         char buf[PAGE_SIZE];
>         char *ptr = buf;
>
> +       /* If cgroup.kill exists use it. */
> +       if (!cg_write(cgroup, "cgroup.kill", "1"))
> +               return 0;

Now cg_killall will kill all the processes in the tree rooted at
cgroup which I think is fine.

> +
>         if (cg_read(cgroup, "cgroup.procs", buf, sizeof(buf)))
>                 return -1;
>
> --
> 2.27.0
>
