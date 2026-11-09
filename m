Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794217539;
	b=y4VPSGTLs50QIvVq03h2LmhpCZoAH7rpM1Wf+sDrH+8a6+W4FSrDW2rkDR2KflMbE/sn
	 eEaQvrpZ8NaVSv6CMfYAvnyFDvdL3Ye34OnIAWSMP/bO2HlVmCrRkPQF0Rtoup7RDjcCQ
	 ApMG5M6b7IZ5JbRk/zGFfGCLXkLVz5KvpT6Bj2QyNI2I+OCmS9vmcR6aznSLqWR1DAIU8
	 1mnVm4rRGFDEEvaqgq5Prwb3XQbEZMt/TnkfBeY2YrMywheFo0BHMNixp9Jz2b703YBvK
	 DTNPQazs2HBJJkJ2SjMqWlfpvdtEK89ziLFEKDCvwsicrgtzyI7opswx0lgzPlhiLaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794217539;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=aVhDRH0Ejv2dP5BNHANZ6BfN36P5eG+GYmlsiu8O5i0=;
	b=qe6KD47tvLjQ31iKa/+pJ5oJRBTlVHWChXiAt7RuM3xILevG8yHdbNfR9kBzcXLLGc8/
	 U5iPnjJdyyK+GA3rxHPIUjabVGVFN1seN0F/W3BXL3uZaSAG+aKIVXpvu+tdm41h0zylh
	 gN4WFOsRyd+fsqwernJlR5fU0dmEFuF4vz6LgCGdDxHVBCHLya8Frda6qRgXqRqPLWSAh
	 /uGGEPVM98CW4biGHBXq/Szx0VY+eiprwg/MkANzx+y2zqSgumdpoUzPNy/ID6lFO4urM
	 xM2l8Ul2NeXblMQbxIxhsPzHsufyQozrM4qTnPOMiWZvRf0RuOVJlY4cBA/JTYTsPnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IIiDOn+6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA24606A323
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 09:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IIiDOn+6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD161F008A2
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 09:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794217538;
	bh=aVhDRH0Ejv2dP5BNHANZ6BfN36P5eG+GYmlsiu8O5i0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IIiDOn+6mHfBnlcx8dhDV0FbXr2mIkgDI/paabPEfftwv+t/j09LPO0F9TMdLelU0
	 tF2I7Yd6xJ8I9DUoadaKfVesvIhkMVneSGd/Yyc6alpGUegu/IMkgHDPJOxukl+4K9
	 HVuGPXppT6pwICcvzAwKVAc9t3ftXP6BPM/xsK7sBY74+t775KrL45Z4Dj+6YK5a9b
	 92SdWwCP63fFsXWmHTdJ9eLVu1/SoGtiU8M298cTk6P5HkN5ayeiHetEDIZELpuaRB
	 znspq3nuzORltN9i94EKzRNFp9RwUmabvzdG5ZuUL7SO4xL9xcUbOSTMUAr/AaOJzh
	 AkQbbHe0knYPA==
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-5eac6c5f927so238280e0c.0
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 01:45:38 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHzgxh0m7LibDsELVPpHkJFm2UUXcIIM1D2nilNZB0ThkMxeZJdTOIQkPMk4CkV5IKAUVGx7YF9@vger.kernel.org
X-Gm-Message-State: APuU4Z8OOGvd32ukZUm9nzbSvWsT4pnIhUJFZPRR683K3RnlLkDcldky
	2D73pDyFTTRtmJmzZtn4HgVPjXmp4LS6Jr0Gc4tjtN03BjslZp61iUbIysfdT9l9GyoKe/y4O25
	9ZVrI1aBV7WkJTZPDuFRwdLY9XwGmM/w=
X-Received: by 2002:a05:6122:e203:b0:5c9:a60d:3276 with SMTP id
 71dfb90a1353d-5ece7246f6emr692804e0c.10.1794217537447; Mon, 09 Nov 2026
 01:45:37 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
 <20261016-mglru-fg-v4-15-2106750c0bfa@tencent.com> <CAGsJ_4wTFHJxzuiRDBcuevdULMcD+se6SuPbzWKA8wsUAG80_w@mail.gmail.com>
 <CAMgjq7Atry0zRc_-xbrL_VubxTBQOT8R2_aumghXQaO9uTANHg@mail.gmail.com>
In-Reply-To: <CAMgjq7Atry0zRc_-xbrL_VubxTBQOT8R2_aumghXQaO9uTANHg@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 9 Nov 2026 17:45:24 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wRw=z0fqWo8pK6cJ-NdnjxC-W7uLRw=_Y+VjNaAO2+kQ@mail.gmail.com>
X-Gm-Features: AclHuK8xNVegVCW7QSB1W4kv0lSWF1rRdFvqk_1TYyR009hud_IPjR1oWsQQqAY
Message-ID: <CAGsJ_4wRw=z0fqWo8pK6cJ-NdnjxC-W7uLRw=_Y+VjNaAO2+kQ@mail.gmail.com>
Subject: Re: [PATCH v4 15/17] mm/mglru: make folio_inc_lru_refs lruvec lockless
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, SJ Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 9, 2026 at 4:08=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> On Mon, Nov 9, 2026 at 5:48=E2=80=AFAM Barry Song <baohua@kernel.org> wro=
te:
> >
> > On Fri, Oct 16, 2026 at 2:16=E2=80=AFAM Kairui Song via B4 Relay
> > <devnull+kasong.tencent.com@kernel.org> wrote:
> > >
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > The lruvec spinlock in folio_inc_lru_refs was only taken to keep
> > > concurrent aging from corrupting the size counters.  This is no
> > > longer needed: the per-generation counters are atomic, and the
> > > active/inactive ABI counters are updated per folio and linearized by
> > > the CAS on the folio flags, so concurrent aging can no longer corrupt
> > > them.  The same argument already allowed folio_reset_lru_refs() to
> > > drop the lock.
> > >
> > > Use folio_lruvec_live_get()/folio_lruvec_live_put() to hold the RCU
> > > read lock around the lruvec lookup, and drop the spinlock entirely.
> > >
> >
> > Yes, this is cool. We have two paths calling
> > folio_inc_lru_refs() or folio_inc_lru_refs_walk().
> >
> > 1. folio_mark_accessed() from syscall access
> > 2. walk_update_folio() from page table walker or look_around
> >
> > For the latter, we can't actually cross multiple
> > lruvecs/memcgs, because of get_pfn_folio() as shown
> > below:
> >
> > static struct folio *get_pfn_folio(unsigned long pfn, struct mem_cgroup=
 *memcg,
> >                                    struct pglist_data *pgdat)
> > {
> >         ...
> >         rcu_read_lock();
> >         if (folio_memcg(folio) !=3D memcg)
> >                 folio =3D NULL;
> >         rcu_read_unlock();
> >         ...
> > }
> >
> > Consider a common library file used by 100 memcgs, with
> > its folio residing in the root memcg.
> >
> > When walking the 99 non-root memcgs, even if the folio
> > has been accessed, we won't get a chance to call
> > folio_inc_lru_refs_walk() for it. As a result, this folio
> > may eventually reach the eviction rmap path. With a high
> > mapcount, folio_referenced() could become quite
> > expensive.
> >
> > That's what I was trying to point out here as well:
> >
> > https://lore.kernel.org/linux-mm/20261102213915.57805-1-baohua@kernel.o=
rg/#t
>
> Hi Barry,
>
> Thanks for the review, I saw that too, very interesting approach! And
> I believe it will helpful.
>
> > For the former, you can get the lruvec with:
> >
> > lruvec =3D lruvec_live_lock_irq(folio_lruvec(folio));
> >
> > I'm wondering whether we could eventually unify them
> > so that both support cross-memcg inc_refs.
>
> Definately, actually for that link you posted, combined with the code
> snip above, after FG, I think we can further simplify that, no need to
> check mem_cgroup_is_descendant, we just do:
>
> - folio_inc_lru_refs_walk: if the folio belongs to the lruvec being
> walked, the batch stays in walk->lruvec
> - folio_inc_lru_refs: if the folio is a remote one, per-folio, no batch
>
> non-descendant folio sharing across memcg are actually quite common
> e.g., libc and shared mapped memory, this could be more helpful? And
> it seems fast for the walker.

I agree. I mentioned mem_cgroup_is_descendant() because
folio_referenced() checks for descendants and ignores
folios belonging to non-descendant memcgs:

static bool invalid_folio_referenced_vma(struct vm_area_struct *vma, void *=
arg)
{
        struct folio_referenced_arg *pra =3D arg;
        struct mem_cgroup *memcg =3D pra->memcg;

        ...
        /*
         * If we are reclaiming on behalf of a cgroup, skip counting on beh=
alf
         * of references from different cgroups.
         */
        if (memcg && !mm_match_cgroup(vma->vm_mm, memcg))
                return true;

        return false;
}

static inline bool mm_match_cgroup(struct mm_struct *mm,
                                   const struct mem_cgroup *memcg)
{
        struct mem_cgroup *task_memcg;
        bool match =3D false;

        rcu_read_lock();
        task_memcg =3D mem_cgroup_from_task(rcu_dereference(mm->owner));
        if (task_memcg)
                match =3D mem_cgroup_is_descendant(task_memcg, memcg);
        rcu_read_unlock();
        return match;
}

I actually wonder whether this is really correct...

>
> folio_inc_lru_refs_walk follow the same rule as folio_inc_lru_refs
> (with MAPPED flag), just faster, skipping RCU and the speculative
> check afterwards as the walker owns the seq it is advancing, and
> caller handles the batch update of counter. While folio_inc_lru_refs
> only requires the caller to hold an reference to the folio it heavily
> relies on RCU / CAS conventions, not easy to batch things there, but
> it's still accetablily fast already (e.g. the fio read test showed
> almost no performance penalty).

Yes. One tricky aspect is that update_batch_size() is
designed for the current lruvec, not a remote one.

static void walk_update_folio(struct lru_gen_mm_walk *walk, struct
vm_area_struct *vma,
                struct lruvec *lruvec, struct folio *folio, bool dirty)
{
        ...
        if (walk) {
                old_gen =3D folio_update_gen(folio, new_gen, &type, &vma->f=
lags);
                if (old_gen >=3D 0 && old_gen !=3D new_gen)
                        update_batch_size(walk, folio, old_gen, new_gen, ty=
pe);
        } else if (lru_gen_set_refs(folio, &vma->flags)) {
                ...
        }
}

>
> And I think the main reason MGLRU can't operate cross memcg was, lack
> of a protocol to stablilze the memcg's gen and holding a lock is too
> costly, now folio_inc_lru_refs handles that, and FG
>  lives on top of that. So we can try that out right after the FG series.

Yes, absolutely. With MGLRU-FG, we lay the groundwork
for further cross-memcg optimizations.

On Android, we observed that folios with very large mapcounts
still reach the rmap path because walk and look-around cannot
promote them across memcgs. In more than 99% of cases,
folio_referenced() finds them PTE-young. As a result, these
folios incur the rmap overhead but are unlikely to be
reclaimed. It's essentially wasted rmap work.

With the cross-memcg optimizations, we are likely to
eliminate this overhead.

Thanks,
Barry
