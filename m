Received: from cu-ua11p00im-quki07171502.ua.silu.net (cu-ua11p00im-quki07171502.ua.silu.net [123.126.78.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609602E0B5C;
	Sun, 20 Sep 2026 10:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=123.126.78.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789898883; cv=none; b=PjQKEfDq8jVlMUEuKxw8WuzfEwa7nZCfcuPsEm4DJmMmB2V1gLHNvlKYF6Od3ikeHztOiRdcoFgu3J5QMPkW5Ad2ITtGypa0nuvULVj5AzpW+T4/6/z3sNG35qVE5VmMQa5Hl3uIvNHkQEQ7ilpI6jN7rkLPg+oZpL6M/KxT0z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789898883; c=relaxed/simple;
	bh=zaHY5NBLEZnljNLVXvcA7+FjEJqwQ/nEJy/cBU5A/ac=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=ZBU614qNEZhe9LnvC1rL3zjlAzMBsjdhmfZoFn0rl2S2pYyBOAntGscW23a7FU14xS6KoJVn5Ds+Eo6v5KuxonQeZSIcqckWdLxIzFyMECR2S9x4SnCSjsSiW16tgt7nuMPhIlAZ73t8KW7xlOo0YPmYECQN24BMdZnl+mhCU6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=JHkA0eRm; arc=none smtp.client-ip=123.126.78.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="JHkA0eRm"
Received: from smtpclient.apple (ua11p00im-asmtpcmvip.ua.silu.net [112.19.242.76])
	by ua11p00im-quki07171502.ua.silu.net (Postfix) with ESMTPSA id 4818B28C00AA;
	Sun, 20 Sep 2026 10:07:56 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1789898878; x=1792490878; bh=E55+tu5KL9AnKSPgSq7nNcHqWE11x7RdNO/VLX6SJ48=; h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To:x-icloud-hme; b=JHkA0eRmHTEAbrTiOqLc/wgflI1kMXfD5f+z+E6+WiJmG473XO1KKygYZrUGRblQd37Qu0tx1tKGb3sxAxyPROuQL58z82D51Do3UJGPlZSler5+WnuBZ9UdfMeuaiuB4LeFAHp3X701YcatUh/YS5se0zSG5jrB+emKZ69D/4/aEa4BnUVBGIheejrWKgTz7aYKv9330qfE2frmPL9xxT86OCTP2KoqhTTYM65N1NiWnfSZG6U6G+X02HUfAJqB+uV8Ebxw4NPR6zLzkbfWIUCM5IQ8PV7yxJ0w7BW84pCEgufS+q475HoogLVdd1VQKg2PaX4tQSJ4SXyTdwtUaw==
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH 3/4] memcg: manipulate memcg private ID references by ID
From: Bingfang Guo <bfguo@icloud.com>
In-Reply-To: <aq2dkhBuFktQYvTB@linux.dev>
Date: Sun, 20 Sep 2026 18:07:45 +0800
Cc: bingfangguo@tencent.com,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <CA3A67DE-DF83-4B0E-81A2-AEDE93FF5F78@icloud.com>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
 <20260918-bingfangguo-memcgid-rework-v1-3-5bbf3220d88f@tencent.com>
 <aq1_Qhid7-62pHcW@linux.dev> <aq2BfYdMr_8JeY_Q@BINGFANGGUO-MC0>
 <aq2dkhBuFktQYvTB@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Mailer: Apple Mail (2.3864.300.41.1.7)
X-Proofpoint-GUID: 0QbLG567OwrrvR_Np6s0bqe9fIGmmYD0
X-Proofpoint-ORIG-GUID: 0QbLG567OwrrvR_Np6s0bqe9fIGmmYD0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDM1MCBTYWx0ZWRfX+m7HBmfAwO1j
 AtWl7t9WlxmlYW9eNvvo6Q1otP//97j1N414CgEtjWHPsyhBgZwytYaIEY7oQI06dhkSBiG7W1H
 4tCQgrsbQ/VQ8ECVV5qvLdSCOdPSAH15KYezyMtrUjOeiwcgDSCwydqy0cSBySIbziJxyVhZ/6s
 4X41epvGF5KKjnuBD+78goInNK+0qdx38bJQXLaNYr6TNl3m1LdD+GkFZFqf2nNxsVAvthnW6fR
 ziH3+zFFAK9EKTMqo+tnA2RC0StgxQI0JyIZzsQ6hBSRgFRjSDj0Fl0ZI9hetjMngjbRxXccUv2
 iUHRkLCl6UfAzWeuAfLDAKPme4UukO02ECorql/xw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-19_07,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=900
 lowpriorityscore=0 bulkscore=0 spamscore=0 malwarescore=0
 clxscore=-2147483648 suspectscore=0 mlxscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2609190350

On Fri, Sep 18, 2026 at 01:24:01PM -0700, Shakeel Butt wrote:
> On Sat, Sep 19, 2026 at 02:46:52AM +0800, Bingfang Guo wrote:
>> Thanks for pointing out this.
>>=20
>> Agreed.  Both two callers are already holding the rcu lock so
>> taking the lock here is unnecessary. So I will drop the
>> rcu_read_lock() and use that in the next version!
>>=20
>> My concern is that: mem_cgroup_private_id_put() looks like a
>> universal put function, requiring rcu held (which is true today)
>> is not that obvious to the users.  So I think adding a short kdoc
>> comment to make it clear later might be a good idea.
>=20
> This function is internal to memcg code, so whoever is going to call =
it better
> know to call it with rcu held because of lockdep assert. No need to =
have a
> comment.

Okay, I'll keep that in mind!

