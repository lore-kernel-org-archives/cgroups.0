From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 7/9] mm: Mark functions as static in page_cgroup.c
Date: Mon, 10 Feb 2014 09:23:24 +0100
Message-ID: <20140210082324.GA3204@dhcp22.suse.cz>
References: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com>
 <6054d570fc83c3d4f3de240d6da488f876e21450.1391167128.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=kjqMBvGdEXTtdP/QqkLou8dv2RMUEo8M8Bmsfv8Kn7M=;
        b=LVwa9P6lV4jB9mBzuZJ1cVc++5AjodZeRr1XA5GVhYMi59q2aJSKCSKK1uj4fJrJ4q
         w+EPl9qPJozUucuGRhizEKYxo0SeduJMUW0vlFfKuL9HKBiw3oI6BijNbskQGc6eeXKU
         9sH1sFzSqs5GhFhcf33BoNq+Y7fW3/QHyVulC8lwkEN4QLqk1OQ99CAbVYG3XmMgMUSM
         jEFQaBjrf1cu6C7XGy8Fsyl9P9j03xEFO+bnmRXkG2gz6tylYM5yKm51pRV3t1O0Tc+U
         Yml9JMcyqjILnp3itisk7PfMNA3V4NALpoirUBVfmluOqlUF/iLD9or8pVFmK3kJ4RXO
         8zng==
Content-Disposition: inline
In-Reply-To: <6054d570fc83c3d4f3de240d6da488f876e21450.1391167128.git.rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Rashika Kheria <rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-CkwikUCVwVsb1SvskN2V4Q@public.gmane.org

On Fri 07-02-14 17:41:34, Rashika Kheria wrote:
> Mark functions as static in page_cgroup.c because they are not used
> outside this file.
>=20
> This eliminates the following warning in mm/page_cgroup.c:
> mm/page_cgroup.c:177:6: warning: no previous prototype for =E2=80=98_=
_free_page_cgroup=E2=80=99 [-Wmissing-prototypes]
> mm/page_cgroup.c:190:15: warning: no previous prototype for =E2=80=98=
online_page_cgroup=E2=80=99 [-Wmissing-prototypes]
> mm/page_cgroup.c:225:15: warning: no previous prototype for =E2=80=98=
offline_page_cgroup=E2=80=99 [-Wmissing-prototypes]
>=20
> Signed-off-by: Rashika Kheria <rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  mm/page_cgroup.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
> index 6d757e3a..6ec349c 100644
> --- a/mm/page_cgroup.c
> +++ b/mm/page_cgroup.c
> @@ -174,7 +174,7 @@ static void free_page_cgroup(void *addr)
>  	}
>  }
> =20
> -void __free_page_cgroup(unsigned long pfn)
> +static void __free_page_cgroup(unsigned long pfn)
>  {
>  	struct mem_section *ms;
>  	struct page_cgroup *base;
> @@ -187,9 +187,9 @@ void __free_page_cgroup(unsigned long pfn)
>  	ms->page_cgroup =3D NULL;
>  }
> =20
> -int __meminit online_page_cgroup(unsigned long start_pfn,
> -			unsigned long nr_pages,
> -			int nid)
> +static int __meminit online_page_cgroup(unsigned long start_pfn,
> +				unsigned long nr_pages,
> +				int nid)
>  {
>  	unsigned long start, end, pfn;
>  	int fail =3D 0;
> @@ -222,8 +222,8 @@ int __meminit online_page_cgroup(unsigned long st=
art_pfn,
>  	return -ENOMEM;
>  }
> =20
> -int __meminit offline_page_cgroup(unsigned long start_pfn,
> -		unsigned long nr_pages, int nid)
> +static int __meminit offline_page_cgroup(unsigned long start_pfn,
> +				unsigned long nr_pages, int nid)
>  {
>  	unsigned long start, end, pfn;
> =20
> --=20
> 1.7.9.5
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>=20
>=20

--=20
Michal Hocko
SUSE Labs
