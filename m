From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 5/5] tests/cgroup: test cgroup.kill
Date: Wed, 5 May 2021 20:52:24 +0200
Message-ID: <20210505185224.zjfunx5wetgp6a2f@wittgenstein>
References: <20210503143922.3093755-1-brauner@kernel.org>
 <20210503143922.3093755-5-brauner@kernel.org>
 <CALvZod58WX-YpX_eSJzDyYknZiV5GzOe1wnKL8Pk4qMkq+oBQQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALvZod58WX-YpX_eSJzDyYknZiV5GzOe1wnKL8Pk4qMkq+oBQQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, containers-cunTk1MwBs/YUNznpcFYbw@public.gmane.org

On Wed, May 05, 2021 at 11:34:41AM -0700, Shakeel Butt wrote:
> On Mon, May 3, 2021 at 7:40 AM Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> [...]
> > +
> > +static int test_cgkill_simple(const char *root)
> > +{
> > +       pid_t pids[100];
> > +       int ret = KSFT_FAIL;
> > +       char *cgroup = NULL;
> > +       int i;
> > +
> > +       cgroup = cg_name(root, "cg_test_simple");
> > +       if (!cgroup)
> > +               goto cleanup;
> > +
> > +       if (cg_create(cgroup))
> > +               goto cleanup;
> > +
> > +       for (i = 0; i < 100; i++)
> > +               pids[i] = cg_run_nowait(cgroup, child_fn, NULL);
> > +
> > +       if (cg_wait_for_proc_count(cgroup, 100))
> > +               goto cleanup;
> > +
> > +        if (cg_write(cgroup, "cgroup.kill", "1"))
> > +               goto cleanup;
> 
> I don't think the above write to cgroup.kill is correct.

Hm, that's a left-over from the port of the similar freezer test. Thanks
for spotting this. It never failed because of the number of procs being
created and then killed most likely.

Thanks, will remove.
Christian
