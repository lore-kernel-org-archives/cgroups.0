Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203B341F353
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 07:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785829746; cv=none; b=o58OpEyi3Xpf8d8HRJtJ3hFvDEzr8dT3P1/dhC4Z81U4AWQjlQbbP5mW/2Ggvp2uLMyN00auuosy1wg8jEA3RPvNuXMRrr3ItTHCYfZCBFwr4U1/NuoJDH5G8hcmkmhmme4JunigZW76KlquKzHOU0uIr7+ussEn7yy9JDqrJm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785829746; c=relaxed/simple;
	bh=6U+QT7E+ng2LNvIZ9Dt2uHbmOYHdgc63epHMecfQav0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0spwxw8TpU6GDDocF3+4EqG1MAMGS9102PrEjMbjkhPGd7b1eAkWtRv0+74/EtvXmO5U6QiS0sQ8B7PYnpJRf7CNRArwx9hcyTqE6k4kXtHXgRVCCUnXvn4eEkxGadphynASa5/lZN/wJE6R+v9XiCikIOgce8hMw9tK9TAd48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SZaqmEym; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SZaqmEym"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8485b358552so4432695b3a.2
        for <cgroups@vger.kernel.org>; Tue, 04 Aug 2026 00:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785829744; x=1786434544; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=URYlG/xGVV5ysvUhV3ID8hokH80qFBSptYE9Jdvimh4=;
        b=SZaqmEym0CPqVcMML5r5Sd6Ah5p5Lzqv3uRFxb05Z6LoHbde6mChGugJq3xzPmmjNx
         wJd1xHSPi66URedRUDzPw4BCmMB2soZR+yuntCpt/bdcxT0rT7tEZBLaHUQZGNotQjtW
         tK9R1I9r1rdpLCxNUO3aGo/BYYMARU8y8dt++tt4lwEMpKK1ciDM16BcAahUH4pUPTOJ
         1jkdogx7Gm9oC08uPZtY1Oe7thjaDSYDy5RnSFPp6dpqvM+qk7Pho2fO5VnHsFzsL15Q
         LVRHo1adGWSysgBIHOUcbVfU0EdKzPoqTOtirnKWaAz9PrhGQq4Ru++qG1Z7LBnT/xsm
         Gpew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785829744; x=1786434544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=URYlG/xGVV5ysvUhV3ID8hokH80qFBSptYE9Jdvimh4=;
        b=qBwkTl6sl9/wDDb8JIbd4Y4KYFVQF9mQuqyP4KgXSzKdcEJkHgGc+4hvF9T4W/hMAM
         LaGc0eOYJp2cEq7dH2by/wowhE/vu7kcwHDMg6FBKT9jvkb2Y8g4W/v/3PzHQNDMXeWf
         MNOMTQB/0jVZu9bN/OZmzU47ZlR1Nsp851QCEmdMwfv3YThpATSD9P0RniKkpB1iQJIe
         z5hL80rMDE0XhufHpz61fkHOseQpVF8sTK7nq/hEL/0VS0MDtt0luZz7UzNihctfaLGn
         pRfG0SquFU0XAJybBOe95rrg50OYtNUSGwxhUGMVOemWzcQgvUwtKBXdvJSa18CN99TP
         RpGQ==
X-Forwarded-Encrypted: i=1; AHgh+RpUnZXFyca53MFUglRy73REMBPo66Ft3L0LHQijPK575OQoM0WvEw+u1257rGV/kmC+AfZMC407@vger.kernel.org
X-Gm-Message-State: AOJu0YzMWPFG68uTpDzhHpI82Uijc6oj9tX8ow6dVRLsobqYs+hs/D8L
	pp2wZI9oXPc0RyCmPNCkQ5Us+spdzjtgASSH6HivHJ7arQXcXMi5m1c/
X-Gm-Gg: AR+sD13mBbhzr4kzZ7auMY8y+BLC9Jd7fNUdMgFIAuc+h8qBbJT4Gog64naWuVInm/s
	//ermKEAwpiS+jQ3HBXSnbyYwH/Hkhia5z12BOrmzdS0nB2RV3ESabMCFIjSegT0MQ807Cr93N8
	fC5Uq3RnpC2R0f1ivj5umQ5COFTWxFOgFpQDPHaDvlgwkDjQUDtQynjBT3qvLNTyROxzhy6yhX0
	zjqxQ8wyu5LPKAQ+CNCMiKgBoWFLqP4tcQ6okAufWrpjD1DMsGl0GvHPewWBpSoK8kpG4yCCZKK
	C0NxE/rYYft+S3PjAkyPJZQjfjrlZqBpXCXQ1hMee9vtKvGSarub1chgarxPLj7bdshYaN9jEqv
	RsNttayt3yydMFjn40CTiQ9N8bGu8bEvSangsJ7xclVw+71Kq0XNCz0OGH/WJiYctCr/qakkCii
	HWutASVdSve0semmilvaz9AC2ziCXpeRAJKBCwSG9oDjqsAUDmi5B16LBaCuFh/2Z82N7PiNl1Z
	dUC4CwrcJh+ew==
X-Received: by 2002:a05:6a00:4b0d:b0:845:da74:5d7c with SMTP id d2e1a72fcca58-84ee480aa3fmr12133731b3a.32.1785829744273;
        Tue, 04 Aug 2026 00:49:04 -0700 (PDT)
Received: from localhost.localdomain ([112.65.87.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84edc2d45e5sm4687101b3a.42.2026.08.04.00.48.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 04 Aug 2026 00:49:03 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Cc: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>,
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
	SeongJae Park <sj@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	Zicheng Wang <wangzicheng@honor.com>,
	Chen Ridong <chenridong@xiaomi.com>,
	Tal Zussman <tz2294@columbia.edu>,
	Kairui Song <ryncsn@gmail.com>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH RFC 08/15] mm/memcg: add folio-based lruvec live helper
Date: Tue,  4 Aug 2026 15:48:03 +0800
Message-ID: <20260804074844.99770-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804-mglru-fg-v1-8-4d8dad39dad6@tencent.com>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com> <20260804-mglru-fg-v1-8-4d8dad39dad6@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>

Hi Kairui,

I am trying to understand the lifetime and accounting guarantee here, and
would appreciate your guidance. My understanding is that RCU protects the
lruvec lifetime, but by itself does not stabilize the folio->lruvec
association across memcg deletion and reparenting.

Could folio_inc_lru_refs() obtain the child lruvec here, then race with
__lru_gen_reparent_memcg(), and finally account the generation move to the old
child after the folio and its counters have moved to the parent? The opposite
ordering also seems possible: this helper observes css_is_dying() and selects
the parent while the folio is still accounted to the child.

Is there another invariant that closes these races? If my understanding is
correct, it seems the helper guarantees a live object, but not a stable
binding, and the lockless promotion path may need validation/retry or explicit
synchronization with reparenting.

If I have misunderstood the intended synchronization here, please feel free
to ignore this concern.

Thanks,
Lian

On Tue, 04 Aug 2026 03:47:04 +0800 Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:

> From: Kairui Song <kasong@tencent.com>
> 
> Add a helper that resolves a stable lruvec for a folio under RCU
> without taking the lruvec lock.  It takes a folio directly so the
> lruvec lookup happens inside the RCU read-side critical section,
> which a lruvec-based interface cannot guarantee.
> 
> The lock-taking variant now inlines the ancestor walk instead of
> calling a separate helper.
> 
> No functional change.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/memcontrol.h | 38 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 68f363000d7f..ea0111392b9b 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1506,6 +1506,44 @@ static inline void lruvec_lock_irq(struct lruvec *lruvec)
>  	spin_lock_irq(&lruvec->lru_lock);
>  }
>  
> +/**
> + * folio_lruvec_live_get - get a live lruvec for a folio under RCU
> + * @folio: the folio
> + *
> + * Computes @folio's lruvec and walks up to the nearest live ancestor
> + * if the folio's memcg is dying.  Must be paired with
> + * folio_lruvec_live_put().
> + *
> + * Return: the live lruvec, with rcu_read_lock held.
> + */
> +static inline struct lruvec *folio_lruvec_live_get(struct folio *folio)
> +{
> +#ifdef CONFIG_MEMCG
> +	struct lruvec *lruvec;
> +	struct pglist_data *pgdat;
> +	struct mem_cgroup *memcg;
> +
> +	rcu_read_lock();
> +	lruvec = folio_lruvec(folio);
> +	pgdat = lruvec_pgdat(lruvec);
> +	memcg = lruvec_memcg(lruvec);
> +	while (unlikely(memcg && css_is_dying(&memcg->css))) {
> +		memcg = parent_mem_cgroup(memcg);
> +		lruvec = mem_cgroup_lruvec(memcg, pgdat);
> +	}
> +	return lruvec;
> +#else
> +	return folio_lruvec(folio);
> +#endif
> +}
> +
> +static inline void folio_lruvec_live_put(struct lruvec *lruvec)
> +{
> +#ifdef CONFIG_MEMCG
> +	rcu_read_unlock();
> +#endif
> +}
> +
>  static inline struct lruvec *lruvec_live_lock_irq(struct lruvec *lruvec)
>  {
>  #ifdef CONFIG_MEMCG
> 
> -- 
> 2.55.0
> 
> 
> 

Sent using hkml (https://github.com/sjp38/hackermail)
