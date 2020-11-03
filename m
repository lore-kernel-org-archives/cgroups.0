From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v20 04/20] mm/thp: use head for head page in
 lru_add_page_tail
Date: Tue, 3 Nov 2020 10:43:07 +0800
Message-ID: <374a5d13-e5d2-9f5e-0185-5b0f2a613fa6@linux.alibaba.com>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
 <1603968305-8026-5-git-send-email-alex.shi@linux.alibaba.com>
 <20201029135047.GE599825@cmpxchg.org>
 <06a5b7d8-bbf2-51b7-1352-2b630186e15f@linux.alibaba.com>
 <20201102160357.GP27442@casper.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20201102160357.GP27442-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org



=D4=DA 2020/11/3 =C9=CF=CE=E712:03, Matthew Wilcox =D0=B4=B5=C0:
> On Fri, Oct 30, 2020 at 10:46:54AM +0800, Alex Shi wrote:
>> -static void lru_add_page_tail(struct page *page, struct page *page_tail,
>> +static void lru_add_page_tail(struct page *head, struct page *tail,
>>  		struct lruvec *lruvec, struct list_head *list)
>>  {
>> -	VM_BUG_ON_PAGE(!PageHead(page), page);
>> -	VM_BUG_ON_PAGE(PageCompound(page_tail), page);
>> -	VM_BUG_ON_PAGE(PageLRU(page_tail), page);
>> +	VM_BUG_ON_PAGE(!PageHead(head), head);
>> +	VM_BUG_ON_PAGE(PageCompound(tail), head);
>> +	VM_BUG_ON_PAGE(PageLRU(tail), head);
>=20
> These last two should surely have been
> 	VM_BUG_ON_PAGE(PageCompound(tail), tail);
> 	VM_BUG_ON_PAGE(PageLRU(tail), tail);
>=20
> Also, what do people think about converting these to VM_BUG_ON_PGFLAGS?

Hi Matthew,

Thanks for reminder! Looks these changes worth for another patch.

>=20
> Either way:
>=20
> Reviewed-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public=
.gmane.org>
>=20


I will take this option this time. :)

Thanks!
Alex
