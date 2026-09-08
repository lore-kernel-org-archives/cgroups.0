Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A24858039F
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 15:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788883071; cv=none; b=kT0vAmkH/u8xtSMfrSRhYzLlQnOjYsK++/KMVFIV+XerAHrjVhJkXhMva9MQbxLu5l/J1A9U+fjxCOk2mzTzzrlkWTeQfXsa//hbI9eXk6h+1oBj/afjaFgY8E3p4YMczT2OU+dP6C27KS8Dc+jJ3SvYSxRA4QL8kZF9za5eYxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788883071; c=relaxed/simple;
	bh=UinAA03uCLSDnqTeuLsKq7N1uV7CWB3kv6f1gByAtp4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IEAcW0q4Xzk9PHXAcoCDdoGhaVm74/LRc4Kkp1ZOl+4v9+Vbr4vozZlIPJJMvcM3nFGZmEu0mdBoJHy6mQuaBm8rZ7/HlVou2E14fteXZa8ENkcXTR0oQGgFDA3zK5db8Ib7qJBYCSfKuO0Rztk16o7/YY9exxZKGN5R7FI+QmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=j5I3RNnU; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=HlfGtxUN; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="j5I3RNnU";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="HlfGtxUN"
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688Fbi5W426545
	for <cgroups@vger.kernel.org>; Tue, 8 Sep 2026 11:57:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Sj1N
	7uQmnGuNNgPkBsDb4ODo0/fNYM3Wqy1K3HrTKe0=; b=j5I3RNnUd0MS/NrBD70/
	7/0lxzZFw4VWhZUt5gKhJhTsXfcBODPPBpAPpLwSDYoMJ3FtHN8uv4vm8U/ysa4e
	BsrtRO5j6SnD6XyQ+SGNHtJVIio3TRJrr1P4tEwsiZz0CxLKFQ5stdm5FHyMnMKM
	DVovccz0GsgurCVgVaU4J8Ra+Lk/BeiFTqCHBYrtRuczzJF7MYRk3sVtq8+Bjd1I
	LRTDKqbsck5PGKZ9pxJcB4OEEEwc7ajMyOF4DyE4oXu9Z1lbcrz3Yi5GYQx85wQr
	m9iDedE80zhRJqA7Ow8137cQTfR+u+dnICd7WduO4Qk7G2Z34E2zvM01wBFSJOE+
	Ew==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gjmv7geyd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Tue, 08 Sep 2026 11:57:48 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-52fb6c7b680so62328281cf.1
        for <cgroups@vger.kernel.org>; Tue, 08 Sep 2026 08:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788883067; x=1789487867; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Sj1N7uQmnGuNNgPkBsDb4ODo0/fNYM3Wqy1K3HrTKe0=;
        b=HlfGtxUNGP79ks2Ew8htyYZDc++m+Xieb3iL9t3OxUib4/o0tQVicVHhQ0tXG3E4rT
         z2qouY0nrbQ8XMUb9xuXFaeRHiUCP6GNxaLuT150O1ScZomxJgkV22l+qKQ0DRpsFbRx
         GaKL0XMn3+WbyzF+cXm22siPjkY6JQzlVAlFY6dgq4BtuOMgQ/eclI/g99Kzfqpc787M
         umq02TFDnMFwYUw6uX4wnMEkVuyzbGfNVaoyT2EmsbrL1cSrmJhqwV5Y4wo12pQ7+neE
         c4gq603skvSLqaBA2EEIVrHSwAZJBdQW9aRdwyJse2PJrB2H75M7hhKqk/AsMIgFTD/h
         +xmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788883067; x=1789487867;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Sj1N7uQmnGuNNgPkBsDb4ODo0/fNYM3Wqy1K3HrTKe0=;
        b=ToLJGakD4dxVGhMO0ip4GNIVOhmByrjHhZOtExgFy/BxbxviG5UbXNbtqR/YN3IC/3
         ro2ib7tWseg/wKCkxj9G+Weh2yAxE7YdhuwcHXlwOSZJg3HOwoGJMlZGkltsYWHH9oll
         599H9Jd3xRoIlGFvoblTfZ398vCV56v+5uqkmnC+/lke+RVTLNR9RZ6nSj+Lwu4ViXBG
         ZZsPGkvCpRTcAxBiutaGIF2BttiK2VZXAdEgBUFU4sw2yvyVWgU7jjwYyen4zdBspaXI
         Ud4490Wrn0rbL09sUtMwfFpXF4AqvBTlWq+a67PV52UVGiObo89TF06QpeIvcHF5f1wJ
         ZZ+Q==
X-Gm-Message-State: AFuF++nWFuXV9+ZnITvz/J87oEEZgcpuZkaMavIZTgD7XtuQsT6QThb9
	fCbWBUkcyrAMqtrJxCHavj6MMRtjKYPe2l79DYpQLLN5YXmN/JGZO2NJXtu/yB45KQQhKMwmSwk
	lNB3iQ2nihBrsZK2NNnqeAf1YrwGkkrg1mW9RYQKrm1BpBrkA/+cDjo8=
X-Gm-Gg: AYBFou3XJ1j2MXlb/kjenc+G+My042JtM0GokKvoxQppqP4+aIzf/DRdOavbQJOQuOi
	QQjpXmPDrGjnb65F6oompMDk4b2GfU95P3zBGXbgvmyID94wQKqrXrZs4OJ4LP47TFvNWqMCy2j
	Z6xESt6kwzRdp2audnY/KWsbeaFo9Jd+mCQt+hrKM8y71YW+IjSwnPwBPdt+9AGAPkdwraReEqw
	Zgx4p36dZpuroCWctv6XWoLhO5aeqsaiSamk0gyPMNXyNscGk2LOsBnHoqDInSq9EqK3Y4fquSH
	+fHfYN+UOkZlqfJOlFyF1799YPRLgsjqDg9LI4Ct7QLgExjlCDWXUkN/GjYXvZCjNwDuR6TvpO0
	Byd08R3yoWYVlj67aZi7GVXqhd1kBa3UV3NPvGfU1UdSdbU0R
X-Received: by 2002:a05:622a:261a:b0:530:7bd0:72a7 with SMTP id d75a77b69052e-5307bd074e3mr207354301cf.14.1788883067561;
        Tue, 08 Sep 2026 08:57:47 -0700 (PDT)
X-Received: by 2002:a05:622a:261a:b0:530:7bd0:72a7 with SMTP id d75a77b69052e-5307bd074e3mr207353371cf.14.1788883066890;
        Tue, 08 Sep 2026 08:57:46 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53093295584sm27830461cf.13.2026.09.08.08.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:57:46 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 08 Sep 2026 11:57:38 -0400
Subject: [PATCH v2 02/11] mm: memcontrol: constify obj_cgroup_memcg() and
 friends
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-folio_memcg-const-v2-2-811e9f443409@columbia.edu>
References: <20260908-folio_memcg-const-v2-0-811e9f443409@columbia.edu>
In-Reply-To: <20260908-folio_memcg-const-v2-0-811e9f443409@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788883062; l=1873;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=UinAA03uCLSDnqTeuLsKq7N1uV7CWB3kv6f1gByAtp4=;
 b=CDRAqj/1wb/3WnGAi9BY4rxHz8UgL120vcouDu/S7bC4uAUypmncBBwZxrKy82c8EXPYIfw5t
 qSiBFt4YV82DeeoHQG/qc3T/+N2P7kl5zdw9sNHqwNj+PrDkLIAp7LE
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX0ExoDJbzSivM
 W6dV2pAsi5CJFfjtr1OdhO9wm23VIXo276Eq8ctb9sIXcLmTRJCWlJ5np0qyZ5n+R3vrTBtJHCD
 M5APIw3Cqt24HfmP3VTwS5s8Bbcwe8ffvYx+0pfGbk9wC/kw8vLnCtRXYpmXq8QRgQU0FUBROVt
 31JZ+xSw7K9sX7SYlupcUqBD7hiq9g070Q3E7uOUWCWsIwWQ5Ea3fTpeO8hvOV3F0MBTo1gq3/J
 fsQnjovjfgHthJa4FXcLIII0NdbH0s07X4tG0+aDKeM6wYPJ5zViW0bGwZYlT0VDx5ioJJbLHAV
 9y6vAJABUJp69OnHyyKQr32TH/IjPEmfnjyZBIwwymhDBE9ull7pDwivWoat+tFd3fI0ctDz8Ez
 XWqwLfEkK5+7OS8R2JZJmf6at3SpMxDzSMxYRtzNC8MJ+Vc+aW+Ddvl6PSEam4wmN540B9dC7VJ
 iCAgMsFSFrqXDEJ+i5g==
X-Proofpoint-ORIG-GUID: 61bGbmX99c44sp08jVd7ZiUtsB2pY2hT
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX4jhq56SkFg0b
 Bc//hT8TRyuPR98mC2hzVIfbBYy8nbNku7+qi1O5YDymAFvLvLbKF4NFwJlVxkUO3q7FD+b0qQT
 m+qK43c3kT8gZcpzl6RgZBJfCfgK67eRd7WEFw+/p8nPJsk6CcIS
X-Authority-Analysis: v=2.4 cv=fpnsol4f c=1 sm=1 tr=0 ts=6aa0307c cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=HbpFEVrQSsppjrtFf58A:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-GUID: 61bGbmX99c44sp08jVd7ZiUtsB2pY2hT
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 phishscore=0 suspectscore=0
 lowpriorityscore=10 impostorscore=10 malwarescore=0 spamscore=0 adultscore=0
 bulkscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080172

obj_cgroup_memcg() and get_mem_cgroup_from_objcg() only read from the
objcg. Constify them.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 8a614a36c05d..d2577a064894 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -396,7 +396,7 @@ enum objext_flags {
  *
  * The caller must ensure that the returned memcg won't be released.
  */
-static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
+static inline struct mem_cgroup *obj_cgroup_memcg(const struct obj_cgroup *objcg)
 {
 	lockdep_assert_once(rcu_read_lock_held() || lockdep_is_held(&cgroup_mutex));
 	return objcg ? READ_ONCE(objcg->memcg) : NULL;
@@ -505,7 +505,7 @@ static inline struct mem_cgroup *page_memcg_check(const struct page *page)
 	return folio_memcg_check((const struct folio *)page);
 }
 
-static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
+static inline struct mem_cgroup *get_mem_cgroup_from_objcg(const struct obj_cgroup *objcg)
 {
 	struct mem_cgroup *memcg;
 
@@ -1075,7 +1075,7 @@ void mem_cgroup_flush_workqueue(void);
 extern int mem_cgroup_init(void);
 #else /* CONFIG_MEMCG */
 
-static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
+static inline struct mem_cgroup *obj_cgroup_memcg(const struct obj_cgroup *objcg)
 {
 	return NULL;
 }
@@ -1104,7 +1104,7 @@ static inline struct mem_cgroup *page_memcg_check(const struct page *page)
 	return NULL;
 }
 
-static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
+static inline struct mem_cgroup *get_mem_cgroup_from_objcg(const struct obj_cgroup *objcg)
 {
 	return NULL;
 }

-- 
2.39.5

