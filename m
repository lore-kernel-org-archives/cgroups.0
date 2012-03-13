From: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -V3 1/8] hugetlb: rename max_hstate to hugetlb_max_hstate
Date: Tue, 13 Mar 2012 21:13:00 +0800
Message-ID: <CAJd=RBA+D0MyjwuCNp3WtKRq-d3F_t9rKHLgmyLhznhZ9HjG4g@mail.gmail.com>
References: <1331622432-24683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1331622432-24683-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=ByY1kKdMGle+XGnkpX9TGeK3t/z7G8Qo6Q5sDc3p/18=;
        b=Rv1CWds2gZTE38wU0H4q7f9/FY8flvcQdLt4IFd9JqQpE51wr4e7Apey41wYG1WGQT
         CiO1R90oBS6h1mkcqXeXTcLzLJWmj5XwD63NzVUtuT0v0nzdx6KO7eI0Cm8w8ArtJOFH
         atXFWLaKOlgxC0nJj4CZYLr4Bkys2JvWa105LlSgxjcpaBU4I6rOyeuVQ9E/lZA9gl9V
         WBu6JrQFqbJa4Bvy2U5AYgMyOaJrrI6iu3ob+motu9ChCEMgTf8wmrIQbIAkmFYbnjWh
         harmuCG8VM5i7V97yr7Ch0sRvJa2VqIiOyvUs/KqMAjo9/TuhwvukR+u9gTgntXoKpho
         xV6w==
In-Reply-To: <1331622432-24683-2-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Mar 13, 2012 at 3:07 PM, Aneesh Kumar K.V
<aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>
> We will be using this from other subsystems like memcg
> in later patches.
>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---

Acked-by: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

> =C2=A0mm/hugetlb.c | =C2=A0 14 +++++++-------
> =C2=A01 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 5f34bd8..d623e71 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -34,7 +34,7 @@ const unsigned long hugetlb_zero =3D 0, hugetlb_inf=
inity =3D ~0UL;
> =C2=A0static gfp_t htlb_alloc_mask =3D GFP_HIGHUSER;
> =C2=A0unsigned long hugepages_treat_as_movable;
>
> -static int max_hstate;
> +static int hugetlb_max_hstate;
> =C2=A0unsigned int default_hstate_idx;
> =C2=A0struct hstate hstates[HUGE_MAX_HSTATE];
>
> @@ -46,7 +46,7 @@ static unsigned long __initdata default_hstate_max_=
huge_pages;
> =C2=A0static unsigned long __initdata default_hstate_size;
>
> =C2=A0#define for_each_hstate(h) \
> - =C2=A0 =C2=A0 =C2=A0 for ((h) =3D hstates; (h) < &hstates[max_hstat=
e]; (h)++)
> + =C2=A0 =C2=A0 =C2=A0 for ((h) =3D hstates; (h) < &hstates[hugetlb_m=
ax_hstate]; (h)++)
>
> =C2=A0/*
> =C2=A0* Protects updates to hugepage_freelists, nr_huge_pages, and fr=
ee_huge_pages
> @@ -1808,9 +1808,9 @@ void __init hugetlb_add_hstate(unsigned order)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printk(KERN_WA=
RNING "hugepagesz=3D specified twice, ignoring\n");
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> - =C2=A0 =C2=A0 =C2=A0 BUG_ON(max_hstate >=3D HUGE_MAX_HSTATE);
> + =C2=A0 =C2=A0 =C2=A0 BUG_ON(hugetlb_max_hstate >=3D HUGE_MAX_HSTATE=
);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(order =3D=3D 0);
> - =C2=A0 =C2=A0 =C2=A0 h =3D &hstates[max_hstate++];
> + =C2=A0 =C2=A0 =C2=A0 h =3D &hstates[hugetlb_max_hstate++];
> =C2=A0 =C2=A0 =C2=A0 =C2=A0h->order =3D order;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0h->mask =3D ~((1ULL << (order + PAGE_SHIFT=
)) - 1);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0h->nr_huge_pages =3D 0;
> @@ -1831,10 +1831,10 @@ static int __init hugetlb_nrpages_setup(char =
*s)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0static unsigned long *last_mhp;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0* !max_hstate means we haven't parsed a =
hugepagesz=3D parameter yet,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* !hugetlb_max_hstate means we haven't p=
arsed a hugepagesz=3D parameter yet,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * so this hugepages=3D parameter goes to =
the "default hstate".
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> - =C2=A0 =C2=A0 =C2=A0 if (!max_hstate)
> + =C2=A0 =C2=A0 =C2=A0 if (!hugetlb_max_hstate)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mhp =3D &defau=
lt_hstate_max_huge_pages;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0else
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mhp =3D &parse=
d_hstate->max_huge_pages;
> @@ -1853,7 +1853,7 @@ static int __init hugetlb_nrpages_setup(char *s=
)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * But we need to allocate >=3D MAX_ORDER =
hstates here early to still
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * use the bootmem allocator.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> - =C2=A0 =C2=A0 =C2=A0 if (max_hstate && parsed_hstate->order >=3D MA=
X_ORDER)
> + =C2=A0 =C2=A0 =C2=A0 if (hugetlb_max_hstate && parsed_hstate->order=
 >=3D MAX_ORDER)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0hugetlb_hstate=
_alloc_pages(parsed_hstate);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0last_mhp =3D mhp;
> --
> 1.7.9
>
