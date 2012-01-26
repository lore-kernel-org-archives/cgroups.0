From: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] [PATCH 4/7 v2] memcg: new scheme to update per-memcg page
 stat accounting.
Date: Thu, 26 Jan 2012 11:01:32 -0800
Message-ID: <CALWz4izcvRGe2wBsthhhp3eW4rS=shW1wcZG3DW1=2skeaHmog@mail.gmail.com>
References: <20120113173001.ee5260ca.kamezawa.hiroyu@jp.fujitsu.com>
	<20120113174138.ec7b64d9.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:x-system-of-record:content-type:content-transfer-encoding;
        bh=8/wRc3D5DIJXq9cBvEi/XAw1o68Kwr8t1VD1I2HsDZQ=;
        b=j7AmkR5rlT5s5j0EWYe/wSOXhCFnKvsQG2/TLROTqImweHG470wSX5xOpSepHy4PZy
         sua4JBGEl5+JHAdAvL8+eR0ByvBh6wECTDHLh3/vvcuGZs7JH8YmOcquhEAUlNQh+2GD
         F81/KGBtuTy+DleV4AC6iqg4siAxV9MF09NfA=
In-Reply-To: <20120113174138.ec7b64d9.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org" <hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Fri, Jan 13, 2012 at 12:41 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
> From 08a81022fa6f820a42aa5bf3a24ee07690dfff99 Mon Sep 17 00:00:00 200=
1
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Date: Thu, 12 Jan 2012 18:13:32 +0900
> Subject: [PATCH 4/7] memcg: new scheme to update per-memcg page stat =
accounting.
>
> Now, page status accounting is done by a call mem_cgroup_update_page_=
stat()
nitpick, /by a call/by calling

> and this function set flags to page_cgroup->flags.
>
> This flag was required because the page's status and page <=3D> memcg
> relationship cannot be updated in atomic way.

I assume we are talking about the PCG_FILE_MAPPED flag, can we make it
specific here?

=46or example,
> Considering FILE_MAPPED,
>
> =A0 =A0 =A0 =A0CPU A =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CPU B
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pick u=
p a page to be moved.
> =A0 =A0set page_mapcount()=3D0.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0move m=
emcg' FILE_MAPPED stat --(*)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0overwr=
ite pc->mem_cgroup
> =A0 =A0modify memcg's FILE_MAPPED-(**)
>
> If we don't have a flag on pc->flags, we'll not move 'FILE_MAPPED'
> account information in (*) and we'll decrease FILE_MAPPED in (**)
> from wrong cgroup. We'll see this kind of race at handling
> dirty, writeback...etc..bits. (And Dirty flag has another problem
> which cannot be handled by flag on page_cgroup.)
>
> I'd like to remove this flag because
> =A0- In recent discussions, removing pc->flags is our direction.
> =A0- This kind of duplication of flag/status is very bad and
> =A0 it's better to use status in 'struct page'.
>
> This patch is for removing page_cgroup's special flag for
> page-state accounting and for using 'struct page's status itself.

I think this patch itself doesn't remove any pc flags. I believe it is
on the following patch, which removes the PCG_FILE_MAPPED flag.

>
> This patch adds an atomic update support of page statistics accountin=
g
> in memcg. In short, it prevents a page from being moved from a memcg
> to another while updating page status by...
>
> =A0 =A0 =A0 =A0locked =3D mem_cgroup_begin_update_page_stat(page)
> =A0 =A0 =A0 =A0modify page
> =A0 =A0 =A0 =A0mem_cgroup_update_page_stat(page)
> =A0 =A0 =A0 =A0mem_cgroup_end_update_page_stat(page, locked)
>
> While begin_update_page_stat() ... end_update_page_stat(),
> the page_cgroup will never be moved to other memcg.

This is nice.

In general, the description needs some work and it isn't clear to me
what this patch does at the first glance.

--Ying

>
> In usual case, overhead is rcu_read_lock() and rcu_read_unlock(),
> lookup_page_cgroup().
>
> Note:
> =A0- I still now considering how to reduce overhead of this scheme.
> =A0 Good idea is welcomed.
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> ---
> =A0include/linux/memcontrol.h | =A0 36 ++++++++++++++++++++++++++++++=
++++
> =A0mm/memcontrol.c =A0 =A0 =A0 =A0 =A0 =A0| =A0 46 ++++++++++++++++++=
++++++++-----------------
> =A0mm/rmap.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 14 +++++++++++-
> =A03 files changed, 76 insertions(+), 20 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 4d34356..976b58c 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -141,9 +141,35 @@ static inline bool mem_cgroup_disabled(void)
> =A0 =A0 =A0 =A0return false;
> =A0}
>
> +/*
> + * When we update page->flags,' we'll update some memcg's counter.
> + * Unlike vmstat, memcg has per-memcg stats and page-memcg relations=
hip
> + * can be changed while 'struct page' information is updated.
> + * We need to prevent the race by
> + * =A0 =A0 locked =3D mem_cgroup_begin_update_page_stat(page)
> + * =A0 =A0 modify 'page'
> + * =A0 =A0 mem_cgroup_update_page_stat(page, idx, val)
> + * =A0 =A0 mem_cgroup_end_update_page_stat(page, locked);
> + */
> +bool __mem_cgroup_begin_update_page_stat(struct page *page);
> +static inline bool mem_cgroup_begin_update_page_stat(struct page *pa=
ge)
> +{
> + =A0 =A0 =A0 if (mem_cgroup_disabled())
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return false;
> + =A0 =A0 =A0 return __mem_cgroup_begin_update_page_stat(page);
> +}
> =A0void mem_cgroup_update_page_stat(struct page *page,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 enum =
mem_cgroup_page_stat_item idx,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int v=
al);
> +void __mem_cgroup_end_update_page_stat(struct page *page, bool locke=
d);
> +static inline void
> +mem_cgroup_end_update_page_stat(struct page *page, bool locked)
> +{
> + =A0 =A0 =A0 if (mem_cgroup_disabled())
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 __mem_cgroup_end_update_page_stat(page, locked);
> +}
> +
>
> =A0static inline void mem_cgroup_inc_page_stat(struct page *page,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0enum mem_cgroup_page_stat_item idx)
> @@ -356,6 +382,16 @@ mem_cgroup_print_oom_info(struct mem_cgroup *mem=
cg, struct task_struct *p)
> =A0{
> =A0}
>
> +static inline bool mem_cgroup_begin_update_page_stat(struct page *pa=
ge)
> +{
> + =A0 =A0 =A0 return false;
> +}
> +
> +static inline void
> +mem_cgroup_end_update_page_stat(struct page *page, bool locked)
> +{
> +}
> +
> =A0static inline void mem_cgroup_inc_page_stat(struct page *page,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0enum mem_cgroup_page_stat_item idx)
> =A0{
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 61e276f..30ef810 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1912,29 +1912,43 @@ bool mem_cgroup_handle_oom(struct mem_cgroup =
*memcg, gfp_t mask)
> =A0* possibility of race condition. If there is, we take a lock.
> =A0*/
>
> +bool __mem_cgroup_begin_update_page_stat(struct page *page)
> +{
> + =A0 =A0 =A0 struct page_cgroup *pc =3D lookup_page_cgroup(page);
> + =A0 =A0 =A0 bool locked =3D false;
> + =A0 =A0 =A0 struct mem_cgroup *memcg;
> +
> + =A0 =A0 =A0 rcu_read_lock();
> + =A0 =A0 =A0 memcg =3D pc->mem_cgroup;
> +
> + =A0 =A0 =A0 if (!memcg || !PageCgroupUsed(pc))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 if (mem_cgroup_stealed(memcg)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mem_cgroup_account_move_rlock(page);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 locked =3D true;
> + =A0 =A0 =A0 }
> +out:
> + =A0 =A0 =A0 return locked;
> +}
> +
> +void __mem_cgroup_end_update_page_stat(struct page *page, bool locke=
d)
> +{
> + =A0 =A0 =A0 if (locked)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mem_cgroup_account_move_runlock(page);
> + =A0 =A0 =A0 rcu_read_unlock();
> +}
> +
> =A0void mem_cgroup_update_page_stat(struct page *page,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 enum =
mem_cgroup_page_stat_item idx, int val)
> =A0{
> - =A0 =A0 =A0 struct mem_cgroup *memcg;
> =A0 =A0 =A0 =A0struct page_cgroup *pc =3D lookup_page_cgroup(page);
> - =A0 =A0 =A0 bool need_unlock =3D false;
> + =A0 =A0 =A0 struct mem_cgroup *memcg =3D pc->mem_cgroup;
>
> =A0 =A0 =A0 =A0if (mem_cgroup_disabled())
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
>
> - =A0 =A0 =A0 rcu_read_lock();
> - =A0 =A0 =A0 memcg =3D pc->mem_cgroup;
> =A0 =A0 =A0 =A0if (unlikely(!memcg || !PageCgroupUsed(pc)))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> - =A0 =A0 =A0 /* pc->mem_cgroup is unstable ? */
> - =A0 =A0 =A0 if (unlikely(mem_cgroup_stealed(memcg))) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* take a lock against to access pc->me=
m_cgroup */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mem_cgroup_account_move_rlock(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 need_unlock =3D true;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcg =3D pc->mem_cgroup;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!memcg || !PageCgroupUsed(pc))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> - =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
>
> =A0 =A0 =A0 =A0switch (idx) {
> =A0 =A0 =A0 =A0case MEMCG_NR_FILE_MAPPED:
> @@ -1950,10 +1964,6 @@ void mem_cgroup_update_page_stat(struct page *=
page,
>
> =A0 =A0 =A0 =A0this_cpu_add(memcg->stat->count[idx], val);
>
> -out:
> - =A0 =A0 =A0 if (unlikely(need_unlock))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mem_cgroup_account_move_runlock(page);
> - =A0 =A0 =A0 rcu_read_unlock();
> =A0 =A0 =A0 =A0return;
> =A0}
> =A0EXPORT_SYMBOL(mem_cgroup_update_page_stat);
> diff --git a/mm/rmap.c b/mm/rmap.c
> index aa547d4..def60d1 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1150,10 +1150,13 @@ void page_add_new_anon_rmap(struct page *page=
,
> =A0*/
> =A0void page_add_file_rmap(struct page *page)
> =A0{
> + =A0 =A0 =A0 bool locked =3D mem_cgroup_begin_update_page_stat(page)=
;
> +
> =A0 =A0 =A0 =A0if (atomic_inc_and_test(&page->_mapcount)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__inc_zone_page_state(page, NR_FILE_MA=
PPED);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mem_cgroup_inc_page_stat(page, MEMCG_N=
R_FILE_MAPPED);
> =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 mem_cgroup_end_update_page_stat(page, locked);
> =A0}
>
> =A0/**
> @@ -1164,10 +1167,14 @@ void page_add_file_rmap(struct page *page)
> =A0*/
> =A0void page_remove_rmap(struct page *page)
> =A0{
> + =A0 =A0 =A0 bool locked =3D false;
> +
> + =A0 =A0 =A0 if (!PageAnon(page))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 locked =3D mem_cgroup_begin_update_page=
_stat(page);
> +
> =A0 =A0 =A0 =A0/* page still mapped by someone else? */
> =A0 =A0 =A0 =A0if (!atomic_add_negative(-1, &page->_mapcount))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> -
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * Now that the last pte has gone, s390 must transfer =
dirty
> =A0 =A0 =A0 =A0 * flag from storage key to struct page. =A0We can usu=
ally skip
> @@ -1204,6 +1211,9 @@ void page_remove_rmap(struct page *page)
> =A0 =A0 =A0 =A0 * Leaving it set also helps swapoff to reinstate ptes
> =A0 =A0 =A0 =A0 * faster for those pages still in swapcache.
> =A0 =A0 =A0 =A0 */
> +out:
> + =A0 =A0 =A0 if (!PageAnon(page))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mem_cgroup_end_update_page_stat(page, l=
ocked);
> =A0}
>
> =A0/*
> --
> 1.7.4.1
>
>
