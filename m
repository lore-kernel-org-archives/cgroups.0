Received: from mail-oi2-f13.google.com (mail-oi2-f13.google.com [74.125.231.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0356D5187F1
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 22:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790030150; cv=none; b=R8cfNncmXA0m8Di/2nBadByH1kUxIhqJxk0i84KpHOwC3oSYY8htF3BkzUzZTutUn0Vr8EtouThusTCi+erWKwMghEdzb3bLBiYH5/sGWBVxw/ScpbB2axCmRZUsQ/d+wqmj8esPbj8Bv5BNT7LU/r6mqzNWCsokxofcrdn5Z30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790030150; c=relaxed/simple;
	bh=UvcbGc822koLaOALFi/wSkQju9rQju2KghdVJzDbQUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkfICZCfjEBDC7CSU9wzYsq4Sq/C4wmdVi64W23yYLcxJblZc7Z6Z5PSNnXcrqJCL4QUFQ+btbqp6jHwOAJwX0PDRWrqcb4f8UEyZkc4FRWE6PZkKdzL7pTlDf1MUNmeP7gq9FihcVnq2vziFNeZJ6KmjBVjWgB0P/1Sn4GK/D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qph1jtCk; arc=none smtp.client-ip=74.125.231.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qph1jtCk"
Received: by mail-oi2-f13.google.com with SMTP id 5614622812f47-4c112aaaf04so2117105b6e.1
        for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 15:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790030148; x=1790634948; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qNGCiFvjZR5zDf6Moy6F7fBM805r8TOBg7DYawpb12s=;
        b=Qph1jtCkDmMdp1QpBpOZa5D7rpEJv9xvRktWT3YXf1ItQlS/4FMQiBkitEO6QgAVPK
         4e6V3ND8uNe+KMdVJW3A+pTYfwJfOiNPtNBu47J0Ug6NCABpQECFo574qS9yazY64Mm1
         EAz3uyF2BRH6L22WO42SjWoLfnUAYuOIKk/yi6lIExowKeBbrC07Du0gy8fJwNMMMIUg
         15DeM4KRNnxn1sdwn0ugepOT43XezA4CVx5V3CK2SktvzHA/ObeEV5cVM6mDdIGfu4Y/
         3Qnj0Cn86s7aztaT0cqBgrocaQd4FHLQ8npRcv6GGeU3J/9cK7v+b/xQAXmsmPeYiKmh
         eoeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790030148; x=1790634948;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qNGCiFvjZR5zDf6Moy6F7fBM805r8TOBg7DYawpb12s=;
        b=V6aI71z20mkG11wDBWFPSvWeAws9qG3Z2KOzq6tArfht8Gg8zjHbbYAMfijZ+rg0xg
         C3I2am1xrnIXLUMbirch5s+y/2GMk0WvlakFv4iTS6944ZWkLF3hp2aO5nOjzx3lNzBf
         CALulwablyKt3bNbetMkwO1p6bvXTEK7C8mkUJ2bgDCDMfEYZ6OlACQ7Uq1Ggiyq163L
         TrCALMjqwAyaQphFnhUkxpUy4Bh1eHhphnp9DRS8I10qe7VWgNGO2GqgQz4pK8GgFogK
         l9/42gS82GMusJ1XIlCGHYc0LTWluxouItvu3jl7x+ppzaWgmc6KXR9MOS3maN+GOGvR
         UraA==
X-Forwarded-Encrypted: i=1; AKwUvBx3s4NWB5dO/+SB9UFsmlaDmiiyVI1s9FmJ2V1sBehAwATOHPntctf4JG5CK4ZIinGurt1ikbV2@vger.kernel.org
X-Gm-Message-State: AFuF++nwV788XUQCMHEkI31MXydDRwGmVUNOzWxCQcJBpoALBYDAMAkE
	HufsuOdAAO1X5g3kaFZRI6aU6YeUTVMwHlKllmdyuSO2Iu7DVGwjxaXv
X-Gm-Gg: AYBFou3hKAtjLkWwdtI99InijEKTfRDkfi2LruP0yHeEixdHH8gYAnkqZR84/6DgEu4
	seIlsTZBnYq5VddJEj23xDjNigCMsWyxbLKvrKh2mcRDQ1r7Rd6F7d/+I6+JPJI7MOiW6gQlq8m
	KKDwk99M4/Yq3LL+swNL0+fFv+v10lwj6o0HnCL/vhlS0uG1qJDLzyE0bM7ibNBYvVH4Yb7b4OC
	ABASkK0QH1TNsfd5xZbte9aAZRp8r1rIKaA3ESu1W+74GzWjO13akUi8mgSvWGGYX8ZinyGUZzR
	DIKqk4bhQMj+kWtCTxlm2ol8mUjmLF1BnzzhLflfS9Z+A8LaTzRYYdlKjz8xS3SN/7e4ICAU2f8
	FJaC9Ha3Xrq/LePxm3RJMqG4zvmPlRNaqFeuKUTRvsT/13pVcxztFByovKVM/uPV3DDrxN14uCj
	rq3mwrPH/liwi0rt6z3jmFpTefKDS1Qb2zXhI7q/NJY7sKb5jgAMw/KDhtkTKgXyRfEmwWCCKDK
	JjwgQF6g9/r6QmZD5KHXEuYwi+UxQ==
X-Received: by 2002:a05:6808:1185:b0:4cb:f21c:a799 with SMTP id 5614622812f47-4ccf9366320mr12128261b6e.33.1790030147780;
        Mon, 21 Sep 2026 15:35:47 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:16::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-814e649352bsm93244a34.19.2026.09.21.15.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 15:35:47 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chris Down <chris@chrisdown.name>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/hugetlb: account migration target folio in per-node NR_HUGETLB vmstat
Date: Mon, 21 Sep 2026 15:35:44 -0700
Message-ID: <20260921223544.2401052-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260921-for-hugetlb_state-v1-1-8a6eec92661f@kylinos.cn>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 21 Sep 2026 17:12:34 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:

Hi Hongfu,

Thanks for this fix. From the cover letter I was frowning because I was
thinking to myself "surely there's no way hugetlb accounting is this
broken..." but it seems like indeed it is. 

> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> The NR_HUGETLB vmstat counter is maintained per folio's node: incremented
> when a huge page is handed to a user via hugetlb_alloc_folio() and
> decremented when it is returned to the pool via free_huge_folio().
> 
> A folio obtained by alloc_hugetlb_folio_nodemask() never goes through
> hugetlb_alloc_folio(), so it is never accounted, while its free always
> is.

That's pretty scary! Glad that you caught it here.

> For a migration target this means the target node gets no matching
> increment for the decrement on the old node, so the global nr_hugetlb in
> /proc/vmstat drops by nr_pages for each migration. The same asymmetry
> affects the failed migration path, which frees the target again right
> away, and the temporary folio hugetlb_mfill_atomic_pte() takes from the
> same helper.
> 
> alloc_hugetlb_folio_reserve(), used to preallocate the memfd page cache
> folios, has the same asymmetry: the folio is handed to a user without
> being accounted, while its free is accounted through free_huge_folio().
> 
> Account the folio where it is obtained, in alloc_hugetlb_folio_nodemask()
> and alloc_hugetlb_folio_reserve(), so that the increment pairs with the
> decrement in free_huge_folio(): a successful migration hands the folio
> to a user, a failed one frees it again.

The changes look good to me, and I was able to reproduce the issue on
my host and confirm that after this change, the missing charge is
fully accounted for.
Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Again, I'm super surprised that a problem this big has gone unnoticed
for so long. Thanks again for working on this fix!

I hope you have a great day : -)
Joshua

> Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---
