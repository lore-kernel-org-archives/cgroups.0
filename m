From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v18 00/32] per memcg lru_lock: reviews
Date: Wed, 9 Sep 2020 16:16:41 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.2009091524260.10087@eggly.anvils>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com> <20200824114204.cc796ca182db95809dd70a47@linux-foundation.org> <alpine.LSU.2.11.2008241231460.1065@eggly.anvils> <alpine.LSU.2.11.2008262301240.4405@eggly.anvils>
 <alpine.LSU.2.11.2009081640070.7256@eggly.anvils> <61a42a87-eec9-e300-f710-992756f70de6@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-945709820-1599693416=:10087"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=eNbgA7wJNhgB/YQkgVZ6Sifq4zF6BFfhA4BIqD8+kaE=;
        b=bF8Qb/grHct1/eaX/5eL6k6ObxpykJb0d4zLLV2jGb0xvjs073Ym42sOFNa63xRsKl
         3UiR7OtWtNLBbgQqlDP/Ze+fx+8eBg1pR3fjkL3tjBrMZOrxXwY9f39eH3HocooAVVNZ
         H7mQzRzVzUnPj5qbRNxztp/s2ul4YWIYfJklEuDJOAoCgMe/9Ml2w/ZHH0qLx6T/n04F
         ErB/S2m3jU99ylGanWDQjBbcs8mqb3f7QhPX81WiT2tnbnH1pzdeTTh3KdYG/1FNun5B
         3x3lbmO3Z8hOpFjJAeJMv7ygsuY6oQr+ylEA9bFQV5A9rkplXpOgTzg67S4c4qvcrl2W
         rpzQ==
In-Reply-To: <61a42a87-eec9-e300-f710-992756f70de6@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, mgorman@techsingularity.net, tj@kernel.org, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com, vbabka@suse.cz, minchan@kernel.org, cai@lca.pw

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-945709820-1599693416=:10087
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 9 Sep 2020, Alex Shi wrote:
> =E5=9C=A8 2020/9/9 =E4=B8=8A=E5=8D=887:41, Hugh Dickins =E5=86=99=E9=81=
=93:
> >=20
> > [PATCH v18 05/32] mm/thp: remove code path which never got into
> > This is a good simplification, but I see no sign that you understand
> > why it's valid: it relies on lru_add_page_tail() being called while
> > head refcount is frozen to 0: we would not get this far if someone
> > else holds a reference to the THP - which they must hold if they have
> > isolated the page from its lru (and that's true before or after your
> > per-memcg changes - but even truer after those changes, since PageLRU
> > can then be flipped without lru_lock at any instant): please explain
> > something of this in the commit message.
>=20
> Is the following commit log better?
>=20
>     split_huge_page() will never call on a page which isn't on lru list, =
so
>     this code never got a chance to run, and should not be run, to add ta=
il
>     pages on a lru list which head page isn't there.
>=20
>     Hugh Dickins' mentioned:
>     The path should never be called since lru_add_page_tail() being calle=
d
>     while head refcount is frozen to 0: we would not get this far if some=
one
>     else holds a reference to the THP - which they must hold if they have
>     isolated the page from its lru.
>=20
>     Although the bug was never triggered, it'better be removed for code
>     correctness, and add a warn for unexpected calling.

Not much better, no.  split_huge_page() can easily be called for a page
which is not on the lru list at the time, and I don't know what was the
bug which was never triggered.  Stick with whatever text you end up with
for the combination of 05/32 and 18/32, and I'll rewrite it after.

> > [PATCH v18 06/32] mm/thp: narrow lru locking
> > Why? What part does this play in the series? "narrow lru locking" can
> > also be described as "widen page cache locking":=20
>=20
> Uh, the page cache locking isn't widen, it's still on the old place.

I'm not sure if you're joking there. Perhaps just a misunderstanding.

Yes, patch 06/32 does not touch the xa_lock(&mapping->i_pages) and
xa_lock(&swap_cache->i_pages) lines (odd how we've arrived at two of
those, but please do not get into cleaning it up now); but it removes
the spin_lock_irqsave(&pgdata->lru_lock, flags) which used to come
before them, and inserts a spin_lock(&pgdat->lru_lock) after them.

You call that narrowing the lru locking, okay, but I see it as also
pushing the page cache locking outwards: before this patch, page cache
lock was taken inside lru_lock; after this patch, page cache lock is
taken outside lru_lock.  If you cannot see that, then I think you
should not have touched this code at all; but it's what we have
been testing, and I think we should go forward with it.

> > But I wish you could give some reason for it in the commit message!
>=20
> It's a head scratch task. Would you like to tell me what's detailed info=
=20
> should be there? Thanks!

So, you don't know why you did it either: then it will be hard to
justify.  I guess I'll have to write something for it later.  I'm
strongly tempted just to drop the patch, but expect it will become
useful later, for using lock_page_memcg() before getting lru_lock.

> > Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> > Is that correct? Or Wei Yang suggested some part of it perhaps?
>=20
> Yes, we talked a lot to confirm the locking change is safe.

Okay, but the patch was written by you, and sent by you to Andrew:
that is not a case for "Signed-off-by: Someone Else".

> > [PATCH v18 27/32] mm/swap.c: optimizing __pagevec_lru_add lru_lock
> > Could we please drop this one for the moment? And come back to it later
> > when the basic series is safely in.  It's a good idea to try sorting
> > together those pages which come under the same lock (though my guess is
> > that they naturally gather themselves together quite well already); but
> > I'm not happy adding 360 bytes to the kernel stack here (and that in
> > addition to 192 bytes of horrid pseudo-vma in the shmem swapin case),
> > though that could be avoided by making it per-cpu. But I hope there's
> > a simpler way of doing it, as efficient, but also useful for the other
> > pagevec operations here: perhaps scanning the pagevec for same page->
> > mem_cgroup (and flags node bits), NULLing entries as they are done.
> > Another, easily fixed, minor defect in this patch: if I'm reading it
> > right, it reverses the order in which the pages are put on the lru?
>=20
> this patch could give about 10+% performance gain on my multiple memcg
> readtwice testing. fairness locking cost the performance much.

Good to know, should have been mentioned.  s/fairness/Repeated/

But what was the gain or loss on your multiple memcg readtwice
testing without this patch, compared against node-only lru_lock?
The 80% gain mentioned before, I presume.  So this further
optimization can wait until the rest is solid.

>=20
> I also tried per cpu solution but that cause much trouble of per cpu func
> things, and looks no benefit except a bit struct size of stack, so if=20
> stack size still fine. May we could use the solution and improve it bette=
r.
> like, functionlize, fix the reverse issue etc.

I don't know how important the stack depth consideration is nowadays:
I still care, maybe others don't, since VMAP_STACK became an option.

Yes, please fix the reversal (if I was right on that); and I expect
you could use a singly linked list instead of the double.

But I'll look for an alternative - later, once the urgent stuff
is completed - and leave the acks on this patch to others.

Hugh
--0-945709820-1599693416=:10087--
