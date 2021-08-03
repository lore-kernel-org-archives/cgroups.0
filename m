From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 2/5] mm, memcg: narrow the scope of percpu_charge_mutex
Date: Mon, 2 Aug 2021 20:40:04 -0700
Message-ID: <YQi6lOT6j2DtOGlT@carbon.dhcp.thefacebook.com>
References: <20210729125755.16871-1-linmiaohe@huawei.com>
 <20210729125755.16871-3-linmiaohe@huawei.com>
 <YQNsxVPsRSBZcfGG@carbon.lan>
 <YQOhGs3k9rHx3mmT@dhcp22.suse.cz>
 <4a3c23c4-054c-2896-29c5-8cf9a4deee98@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=kmMdd7tY7zbfnCesS+60VWwPMXzWClZuK+uqJJzvkw8=;
 b=rh24/XUlIF6iRjdTE9NMoheJFdUL0GALOJFuFT+eebIOzDSMKiVoxERqzgeKyIqAi8D+
 XsZ8OQx/IQBiFGYd7ZoDDplzNX4ti9rNt/9SpzZWTEGdpxWrkP910TLDGmCxLwxWMYJE
 OL2eSrKaLJAccubs9nebgN203GB9db0PyEk= 
Content-Disposition: inline
In-Reply-To: <4a3c23c4-054c-2896-29c5-8cf9a4deee98-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Jul 31, 2021 at 10:29:52AM +0800, Miaohe Lin wrote:
> On 2021/7/30 14:50, Michal Hocko wrote:
> > On Thu 29-07-21 20:06:45, Roman Gushchin wrote:
> >> On Thu, Jul 29, 2021 at 08:57:52PM +0800, Miaohe Lin wrote:
> >>> Since percpu_charge_mutex is only used inside drain_all_stock(), we c=
an
> >>> narrow the scope of percpu_charge_mutex by moving it here.
> >>>
> >>> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gm=
ane.org>
> >>> ---
> >>>  mm/memcontrol.c | 2 +-
> >>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >>> index 6580c2381a3e..a03e24e57cd9 100644
> >>> --- a/mm/memcontrol.c
> >>> +++ b/mm/memcontrol.c
> >>> @@ -2050,7 +2050,6 @@ struct memcg_stock_pcp {
> >>>  #define FLUSHING_CACHED_CHARGE	0
> >>>  };
> >>>  static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock);
> >>> -static DEFINE_MUTEX(percpu_charge_mutex);
> >>> =20
> >>>  #ifdef CONFIG_MEMCG_KMEM
> >>>  static void drain_obj_stock(struct obj_stock *stock);
> >>> @@ -2209,6 +2208,7 @@ static void refill_stock(struct mem_cgroup *mem=
cg, unsigned int nr_pages)
> >>>   */
> >>>  static void drain_all_stock(struct mem_cgroup *root_memcg)
> >>>  {
> >>> +	static DEFINE_MUTEX(percpu_charge_mutex);
> >>>  	int cpu, curcpu;
> >>
> >> It's considered a good practice to protect data instead of code paths.=
 After
> >> the proposed change it becomes obvious that the opposite is done here:=
 the mutex
> >> is used to prevent a simultaneous execution of the code of the drain_a=
ll_stock()
> >> function.
> >=20
> > The purpose of the lock was indeed to orchestrate callers more than any
> > data structure consistency.
> > =20
> >> Actually we don't need a mutex here: nobody ever sleeps on it. So I'd =
replace
> >> it with a simple atomic variable or even a single bitfield. Then the c=
hange will
> >> be better justified, IMO.
> >=20
> > Yes, mutex can be replaced by an atomic in a follow up patch.
> >=20
>=20
> Thanks for both of you. It's a really good suggestion. What do you mean i=
s something like below=EF=BC=9F
>=20
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 616d1a72ece3..508a96e80980 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2208,11 +2208,11 @@ static void refill_stock(struct mem_cgroup *memcg=
, unsigned int nr_pages)
>   */
>  static void drain_all_stock(struct mem_cgroup *root_memcg)
>  {
> -       static DEFINE_MUTEX(percpu_charge_mutex);
>         int cpu, curcpu;
> +       static atomic_t drain_all_stocks =3D ATOMIC_INIT(-1);
>=20
>         /* If someone's already draining, avoid adding running more worke=
rs. */
> -       if (!mutex_trylock(&percpu_charge_mutex))
> +       if (!atomic_inc_not_zero(&drain_all_stocks))
>                 return;

It should work, but why not a simple atomic_cmpxchg(&drain_all_stocks, 0, 1=
) and
initialize it to 0? Maybe it's just my preference, but IMO (0, 1) is easier
to understand than (-1, 0) here. Not a strong opinion though, up to you.

Thanks!
