From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v18 15/32] mm/lru: move lock into lru_note_cost
Date: Tue, 22 Sep 2020 11:39:05 +0800
Message-ID: <323ae796-a547-3ac3-b4fd-68a4ac180690@linux.alibaba.com>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
 <1598273705-69124-16-git-send-email-alex.shi@linux.alibaba.com>
 <alpine.LSU.2.11.2009211434490.5214@eggly.anvils>
 <alpine.LSU.2.11.2009211440570.5214@eggly.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LSU.2.11.2009211440570.5214-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org



=D4=DA 2020/9/22 =C9=CF=CE=E76:03, Hugh Dickins =D0=B4=B5=C0:
>> Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>
>> In your lruv19 github tree, you have merged 14/32 into this one: thanks.
> Grr, I've only just started, and already missed some of my notes.
>=20
> I wanted to point out that this patch does introduce an extra unlock+lock
> in shrink_inactive_list(), even in a !CONFIG_MEMCG build.  I think you've
> done the right thing for now, keeping it simple, and maybe nobody will
> notice the extra overhead; but I expect us to replace lru_note_cost()
> by lru_note_cost_unlock_irq() later on, expecting the caller to do the
> initial lock_irq().
>=20
> lru_note_cost_page() looks redundant to me, but you're right not to
> delete it here, unless Johannes asks you to add that in: that's his
> business, and it may be dependent on the XXX at its callsite.
>=20

Thanks for comments! And got your point. so I will leave this patch alone.

Thanks!
