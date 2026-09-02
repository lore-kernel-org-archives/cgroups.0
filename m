Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0DA4CCDC9
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 19:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377310; cv=none; b=ZTIOf84YUBddqYX9y7BGu4ViNE+Jl1+8uM9Cac93nRV2OXKBqFebJJ/XgAShhVt7NVTQCFVtmWJtK2EDav03HLljxgXicyRl+KFes+Uor4Y446+ROCNaVOpI0cdJdrkpM82s4l+TO4cCgB1U27pnkXcKCFZ7vJtGixcRAkgIbb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377310; c=relaxed/simple;
	bh=yUEHEeReCZ4YDwLuJjsFeMZaNLX0OqqIMp+1QYovZ20=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=oRkTPx9s1QtimChz+vU0GJ9be7wJMQxgG1Ji92kZxrQNgwwTipQoiGlslcH67afyPzOcwn8lKcgzO7HnbcPxI5KTBSHWyoUXrmwZpoePvKFE3vqVd/xFa0fa2J7/TtVjEsSyeZ6LWaK/eHqAAAjTrMI7MGmO223/vyTD9Tc0ve8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=niXq4kAh; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=tPqjUzse; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="niXq4kAh";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="tPqjUzse"
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682IjTac686584
	for <cgroups@vger.kernel.org>; Wed, 2 Sep 2026 15:28:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=XIT4QoZ71Osmkeg+FUd1lgbaZ4
	qc1T8WZBa2s5ZV9iA=; b=niXq4kAh4v7hiV/l+BZL0JNK9e+f+jGhoZVubGdaQ5
	9E/m53+u1+9nAzknOr+b2/5r9RozqOe/z719xeaGcNpFyRSc4fSZd/S4wsYf7d7n
	JdgOpT92vu2DnDyzwLdkmYTkgcI5tz+aDh3oS0bbR/4D/gIxCmQy8rAJBHVczWD8
	sEL9wXkCRQALtIu08cqgRrUT3rTTIz7ujZROEEI7oxV6SO51rODXtnNNFvI4xs9b
	a9MJ4j08HaijuZCyOzaOkaKJHRGqeFxKNQFAPaADLqXRvibzA2NT1Lh8uzT9hQL7
	cqrCU8YcAR/0/reH4kX1mx+ef2mGAfX+BGxHRChycY2A==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gesc08bge-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 15:28:18 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-52fbe82671dso27102401cf.2
        for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 12:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788377297; x=1788982097; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=XIT4QoZ71Osmkeg+FUd1lgbaZ4qc1T8WZBa2s5ZV9iA=;
        b=tPqjUzseAyp0XaBCmzpb8llS60nELzXCHAFl5yqNa6IsF34Huy38AKoqPduML2IGEb
         jBZX3hkFlArNNA/+p277PRB1hWN+MF+DMhcGOiJvcv9iSVxM/j8TxJ/Erb4jvI+FwYAi
         gOIH8Ei1uhMAvQCBdyF20ychgrfEWShjoHq7qtrALBdvYzfEIhp+FHHmg4kBS54eojfw
         hJu7Azl+GZhqc1t7fh3/4X6lfpyygUVNlIWpPAwv3HMT+nNevw5Zn5iLEv0k08PVI5gm
         MYm/WBDhgNEQ0Iqr4ccWu/Ni+XFm3o9U/cnwUPzqrpEOyCSvPu+wF7ZvF094f+RW5Nkl
         k1EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377297; x=1788982097;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=XIT4QoZ71Osmkeg+FUd1lgbaZ4qc1T8WZBa2s5ZV9iA=;
        b=rIsFHtWoNWqOKzT8/fMa0AsareTYbccOw/VENEFZ+i201W+exjJN73YhgA3vokF+jK
         4ziNWYjy07F+ZaLC4/4ZH6lgwa9y6rvBgf2ewQhzeUnCxNLdsiru2Y1LIj1F0wGId4ZG
         3/qHoWSUL1ND2oU4y1H8Tk+NegS9nht2qJ/gNuf2/xM1nJpRmM2n2y5+su0l8w1T5vDO
         khwsRCg6smRf/8y0/103bQ6dxiJO9PWql3q7W8Mk/Yy4/0SHx6s34ZW4b+KblUtoJL7L
         NYMUT3wjc02W87gGdZdqAB4htD9IRqhMqjKU6daCXpPzDyQ2A4bu3SFQ1wFamGDBAom9
         NlBg==
X-Gm-Message-State: AFuF++k+MJCsHKEGaadkEovGxxiikgHAbmQvvuB+SCzuaStK/IGytSlc
	edECVNQdX+SRwl23ZdDc4KhbCkHSuVl1iQA7ng+8CxdYa6CRzHNHZ/ZoQkjCb676s4wus9DY7Ex
	be3yO5iMxy8OxLGeaCsg/HJ3zHEIgdAVn/mFSKncEC8V4gPr+WvZOH5c=
X-Gm-Gg: AYBFou0uA7UYCm0+fHekQLnxWe0c9G0iDllRj/Tm2uQYyBjYi/uo8cAhXHGwLnKD4Cf
	UXsXC0uLbYAGltypBnIGJVlMr8hvsCpDrb7l/aR3V0CQKs8pkuxVaBXDzTfXdgssRFBROqbG3SF
	CpG2ib6FDKGANeSTvf7T9a4VRFbFX9J73TWMEVVZ9nsY6IJQu5o4gdV7tDALE2PunSJYSwsBIe6
	YGH3ISjzz58+J7CJSYxkArvnjMnT1a9NHBFlHW2r8KRF42kcYVyOPw8c2GC+Ey/wUQscVGYUYOC
	6TunAJcV9nAN6kiNSmCPWdBmd414geOhIL2af4WL3HfWvbODeesf59wElY6JRi4hvUOcFpRdH0B
	xyc82+TQ4zHlMtw2+o/rDJI1R/sQ4PUZlosFZrRSP7RZI3idqNMTTZQ==
X-Received: by 2002:a05:622a:259b:b0:530:42e5:f3a6 with SMTP id d75a77b69052e-53042e5f678mr19138171cf.41.1788377296985;
        Wed, 02 Sep 2026 12:28:16 -0700 (PDT)
X-Received: by 2002:a05:622a:259b:b0:530:42e5:f3a6 with SMTP id d75a77b69052e-53042e5f678mr19137421cf.41.1788377296525;
        Wed, 02 Sep 2026 12:28:16 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-193.net.columbia.edu. [128.59.178.193])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eec85a0sm25420936d6.29.2026.09.02.12.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:28:16 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH 00/11] mm: memcontrol: constify the read side of the memcg
 API
Date: Wed, 02 Sep 2026 15:27:46 -0400
Message-Id: <20260902-folio_memcg-const-v1-0-e2c1da22246d@columbia.edu>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALJ4mGoC/yXMTQ5AMBBA4avIrDUpqZ+4iohQgxFa6SAScXfF8
 lu8dwGjI2QoggscHsRkjUcUBqDHxgwoqPOGWMapzGUmejuTrRdc9CC0NbwJ1aQZKtmpPGnBd6v
 Dns7vWVa/eW8n1Ns7gvt+ADk2adB1AAAA
X-Change-ID: 20260807-folio_memcg-const-4a67e40d485b
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788377294; l=1753;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=yUEHEeReCZ4YDwLuJjsFeMZaNLX0OqqIMp+1QYovZ20=;
 b=2daVjnF7Z44mYyYEgCKwKIDVPS3KI363eBjdVBOQmy8mvuZWK9eeEd/RLIccXxkUpN6jD5buI
 mEW0E1ifqpfDJ8ZVGf2ruhaosGULcxIBFz8zgH6A4uepudoqU4gl1p9
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX7BiFqLhhQWte
 0K5sLctKlAegYtHcBfnkniS9HbYE6h9OAlnEJ9F1thG/ropcI2HP2Bt8YtTz4G0CHq2Xcqi0LDD
 6duWRdGiwq+KXB2f6o20xPTdjUoJnPTERa0aXZ6qdEYazz5cKDkr
X-Authority-Analysis: v=2.4 cv=F/FnsKhN c=1 sm=1 tr=0 ts=6a9878d2 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=XwBYxoxBwSosfWEfMcqm5A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=LIvFlyDzFMSjF_C-DhYA:9 a=QEXdDO2ut3YA:10
 a=a_PwQJl-kcHnX1M80qC6:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX7O2S7v2UGzYt
 /Bm1H5Y8M1q/yiQJQP14GIhsQQKL75yg+Fc/HnSMrJd8pgMdEXXnxlxNXpQ6hQxK7eUQup4h7aj
 nu7mFTDk73kgiSmpqZjvVYZrnqcg/ePVlLJwCt+LHnfYK8If6RgV4+5NqNofOr8mmC7knEAE0dh
 vfWgwc0aurOKdyRHKnIQLrGe+cUMENOzsfMK4709nlbvRaruT5ShwM7ah3XwtVrN4IH7jZyNqpp
 2ZWGhz7/DOp7EInPlg9LpOmh7fMynFj2Vly9VL4E0OykJr8EkyxY6qUrnCacRgvplBvUYA5p0Ji
 dzBEGeYSq4vPa1Rw/x/YG2yP6rpqc54VsG8kSaPTBbm0knuBFwgFfNBrvBih8Liv7GajY5OQTdA
 GC8KjXSVgEuPZ9/FspwIB28iFOGSpQp5T8GyAV1q2zGy6mQDlRRzi+oLIxUn5gZjh/GXGo2IXRx
 Ordl3bIhlAShQHWoxpw==
X-Proofpoint-GUID: byOq6udJE46uRz35DptEsIkt7W5lpfSQ
X-Proofpoint-ORIG-GUID: byOq6udJE46uRz35DptEsIkt7W5lpfSQ
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11894
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 phishscore=0 bulkscore=10 priorityscore=1501 malwarescore=0
 adultscore=0 lowpriorityscore=10 spamscore=0 suspectscore=0 impostorscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020172

The memcg accessors, lruvec helpers, and stat readers only read from
the memcg, folio, or lruvec they are given, but take non-const
pointers. Constify them, along with a couple other helper functions in
mm/page_counter.c along the way. 

This started as a follow-up to [1] that quickly grew in proportions :)

[1]: https://lore.kernel.org/linux-mm/anYqSDnC2BbJXv1h@casper.infradead.org/

---
Tal Zussman (11):
      mm: memcontrol: take a const folio in folio_memcg() and friends
      mm: memcontrol: constify obj_cgroup_memcg() and friends
      mm: memcontrol: constify the lruvec helpers
      mm/page_io: take a const folio in bio_associate_blkg_from_folio()
      mm: memcontrol: constify the mem_cgroup accessors
      mm: page_counter: constify page_counter_read() and page_counter_margin()
      mm: memcontrol: constify the reclaim protection helpers
      mm: memcontrol: constify the memcg and lruvec stat readers
      mm: memcontrol: constify the swap accounting helpers
      mm: memcontrol: constify mem_cgroup_swappiness() and mem_cgroup_get_max()
      mm: memcontrol: constify the zswap and socket pressure helpers

 include/linux/memcontrol.h   | 196 ++++++++++++++++++++++---------------------
 include/linux/mmzone.h       |   2 +-
 include/linux/page_counter.h |   4 +-
 include/linux/swap.h         |  12 +--
 mm/memcontrol.c              |  37 ++++----
 mm/page_counter.c            |   2 +-
 mm/page_io.c                 |  14 ++--
 mm/swap.h                    |   2 +-
 8 files changed, 138 insertions(+), 131 deletions(-)
---
base-commit: 178b3d97bf1f15f598ea7cc615a40c115e528e1c
change-id: 20260807-folio_memcg-const-4a67e40d485b

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>

