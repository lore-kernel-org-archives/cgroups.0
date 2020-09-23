From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v18 25/32] mm/mlock: remove lru_lock on
 TestClearPageMlocked in munlock_vma_page
Date: Wed, 23 Sep 2020 09:58:52 +0800
Message-ID: <289ad388-d91a-92f5-b29c-030b666a74ee@linux.alibaba.com>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
 <1598273705-69124-26-git-send-email-alex.shi@linux.alibaba.com>
 <alpine.LSU.2.11.2009212253320.6434@eggly.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LSU.2.11.2009212253320.6434-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>



=D4=DA 2020/9/22 =CF=C2=CE=E72:13, Hugh Dickins =D0=B4=B5=C0:
> On Mon, 24 Aug 2020, Alex Shi wrote:
>=20
>> In the func munlock_vma_page, the page must be PageLocked as well as
>> pages in split_huge_page series funcs. Thus the PageLocked is enough
>> to serialize both funcs.
>>
>> So we could relief the TestClearPageMlocked/hpage_nr_pages which are not
>> necessary under lru lock.
>>
>> As to another munlock func __munlock_pagevec, which no PageLocked
>> protection and should remain lru protecting.
>>
>> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@publi=
c.gmane.org>
> I made some comments on the mlock+munlock situation last week:
> I won't review this 24/32 and 25/32 now, but will take a look
> at your github tree tomorrow instead.  Perhaps I'll find you have
> already done the fixes, perhaps I'll find you have merged these back
> into earlier patches.  And I won't be reviewing beyond this point:
> this is enough for now, I think.
>=20

Yes, these 2 patches was fixed as your suggested on=20
https://github.com/alexshi/linux.git lruv19.5=20

83f8582dcd5a mm/mlock: remove lru_lock on TestClearPageMlocked
20836d10f0ed mm/mlock: remove __munlock_isolate_lru_page

Thanks!
Alex
