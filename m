From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v18 20/32] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Tue, 22 Sep 2020 16:58:47 +0800
Message-ID: <0ae8709b-b82a-0956-9934-cbbd1f2e50ce@linux.alibaba.com>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
 <1598273705-69124-21-git-send-email-alex.shi@linux.alibaba.com>
 <alpine.LSU.2.11.2009211908080.6434@eggly.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LSU.2.11.2009211908080.6434-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>



=D4=DA 2020/9/22 =CF=C2=CE=E71:27, Hugh Dickins =D0=B4=B5=C0:
> On Mon, 24 Aug 2020, Alex Shi wrote:
>=20
>> This patch moves per node lru_lock into lruvec, thus bring a lru_lock for
>> each of memcg per node. So on a large machine, each of memcg don't
>> have to suffer from per node pgdat->lru_lock competition. They could go
>> fast with their self lru_lock.
>>
>> After move memcg charge before lru inserting, page isolation could
>> serialize page's memcg, then per memcg lruvec lock is stable and could
>> replace per node lru lock.
>>
>> In func isolate_migratepages_block, compact_unlock_should_abort is
>> opend, and lock_page_lruvec logical is embedded for tight process.
>=20
> Hard to understand: perhaps:
>=20
> In func isolate_migratepages_block, compact_unlock_should_abort and
> lock_page_lruvec_irqsave are open coded to work with compact_control.

will update with your suggestion. Thanks!

>=20
>> Also add a debug func in locking which may give some clues if there are
>> sth out of hands.
>>
>> According to Daniel Jordan's suggestion, I run 208 'dd' with on 104
>> containers on a 2s * 26cores * HT box with a modefied case:
>> https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git/t=
ree/case-lru-file-readtwice
>=20
> s/modeified/modified/
> lruv19 has an lkml.org link there, please substitut
> https://lore.kernel.org/lkml/01ed6e45-3853-dcba-61cb-b429a49a7572-KPsoFbN=
s7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org/
>=20

Thanks!

>>
>> With this and later patches, the readtwice performance increases
>> about 80% within concurrent containers.
>>
>> On a large machine with memcg enabled but not used, the page's lruvec
>> seeking pass a few pointers, that may lead to lru_lock holding time
>> increase and a bit regression.
>>
>> Hugh Dickins helped on patch polish, thanks!
>>
>> Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.=
org>
>=20
> Eh? It may have reported some locking bugs somewhere, but this
> is the main patch of your per-memcg lru_lock: I don't think the
> kernel test robot inspired your whole design, did it?  Delete that.
>=20
>=20
>> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@publi=
c.gmane.org>
>=20
> I can't quite Ack this one yet, because there are several functions
> (mainly __munlock_pagevec and check_move_unevictable_pages) which are
> not right in this v18 version, and a bit tricky to correct: I already
> suggested what to do in other mail, but this patch comes before
> relock_page_lruvec, so must look different from the final result;
> I need to look at a later version, perhaps already there in your
> github tree, before I can Ack: but it's not far off.
> Comments below.

All suggestions are taken! Many thanks for so detailed review!
A new branch with all comments is updated as=20
    https://github.com/alexshi/linux.git lruv19.5

A quick summary for the branch,
Add a new patch for move_pages_to_lru:
	mm/vmscan: remove lruvec reget in move_pages_to_lru
Add another patch for split part from 'Introduce TestClearPageLRU':
 	mm/swap.c: reorder __ClearPageLRU and lruvec

the mlock changes moved earlier:
	mm/mlock: remove __munlock_isolate_lru_page
	mm/mlock: remove __munlock_isolate_lru_page

I am wondering if it's good to send out v19 here or maybe better to wait
for your confirm if all suggestion/comments are settled?

Thanks
Alex
