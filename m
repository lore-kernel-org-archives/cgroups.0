From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH -V3 3/8] hugetlb: add charge/uncharge calls for HugeTLB alloc/free
Date: Wed, 14 Mar 2012 15:52:28 +0530
Message-ID: <87wr6n8ot7.fsf@linux.vnet.ibm.com>
References: <1331622432-24683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331622432-24683-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <CAJd=RBAHYi-BOXBO+u0u9-C=35Lu=ow=L77w2WSsndUBxVKf9w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJd=RBAHYi-BOXBO+u0u9-C=35Lu=ow=L77w2WSsndUBxVKf9w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 13 Mar 2012 21:20:21 +0800, Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
> On Tue, Mar 13, 2012 at 3:07 PM, Aneesh Kumar K.V
> <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> > From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> >
> > This adds necessary charge/uncharge calls in the HugeTLB code
> >
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> > ---
> > =C2=A0mm/hugetlb.c =C2=A0 =C2=A0| =C2=A0 21 ++++++++++++++++++++-
> > =C2=A0mm/memcontrol.c | =C2=A0 =C2=A05 +++++
> > =C2=A02 files changed, 25 insertions(+), 1 deletions(-)
> >
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index fe7aefd..b7152d1 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -21,6 +21,8 @@
> > =C2=A0#include <linux/rmap.h>
> > =C2=A0#include <linux/swap.h>
> > =C2=A0#include <linux/swapops.h>
> > +#include <linux/memcontrol.h>
> > +#include <linux/page_cgroup.h>
> >
> > =C2=A0#include <asm/page.h>
> > =C2=A0#include <asm/pgtable.h>
> > @@ -542,6 +544,9 @@ static void free_huge_page(struct page *page)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(page_mapcount(page));
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0INIT_LIST_HEAD(&page->lru);
> >
> > + =C2=A0 =C2=A0 =C2=A0 if (mapping)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mem_cgroup_huget=
lb_uncharge_page(h - hstates,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0pages_per_huge_page(h), page);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock(&hugetlb_lock);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (h->surplus_huge_pages_node[nid] && h=
uge_page_order(h) < MAX_ORDER) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0update_and_f=
ree_page(h, page);
> > @@ -1019,12 +1024,15 @@ static void vma_commit_reservation(struct h=
state *h,
> > =C2=A0static struct page *alloc_huge_page(struct vm_area_struct *vm=
a,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long a=
ddr, int avoid_reserve)
> > =C2=A0{
> > + =C2=A0 =C2=A0 =C2=A0 int ret, idx;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct hstate *h =3D hstate_vma(vma);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct page *page;
> > + =C2=A0 =C2=A0 =C2=A0 struct mem_cgroup *memcg =3D NULL;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct address_space *mapping =3D vma->v=
m_file->f_mapping;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct inode *inode =3D mapping->host;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0long chg;
> >
> > + =C2=A0 =C2=A0 =C2=A0 idx =3D h - hstates;
>=20
> Better if hstate index is computed with a tiny inline helper?
> Other than that,

Will update in the next iteration.

>=20
> Acked-by: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>=20

-aneesh
