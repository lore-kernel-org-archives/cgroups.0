From: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/7] per-cgroup slab caches
Date: Tue, 21 Feb 2012 15:50:32 -0800
Message-ID: <CABCjUKAmjGS1j6kNgj8it_QZSPKJiCmgpme6BTxAGkoJ=DSR7w@mail.gmail.com>
References: <1329824079-14449-1-git-send-email-glommer@parallels.com>
	<1329824079-14449-4-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding:x-system-of-record;
        bh=jfkrjG37rtLjfMAV8UoBezc6ycZ/3P/Aln0U4OC90C4=;
        b=v28wztWssmPc/2BETA+kudn8tmJny0pORa4+B8/1mQSUdA93oqm853m1LvEiDpvvUE
         NpUnabLmno9eIWMfCdDzGL6rtnltqA+k2wGOyDIcmL1Cf5DYV8x20RYNEhZ4iXprmUZq
         1wyQLgR9Xx4velTgBwXdDT10x1wzOyE4/rpM8=
In-Reply-To: <1329824079-14449-4-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hiroyouki Kamezawa <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

On Tue, Feb 21, 2012 at 3:34 AM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> =
wrote:
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 26fda11..2aa35b0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> +struct kmem_cache *
> +kmem_cache_dup(struct mem_cgroup *memcg, struct kmem_cache *base)
> +{
> + =A0 =A0 =A0 struct kmem_cache *s;
> + =A0 =A0 =A0 unsigned long pages;
> + =A0 =A0 =A0 struct res_counter *fail;
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* TODO: We should use an ida-like index here, instea=
d
> + =A0 =A0 =A0 =A0* of the kernel address
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 char *kname =3D kasprintf(GFP_KERNEL, "%s-%p", base->na=
me, memcg);

Would it make more sense to use the memcg name instead of the pointer?

> +
> + =A0 =A0 =A0 WARN_ON(mem_cgroup_is_root(memcg));
> +
> + =A0 =A0 =A0 if (!kname)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
> +
> + =A0 =A0 =A0 s =3D kmem_cache_create_cg(memcg, kname, base->size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0base=
->align, base->flags, base->ctor);
> + =A0 =A0 =A0 if (WARN_ON(!s))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> +
> +
> + =A0 =A0 =A0 pages =3D slab_nr_pages(s);
> +
> + =A0 =A0 =A0 if (res_counter_charge(memcg_kmem(memcg), pages << PAGE=
_SHIFT, &fail)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kmem_cache_destroy(s);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 s =3D NULL;
> + =A0 =A0 =A0 }

What are we charging here? Does it ever get uncharged?

-- Suleiman
