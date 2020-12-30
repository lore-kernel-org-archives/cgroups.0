From: Muchun Song <smuchun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: fix: Uninitialized variable ret.
Date: Wed, 30 Dec 2020 15:10:25 +0800
Message-ID: <CAPSr9jG53xF=9BEYe4phGuyPK7yrtCB57mDwRHzb0s7ic2sGyA@mail.gmail.com>
References: <1609311551-97108-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dz6zakxhTN9+Hb27qzL2JoTPTR2hDJy3fnAhKgXSzDc=;
        b=gwEYQaCoHeTnnujhW9VMYcJPWPdfkrdzbsXXYBFkSRNkwo8LO5odYwzd841ttNPBA2
         YII/xF3VBYOs8HCqKxa4xEosWWTj76HlHJONYDiLzDOJAGWrNdWZYL3RU9Or+h2exMtW
         SeNnhSt4CAOPu8t3qcLsgqv3APCvREgULe5xYGFpxni60+76S82TohUATfKXCW0JuluD
         eAhyPregxgTVbPwlNyH0/hQR8YEYIxEMxlx714UupvIUoGkmWJ8g1UrNO5plyirkQ1rS
         dO4VfnNV3uvA6Wl9q5wgXjvj4rHvfvlpjG3dXpowyy5pplI8Qc+Z+FNkJobsYaZ4cNrH
         H3oQ==
In-Reply-To: <1609311551-97108-1-git-send-email-abaci-bugfix-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: YANG LI <abaci-bugfix-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

YANG LI <abaci-bugfix-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> =E4=BA=8E2020=E5=B9=B412=E6=9C=883=
0=E6=97=A5=E5=91=A8=E4=B8=89 =E4=B8=8B=E5=8D=883:02=E5=86=99=E9=81=93=EF=BC=
=9A
>
> The ret is being used but it isn't being initialized,
> need to assign a value to it, like 0.

Hi Yang,

I didn't see where it was used without initialized.
Can you point that out to me?

Thanks.


>
> Signed-off-by: YANG LI <abaci-bugfix-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Reported-by: Abaci <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 605f671..15ba17d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3366,7 +3366,7 @@ static int mem_cgroup_resize_max(struct mem_cgroup =
*memcg,
>  {
>         bool enlarge =3D false;
>         bool drained =3D false;
> -       int ret;
> +       int ret =3D 0;
>         bool limits_invariant;
>         struct page_counter *counter =3D memsw ? &memcg->memsw : &memcg->=
memory;
>
> --
> 1.8.3.1
>
