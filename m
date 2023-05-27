From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: remove unused macro for_each_e_css()
Date: Fri, 26 May 2023 20:55:49 -0700
Message-ID: <CAJD7tkbY0kXbb3r3ObgOjmSa5kmw7n1uhN=Opvumty3=i9Ev0g@mail.gmail.com>
References: <20230527093353.153078-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685159785; x=1687751785;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zcxx+uBeHJ8GiGdDOZOOVVIqwP9cLUm7L1SVeB9sLvM=;
        b=xE6160P9Zr4wEkT61Vr5IkbHXpmY1HjWeK774oQn5uOLjZ2QEShy9mhrvVb4HqrxNS
         Z6YAg0LrJSUZi4tWr0CbVwQP+J5RhaPpDHoV4HUQHCB33J/wh1mvABD2dO+suyipiw9p
         QCz+GmmD3/0o1Pyp7lX+CznaXnTzdYR0Id4oWQEPZ5F2ga6slqiCNJPehrr+OrqLM2d1
         Whe/YslfEdc084vxdVSFYv/Jl+2Z69RrvRZpAXfhZZiPq2ClZnt9quqrkENE6BIROcRp
         P+9RUjet0hlHRR4Qtj6bY4XtxobK8M7zWElCDxcqPoakr+NiUD5EL3rinGOj0K2M14QT
         nKRg==
In-Reply-To: <20230527093353.153078-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, May 26, 2023 at 6:43=E2=80=AFPM Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> w=
rote:
>
> for_each_e_css() is unused now. Remove it.
>
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

LGTM. I can't see any references in Linus's tree or mm-unstable.

Reviewed-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

> ---
>  kernel/cgroup/cgroup.c | 15 ---------------
>  1 file changed, 15 deletions(-)
>
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 625d7483951c..413b4f1f1b70 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -689,21 +689,6 @@ EXPORT_SYMBOL_GPL(of_css);
>                                 lockdep_is_held(&cgroup_mutex)))) { }   \
>                 else
>
> -/**
> - * for_each_e_css - iterate all effective css's of a cgroup
> - * @css: the iteration cursor
> - * @ssid: the index of the subsystem, CGROUP_SUBSYS_COUNT after reaching=
 the end
> - * @cgrp: the target cgroup to iterate css's of
> - *
> - * Should be called under cgroup_[tree_]mutex.
> - */
> -#define for_each_e_css(css, ssid, cgrp)                                 =
           \
> -       for ((ssid) =3D 0; (ssid) < CGROUP_SUBSYS_COUNT; (ssid)++)       =
     \
> -               if (!((css) =3D cgroup_e_css_by_mask(cgrp,               =
     \
> -                                                  cgroup_subsys[(ssid)])=
)) \
> -                       ;                                                =
   \
> -               else
> -
>  /**
>   * do_each_subsys_mask - filter for_each_subsys with a bitmask
>   * @ss: the iteration cursor
> --
> 2.27.0
>
