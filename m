Received: from mail-qk2-f24.google.com (mail-qk2-f24.google.com [74.125.230.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECB23AB460
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 03:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790135149; cv=none; b=C6lDGJ6B16lXDkK28uJZBpjgHvOC++/869hZwCFwogtNvy1w8o17105PAeZOyI0ABUUoNqh/Lly4neW/vJqooAW/N4ZPRiGIh1XKXoTPk9aoKdveVGmFaldOD2N7LL6Ff5tptTm4UjUQlXnALBJWzwSaEvqGlm2y9Hqs4u5Lpjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790135149; c=relaxed/simple;
	bh=VV1daVIrklm8NAgbxgWTs5E3t9FJPZkllrfVvHSGNKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MXttokhXS8wT/H09Urt7v94C/gQO8ghaTOBEYcTGSfmONJ/4NIFDKPXMbtJkdBjzB6xcCH4tTgCtaIRS3B/KM1//VX41p4wGrf1ypHjwCDSzpDxZJvNcGm9yejl+Xv4+5Y4G+PbshoxMnEk3X3cwX4nUonndBhkMNhMAFi3keLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Zt/OGiWx; arc=none smtp.client-ip=74.125.230.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Zt/OGiWx"
Received: by mail-qk2-f24.google.com with SMTP id af79cd13be357-939695b5741so48371485a.1
        for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 20:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790135146; x=1790739946; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZoBrlOKKae5h9YawjwIgBVWbvwNAnx3gQiwI9yKP0ug=;
        b=Zt/OGiWx7g8a52pa3BBPdNAIO3+0rszNi2trrvmvOe7cHSYjdF0fz0fQfT5r0avt07
         nq8cg7ODvqcLfdAPk/YHg9azI/kUw8IOqKn1dV299dlnHschpGz65crsDNzu4YxpoxPw
         NtHaD0MZgVYh7mlxMEqxrK4IBTL95n8vcod3yhuLfFQVP6+xVp+q2ZIV1t/kjXsCchzi
         Prgwy14wQi5ziOJMDYxHkW8oBMqlkeuC1wZu4/cyQQo9Eo2InPZ5YSFX5g4HXEOvtLsA
         D4DiuUv4ZIHZBmP8IQX86irI9/U9D505Yqb5Cg32OviDvJ3ddpyyrXlZn6QYlPRXAKAD
         8F3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790135146; x=1790739946;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZoBrlOKKae5h9YawjwIgBVWbvwNAnx3gQiwI9yKP0ug=;
        b=2Yuubl/5RMJXTYeHdEZpq0CHjTCcutWRY3Qdy4QVMe4g2FDRcHD058du44mNyYEUrV
         VVUCnhyE/9AKl3JzW3hMq72nJ8uA4JqRAuHi2Kc1h9Y418fBn642YRhmy+1Q/fTS5g5g
         q9gXbOeeIgr6mOXzOpAU2IPv0An8lFBcvP1cUFDXwH8ktuAsed6iNfxaLbeUD33veMx9
         4+Ok7AirmZmKqU4t4Qp3zwGPW58Ez2qq71B0J7Sm46Aip/uloty2SOtbJyKr69R9Hnl6
         Aqo+5gdNIuipDZn3hqpNEWJ3JYZfnGmSAkFFFdoqPbgLyWp9BjoofhTOzmgJUltT1Smi
         au0Q==
X-Forwarded-Encrypted: i=1; AKwUvBwNG/oczOGn0QkpPhHq9QP6u+L93lPCpaSi8cAhJKOgSs+bClQak9IdfnA0kzYnDr1H4NSldt3f@vger.kernel.org
X-Gm-Message-State: AFuF++lVWcj1rL4FACdzzwSfsppXH2azdMD5VS1lCY8c1PHlYY1EDiZR
	UgowqHUlPGWdmZ9pBX6CzNqcUmfODEPWWUbwk3ENH6d7PlmUQzrL1ZP6YOI44+n9qdA=
X-Gm-Gg: AYBFou3vwslGtUu6Y+lYWFCQ5pbzJBlaq1zFjQvwkb/+TwfS0eTQae3dFLncg5kyK+1
	r2axanGpDT9ADVWZ0wcbpT1Lp+fiwe1/TAOx0mh5K6TM8T8aEP4nawJ0tbX+uUtg4NfjesBwNgU
	R3ONFdez8Bcf9X7rfJpSCRXoMubScFrU4Ib0IPVt5DTJzE6nRzFqZqWQ/6yGHrgxYcUowQcR6qy
	UhuJJ/iIGcuE2uPnA52TmeYcgo9w/Db4RHGJ1oEW/kdnuPkBy/5nOqL/4kKKmYgnII69ZmEb64A
	KOeU97bmwDyN7G3FOny3Q17J4Z9EfY0RnBbudWyJTQd2ykwaV3jsiJ091M7OIr5fWVJUygJVREC
	c1bLSJQOJFlRZ1nPo4qRvqwG3UTjPuBNhkbWOSwW0f8n+eOVuoksS0R5UbqzqYqmMdm9fC4g/I/
	wgBh+eUuCUwe2jcZlwGloqipjHN/ZBwKhYPcS9EDtB+UXQTWHJPKa4vBxACiLoEZkbetMTkXoAV
	vbi0+BBJE8Rx1Atg/V0CSjhyOKeWiPM0rPcO8d/fIOCnEuy4yY33VU=
X-Received: by 2002:a05:620a:6f04:b0:93b:d79e:18f6 with SMTP id af79cd13be357-93c2521bb42mr221267385a.57.1790135146524;
        Tue, 22 Sep 2026 20:45:46 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c248a1481sm136441685a.35.2026.09.22.20.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 20:45:46 -0700 (PDT)
Date: Tue, 22 Sep 2026 23:45:44 -0400
From: Gregory Price <gourry@gourry.net>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Usama Arif <usama.arif@linux.dev>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Xunlei Pang <xlpang@linux.alibaba.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mm: memcontrol: drop kmemcg_id and use the memcg
 ID for list_lru indexing
Message-ID: <arNK64PxTXbVEhis@gourry-fedora-PF4VCD3F>
References: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com>
 <20260907110111.2286932-2-qinyuntan@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907110111.2286932-2-qinyuntan@linux.alibaba.com>

On Mon, Sep 07, 2026 at 07:01:08PM +0800, Qinyun Tan wrote:
> kmemcg_id is a copy of the memcg ID assigned in memcg_online_kmem(),
> and is only used as the list_lru xarray index.  With
> cgroup.memory=nokmem the assignment never happens, so every memcg
> resolves to the per-node lists.  The next patch needs the index to
> work under nokmem as well, so drop the copy and use the memcg ID.
> 
> The ID works just as well as the copy did: root and NULL still
> return -1 and use the per-node lists, and the ID is only released
> after the list_lru reparenting, so a stale or recycled ID can never
> reach a live list_lru entry.
> 
> The early return of memcg_offline_kmem() under nokmem is dropped as
> well, so the reparenting also covers lrus that stay memcg aware
> without kmem accounting.
> 
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>

This breaks an assert in memcg_struct_check - i think you want to drop
this line as well

---

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5d7a26c91610..fcba9eb55659 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5886,8 +5886,6 @@ static void __init memcg_struct_check(void)
 				      private_id_objcg);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
 				      private_id);
-	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
-				      kmemcg_id);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
 				      oom_group);
 
