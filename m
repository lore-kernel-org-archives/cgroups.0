From: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH 5/9 v2] move charges to root at rmdir if
 use_hierarchy is unset
Date: Fri, 27 Apr 2012 12:12:52 -0700
Message-ID: <CALWz4ixHGCqfWh1U+JyiJWTkGmCDtXQy1vbHRjrHaU_pOgGuBw@mail.gmail.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
	<4F9A359C.10107@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding:x-system-of-record;
        bh=PVBKkhnYKW7/BdPh8lScWnngwp0Mc1m38gJhelvekWE=;
        b=CDOgxEnSvcC2+gH7szFoIVcslofAfjwf2/tao7Ut4APArmovMDiBENL4wG56GNoUFR
         Of6JqQr09+UdjdKKW8q6aQKNsjjM7bECab8yWnix3XHI0/keDaXlamVkwO9Xo7yaMRwz
         InSxIja52x6ubVK2GNOqbUSVSWuPiWRAoY1vXvhaxNuulHEfeeriazfy2pBcCveIKMxP
         FCRJ31CNQqe+7vD76ip2YJcpMEuML+lRD/+mWUiA2GOnQ+Xo4SeCEo/q6nqT721mpK33
         Ff2MRtJm/lq5nVzxnX80XD7ZuKOwUTyvDCBRrLN6p6/mYdk0L+sTkYKlwXhgKyibXrgR
         2SQQ==
In-Reply-To: <4F9A359C.10107-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Thu, Apr 26, 2012 at 10:58 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
> Now, at removal of cgroup, ->pre_destroy() is called and move charges
> to the parent cgroup. A major reason of -EBUSY returned by ->pre_dest=
roy()
> is that the 'moving' hits parent's resource limitation. It happens on=
ly
> when use_hierarchy=3D0. This was a mistake of original design.(it's m=
e...)

Nice patch, i can see how broken it is now with use_hierarchy=3D0...

nitpick on the documentation below:

>
> Considering use_hierarchy=3D0, all cgroups are treated as flat. So, n=
o one
> cannot justify moving charges to parent...parent and children are in
> flat configuration, not hierarchical.
>
> This patch modifes to move charges to root cgroup at rmdir/force_empt=
y
> if use_hierarchy=3D=3D0. This will much simplify rmdir() and reduce e=
rror
> in ->pre_destroy.
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> ---
> =A0Documentation/cgroups/memory.txt | =A0 12 ++++++----
> =A0mm/memcontrol.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 39 ++++++=
+++++++------------------------
> =A02 files changed, 21 insertions(+), 30 deletions(-)
>
> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups=
/memory.txt
> index 54c338d..82ce1ef 100644
> --- a/Documentation/cgroups/memory.txt
> +++ b/Documentation/cgroups/memory.txt
> @@ -393,14 +393,14 @@ cgroup might have some charge associated with i=
t, even though all
> =A0tasks have migrated away from it. (because we charge against pages=
, not
> =A0against tasks.)
>
> -Such charges are freed or moved to their parent. At moving, both of =
RSS
> -and CACHES are moved to parent.
> -rmdir() may return -EBUSY if freeing/moving fails. See 5.1 also.
> +Such charges are freed or moved to their parent if use_hierarchy=3D1=
=2E
> +if use_hierarchy=3D0, the charges will be moved to root cgroup.

It is more clear that we move the stats to root (if use_hierarchy=3D=3D=
0)
or parent (if use_hierarchy=3D=3D1), and no change on the charge except
uncharging from the child.

--Ying

>
> =A0Charges recorded in swap information is not updated at removal of =
cgroup.
> =A0Recorded information is discarded and a cgroup which uses swap (sw=
apcache)
> =A0will be charged as a new owner of it.
>
> +About use_hierarchy, see Section 6.
>
> =A05. Misc. interfaces.
>
> @@ -413,13 +413,15 @@ will be charged as a new owner of it.
>
> =A0 Almost all pages tracked by this memory cgroup will be unmapped a=
nd freed.
> =A0 Some pages cannot be freed because they are locked or in-use. Suc=
h pages are
> - =A0moved to parent and this cgroup will be empty. This may return -=
EBUSY if
> - =A0VM is too busy to free/move all pages immediately.
> + =A0moved to parent(if use_hierarchy=3D=3D1) or root (if use_hierarc=
hy=3D=3D0) and this
> + =A0cgroup will be empty.
>
> =A0 Typical use case of this interface is that calling this before rm=
dir().
> =A0 Because rmdir() moves all pages to parent, some out-of-use page c=
aches can be
> =A0 moved to the parent. If you want to avoid that, force_empty will =
be useful.
>
> + =A0About use_hierarchy, see Section 6.
> +
> =A05.2 stat file
>
> =A0memory.stat file includes following statistics
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ed53d64..62200f1 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2695,32 +2695,23 @@ static int mem_cgroup_move_parent(struct page=
 *page,
> =A0 =A0 =A0 =A0nr_pages =3D hpage_nr_pages(page);
>
> =A0 =A0 =A0 =A0parent =3D mem_cgroup_from_cont(pcg);
> - =A0 =A0 =A0 if (!parent->use_hierarchy) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D __mem_cgroup_try_charge(NULL,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 gfp_mask, nr_pages, &parent, false);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto put_back;
> - =A0 =A0 =A0 }
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* if use_hierarchy=3D=3D0, move charges to root cgro=
up.
> + =A0 =A0 =A0 =A0* in root cgroup, we don't touch res_counter
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (!parent->use_hierarchy)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 parent =3D root_mem_cgroup;
>
> =A0 =A0 =A0 =A0if (nr_pages > 1)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flags =3D compound_lock_irqsave(page);
>
> - =A0 =A0 =A0 if (parent->use_hierarchy) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D mem_cgroup_move_account(page, n=
r_pages,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 pc, child, parent, false);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ret)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __mem_cgroup_cancel_loc=
al_charge(child, nr_pages);
> - =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D mem_cgroup_move_account(page, n=
r_pages,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 pc, child, parent, true);
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __mem_cgroup_cancel_cha=
rge(parent, nr_pages);
> - =A0 =A0 =A0 }
> + =A0 =A0 =A0 ret =3D mem_cgroup_move_account(page, nr_pages,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pc, chi=
ld, parent, false);
> + =A0 =A0 =A0 if (!ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 __mem_cgroup_cancel_local_charge(child,=
 nr_pages);
>
> =A0 =A0 =A0 =A0if (nr_pages > 1)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0compound_unlock_irqrestore(page, flags=
);
> -put_back:
> =A0 =A0 =A0 =A0putback_lru_page(page);
> =A0put:
> =A0 =A0 =A0 =A0put_page(page);
> @@ -3338,12 +3329,10 @@ int mem_cgroup_move_hugetlb_parent(int idx, s=
truct cgroup *cgroup,
> =A0 =A0 =A0 =A0csize =3D PAGE_SIZE << compound_order(page);
> =A0 =A0 =A0 =A0/* If parent->use_hierarchy =3D=3D 0, we need to charg=
e parent */
> =A0 =A0 =A0 =A0if (!parent->use_hierarchy) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D res_counter_charge(&parent->hug=
epage[idx],
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0csize, &fail_res);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -EBUSY;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err_out;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 parent =3D root_mem_cgroup;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* root has no limit */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 res_counter_charge_nofail(&parent->huge=
page[idx],
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0csiz=
e, &fail_res);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0counter =3D &memcg->hugepage[idx];
> =A0 =A0 =A0 =A0res_counter_uncharge_until(counter, counter->parent, c=
size);
> --
> 1.7.4.1
>
>
