From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v4 3/9] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Tue, 19 Nov 2019 11:04:56 -0500
Message-ID: <20191119160456.GD382712@cmpxchg.org>
References: <1574166203-151975-1-git-send-email-alex.shi@linux.alibaba.com>
 <1574166203-151975-4-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=ERJD83QXVwqnYgYCzdb0bwkiShGx05+e+BAlf5zZbPQ=;
        b=diRMc+R/wv6O/zk5sdqMsYxdrOTmEtcK0piBIQlHb+EQf9wKsiMHHHi50G+BtrGxIp
         g8XHgXZ4v0DxazaNoJ7EPyK/XdKNVRXKTKahGH1S3OCcVJSD1f1j0CBDGEnMkQmBr18f
         5ZEe/pCPanQf8JN/v1mRs9ndYKZ7ySQWOozgfKll3FDFUTncarXPng3kASzB4s7lJllW
         S1yfmOkaJPz3MxL6xQwkHXy4hk10MW5mWKr+5VeSD3abLpxHDAVozL6iitP1R5gp/8iL
         3HXiy6FzPmMHX86MujgxMaCQn+LSk8cJs4Na3TUGePFMc08J7yCgWW+vk9Ipbt7W7sXr
         BIGA==
Content-Disposition: inline
In-Reply-To: <1574166203-151975-4-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, shakeelb@google.com, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, David Rientjes <rientjes@google.com>, Aneesh Ku

On Tue, Nov 19, 2019 at 08:23:17PM +0800, Alex Shi wrote:
> This patchset move lru_lock into lruvec, give a lru_lock for each of
> lruvec, thus bring a lru_lock for each of memcg per node.
>=20
> This is the main patch to replace per node lru_lock with per memcg
> lruvec lock.
>=20
> We introduce function lock_page_lruvec, it's same as vanilla pgdat lock
> when memory cgroup unset, w/o memcg, the function will keep repin the
> lruvec's lock to guard from page->mem_cgroup changes in page
> migrations between memcgs. (Thanks Hugh Dickins and Konstantin
> Khlebnikov reminder on this. Than the core logical is same as their
> previous patchs)
>=20
> According to Daniel Jordan's suggestion, I run 64 'dd' with on 32
> containers on my 2s* 8 core * HT box with the modefied case:
>   https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git/=
tree/case-lru-file-readtwice
>=20
> With this and later patches, the dd performance is 144MB/s, the vanilla
> kernel performance is 123MB/s. 17% performance increased.
>=20
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: Chris Down <chris@chrisdown.name>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Qian Cai <cai@lca.pw>
> Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
> Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Cc: "J=E9r=F4me Glisse" <jglisse@redhat.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Yang Shi <yang.shi@linux.alibaba.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
> Cc: swkhack <swkhack@gmail.com>
> Cc: "Potyra, Stefan" <Stefan.Potyra@elektrobit.com>
> Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Colin Ian King <colin.king@canonical.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Peng Fan <peng.fan@nxp.com>
> Cc: Nikolay Borisov <nborisov@suse.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
> Cc: Yafang Shao <laoar.shao@gmail.com>
> Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: cgroups@vger.kernel.org
> ---
>  include/linux/memcontrol.h | 24 +++++++++++++++
>  include/linux/mmzone.h     |  2 ++
>  mm/compaction.c            | 67 ++++++++++++++++++++++++++++-------------
>  mm/huge_memory.c           | 15 ++++------
>  mm/memcontrol.c            | 75 +++++++++++++++++++++++++++++++++++-----=
------
>  mm/mlock.c                 | 31 ++++++++++---------
>  mm/mmzone.c                |  1 +
>  mm/page_idle.c             |  5 ++--
>  mm/swap.c                  | 74 +++++++++++++++++++---------------------=
-----
>  mm/vmscan.c                | 58 +++++++++++++++++------------------
>  10 files changed, 214 insertions(+), 138 deletions(-)
>=20
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 5b86287fa069..9538253998a6 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -418,6 +418,10 @@ static inline struct lruvec *mem_cgroup_lruvec(struc=
t mem_cgroup *memcg,
> =20
>  struct lruvec *mem_cgroup_page_lruvec(struct page *, struct pglist_data =
*);
> =20
> +struct lruvec *lock_page_lruvec_irq(struct page *, struct pglist_data *);
> +struct lruvec *lock_page_lruvec_irqsave(struct page *, struct pglist_dat=
a *,
> +					unsigned long*);
> +
>  struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
> =20
>  struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm);
> @@ -901,6 +905,26 @@ static inline struct lruvec *mem_cgroup_page_lruvec(=
struct page *page,
>  	return &pgdat->__lruvec;
>  }
> =20
> +static inline struct lruvec *lock_page_lruvec_irq(struct page *page,
> +						struct pglist_data *pgdat)
> +{
> +	struct lruvec *lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
> +
> +	spin_lock_irq(&lruvec->lru_lock);
> +
> +	return lruvec;

While this works in practice, it looks wrong because it doesn't follow
the mem_cgroup_page_lruvec() rules.

Please open-code spin_lock_irq(&pgdat->__lruvec->lru_lock) instead.

> @@ -1246,6 +1245,46 @@ struct lruvec *mem_cgroup_page_lruvec(struct page =
*page, struct pglist_data *pgd
>  	return lruvec;
>  }
> =20
> +struct lruvec *lock_page_lruvec_irq(struct page *page,
> +					struct pglist_data *pgdat)
> +{
> +	struct lruvec *lruvec;
> +
> +again:
> +	rcu_read_lock();
> +	lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
> +	spin_lock_irq(&lruvec->lru_lock);
> +	rcu_read_unlock();

The spinlock doesn't prevent the lruvec from being freed.

You deleted the rules from the mem_cgroup_page_lruvec() documentation,
but they still apply: if the page is already !PageLRU() by the time
you get here, it could get reclaimed or migrated to another cgroup,
and that can free the memcg/lruvec. Merely having the lru_lock held
does not prevent this.

Either the page needs to be locked, or the page needs to be PageLRU
with the lru_lock held to prevent somebody else from isolating
it. Otherwise, the lruvec is not safe to use.
