Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794217921;
	b=i1MQmgreqisbiaR0j3+zhsJJ/ICTb4Zw+HL0nNXXIFknQUEA9zPMMv0BDFVOHSg52RUG
	 oq7PUEMfEH1aWkJhhg3bWg6TC1MD6b+TKfw5G6vnXsA7T3+DTSolNkZtrLs95ig8V+TEc
	 x8ccJdSE3Hf+XkGO0PjK4Cm3re0mGi+b2zpBowKs3Luv42VMRPXT/R+K8VmHIGiTBi9l1
	 6/gQMnwWbTrmrsJ0o1ItK4RzQ6cWhHqAxmv8e/oVGbVT0shjVdXsT4j03sWwV1SBzoNgW
	 LXGS8YwEAKDnGoAtL0BsdXBJh5n1k5NsMJM9GU9Vh9lIBQaI1IVWD3XID4tbu6X177Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794217921;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=BPClaJ9k3pZ7M2HgIHwRGL9GY0oByLTbIb+UN2JvJdI=;
	b=vo3QsYEMcrWO8GJZe1a3n8M1tL+Q6CDV5PacdLkyqE/f6p5oRBtFcKdVx6y0JVH4hoZ0
	 kzO0Q6x08FC66apxtk58GUlSNlb3lk7JvBbugpTl3zdZBOUoOvvXNnLBEID0Tc7itrBmq
	 gV++Zc/k33AKZW8tbx44E3/G2WAZ8fcipwifAh0++WTdmzDn5nnfEpgUJWi5g8uu3RW2h
	 7PywkZ1QFnyKDH4JqvqYWEAqcXCJUXwNHy8jqmpReXVu6mQ4/0mGPOU/7+QyjEot+Iu94
	 dpH+S5ErXD5O3YJjyPgh9b7pjKLr9oZNDK6sxESGKzIwuNMjI/uAB8WMcAnZle2wtoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ClskhasM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DCC606EE81
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 09:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ClskhasM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCE91F008BE
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 09:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794217919;
	bh=BPClaJ9k3pZ7M2HgIHwRGL9GY0oByLTbIb+UN2JvJdI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ClskhasMy/BO/ZFdZwG+TW51LQNe0aK6dpQ2tXf3zXQZrXEHcm8neQwkSGJQK5bn8
	 LSLm+/HBxMHZMxvoJu/FfopjGzpVjathiWg6LhLTjtHomqOV6NScv+voJMgOraZPB+
	 /ycD4F1aoK068VBjmEHIzTpz6UCYVE334qo4AAnvYskYS657GvVKuV95oqJnh/isCp
	 Ew07MQtp8jOpq34koBR4cll0v4jnwrIVmL3RYMomGUCU4+PMwbvb/yi5tiY3SPEdBZ
	 YFw2QOk4Ib9EJpoMe7VKixgAJAlLv7+MJTeey2wVMPTTTLYNNHu/Q6loLUjbENBCIP
	 uVqmfBr+FuxdQ==
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-5ecda93627eso180384e0c.1
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 01:51:59 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGA/7C8a8uviX1mkKdc+wGcD3slIDpsAAotXhCOxgmVk28I/7FyWLE+tRo7YssRUAxOluaeiR7x@vger.kernel.org
X-Gm-Message-State: APuU4Z+3AFKVQOVpi+9GC4u0wWkkA5RSL20RMfpWPuPUObpk6wgvtqDE
	Or66iTZQ0oqvBH0al+SAcgV5yuJ8u+WzUtv+Ns4ka32PEEQfxW6vqJPwgaeKLiVFODErACq3aYh
	qtnIU7YazxRaV34C6vICAzopxLOdlgRI=
X-Received: by 2002:a05:6122:a012:b0:5ea:c9ab:bd86 with SMTP id
 71dfb90a1353d-5edf9435d18mr565522e0c.21.1794217918356; Mon, 09 Nov 2026
 01:51:58 -0800 (PST)
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
 <20261016-mglru-fg-v4-6-2106750c0bfa@tencent.com> <CAGsJ_4zQh0TnAxifWPo2+DcyFFOtpXM+2QW91A07oumfyrqVYg@mail.gmail.com>
 <CAMgjq7DeC23zak6Xur=E29qo7JPNvQUMtbbO34Y62jrQjQgStA@mail.gmail.com>
In-Reply-To: <CAMgjq7DeC23zak6Xur=E29qo7JPNvQUMtbbO34Y62jrQjQgStA@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 9 Nov 2026 17:51:47 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w275Z8ruQHNMFd9uL+wJgAusU2+QN-cwS5mZcBrg9fRA@mail.gmail.com>
X-Gm-Features: AclHuK-xWTO8SHWDNdqRk7rNXhHpJft0o90jKbimD22mK-2buKuHz7N9dEvOsNg
Message-ID: <CAGsJ_4w275Z8ruQHNMFd9uL+wJgAusU2+QN-cwS5mZcBrg9fRA@mail.gmail.com>
Subject: Re: [PATCH v4 06/17] mm/mglru: move add/del LRU size accounting out
 of lru_gen_update_size()
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

On Mon, Nov 9, 2026 at 5:34=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> On Mon, Nov 9, 2026 at 4:48=E2=80=AFAM Barry Song <baohua@kernel.org> wro=
te:
> >
> > On Fri, Oct 16, 2026 at 2:15=E2=80=AFAM Kairui Song via B4 Relay
> > <devnull+kasong.tencent.com@kernel.org> wrote:
> > >
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > Pure code shuffle, no behavior change.  lru_gen_update_size() now onl=
y
> > > updates the per-generation counters plus the promotion move; the
> > > addition and deletion active/inactive accounting move to
> > > lru_gen_add_folio() and lru_gen_del_folio(), which know the generatio=
n
> > > and can apply the active-window test directly.
> > >
> > > The unevictable case is untouched: unevictable folios never enter
> > > lru_gen_add_folio() and keep being accounted by lruvec_add_folio() as
> > > before.
> > >
> > > Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
> > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > ---
> >
> > The patch looks good to me.
> >
> > Meanwhile, I've been struggling with the names of
> > __update_lru_size() and lru_gen_update_size() for a long
> > time.
> >
> > Given that lru_gen_update_size() now only updates
> > nr_pages:
> > static inline void lru_gen_update_size(struct lruvec *lruvec, int type,
> >                 struct folio *folio, int old_gen, int new_gen)
> > {
> >        ...
> >
> >         if (old_gen >=3D 0)
> >                 atomic_long_sub(delta, &lrugen->nr_pages[old_gen][type]=
[zone]);
> >         if (new_gen >=3D 0)
> >                 atomic_long_add(delta, &lrugen->nr_pages[new_gen][type]=
[zone]);
> > }
> >
> > while __update_lru_size() only handles
> > active/inactive accounting, could we rename them to make
> > their roles clearer? For example:
> >
> > lru_gen_update_nr_pages()
> > lru_gen_update_active_inactive_size()
>
> Hmm but __update_lru_size is also used by CLRU, so it's not a
> "lru_gen" specific helper. If we can merge CLRU/MGLRU, then maybe we
> can rename them?

I did a quick search in mm/vmscan.c and found that
everything is MGLRU. But you're right, I missed
update_lru_size(), which is part of CLRU.

   1     62  include/linux/mm_inline.h <<update_lru_size>>
             __update_lru_size(lruvec, lru, zid, nr_pages);
   2    279  include/linux/mm_inline.h <<lru_gen_update_size>>
             __update_lru_size(lruvec, lru, zone, delta);
   3    287  include/linux/mm_inline.h <<lru_gen_update_size>>
             __update_lru_size(lruvec, lru, zone, -delta);
   4    293  include/linux/mm_inline.h <<lru_gen_update_size>>
             __update_lru_size(lruvec, lru, zone, -delta);
   5    294  include/linux/mm_inline.h <<lru_gen_update_size>>
             __update_lru_size(lruvec, lru + LRU_ACTIVE, zone, delta);
   6   3355  mm/vmscan.c <<reset_batch_size>>
             __update_lru_size(lruvec, lru, zone, delta);
   7   4101  mm/vmscan.c <<inc_max_seq>>
             __update_lru_size(lruvec, lru, zone, delta);
   8   4102  mm/vmscan.c <<inc_max_seq>>
             __update_lru_size(lruvec, lru + LRU_ACTIVE, zone, -delta);
   9   4632  mm/vmscan.c <<__lru_gen_reparent_memcg>>
             __update_lru_size(child_lruvec, lru + child_lru_active,
zone, -nr_pages);
  10   4633  mm/vmscan.c <<__lru_gen_reparent_memcg>>
             __update_lru_size(parent_lruvec, lru + parent_lru_active,
zone, nr_pages);

Thanks,
Barry
