From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 5/5] tests/cgroup: test cgroup.kill
Date: Wed, 5 May 2021 11:34:41 -0700
Message-ID: <CALvZod58WX-YpX_eSJzDyYknZiV5GzOe1wnKL8Pk4qMkq+oBQQ@mail.gmail.com>
References: <20210503143922.3093755-1-brauner@kernel.org> <20210503143922.3093755-5-brauner@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K5BbP+PQbZDrsW3Z0I2K54qvJu7T8OT3Rig60hvbO1U=;
        b=vsqKdvcVbJzePaO2Rdkii7+aVDG4GsKFVmMNGiJb3HJ/5dEyks73H4moEQib1EV6+A
         iHzoGwnjHsbOh0Fx60YpVgWrLdjLsXZozOLaCv2o9F+RvKD5gM3ENd+K7zwidkabXiQO
         ZcLZVb1qh9Q3myp39yWjYo34ivvZWA1CXzpBqsomjfPx0nAFVzPOLLTmomuP7FGIZu0y
         N+Uv01Eanyf2MW5nTNqzBKWf4wJKELwo/6qUM12Ffienqd/MdEtWZ6+/zXHCsHLOCVIv
         cqwGpNFnkJq588E3Wo9tvTByYl3d+DETyi/C3tG3NvDk8sXW0i0OrMA9Z+uPM14dhoL7
         ltPw==
In-Reply-To: <20210503143922.3093755-5-brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, containers-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

On Mon, May 3, 2021 at 7:40 AM Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
[...]
> +
> +static int test_cgkill_simple(const char *root)
> +{
> +       pid_t pids[100];
> +       int ret = KSFT_FAIL;
> +       char *cgroup = NULL;
> +       int i;
> +
> +       cgroup = cg_name(root, "cg_test_simple");
> +       if (!cgroup)
> +               goto cleanup;
> +
> +       if (cg_create(cgroup))
> +               goto cleanup;
> +
> +       for (i = 0; i < 100; i++)
> +               pids[i] = cg_run_nowait(cgroup, child_fn, NULL);
> +
> +       if (cg_wait_for_proc_count(cgroup, 100))
> +               goto cleanup;
> +
> +        if (cg_write(cgroup, "cgroup.kill", "1"))
> +               goto cleanup;

I don't think the above write to cgroup.kill is correct.

> +
> +       if (cg_read_strcmp(cgroup, "cgroup.events", "populated 1\n"))
> +               goto cleanup;
> +
> +       if (cg_kill_wait(cgroup))
> +               goto cleanup;
> +
> +       if (cg_read_strcmp(cgroup, "cgroup.events", "populated 0\n"))
> +               goto cleanup;
> +
> +       ret = KSFT_PASS;
> +
> +cleanup:
> +       for (i = 0; i < 100; i++)
> +               wait_for_pid(pids[i]);
> +
> +       if (cgroup)
> +               cg_destroy(cgroup);
> +       free(cgroup);
> +       return ret;
> +}
