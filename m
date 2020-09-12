From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v18 00/32] per memcg lru_lock: reviews
Date: Fri, 11 Sep 2020 19:13:39 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.2009111634020.22739@eggly.anvils>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com> <20200824114204.cc796ca182db95809dd70a47@linux-foundation.org> <alpine.LSU.2.11.2008241231460.1065@eggly.anvils> <alpine.LSU.2.11.2008262301240.4405@eggly.anvils>
 <alpine.LSU.2.11.2009081640070.7256@eggly.anvils> <61a42a87-eec9-e300-f710-992756f70de6@linux.alibaba.com> <alpine.LSU.2.11.2009091524260.10087@eggly.anvils> <855ad6ee-dba4-9729-78bd-23e392905cf6@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-2118919784-1599876844=:22739"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=2v1i6ZchjJszrJRz/D9EWNCywGeiZUhvr2WWU4Ulyq8=;
        b=Q2vaHepLzKNvoHsZIdLC1U+mqVqMe+VnWuWcr00gXxXnynTK6+NMBU8TnurWZq5wQ/
         sLpMp/RcfQDHLFNYpQWat+FKt+v62r9AwYRLPHM76/W0l3D51LCM1xWTQidMk5o65Q2a
         68JLpyFywXx2OEuKEYfxVGPrwVC37+Pcra6kJl1fAMqTTKwk0ym4FDvUlVuE1Hp+6QpW
         tTPg65euQypFj5YnpO+PbRErsx53f2tOj9z2UX9s9sG//RzRQ3nnp+6xeczE5uMgnpcb
         Z/pd59n9QmVgR/KQQxKo8e8twBPMhbEQhJVZwMEFG00UNpkNF3+5JlQj29x1QhqtKORM
         3+uQ==
In-Reply-To: <855ad6ee-dba4-9729-78bd-23e392905cf6@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, mgorman@techsingularity.net, tj@kernel.org, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com, vbabka@suse.cz, minchan@kernel.org, cai@lca.pw

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-2118919784-1599876844=:22739
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 11 Sep 2020, Alex Shi wrote:
> =E5=9C=A8 2020/9/10 =E4=B8=8A=E5=8D=887:16, Hugh Dickins =E5=86=99=E9=81=
=93:
> > On Wed, 9 Sep 2020, Alex Shi wrote:
> >> =E5=9C=A8 2020/9/9 =E4=B8=8A=E5=8D=887:41, Hugh Dickins =E5=86=99=E9=
=81=93:
> >>>
> >>> [PATCH v18 05/32] mm/thp: remove code path which never got into
> >>> This is a good simplification, but I see no sign that you understand
> >>> why it's valid: it relies on lru_add_page_tail() being called while
> >>> head refcount is frozen to 0: we would not get this far if someone
> >>> else holds a reference to the THP - which they must hold if they have
> >>> isolated the page from its lru (and that's true before or after your
> >>> per-memcg changes - but even truer after those changes, since PageLRU
> >>> can then be flipped without lru_lock at any instant): please explain
> >>> something of this in the commit message.
> >>
> >> Is the following commit log better?
> >>
> >>     split_huge_page() will never call on a page which isn't on lru lis=
t, so
> >>     this code never got a chance to run, and should not be run, to add=
 tail
> >>     pages on a lru list which head page isn't there.
> >>
> >>     Hugh Dickins' mentioned:
> >>     The path should never be called since lru_add_page_tail() being ca=
lled
> >>     while head refcount is frozen to 0: we would not get this far if s=
omeone
> >>     else holds a reference to the THP - which they must hold if they h=
ave
> >>     isolated the page from its lru.
> >>
> >>     Although the bug was never triggered, it'better be removed for cod=
e
> >>     correctness, and add a warn for unexpected calling.
> >=20
> > Not much better, no.  split_huge_page() can easily be called for a page
> > which is not on the lru list at the time,=20
>=20
> Hi Hugh,
>=20
> Thanks for comments!
>=20
> There are some discussion on this point a couple of weeks ago,
> https://lkml.org/lkml/2020/7/9/760
>=20
> Matthew Wilcox and Kirill have the following comments,
> > I don't understand how we get to split_huge_page() with a page that's
> > not on an LRU list.  Both anonymous and page cache pages should be on
> > an LRU list.  What am I missing?
>=20
> Right, and it's never got removed from LRU during the split. The tail
> pages have to be added to LRU because they now separate from the tail
> page.
>=20
> --=20
>  Kirill A. Shutemov

Yes, those were among the mails that I read through before getting
down to review.  I was surprised by their not understanding, but
it was a bit late to reply to that thread.

Perhaps everybody had been focused on pages which have been and
naturally belong on an LRU list, rather than pages which are on
the LRU list at the instant that split_huge_page() is called.

There are a number of places where PageLRU gets cleared, and a
number of places where we del_page_from_lru_list(), I think you'll
agree: your patches touch all or most of them.  Let's think of a
common one, isolate_lru_pages() used by page reclaim, but the same
would apply to most of the others.

Then there a number of places where split_huge_page() is called:
I am having difficulty finding any of those which cannot race with
page reclaim, but shall we choose anon THP's deferred_split_scan(),
or shmem THP's shmem_punch_compound()?

What prevents either of those from calling split_huge_page() at
a time when isolate_lru_pages() has removed the page from LRU?

But there's no problem in this race, because anyone isolating the
page from LRU must hold their own reference to the page (to prevent
it from being freed independently), and the can_split_huge_page() or
page_ref_freeze() in split_huge_page_to_list() will detect that and
fail the split with -EBUSY (or else succeed and prevent new references
from being acquired).  So this case never reaches lru_add_page_tail().

>=20
> > and I don't know what was the
> > bug which was never triggered. =20
>=20
> So the only path to the removed part should be a bug, like  sth here,
> https://lkml.org/lkml/2020/7/10/118
> or
> https://lkml.org/lkml/2020/7/10/972

Oh, the use of split_huge_page() in __iommu_dma_alloc_pages() is just
nonsense, I thought it had already been removed - perhaps some debate
over __GFP_COMP held it up.  Not something you need worry about in
this patchset.

>=20
> > Stick with whatever text you end up with
> > for the combination of 05/32 and 18/32, and I'll rewrite it after.
>=20
> I am not object to merge them into one, I just don't know how to say
> clear about 2 patches in commit log. As patch 18, TestClearPageLRU
> add the incorrect posibility of remove lru bit during split, that's
> the reason of code path rewrite and a WARN there.

I did not know that was why you were putting 18/32 in at that
point, it does not mention TestClearPageLRU at all.  But the fact
remains that it's a nice cleanup, contains a reassuring WARN if we
got it wrong (and I've suggested a WARN on the other branch too),
it was valid before your changes, and it's valid after your changes.
Please merge it back into the uglier 05/32, and again I'll rewrite
whatever comment you come up with if necessary.

> >=20
> >>> [PATCH v18 06/32] mm/thp: narrow lru locking
> >>> Why? What part does this play in the series? "narrow lru locking" can
> >>> also be described as "widen page cache locking":=20
> >>
> >> Uh, the page cache locking isn't widen, it's still on the old place.
> >=20
> > I'm not sure if you're joking there. Perhaps just a misunderstanding.
> >=20
> > Yes, patch 06/32 does not touch the xa_lock(&mapping->i_pages) and
> > xa_lock(&swap_cache->i_pages) lines (odd how we've arrived at two of
> > those, but please do not get into cleaning it up now); but it removes
> > the spin_lock_irqsave(&pgdata->lru_lock, flags) which used to come
> > before them, and inserts a spin_lock(&pgdat->lru_lock) after them.
> >=20
> > You call that narrowing the lru locking, okay, but I see it as also
> > pushing the page cache locking outwards: before this patch, page cache
> > lock was taken inside lru_lock; after this patch, page cache lock is
> > taken outside lru_lock.  If you cannot see that, then I think you
> > should not have touched this code at all; but it's what we have
> > been testing, and I think we should go forward with it.
> >=20
> >>> But I wish you could give some reason for it in the commit message!
> >>
> >> It's a head scratch task. Would you like to tell me what's detailed in=
fo=20
> >> should be there? Thanks!
> >=20
> > So, you don't know why you did it either: then it will be hard to
> > justify.  I guess I'll have to write something for it later.  I'm
> > strongly tempted just to drop the patch, but expect it will become
> > useful later, for using lock_page_memcg() before getting lru_lock.
> >=20
>=20
> I thought the xa_lock and lru_lock relationship was described clear
> in the commit log,

You say "lru_lock and page cache xa_lock have no reason with current
sequence", but you give no reason for inverting their sequence:
"let's" is not a reason.

> and still no idea of the move_lock in the chain.

memcg->move_lock is what's at the heart of lock_page_memcg(), but
as much as possible that tries to avoid the overhead of actually
taking it, since moving memcg is a rare operation.  For lock ordering,
see the diagram in mm/rmap.c, which 23/32 updates to match this change.

Before this commit: lru_lock > move_lock > i_pages lock was the
expected lock ordering (but it looks as if the lru_lock > move_lock
requirement came from my per-memcg lru_lock patches).

After this commit:  move_lock > i_pages lock > lru_lock is the
required lock ordering, since there are strong reasons (in dirty
writeback) for move_lock > i_pages lock.

> Please refill them for what I overlooked.

Will do, but not before reviewing your remaining patches.

> Thanks!
>=20
> >>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> >>> Is that correct? Or Wei Yang suggested some part of it perhaps?
> >>
> >> Yes, we talked a lot to confirm the locking change is safe.
> >=20
> > Okay, but the patch was written by you, and sent by you to Andrew:
> > that is not a case for "Signed-off-by: Someone Else".
> >=20
>=20
> Ok. let's remove his signed-off.
>=20
> >>> [PATCH v18 27/32] mm/swap.c: optimizing __pagevec_lru_add lru_lock
> >>> Could we please drop this one for the moment? And come back to it lat=
er
> >>> when the basic series is safely in.  It's a good idea to try sorting
> >>> together those pages which come under the same lock (though my guess =
is
> >>> that they naturally gather themselves together quite well already); b=
ut
> >>> I'm not happy adding 360 bytes to the kernel stack here (and that in
> >>> addition to 192 bytes of horrid pseudo-vma in the shmem swapin case),
> >>> though that could be avoided by making it per-cpu. But I hope there's
> >>> a simpler way of doing it, as efficient, but also useful for the othe=
r
> >>> pagevec operations here: perhaps scanning the pagevec for same page->
> >>> mem_cgroup (and flags node bits), NULLing entries as they are done.
> >>> Another, easily fixed, minor defect in this patch: if I'm reading it
> >>> right, it reverses the order in which the pages are put on the lru?
> >>
> >> this patch could give about 10+% performance gain on my multiple memcg
> >> readtwice testing. fairness locking cost the performance much.
> >=20
> > Good to know, should have been mentioned.  s/fairness/Repeated/
> >=20
> > But what was the gain or loss on your multiple memcg readtwice
> > testing without this patch, compared against node-only lru_lock?
> > The 80% gain mentioned before, I presume.  So this further
> > optimization can wait until the rest is solid.
>=20
> the gain based on the patch 26.

If I understand your brief comment there, you're saying that
in a fixed interval of time, the baseline 5.9-rc did 100 runs,
the patches up to and including 26/32 did 180 runs, then with
27/32 on top, did 198 runs?

That's a good improvement by 27/32, but not essential for getting
the patchset in: I don't think 27/32 is the right way to do it,
so I'd still prefer to hold it back from the "initial offering".

>=20
> >=20
> >>
> >> I also tried per cpu solution but that cause much trouble of per cpu f=
unc
> >> things, and looks no benefit except a bit struct size of stack, so if=
=20
> >> stack size still fine. May we could use the solution and improve it be=
tter.
> >> like, functionlize, fix the reverse issue etc.
> >=20
> > I don't know how important the stack depth consideration is nowadays:
> > I still care, maybe others don't, since VMAP_STACK became an option.
> >=20
> > Yes, please fix the reversal (if I was right on that); and I expect
> > you could use a singly linked list instead of the double.
>=20
> single linked list is more saving, but do we have to reverse walking to s=
eek
> the head or tail for correct sequence?

I imagine all you need is to start off with a
=09for (i =3D pagevec_count(pvec) - 1; i >=3D 0; i--)
loop.

>=20
> >=20
> > But I'll look for an alternative - later, once the urgent stuff
> > is completed - and leave the acks on this patch to others.
>=20
> Ok, looking forward for your new solution!
>=20
> Thanks
> Alex
--0-2118919784-1599876844=:22739--
