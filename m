Received: from mta1.migadu.com (out-198.mta1.migadu.com [95.215.58.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28507470139
	for <cgroups@vger.kernel.org>; Fri, 16 Oct 2026 09:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792141851; cv=none; b=G/94sOGwdLJNc5IYWSwe5/ppyuvXsFhU/NMAq4HCxjKfWensIIE3nQKHqLLCorAEbcSrGycFcL3dmYv1+iTF26Iq0jP5MMWT2e4d8TslVs1yZa+PWHW0PX6SVj/i9m4tEkKAbeLCI+Xk6FG8t2bx6XwO2xqA6xK9Fi3MCHeN4EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792141851; c=relaxed/simple;
	bh=OENjaTjOgQb8XGZqbEf0lEkD3kxNX07o2dz0fysyuho=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=YG2vf/Xhnql7toNv/CufcE7c6snWvHdVSACwNEPMkdUde3SFdtzm7P7XAKMjZCGlPKXSXTC6zx2bz3K85GGhgWr7x4iABbtjb9eF9IbdB4vqLiCBDL51B03eLo7pcvhppeXgRlComTSyoYOZrEL9rQ+kTOMRdLZ1GsXL4WbEOoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rpoRrS5a; arc=none smtp.client-ip=95.215.58.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rpoRrS5a"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=OENjaTjOgQb8XGZqbEf0lEkD3kxNX07o2dz0fysyuho=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792141846; v=1; x=1792746646;
 b=rpoRrS5a1PR0n77GkrgpQtkfCZiSCkTqYPQmHkMrlKTb3QLWzUX5wSPpaRGOncktWn1egHmt
 WkoqcdYjfO0mBpGqQOAaBZLeZMfinRLqp/+vpvcapMUX9NO4uUvImqCEvx0pTl1pcJ0PEsqNzC9
 m+dyKWNcCgkUNfhKBu/lo+gY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 059766e191225fb4;
	Fri, 16 Oct 2026 09:10:20 +0000
X-Mizu-Trace-ID: 059766e191225fb4
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v4 03/17] mm/memcg: add folio-based lruvec live helper
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <CAMgjq7D-2HyvuD5U58ohv4YuyuCEbxYAO_wxkx==WxhsNQrXXw@mail.gmail.com>
Date: Fri, 16 Oct 2026 17:09:54 +0800
Cc: linux-mm@kvack.org,
 "Liam R. Howlett" <liam@infradead.org>,
 SJ Park <sj@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>,
 Baoquan He <baoquan.he@linux.dev>,
 Nico Pache <nico.pache@linux.dev>,
 Usama Arif <usama.arif@linux.dev>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>,
 Zi Yan <ziy@nvidia.com>,
 Gregory Price <gourry@gourry.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>,
 Hugh Dickins <hughd@google.com>,
 David Rientjes <rientjes@google.com>,
 Yu Zhao <yuzhao@google.com>,
 Vernon Yang <vernon2gm@gmail.com>,
 Zicheng Wang <wangzicheng@honor.com>,
 Chen Ridong <chenridong@xiaomi.com>,
 Tal Zussman <tz2294@columbia.edu>,
 Xiang Liu <liuxiang.277@bytedance.com>,
 Ehab Ababneh <ehab.ababneh@intel.com>,
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>,
 Lian Wang <lianux.mm@gmail.com>,
 Kunwu Chan <kunwu.chan@gmail.com>,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 damon@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <89B5F552-25E1-4EE7-9B76-8239490125B0@linux.dev>
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
 <20261016-mglru-fg-v4-3-2106750c0bfa@tencent.com>
 <342E57E7-9B7F-4193-805E-D1EBB41299FF@linux.dev>
 <CAMgjq7D-2HyvuD5U58ohv4YuyuCEbxYAO_wxkx==WxhsNQrXXw@mail.gmail.com>
To: Kairui Song <ryncsn@gmail.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)



> On Oct 16, 2026, at 15:54, Kairui Song <ryncsn@gmail.com> wrote:
>=20
> On Fri, Oct 16, 2026 at 3:39=E2=80=AFPM Muchun Song =
<muchun.song@linux.dev> wrote:
>>=20
>>> On Oct 16, 2026, at 02:15, Kairui Song via B4 Relay =
<devnull+kasong.tencent.com@kernel.org> wrote:
>>>=20
>>> From: Kairui Song <kasong@tencent.com>
>>>=20
>>> Add a helper that resolves a stable lruvec for a folio under RCU
>>> without taking the lruvec lock.  It takes a folio directly so the
>>> lruvec lookup happens inside the RCU read-side critical section,
>>> which a lruvec-based interface cannot guarantee.
>>>=20
>>> No functional change.
>>>=20
>>> Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>> ---
>>> include/linux/memcontrol.h | 39 =
+++++++++++++++++++++++++++++++++++++++
>>> 1 file changed, 39 insertions(+)
>>>=20
>>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>>> index 74110a324f9e..829ab776ab44 100644
>>> --- a/include/linux/memcontrol.h
>>> +++ b/include/linux/memcontrol.h
>>> @@ -1535,6 +1535,45 @@ static inline void lruvec_lock_irq(struct =
lruvec *lruvec)
>>> spin_lock_irq(&lruvec->lru_lock);
>>> }
>>>=20
>>> +/**
>>> + * folio_lruvec_live_get - get a live lruvec for a folio under RCU
>>> + * @folio: the folio
>>> + *
>>> + * Computes @folio's lruvec and walks up to the nearest live =
ancestor
>>> + * if the folio's memcg is dying.  Paired with =
folio_lruvec_live_put().
>>> + * The result may be stale: RCU keeps it alive but does not pin =
@folio
>>> + * to it.  That is fine as the counters are fixed up on =
reparenting.
>>> + *
>>> + * Return: the live lruvec, with rcu_read_lock held.
>>> + */
>>> +static inline struct lruvec *folio_lruvec_live_get(struct folio =
*folio)
>>> +{
>>> +#ifdef CONFIG_MEMCG
>>> +     struct lruvec *lruvec;
>>> +     struct pglist_data *pgdat;
>>> +     struct mem_cgroup *memcg;
>>> +
>>> +     rcu_read_lock();
>>> +     lruvec =3D folio_lruvec(folio);
>>> +     pgdat =3D lruvec_pgdat(lruvec);
>>> +     memcg =3D lruvec_memcg(lruvec);
>>> +     while (unlikely(memcg && css_is_dying(&memcg->css))) {
>>> +             memcg =3D parent_mem_cgroup(memcg);
>>> +             lruvec =3D mem_cgroup_lruvec(memcg, pgdat);
>>> +     }
>>> +     return lruvec;
>>=20
>> Hi Kairui,
>>=20
>=20
> Hi Muchun, thanks for the review.
>=20
>> Actually, we don't have any means to guarantee that the memcg
>> to which the returned lruvec belongs will not become dying
>> after the return, right?
>=20
> Yeah but Qi once mentioned that RCU prevents reparenting, right? Even
> if the memcg is dead after return, things happended to it
> (non-hieratical counter reparenting, ones in __lru_gen_reparent_memcg)
> will only occurs after RCU unlock so we can apply counter update to it
> without grabbing an ref, just hold the RCU.

Thanks for the info. I checked the code and confirmed that, aside from
keeping the memcg from being freed, RCU also ensures the memcg doesn't =
get
reparented. If your scenario requires mutual exclusion with the =
reparenting
operation, RCU can handle that.

Thanks,
Muchun

>=20
>>> +#else
>>> +     return folio_lruvec(folio);
>>=20
>> Then, I'm wondering why folio_lruvec() doesn't apply to the
>> memcg scenario.
>>=20
>> Internally, folio_lruvec() obtains the memcg through
>> obj_cgroup_memcg(). So when the memcg becomes dying, it should
>> be reparented to the parent memcg within a short time.
>=20
> I wasn't sure if grabbing RCU can ensure an already dead cgroup has
> not been reparented yet. If we apply the counter update to a already
> reparented lruvec, then the counter is leaked. This new helper is just
> a folio version of lruvec_live_lock_irq.
>=20
> I got the idea from commit de4660898b7a, which says:
>=20
> """
> .... check CSS_DYING under RCU before
> flushing the pending batch.  A non-dying memcg keeps the original =
lruvec
> stable against RCU-delayed offlining; a dying memcg redirects the =
deltas
> to the first non-dying ancestor.
> """
>=20
> Applying counter update to a dead but not reparented lruvec is fine =
though.


