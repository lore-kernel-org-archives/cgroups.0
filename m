From: Lukas Bulwahn <lukas.bulwahn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] docs: cgroup-v1: replace dead CONFIG_MEM_RES_CTRL_SWAP symbol
Date: Fri, 28 Jul 2023 13:00:18 +0200
Message-ID: <CAKXUXMzYyX9rz-=K=1YRRbpOAechRG4U+i5BbX8qagH2epTgXw@mail.gmail.com>
References: <20230728105723.251892-1-krzpaw@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690542030; x=1691146830;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2PDIAfFUsFD3vbVEGsI9j/0thKIcvauqk+miCMI9pQM=;
        b=EyPBQM6RQ+S/JnVzhATw135UHbUhW8+sWivasIl3uNELayYfb/H4HnRU39ec857gzw
         8A7rjGpjYCWQKiIx2Vg+q9vtj+kz9jskd2QF+yToV+zGB3t8+kJuPq4pSmChm3PGYPXl
         V8HL1aB1yXPxOOLgnA1akWOvRDGg5VYNnTHL+e0he1bhaIfkvWG4mbhnxmJrvccjQchU
         SEfgXTN6AwH3fH3Z2JtEAbJXfrEneognCK3lvrNMcy65uQXsyij04M5hs/d18x6EnT7I
         x2oKDDypouEfGRjiNPevP2O4xDEaIypQDU/3yRECJMsejHoem4HiHGu27dtX9a54Nqah
         N+dQ==
In-Reply-To: <20230728105723.251892-1-krzpaw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Krzysztof Pawlaczyk <krzpaw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jul 28, 2023 at 12:59=E2=80=AFPM Krzysztof Pawlaczyk <krzpaw@gmail.=
com> wrote:
>
> Commit e55b9f96860f ("mm: memcontrol: drop dead CONFIG_MEMCG_SWAP
> config symbol") removed MEMCG_SWAP as it was just a shorthand for
> CONFIG_MEMCG && CONFIG_SWAP.
>
> The commit also adjusted the documentation but missed reference to
> CONFIG_MEM_RES_CTRL_SWAP, which was the previous name of
> CONFIG_MEMCG_SWAP before renaming in commit c255a458055e ("memcg: rename
> config variables").
>
> Update the reference to the current state.
>

Thanks for the cleanup.

Reviewed-by: Lukas Bulwahn <lukas.bulwahn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Lukas

> Signed-off-by: Krzysztof Pawlaczyk <krzpaw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  Documentation/admin-guide/cgroup-v1/memcg_test.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/admin-guide/cgroup-v1/memcg_test.rst b/Documen=
tation/admin-guide/cgroup-v1/memcg_test.rst
> index a402359abb99..1f128458ddea 100644
> --- a/Documentation/admin-guide/cgroup-v1/memcg_test.rst
> +++ b/Documentation/admin-guide/cgroup-v1/memcg_test.rst
> @@ -62,7 +62,7 @@ Please note that implementation details can be changed.
>
>         At cancel(), simply usage -=3D PAGE_SIZE.
>
> -Under below explanation, we assume CONFIG_MEM_RES_CTRL_SWAP=3Dy.
> +Under below explanation, we assume CONFIG_SWAP=3Dy.
>
>  4. Anonymous
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --
> 2.25.1
>
