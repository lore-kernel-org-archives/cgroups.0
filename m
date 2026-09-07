Received: from mta1.migadu.com (out-40.mta1.migadu.com [95.215.58.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C343E49FE
	for <cgroups@vger.kernel.org>; Mon,  7 Sep 2026 07:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788765061; cv=none; b=TuZ9xTOtB1BSTjzNWTTlUgg+nSBkC0/h/NpeLoXmXOFsriWV4amiUwfgaYYFb5+UplgZrA/2BmJknYGbck2PfGYOYIeMViyhNfKoyZ28NX56lkkVSsRUy9zsEqgCxX/XbG2VXdNjsK4hFXick9bkRtfKzPo4Z9+XkWmED1KQypo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788765061; c=relaxed/simple;
	bh=JRRbxs4nGui4cuCx7AujhYPrgAf4uhXjt73M6I+9Ogw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=oOAmlKRY0zhMtTloZooUJYyrM+zE23rGJKuPe/zy5ikU+hg83V2s6UXpInWYh0CE2CNak87JkkIelzBbQLNSb2Z7Ta/PhzWMgPFz4XUeHkbiagYY9ayw2ujKidtW1BHvXEjjIbaGAeg2s5faw0+og5zbq5cCcHQx8FlTI7MvLnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Hhgnm4SF; arc=none smtp.client-ip=95.215.58.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Hhgnm4SF"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=JRRbxs4nGui4cuCx7AujhYPrgAf4uhXjt73M6I+9Ogw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788765057; v=1; x=1789369857;
 b=Hhgnm4SF3mmBLXXwrqe1ktY1xlHdGoWv2w2BCE2HumKS1+pUL4nAKQrsYQnapFDQQc78N2Uk
 rgBZ3HjruPMaxvlKWw8Hxod3H2vp1IM/cshr4OgpWiybzzy5RFkq1j45pvmbwh35oPMKTRih4Lz
 bQiREaJCKv5VQSlsI3pOWTdg=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 9cad51a24e8e6336;
	Mon, 07 Sep 2026 07:10:57 +0000
X-Mizu-Trace-ID: 9cad51a24e8e6336
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH RFC v2 4/6] mm/memcg: return the memcg when putting
 memcgid
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <apxvRTMdmit7dYk5@BINGFANGGUO-MC0>
Date: Mon, 7 Sep 2026 15:10:38 +0800
Cc: bingfangguo@tencent.com,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7B499C0E-2A46-4EC7-A850-8CC2DA2B5D20@linux.dev>
References: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
 <20260901-bingfangguo-memcgid-rework-v2-4-8edd7f7a7251@tencent.com>
 <c3bec318-ef9d-4d96-8a98-a68717c17201@linux.dev>
 <apxvRTMdmit7dYk5@BINGFANGGUO-MC0>
To: Bingfang Guo <bfguo@icloud.com>
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 6, 2026, at 03:36, Bingfang Guo <bfguo@icloud.com> wrote:
>=20
> On Sat, Sep 05, 2026 at 03:28:50PM +0800, Muchun Song wrote:
>>=20
>=20
> Hi, Muchun!
>=20
>>=20
>> On 2026/9/1 16:58, Bingfang Guo via B4 Relay wrote:
>>> From: Bingfang Guo <bingfangguo@tencent.com>
>>>=20
>>> __mem_cgroup_uncharge_swap() needs both the memcg and the id =
refcount
>>> drop.  Right now it looks the memcg up by id, uncharges it, then =
looks
>>> it up again inside mem_cgroup_private_id_put() to drop the =
reference.
>>>=20
>>> Make mem_cgroup_private_id_put() resolve the id once, drop the
>>> reference, and return the nearest online memcg with a reference held =
for
>>> the caller.  __mem_cgroup_uncharge_swap() then uses that memcg =
directly
>>> and drops the reference after uncharging, avoiding the second xarray
>>> lookup.
>>>=20
>>> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
>>> ---
>>>  mm/memcontrol.c | 20 +++++++++++++++++---
>>>  1 file changed, 17 insertions(+), 3 deletions(-)
>>>=20
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index 048c9bb0fad79..f0503a1e5492d 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -4048,14 +4048,28 @@ static void =
__mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n
>>>   }
>>>  }
>>> -static void mem_cgroup_private_id_put(unsigned short id, unsigned =
int n)
>>> +/**
>>> + * mem_cgroup_private_id_put - put memcgid and get the nearest =
online memcg
>>> + * @id: the memcg private id got from mem_cgroup_id_get_online
>>> + * @n: count of references to put
>>> + */
>>> +static struct mem_cgroup *mem_cgroup_private_id_put(unsigned short =
id, unsigned int n)
>>=20
>> Having an API that put reference-counted resources return a struct =
pointer
>> is a very strange design. Please don't do that.
>=20
> That's true.
>=20
>>=20
>>>  {
>>>   struct mem_cgroup *memcg;
>>>   rcu_read_lock();
>>>   memcg =3D mem_cgroup_from_private_id(id);
>>> + if (!memcg)
>>> + goto out;
>>> +
>>>   __mem_cgroup_private_id_put(memcg, n);
>>> +
>>> + while (memcg_is_dying(memcg) || !mem_cgroup_tryget(memcg))
>>> + memcg =3D parent_mem_cgroup(memcg);
>>> +
>>> +out:
>>>   rcu_read_unlock();
>>> + return memcg;
>>>  }
>>>  static void mem_cgroup_private_id_kill(struct mem_cgroup *memcg)
>>> @@ -5816,7 +5830,7 @@ void __mem_cgroup_uncharge_swap(unsigned short =
id, unsigned int nr_pages)
>>>   struct mem_cgroup *memcg;
>>>   rcu_read_lock();
>>> - memcg =3D mem_cgroup_from_private_id(id);
>>=20
>> I think we can introduce a new helper like =
obj_cgroup_from_private_id(),
>> We can use the ID to get the corresponding obj_cgroup, and then get =
the
>> mem_cgroup.
>=20
> I actually did this in some local versions but gave up in the end
> because the ID should be referring to some memcg and I was not
> sure if getting some objcg from a memcgid looks normal.

But the current series is already changing the binding
relationship between IDs and pointers. You've already
established a binding between the ID and the objcg, rather
than with the memcg. Therefore, I think this is a very
natural transition.

Muchun,
Thanks.

>=20
> So if that is acceptable, I think it's a great idea to do like
> that! And the put can look less weird then.
>=20
> Thanks for your idea!
>=20
> Regards,
> Bingfang
>=20
>>=20
>> Muhcun,
>> Thanks.
>>> + memcg =3D mem_cgroup_private_id_put(id, nr_pages);
>>>   if (memcg) {
>>>   if (!mem_cgroup_is_root(memcg)) {
>>>   if (do_memsw_account())
>>> @@ -5825,10 +5839,10 @@ void __mem_cgroup_uncharge_swap(unsigned =
short id, unsigned int nr_pages)
>>>   page_counter_uncharge(&memcg->swap, nr_pages);
>>>   }
>>>   mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
>>> - mem_cgroup_private_id_put(id, nr_pages);
>>>   }
>>>   rcu_read_unlock();
>>> + mem_cgroup_put(memcg);
>>>  }
>>>  long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)


