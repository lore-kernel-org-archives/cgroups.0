Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4F852F288
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 17:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791997716; cv=none; b=P5Tf7I+pIVNLlrkE2UIsgjjtl5YiRcPvFufEC0YgsRlEGhylzBX0Hom+0BGESDRkmgJEqSePwzZ20Qxen+RyT0aiEZ9yc69yQHdJsEzPX0Na1P3MHCfr6zvRReP87LTlFSoBEdwjgBrcSViZZb0YlRJY7aE/1nHPa3ViFjXUwwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791997716; c=relaxed/simple;
	bh=A4+6fw0Hc9Z0q42kWQk0GUf4UVLOksq0fQyOCy1QXaw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Z74NE2eq+7gpO9Hf/TeeuSNACGwyrVlOXKBThYFgb+cjgWDu6c/QfAyMyOmkf1Ls1Z4iX0Zp9lhu75KpMG+cN/TIF/wlamzWvzDGm+jqFiXGT+0kjyBEo+Y++dcvURvHcAoEP4iGa1WHvHVmlEWUTG6FIsyOUCXbZxsRtlKyoFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=lqhvhJhj; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=alRHfMmy; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="lqhvhJhj";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="alRHfMmy"
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69EGYJoA3099034
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 13:08:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=qamj
	3Rybiddl1bXwe9wbuQOMEaZBgA53f7HcjTbkGoc=; b=lqhvhJhjucX+yxkQcsgI
	yM9jq+Cw0SVuPisusNMF97Dmt1iBvC4gyRVNqfPIcvpgzJcRLXbnzV13fL/dMaWo
	y4+TiWc3oHCHs13cZjSk7bxtkTjyXxZxsOFzvpwR27cUqpTNjGT7mugAD4Sb/47w
	WUQG4aCvSnNLle+CPRN2TUh8tmgkm+o+Wq9IpQZ/0fvZNUfFSfuRIRYHUB+RxmzY
	gAXCA/kD31EgpsfNrw+3B+X2QtCrJ1K238EHqEYQOY4SSgoUDfZuHpEtGWyiTWUp
	1CYNBhBVM2qfvo3+ZuHiNssSKd+XWEbeorWInKhMVjWtLt4eX5Bzpa8V7IoJFLyQ
	Uw==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4ha9ctk2e6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 13:08:28 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-5339732335dso70340201cf.3
        for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 10:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1791997708; x=1792602508; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qamj3Rybiddl1bXwe9wbuQOMEaZBgA53f7HcjTbkGoc=;
        b=alRHfMmyLvk7OJ683kN2mBRQtVEirmDGTI2pDIh1kaDRySa6/sj//v6xdT3zyo5E+m
         0kjaCgdAjrwXY1VWc6Ik6W67776Wb/T4yQDk+2hmpWl79VLTyUskWunP/sdtEK+e0U1t
         zMvJ7Ovk6XS20GVyMu7wgKB9XpF9BQQWkkBSXXGLB/9hQr+DK5UCP7PfEZTilrILE385
         N5CrBBV4JXwN+IdhgZruu5JTPHSoLZJVWSWb2/ZgCRRSEIilDu4ljha766x33T7Q37gC
         NqTeni44pktJDrL9zwowfI92tumL2DOOmXGJFpMe98fmhXYAQjRBf0zY26Q+xaHgmomx
         bDng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791997708; x=1792602508;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qamj3Rybiddl1bXwe9wbuQOMEaZBgA53f7HcjTbkGoc=;
        b=1AhNUG9vJm+piA80WKFf8baDE/Gw/IfysdDNV54JYu7NrHguMYomHISvczs+DHXHHA
         tN64ThVJhox5ut4t4gKS96HP/LIwTAFN6MWQ4ljMQCO7rCdCgYr50voT+WLxCcaOWo/N
         4mAI8ourVYCtWeYYhpngXVtbSUb5V6jK2L0gz/OgwTDaIv5ay56XKYsziKqfGxpx/9IR
         q4xKtc5xPrUHg2p+5uuSCGkp9Sfrpc5cxPwzj0TGJSHDPK7R+zShHgOhNHe2lSFCsZmB
         g9DYY+AgI19fiExQm1lskV6dOA/oa+HZMAVHCE2z6iYfi3u2UEfVh7BKrjLdDuooIi2J
         qx5Q==
X-Gm-Message-State: AFq9FYLnVxdHZqx/MACuT75xUJqdkGjrojAUdeg2BPFLUq3Ampnam3vv
	vs9+ar+EfpvmpffUBnqpn3ffNzzHXERS8o4ZMRhE8K++u6tx3GEGv0g/JunaSRTOdQhZkQih0Fy
	HyvKS2LSbtQXg4LRl9FSqy/SSCmFkxne59n7TGtV+vS43qQ2xt2YBK2g=
X-Gm-Gg: AYBFou0uvA0SM9jjVdxHo6OnzJyg491UfdEY7Vh5e+eiKgoaK4ecBaKGuK8w8Xif1A5
	y1PShYJKPpxMM6iQ3v1cqMWqrYbFdTZRYnxCglkEGx+IdMHEm6BI1TEffaqEPY/whARDIqMfHFl
	ZxQgjFwojoCtecXQeQ/UZUUFC4/dIRn12mYteKaeaIqe/Yr2d1A+c2CwgmF6smegpHsWZwnGeui
	QpC98FeTY+zH1DRw3EAUnlCvusV+DoO/n71xAlIoRoQKL4SyD8GvWvORa/ag2rGm1DZAVTXpzMQ
	eKdUgQDsVkxCfDYaGSVup1+HUIlgsbiozHhwJcR9ZKas7bVXLJfWnB4fR9ka5+j6OP5FwCl0Xcx
	2nwB5MQT0BKlD+9iZqZVbjLc/qGFl142SWFp3Vl6dW2YlqUM=
X-Received: by 2002:ac8:5743:0:b0:533:90df:fda3 with SMTP id d75a77b69052e-535fc8a0915mr55202241cf.50.1791997707710;
        Wed, 14 Oct 2026 10:08:27 -0700 (PDT)
X-Received: by 2002:ac8:5743:0:b0:533:90df:fda3 with SMTP id d75a77b69052e-535fc8a0915mr55201731cf.50.1791997707295;
        Wed, 14 Oct 2026 10:08:27 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-148.net.columbia.edu. [128.59.176.148])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b9bda8643sm49190116d6.25.2026.10.14.10.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 10:08:26 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 14 Oct 2026 13:08:20 -0400
Subject: [PATCH 1/2] mm: memcontrol: remove mod_memcg_page_state()
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-memcg-unused-page-helpers-v1-1-240b37c53831@columbia.edu>
References: <20261014-memcg-unused-page-helpers-v1-0-240b37c53831@columbia.edu>
In-Reply-To: <20261014-memcg-unused-page-helpers-v1-0-240b37c53831@columbia.edu>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791997705; l=1533;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=A4+6fw0Hc9Z0q42kWQk0GUf4UVLOksq0fQyOCy1QXaw=;
 b=H7zGDut/q/n0LxMAJS6A5fFSkWckFdgdxTvxrNY9XHYWKdppXxMb4q+0U6DLzGYTRwZnhIyEA
 QlnhUXg6FWoA+COdCszz4UMMX3KRNXyOvTJaLBa5QVIC7yStXh+ylHl
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: fPIEx5a2qjakHrv88LRHXBYs2ZNNzGiB
X-Proofpoint-ORIG-GUID: fPIEx5a2qjakHrv88LRHXBYs2ZNNzGiB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA2OCBTYWx0ZWRfXwiMuel8NTQPd
 lB0mWrE8Zw8QncT1YMCSIS6kykyk7J7zrYm1rDXt7usV4O9X0IW/l3jvzSlaX2JV8dM66uVvtWz
 7mHQ4YRfpVJzcQcrOsvsBH5l/dVH8emM5tMu8fhxTzd1EFMWKuhAYPbkX/091IC0mmAD1xqf6n9
 6tTvjpSQkqypthKZFROld3G5d+JxH1uhiqYuMye+y6FjfC9jTRj8puVm8/9yXYMwWkubqVS0sau
 1etW7+b8PP/eOwhmrjr2ZBYN9sp7qXTR2g4phUqq4xsN95QrmBUSP35Q9+LyU2qWZtHSfAgrFEx
 Ao5y8t+SiC4ciHgLFgA4/77XoTypymLG4Y0Q3zfoA3SBpx9xoMSqIzRTY3oWwZzTFEhD73RuC8d
 QMNLZqlrk8PvTFiUngNwTx/bXYfaNDDKbc05nuzEvKxnJgYqZHwqBb/VwgPirepI6gqdC+gw2Bu
 VzP+cmhOdN1ebF6CurQ==
X-Authority-Analysis: v=2.4 cv=FLCOVOos c=1 sm=1 tr=0 ts=6acfb70c cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=dxtdfZqDOO0kCslK4e47hQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=_9uCFvy-xzexSrfj3z4A:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA2OCBTYWx0ZWRfX7HdYGof9lIHs
 AJ8hlRZnr+MBBKAEJfv8H4sm78MmiWkILOPuchjh1/z8ZZBDhdIc+k9xm6+9k6jy8wwaBxBzqFw
 aJS2oeeier1kJ/3wrQYGooHfy3Uj9cFupB9FtMAp4WNR6jMT/u5N
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11935
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 phishscore=0 clxscore=1015 spamscore=0
 bulkscore=10 lowpriorityscore=10 impostorscore=10 adultscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610140068

The last caller was removed in commit c466412c73c3 ("mm: memcontrol:
switch to native NR_VMALLOC vmstat counter"). Remove it.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 74110a324f9e..b65a2d0fca3a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -957,21 +957,6 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg);
 void mod_memcg_state(struct mem_cgroup *memcg,
 		     enum memcg_stat_item idx, int val);
 
-static inline void mod_memcg_page_state(const struct page *page,
-					enum memcg_stat_item idx, int val)
-{
-	struct mem_cgroup *memcg;
-
-	if (mem_cgroup_disabled())
-		return;
-
-	rcu_read_lock();
-	memcg = folio_memcg(page_folio(page));
-	if (memcg)
-		mod_memcg_state(memcg, idx, val);
-	rcu_read_unlock();
-}
-
 unsigned long memcg_events(const struct mem_cgroup *memcg, int event);
 unsigned long memcg_page_state(const struct mem_cgroup *memcg, int idx);
 unsigned long memcg_page_state_output(const struct mem_cgroup *memcg, int item);
@@ -1412,11 +1397,6 @@ static inline void mod_memcg_state(struct mem_cgroup *memcg,
 {
 }
 
-static inline void mod_memcg_page_state(const struct page *page,
-					enum memcg_stat_item idx, int val)
-{
-}
-
 static inline unsigned long memcg_page_state(const struct mem_cgroup *memcg, int idx)
 {
 	return 0;

-- 
2.39.5

