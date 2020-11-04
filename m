From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v20 08/20] mm: page_idle_get_page() does not need lru_lock
Date: Wed, 4 Nov 2020 19:27:21 +0800
Message-ID: <b4038b87-cf5a-fcb7-06f4-b98874029615@linux.alibaba.com>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
 <1603968305-8026-9-git-send-email-alex.shi@linux.alibaba.com>
 <20201102144110.GB724984@cmpxchg.org>
 <20201102144927.GN27442@casper.infradead.org>
 <20201102202003.GA740958@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20201102202003.GA740958-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>



=D4=DA 2020/11/3 =C9=CF=CE=E74:20, Johannes Weiner =D0=B4=B5=C0:
> On Mon, Nov 02, 2020 at 02:49:27PM +0000, Matthew Wilcox wrote:
>> On Mon, Nov 02, 2020 at 09:41:10AM -0500, Johannes Weiner wrote:
>>> On Thu, Oct 29, 2020 at 06:44:53PM +0800, Alex Shi wrote:
>>>> From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>>>
>>>> It is necessary for page_idle_get_page() to recheck PageLRU() after
>>>> get_page_unless_zero(), but holding lru_lock around that serves no
>>>> useful purpose, and adds to lru_lock contention: delete it.
>>>>
>>>> See https://lore.kernel.org/lkml/20150504031722.GA2768@blaptop for the
>>>> discussion that led to lru_lock there; but __page_set_anon_rmap() now
>>>> uses WRITE_ONCE(),
>>>
>>> That doesn't seem to be the case in Linus's or Andrew's tree. Am I
>>> missing a dependent patch series?
>>>
>>>> and I see no other risk in page_idle_clear_pte_refs() using
>>>> rmap_walk() (beyond the risk of racing PageAnon->PageKsm, mostly but
>>>> not entirely prevented by page_count() check in ksm.c's
>>>> write_protect_page(): that risk being shared with page_referenced()
>>>> and not helped by lru_lock).
>>>
>>> Isn't it possible, as per Minchan's description, for page->mapping to
>>> point to a struct anon_vma without PAGE_MAPPING_ANON set, and rmap
>>> thinking it's looking at a struct address_space?
>>
>> I don't think it can point to an anon_vma without the ANON bit set.
>> Minchan's concern in that email was that it might still be NULL.
>=20
> Hm, no, the thread is a lengthy discussion about whether the store
> could be split such that page->mapping is actually pointing to
> something invalid (anon_vma without the PageAnon bit).
>=20
> From his email:
>=20
>         CPU 0                                                            =
               CPU 1
>=20
> do_anonymous_page
>   __page_set_anon_rmap
>   /* out of order happened so SetPageLRU is done ahead */
>   SetPageLRU(page)

This SetPageLRU done in __pagevec_lru_add_fn() which under the lru_lock
protection, so the original memory barrier or lock concern isn't
correct. that means, the SetPageLRU isn't possible to be here.
And then no warry on right side 'CPU 1' problem.

>   /* Compilr changed store operation like below */
>   page->mapping =3D (struct address_space *) anon_vma;
>   /* Big stall happens */
>                                                                 /* idleta=
cking judged it as LRU page so pass the page
>                                                                    in pag=
e_reference */
>                                                                 page_refe=
rnced
								  page_referenced should be page_idle_clear_pte_refs_one here?=09
>                                                                         p=
age_rmapping return true because
>                                                                         p=
age->mapping has some vaule but not complete
>                                                                         s=
o it calls rmap_walk_file.
>                                                                         i=
t's okay to pass non-completed anon page in rmap_walk_file?
>=20


For this patch, According to comments of page_idle_get_page()=20
PageLRU just used to judge if the page is in user using. for this
purpose, a unguard PageLRU check is good enough. So this patch
should be fine.

Thanks
Alex
