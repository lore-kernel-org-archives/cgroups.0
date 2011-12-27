From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 3/6] memcg: remove unused variable
Date: Tue, 27 Dec 2011 15:08:09 +0100
Message-ID: <20111227140809.GM5344@tiehlicka.suse.cz>
References: <1324695619-5537-1-git-send-email-kirill@shutemov.name>
 <1324695619-5537-3-git-send-email-kirill@shutemov.name>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1324695619-5537-3-git-send-email-kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Sat 24-12-11 05:00:16, Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
>=20
> mm/memcontrol.c: In function =E2=80=98mc_handle_file_pte=E2=80=99:
> mm/memcontrol.c:5206:16: warning: variable =E2=80=98inode=E2=80=99 se=
t but not used [-Wunused-but-set-variable]
>=20
> Signed-off-by: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>

Looks good.
Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Thanks!
> ---
>  mm/memcontrol.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>=20
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4bac3a2..627c19e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5203,7 +5203,6 @@ static struct page *mc_handle_file_pte(struct v=
m_area_struct *vma,
>  			unsigned long addr, pte_t ptent, swp_entry_t *entry)
>  {
>  	struct page *page =3D NULL;
> -	struct inode *inode;
>  	struct address_space *mapping;
>  	pgoff_t pgoff;
> =20
> @@ -5212,7 +5211,6 @@ static struct page *mc_handle_file_pte(struct v=
m_area_struct *vma,
>  	if (!move_file())
>  		return NULL;
> =20
> -	inode =3D vma->vm_file->f_path.dentry->d_inode;
>  	mapping =3D vma->vm_file->f_mapping;
>  	if (pte_none(ptent))
>  		pgoff =3D linear_page_index(vma, addr);
> --=20
> 1.7.7.3
>=20

--=20
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9   =20
Czech Republic
