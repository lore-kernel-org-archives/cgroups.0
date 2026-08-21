Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534C53DDB15
	for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 18:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787338674; cv=none; b=lBjme9uhVqev5W2QGJkhgA6HYjajq0iZ7Q8qXDI41gHIUyTh72IULB2zy599YqimV6qf1iJU8qULWfXKK8yl44yPkoEbKu9hVnwO7HIIa7oMxaHtGtTywmKeHKpOq5tQidjqq0DjMT5BKIQeWKgwygi8G88RzHcmIUlJ0xrY6z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787338674; c=relaxed/simple;
	bh=S1+AOOCO+x8P/REZAh+d8jQSHgoqsnPS3Vwsod8b5LE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=bGvFOEOKFgUf6yFWzgokyg7e0JxGlOTUUwyKYMrTvp/t+evWD73OGChUUj28Y/yijFGn/WRT1l+5YM3FIWlO3H42LZLYOsw8drEFhrOEHtPG0FjMrzZrMUGaygiQ+nzspkv0UJXMC69nXVus4uoENAi2UAvLdY27p5YNjFSxg7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BGseqZ7w; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=esLxkPs1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BGseqZ7w";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="esLxkPs1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787338672;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=g7+NxbGivt12D871ywA3vXdCtRMIy1dH4uv3I74lADM=;
	b=BGseqZ7w3iKycabokBueXBw8eVrkCklVZHGm6OBy6DdmC9wBk0fkrbMfAGAkLCHo2hes0C
	lbL0u7Fp0Z6lTNb1lN4k7e25DKfO4PmMMCE9Ofu8YdF42BQcvvKYxSFVY7b/IoongEw0dz
	Ot7ZnDqUrNbT/cdyHuCeG7Ozfibu2AY=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-481-i_7PBJA9OSS69VYXsU-jUA-1; Fri, 21 Aug 2026 14:57:51 -0400
X-MC-Unique: i_7PBJA9OSS69VYXsU-jUA-1
X-Mimecast-MFC-AGG-ID: i_7PBJA9OSS69VYXsU-jUA_1787338670
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-936708f129aso112526585a.0
        for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 11:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787338670; x=1787943470; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=g7+NxbGivt12D871ywA3vXdCtRMIy1dH4uv3I74lADM=;
        b=esLxkPs1Rx3z5LUsnZ9ZJF+OODcjOIv+cWb+hMZRtsTejwyNT7+5JRqFP0GWYnWT6i
         sD6h5g1pnfGJZlgJ06FN7YRfhJ70BUBefr135zSE2MT2rvyZ4x9yYTDap4HCbBOZ0udK
         PmUeKZFvOk31a5iili5i32Yfo+lW044mSTzFYY6YFmAQbjkR7faVFRhLKc/fjZCAi9lb
         ulKSejZ+aMHAJhrGhT/u6tFlC8kBo2xogtHMFjd7zelSRQmZIoCkawDSx9t9UeIIFFWt
         Cb+ypyhaP1DIpTw6mCX7p9SF14VfAB9E/9haOSJ3/4uR8tpNJWih+FmEFTJ22XdpQMCk
         w8LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787338670; x=1787943470;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=g7+NxbGivt12D871ywA3vXdCtRMIy1dH4uv3I74lADM=;
        b=Wj+E81iU9u3vp9WCgITP8SF/WuG2Xs6dJfUVwbOnvI9OjpAKvzX2f0eYN+J4E3VJbV
         00pzTEpn90Q74dim4UDmDAUJpItqOO181sEkEE1cB8MIM/KP/LIQ6GIg3yvRkaCQYDrI
         TC5/ofkHxw2bmzf78bQhyUXdSfcGug/Rj3KGUf5+NCXGVExy+TMW4bftno59YTNn+9xy
         +gWTsCAdwqywyEfA48DseAjwGXDYp9HJ0g0PXnRvRwug760G5fGoDe/z6XdPV/+NW8y8
         zn3XdI6n04V+zDUL/zjpfp4VuXcllSaFqlSYAE0E5VgdqqFx7uy2Cep7Bw5sM9/n1Jeu
         u8xg==
X-Forwarded-Encrypted: i=1; AHgh+Rq4s5orxjkw9wCWx37HZ/d3gv2uzbnsj7qxQI+XMiYDXgMM5KWTHyx7Pba4HD9njsf1W3Ixe9MC@vger.kernel.org
X-Gm-Message-State: AFuF++lnS1Y/80jaWPIfhz9FCcKlHJtzD6ydiXmrVGFgvRvFWiVuICWk
	avMXgVmdISn4fndOT7T+iJZbGiG4NE9/8NuVkt7SX0Dw1FsGu55eeqivmlQVfjzahyqn4VmhW39
	yLxMzt95RHURfPjcrfDTiJrZsGNmlDFunyyrZAdTaGMFKCHBQPLde1oldlDI=
X-Gm-Gg: AR+sD101hCLfXSc6YSk0VYv6Gt/Z0L7y+Uyv2dL0OuB9xkn9WDxmE2nG3h4BUKLcl0V
	V4195mzjQ5QE9CkzXwxCqpvi/kJdb1On8vHfGoboXsRF2HSChdwLo2YAYjVoGs+EhMDRP4ZVzrw
	jPJE5xUcJRupqsDYE587hPgoSLkXqsxZY+BGcg5ljcMU4PH46pzvgxYNGqMGxHh/tGor0b7utEt
	5Zv5AggYcwrMU/VeUX1F9xLY80ArPqGjtmZdJVY5+k2JTLiu8kkwLJXZowcRhdtPGoa6NweX1bV
	EwgCVb8Y9sa18ni4tOk7nYx6USCOOz9pJndVzBX4z5DboCdcJ9VZiMhx+p8VsDvGQWTEKsOq6QH
	zseOov2D2wnk/LU5BLNDXVzKMMB0A5OHl5lZ6mXHVZ+ZM
X-Received: by 2002:a05:620a:6306:20b0:930:9585:e08e with SMTP id af79cd13be357-9373954280emr603127185a.10.1787338670388;
        Fri, 21 Aug 2026 11:57:50 -0700 (PDT)
X-Received: by 2002:a05:620a:6306:20b0:930:9585:e08e with SMTP id af79cd13be357-9373954280emr603122285a.10.1787338669904;
        Fri, 21 Aug 2026 11:57:49 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-937205817f1sm658045085a.32.2026.08.21.11.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 11:57:49 -0700 (PDT)
From: Eric Chanudet <echanude@redhat.com>
Subject: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Date: Fri, 21 Aug 2026 14:56:52 -0400
Message-Id: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MQQqAIBAAvyJ7bsGENPtKdDBbbQ9WKEQg/T3pO
 DAzFQplpgKTqJDp5sLn0aDvBPjdHZGQt8agpNLSSI0+OUyUfMRMsckFtdV+HSgYa0do3ZUp8PM
 /5+V9P4pyRQdjAAAA
X-Change-ID: 20260706-cma-memcg-regions-696cb5ef7998
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>, 
 Albert Esteve <aesteve@redhat.com>, Eric Chanudet <echanude@redhat.com>
X-Mailer: b4 0.14.3

CMA allocations are currently unaccounted for by cgroup memory
controllers. As system resources, they should fall under memcg, but CMA
areas partition the available space for different purposes and memcg
doesn't have a good representation for that.

Add a memory_cma_accounting cgroupfs option in preparation for the
following new behavior. Make it disabled by default since it will
account for CMA allocations in memcg which may affect existing systems.

Provide CMA charge/uncharge functions to memcg that introduce a CMA area
specific counter per CMA area. Charges are issued to memcg and to a page
counter for the CMA area used. The allocation's folios are marked with
the cgroup via commit_charge() (once for large folios, per-page for
0-order ones) so they can be later uncharged correctly.

Add the new memcg calls into the cma allocator under __cma_alloc_frozen,
for both cma and hugetlb_cma allocations accounting.

Finally register the per-area usage counters in the cgroupfs. Each CMA
area creates a memory.cma.<area>.{current,max} pair for reporting and
limitation for each area.

Selftests and a vmtest script are added to this series for convenience.
The tests are simple accounting and limit enforcement verification using
the default reserved CMA area (cma=) and hugetlb_cma.

Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
Eric Chanudet (11):
      mm/cma: drop const for struct page on release API
      mm/cma: include linux/cma.h in cma.h
      cgroup: add memory_cma_accounting mount option
      memcg: add cma charge/uncharge functions for area counters
      mm/cma: charge cma allocation to memcg per area counters
      memcg: register per-area usage counters in cgroupfs
      selftests: cgroup: add cma configs for cgroup selftest suite
      selftests: cgroup: add memcg cma tests
      selftests: cgroup: add a vmtest script for memcg
      selftests: cgroup: add memcg hugetlb_cma tests
      selftests: cgroup: amend vmtest-memcg to run the hugetlb cma tests

 Documentation/admin-guide/cgroup-v2.rst         |  35 +++
 include/linux/cgroup-defs.h                     |   5 +
 include/linux/cma.h                             |   4 +-
 include/linux/memcontrol.h                      |  19 ++
 kernel/cgroup/cgroup.c                          |  15 +-
 mm/cma.c                                        |  14 +-
 mm/cma.h                                        |   6 +
 mm/cma_debug.c                                  |   1 -
 mm/cma_sysfs.c                                  |   1 -
 mm/memcontrol.c                                 | 205 ++++++++++++
 tools/testing/selftests/cgroup/.gitignore       |   1 +
 tools/testing/selftests/cgroup/Makefile         |   2 +
 tools/testing/selftests/cgroup/config           |   5 +
 tools/testing/selftests/cgroup/test_cma_memcg.c | 402 ++++++++++++++++++++++++
 tools/testing/selftests/cgroup/vmtest-memcg.sh  | 197 ++++++++++++
 15 files changed, 903 insertions(+), 9 deletions(-)
---
base-commit: 98f21c54f99519329c18e2625b0ea6db14524d09
change-id: 20260706-cma-memcg-regions-696cb5ef7998

Best regards,
-- 
Eric Chanudet <echanude@redhat.com>

