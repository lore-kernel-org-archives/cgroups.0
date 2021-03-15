From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 5/8] memcg: accounting for fasync_cache
Date: Mon, 15 Mar 2021 08:56:50 -0700
Message-ID: <CALvZod5GXkxUQyxzD-eL4QUhnoayVGTrBQPUC1iv+0LGnYJFzg@mail.gmail.com>
References: <YEnWUrYOArju66ym@dhcp22.suse.cz> <4eb97c88-b87c-6f6e-3960-b1a61b46d380@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QW3CaHPgPmHox0WmReW9hgPm5r4PklZYtPsrifaA0GA=;
        b=GjZCh6DFUHNU5yqp7BNiRmI5nNX7N06Cc8wlYDtW8nKcoLEQzliJpSJ0DNTWm7s5UQ
         OzI2H8rAP9fv6MJpkYit3y/f0XFYxBLyIXnpKCebIFhfyktgK8dZPqGym6ea4aVDL6Kt
         DxtRQD1wI/o0Oomu+p7cLF4egVxRsePMBgwr9wBG84sD8Lhxumbb0mx0zn9qSiH/qsmX
         V2Zb7Jn3ycpIGJLBNPdmAJDPohqgDpY1STomDkQzSSaVarcjO9KKT/Ol98VlrRn3U5fE
         Y1eNX+Q6GCCFYj3qC4KWyfVnypYssQIpMgwsMMSyLLsTEdtpPQxZxp7QLTHARscwqB+x
         4lUg==
In-Reply-To: <4eb97c88-b87c-6f6e-3960-b1a61b46d380-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>

On Mon, Mar 15, 2021 at 5:23 AM Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
>
> unprivileged user inside memcg-limited container can trigger
> creation of huge number of non-accounted fasync_struct objects

You need to make each patch of this series self-contained by including
the motivation behind the series (just one or two sentences). For
example, for this patch include what's the potential impact of these
huge numbers of unaccounted fasync_struct objects?

> ---
>  fs/fcntl.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/fcntl.c b/fs/fcntl.c
> index dfc72f1..7941559 100644
> --- a/fs/fcntl.c
> +++ b/fs/fcntl.c
> @@ -1049,7 +1049,8 @@ static int __init fcntl_init(void)
>                         __FMODE_EXEC | __FMODE_NONOTIFY));
>
>         fasync_cache = kmem_cache_create("fasync_cache",
> -               sizeof(struct fasync_struct), 0, SLAB_PANIC, NULL);
> +                                        sizeof(struct fasync_struct), 0,
> +                                        SLAB_PANIC | SLAB_ACCOUNT, NULL);
>         return 0;
>  }
>
> --
> 1.8.3.1
>
