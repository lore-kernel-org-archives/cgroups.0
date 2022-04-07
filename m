From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 3/4] selftests: cgroup: fix alloc_anon_noexit()
 instantly freeing memory
Date: Thu, 7 Apr 2022 16:04:22 -0700
Message-ID: <CAJD7tkaPaXQ4M_w-YxJizD2DG8co-3Q2bVDfd7_FaG2ivgT6UA@mail.gmail.com>
References: <20220407224244.1374102-1-yosryahmed@google.com> <20220407224244.1374102-4-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LQwT+/mAGUqM3bKuuBQMYn0uTeyRqxSYD1X0xo7/rPE=;
        b=Te8C7q8zW+qLm4J/emex42n1YOTNTgYioZ6aL6jd2MEBaCBiG1MonTEaVigQYrxCnX
         lc2a1Zp9F/CS9bGuKEKpu93mdMYLs+lQfsbi5mhteuVgcuoJm0wqWfraYddXR8D2bRg6
         g80ZitZ42SJag/feMLrn8DX95l13h9byUhXsltGRKCs9KWV88T/Q6QdZkDXhfdleSkQe
         ryLxvSOK7GWWj6jsOpKFb2APmR0DtW+cvDsI5vs30igZtouAhcFKm2Hq3Ic2zZxJev/e
         Hyk2ptU132DXhvbF7YzTGVCDK2FzEn2yYfELqe296BiWwOwU5IvauV2Zbzna4r5BI7u0
         VEvQ==
In-Reply-To: <20220407224244.1374102-4-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chen Wandun <chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vaibhav Jain <vaibhav-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Huang-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel

On Thu, Apr 7, 2022 at 3:43 PM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> Currently, alloc_anon_noexit() calls alloc_anon() which instantly frees
> the allocated memory. alloc_anon_noexit() is usually used with
> cg_run_nowait() to run a process in the background that allocates
> memory. It makes sense for the background process to keep the memory
> allocated and not instantly free it (otherwise there is no point of
> running it in the background).
>
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  tools/testing/selftests/cgroup/test_memcontrol.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
> index 36ccf2322e21..c1ec71d83af7 100644
> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> @@ -211,13 +211,18 @@ static int alloc_pagecache_50M_noexit(const char *cgroup, void *arg)
>  static int alloc_anon_noexit(const char *cgroup, void *arg)
>  {
>         int ppid = getppid();
> +       size_t size = (unsigned long)arg;
> +       char *buf, *ptr;
>
> -       if (alloc_anon(cgroup, arg))
> -               return -1;
> +       buf = malloc(size);
> +       for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
> +               *ptr = 0;
>
>         while (getppid() == ppid)
>                 sleep(1);
>
> +       printf("Freeing buffer");

Hey Andew,

I am very sorry but I left a debugging printf there by mistake. If
it's no hassle, do you mind removing it from the patch (assuming I
won't need to send a v3 anyway)?

Thanks!

> +       free(buf);
>         return 0;
>  }
>
> --
> 2.35.1.1178.g4f1659d476-goog
>
