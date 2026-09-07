Received: from cu-gy11p00im-quki08153201.gy.silu.net (cu-gy11p00im-quki08153201.gy.silu.net [157.255.1.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0131F3672BD;
	Mon,  7 Sep 2026 12:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=157.255.1.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788782971; cv=none; b=dzoq7uE8FWgRu/zXMzG5eNqW2ypdzCRizHvjWkWE260kIfIyN54MeJoIOD8iIsgxhycj7ntySJMN14Tfuen2hiTfnvmnLRUcOLGx/Q4lr+Kcg3o8xoGpIzCKSI0nEz7X1uyY5gIQ+0olTHiFLfb7uZw+0YL21QV9JIKyJy+ypq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788782971; c=relaxed/simple;
	bh=hWYBU33sQwPDjePFz5tVHRbNWpSk0swRP8jM6Pa5I/Y=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=DWgno+ESFxfN7T2w7v9yNM/p3SoVSQvGx2d3xWSaq0gWfoq3pfIpHrRofp3pQzFSEAopnkgxZ4/5jhMafcNsD/bj/suze43jfzBR8VtSXG4bW415JqifDSbRIu2yiO/1+WNXMcb6QVeVSjrWz08uywJe+3bf9KHR6oYrtAyJSSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=HVEu8xhS; arc=none smtp.client-ip=157.255.1.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="HVEu8xhS"
Received: from smtpclient.apple (gy11p00im-asmtpcmvip.gy.silu.net [112.19.199.76])
	by gy11p00im-quki08153201.gy.silu.net (Postfix) with ESMTPSA id 98C9B24600BF;
	Mon,  7 Sep 2026 12:09:22 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1788782967; x=1791374967; bh=3YnIWUzBq9n0gJzBTdfIFMYDRu6uiLWYe+l44kVXkrk=; h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To:x-icloud-hme; b=HVEu8xhSfSb+VquGtfp4oe+zpOkceINU+/+TFp33gMNUvPRSLsxjtXVsiEBXxxl0OaAbLJm4xdevpXp9sNtdZ3YrpjTPZkgez2FTHhcnmm4gGXmQNjOfXUh27puQfmuQTVsveZEymL97r6N1S2MnH8SGxsfDCEA669pyLCLwsE0J9nfez/zj2yq0X8cHYcQmVewu06xA5BRF5OvFE/g1W89JoWN7sc6UTKaGDFNZwrmhUrBjOf7jFdJkuYmRToL0hRASE5GHH6YF6ql6E+62PBXzJWaxf30J8ve2fVIm12DPFxI/oQp1QzUQJLWML6sJLmq5Y2aozz1Tzoijyj/gQQ==
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH RFC v2 3/6] mm/memcg: pass the id itself instead of memcg
 for putting ID
From: Bingfang Guo <bfguo@icloud.com>
In-Reply-To: <29c98946-cb26-4b1e-8a95-fbdc9c9671ad@linux.dev>
Date: Mon, 7 Sep 2026 20:08:56 +0800
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
Message-Id: <F14C600B-D8AB-40E1-97B5-D3B354BA9E1B@icloud.com>
References: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
 <20260901-bingfangguo-memcgid-rework-v2-3-8edd7f7a7251@tencent.com>
 <29c98946-cb26-4b1e-8a95-fbdc9c9671ad@linux.dev>
To: Muchun Song <muchun.song@linux.dev>
X-Mailer: Apple Mail (2.3864.300.41.1.7)
X-Proofpoint-ORIG-GUID: hSpqanX9zO9iIYtdsWNxFt_LhSorxX3u
X-Proofpoint-GUID: hSpqanX9zO9iIYtdsWNxFt_LhSorxX3u
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExNSBTYWx0ZWRfXwFWvk7Tns3eP
 QdmEr2P8kYx7kOOmbXky6GAaMBsP37rs+iOaViQXa5ktAJMa+oJtPSnmBCCkky/UIWDMadkKTNh
 pD41TDaUxVejkoI3VuoQi6IQVhE/zvCS2uWtL9EO6MWR80QeSFZJ9EjmtJxX4OtguZNbASn7oNP
 VcSnL+pEllZvh1hG+c/fDl9peMd1VMg575W0HquuTUWoLO6jie50ncvubZi+ueYiBYdu5I3mIKf
 pP63eUw13EpsqBEGyWpIwfvqg4GvDDHHo8nzHosjARRjNLVs3eC7RM18dNesQGg4GmT/Z0gG6tF
 wsnSqyY4p5xDBThZvrFaay6pld+qgiIj8DZsI5i7Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_02,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 clxscore=-2147483648 phishscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2609070115

On Sat, Sep 05, 2026 at 06:01:44PM +0800, Muchun Song wrote:
>=20
>=20
> On 2026/9/1 16:58, Bingfang Guo via B4 Relay wrote:
>> From: Bingfang Guo <bingfangguo@tencent.com>
>>=20
>> Swap uncharge knows the memcg only by its private id, and the id can
>> outlive the memcg it used to belong to after we rebind memcgid to
>> objcgs.  Make mem_cgroup_private_id_put() take the id and resolve the
>> memcg containing the refcount internally, and keep the underlying
>> __mem_cgroup_private_id_put() for the offline path that still holds a
>> memcg pointer.
>>=20
>> In the uncharge path, the memcg pointer will have to be read from the
>> xarray twice, but we'll fix that later by returning the memcg from =
the
>> put path, so the uncharge path can obtain a reference in the same =
step.
>>=20
>> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
>> ---
>> mm/memcontrol.c | 17 ++++++++++++++---
>> 1 file changed, 14 insertions(+), 3 deletions(-)
>>=20
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index ecb4fb07d7735..048c9bb0fad79 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -4038,7 +4038,7 @@ static void mem_cgroup_private_id_remove(struct =
mem_cgroup *memcg)
>> 	}
>> }
>> -static inline void mem_cgroup_private_id_put(struct mem_cgroup =
*memcg, unsigned int n)
>> +static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, =
unsigned int n)
>> {
>> 	if (refcount_sub_and_test(n, &memcg->id.ref)) {
>> 		mem_cgroup_private_id_remove(memcg);
>> @@ -4048,9 +4048,19 @@ static inline void =
mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned
>> 	}
>> }
>> +static void mem_cgroup_private_id_put(unsigned short id, unsigned =
int n)
>> +{
>> +	struct mem_cgroup *memcg;
>> +
>> +	rcu_read_lock();
>> +	memcg =3D mem_cgroup_from_private_id(id);
>> +	__mem_cgroup_private_id_put(memcg, n);
>> +	rcu_read_unlock();
>> +}
>=20
> To me, the direction of this change makes sense. At the same
> time, I would also suggest applying a similar change to the get
> function, for example: change mem_cgroup_private_id_get_online
> to:
>=20
>    unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg,
>                                             unsigned int n);
>=20
> Have it return a private ID. That way, I think the two interfaces
> look much more symmetrical overall.
>=20
> Based on this change, it should be easier to implement the
> direction of my last suggestion in Patch 5.
>=20
> Muchun,
> Thanks.
>=20

After taking a closer look at Patch 2, I find that charging the
counter before getting memcgid is problematic if the current
memcg is dying.

If the memcg is not root, the swap counter will be charged. But
if it is also dying, we'll get the root's ID and store that in
the swap table, which creates an inconsistent state and leak the
charge when we do swap uncharge, find that the corresponding
objcg is root and skip uncharging the counter.

On the other hand, if we restore the old logic to get an ID first
and then charge if the ID refers to a root objcg, we'll have to
access the xarray again to retrieve the objcg, or return the
objcg using a pointer in the parameter list. And both are not
ideal to me.

I think a better plan is to just check the root status of the
memcgid itself.  We can store the root memcg's ID just as
root_mem_cgroup and add a function:

  bool mem_cgroup_private_id_is_root(unsigned short id);

This makes memcgid related operations a family: we have get, put
and can check its root status independently, without having to go
through another object.  And we can use it to decide whether we
should skip root charge/uncharge for all three functions
(memcgv1, swap charge and uncharge).

>> +
>> static void mem_cgroup_private_id_kill(struct mem_cgroup *memcg)
>> {
>> -	mem_cgroup_private_id_put(memcg, 1);
>> +	__mem_cgroup_private_id_put(memcg, 1);
>> }
>> struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup =
*memcg, unsigned int n)
>> @@ -5815,9 +5825,10 @@ void __mem_cgroup_uncharge_swap(unsigned short =
id, unsigned int nr_pages)
>> 				page_counter_uncharge(&memcg->swap, =
nr_pages);
>> 		}
>> 		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
>> -		mem_cgroup_private_id_put(memcg, nr_pages);
>> +		mem_cgroup_private_id_put(id, nr_pages);
>> 	}
>> 	rcu_read_unlock();
>> +
>> }
>> long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
>>=20
>=20

