From: Souptick Joarder <jrdr.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: Assign boolean values to a bool variable
Date: Sat, 7 Nov 2020 13:58:47 +0530
Message-ID: <CAFqt6zZXEiS7dY+Y2OPXQ=DX=9gXMGpXGrvKCMrSq5qRwpvu5g@mail.gmail.com>
References: <1604737495-6418-1-git-send-email-kaixuxia@tencent.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1Vd93WrgVvvPOFnm9XWhutuIS0jTqt2s/2KmuTAC+LQ=;
        b=A+VYWsiKxRJhotjCN437Jq9UVFfSxHy1z8zL4GFSmFJkbyG4P9QCLVXLXa/q7YXPGg
         pln9mI3nJ4oWPbMTR2Sd+hTcybayJu3ipyZ5hrtbjHfKzE8Ki3FqWnEmeFeV717fy4Ii
         Nc5Gg9vY5gIWDQZtBjLr46tbdu+ssiG3+CWnZxZWLHJxyHpU6PwTnD2ELwjLNBBUyjHj
         wlB16etOYEhoertjV9HJwhsIHLUeL8e1frqowc2JFdVlX39PvMLN7IYa+g3yhCGK9Ip6
         7psSMg3QkyzsGk0Mtl9sfRt33+/zWUVMroh/K53lz+DTh/EYxXP4MrM/PKfzLvnAuz2v
         Ic8w==
In-Reply-To: <1604737495-6418-1-git-send-email-kaixuxia-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: xiakaixu1987-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kaixu Xia <kaixuxia-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

On Sat, Nov 7, 2020 at 1:55 PM <xiakaixu1987-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> From: Kaixu Xia <kaixuxia-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
>
> Fix the following coccinelle warnings:
>
> ./mm/memcontrol.c:7341:2-22: WARNING: Assignment of 0/1 to bool variable
> ./mm/memcontrol.c:7343:2-22: WARNING: Assignment of 0/1 to bool variable
>
> Reported-by: Tosk Robot <tencent_os_robot-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Kaixu Xia <kaixuxia-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Acked-by: Souptick Joarder <jrdr.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

> ---
>  mm/memcontrol.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 3dcbf24d2227..60147cf9f0c0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -7349,9 +7349,9 @@ bool mem_cgroup_swap_full(struct page *page)
>  static int __init setup_swap_account(char *s)
>  {
>         if (!strcmp(s, "1"))
> -               cgroup_memory_noswap = 0;
> +               cgroup_memory_noswap = false;
>         else if (!strcmp(s, "0"))
> -               cgroup_memory_noswap = 1;
> +               cgroup_memory_noswap = true;
>         return 1;
>  }
>  __setup("swapaccount=", setup_swap_account);
> --
> 2.20.0
>
>
