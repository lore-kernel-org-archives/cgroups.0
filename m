From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] selftests: memcg: uninitialized variable in test_memcg_reclaim()
Date: Tue, 19 Jul 2022 10:27:36 -0700
Message-ID: <CAJD7tkYCSY1C_iif4dxF9O3dAgZV4u8o9DFGsqeTyaq_FTT+mQ@mail.gmail.com>
References: <YtZ9Yu6HSQ2sT+O/@kili>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JGWTrJ/A2ihWU/Ug7aQjRrDit++Zh+gpJdGLbqVf1ag=;
        b=aQcLJHLSmAz57vMuBvrLAMuiJ9nsj6bTyOPDKgofJNdmDLyZvDjGqvPFf8eyewoclH
         l1l5WETYZVlZ8uJmvS1H1ti0C5X06q29fxB0wCYYKPJxZfRH94Xb1Mn5EMR6/0o1UY8j
         145zovNXLJSR4DnmMp+8wX78v/m524bvc3tJ+FzQf0nT7yT7yXfSyHDUUj3Hy0aaa4lA
         2P6GzyXXUlsVQ6hDfqddxLzfkhz8yvCLArXMHBH3qtEjNqAPGY+Meno0NzZjndBqiLbZ
         KocO65DubKojur00kb9JuLMzyBK5C5SHKSqew69Pcn4b2KCT1iox6ILhl/V1vBrI7fDX
         yCBg==
In-Reply-To: <YtZ9Yu6HSQ2sT+O/@kili>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Dan!

On Tue, Jul 19, 2022 at 2:46 AM Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>
> The "fd" is used on the clean up path without ever being initialized.
>
> Fixes: eae3cb2e87ff ("selftests: cgroup: add a selftest for memory.reclaim")

Thanks for fixing this :)

> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> I kind of went over kill on fixing this as if it were real code which
> matters.  :P
>
>  .../selftests/cgroup/test_memcontrol.c        | 23 +++++++++++--------
>  1 file changed, 13 insertions(+), 10 deletions(-)
>
> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
> index 8833359556f3..08681699c2f9 100644
> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> @@ -658,18 +658,18 @@ static int test_memcg_reclaim(const char *root)
>
>         memcg = cg_name(root, "memcg_test");
>         if (!memcg)
> -               goto cleanup;
> +               return KSFT_FAIL;

Nit: Just goto free here as well, free ignores NULLs anyway. It's
easier to have fewer return paths and more consistent with other
tests.

>
>         if (cg_create(memcg))
> -               goto cleanup;
> +               goto free_memcg;
>
>         current = cg_read_long(memcg, "memory.current");
>         if (current != 0)
> -               goto cleanup;
> +               goto destroy_memcg;
>
>         fd = get_temp_fd();
>         if (fd < 0)
> -               goto cleanup;
> +               goto destroy_memcg;
>
>         cg_run_nowait(memcg, alloc_pagecache_50M_noexit, (void *)(long)fd);
>
> @@ -697,7 +697,7 @@ static int test_memcg_reclaim(const char *root)
>                         fprintf(stderr,
>                                 "failed to allocate %ld for memcg reclaim test\n",
>                                 expected_usage);
> -                       goto cleanup;
> +                       goto close;
>                 }
>         }
>
> @@ -717,7 +717,7 @@ static int test_memcg_reclaim(const char *root)
>                  * not reclaim the full amount.
>                  */
>                 if (to_reclaim <= 0)
> -                       goto cleanup;
> +                       goto close;
>
>
>                 snprintf(buf, sizeof(buf), "%ld", to_reclaim);
> @@ -729,7 +729,7 @@ static int test_memcg_reclaim(const char *root)
>                          */
>                         current = cg_read_long(memcg, "memory.current");
>                         if (!values_close(current, MB(30), 3) && current > MB(30))
> -                               goto cleanup;
> +                               goto close;
>                         break;
>                 }
>
> @@ -738,14 +738,17 @@ static int test_memcg_reclaim(const char *root)
>                         continue;
>
>                 /* We got an unexpected error or ran out of retries. */
> -               goto cleanup;
> +               goto close;
>         }
>
>         ret = KSFT_PASS;
> -cleanup:
> +
> +close:
> +       close(fd);
> +destroy_memcg:
>         cg_destroy(memcg);
> +free_memcg:
>         free(memcg);
> -       close(fd);
>
>         return ret;
>  }

Nit: keep the cleanup_* naming for labels to make it obvious and to be
consistent with the rest of the file (e.g. cleanup_free,
cleanup_memcg, cleanup_file/cleanup_all). See
test_memcg_subtree_control().

I would honestly have one label to cleanup the memcg. Calling
cg_destroy() on a non-existent memcg should be fine. rmdir() will just
fail silently. All other tests do this and it's easier to read when we
have fewer return paths. My advice would be cleanup_file and
cleanup_memcg labels.

Thanks!

With these nits:
Reviewed-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

> --
> 2.35.1
>
