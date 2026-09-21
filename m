Received: from mail-oi2-f23.google.com (mail-oi2-f23.google.com [74.125.231.215])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB672E266C
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 23:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.215
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790031836; cv=none; b=UzoT+hlR413DzDmhgamfhr/rCMvD0P2ob30uIYOaiKVuBWKOAA23n5/m+t31qMHZC5Bh3q5+UbUBqBRfv+ctyhAtLupfS9x8K/mzKdPndYwtMThNs1aS03qnwS8zySmk4m01IPqmIncUjTShkqOLNOSgnyqh2RQhErWID/mmgoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790031836; c=relaxed/simple;
	bh=kh9puILIR9r20G3kwpzzv7NaVqtxLvbguKQW3SwMZ5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKEop/116YvSVRvUY0ro6fM/Eg/AIfBgiGQQ4BUBr6N9i7fWuHJNWWWnYtw4A0+styWd/vIrLu5UmS9s6m2Hb/7DnQw5eEzCHPSyJKv4UDqaYKTjU9S8miRVbMTUJEkKzZJbEUVwlEzmGF+i1cnY7zV9Wi/a3JEEhE9yJ+pW/qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RJtiu6gf; arc=none smtp.client-ip=74.125.231.215
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RJtiu6gf"
Received: by mail-oi2-f23.google.com with SMTP id 46e09a7af769-7f4f0d37dccso1939321a34.3
        for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 16:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790031833; x=1790636633; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OdbPBPyzaOM2wXlSY62pNAL0ZMKs+usFBD9FO5JbEdo=;
        b=RJtiu6gf6NVWi16q+NFEmBHvIqrrqdw3bUrNst3yKEkzLY9nwfl3bJhtXM0mELCNkf
         RCdbB4qA3RIBfyTipAR50KyF9Bjm2eDI16LGJVZ4mgd2hvKxiV1mSRFCTSQjBwbH4QO3
         XT9Ax1UgRmZQpPeaCgltVBurOsXB5XhRy+ZtXsnSBAJcmv9PhC2WUblhPnZRthDQiH3e
         xESxURzq1Zw7hdsSI+aaxIn2P7oUBm9sqcF6nNRLMDNErYnYpuYXFvjgyi9yDdaKDQnN
         Y+lNKe7d0LBJq0f5yE6dlrQz+H8qs7InnnDgFCKNWNePWtNIpOymedxoGiTD4n7ifo61
         WcLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790031833; x=1790636633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OdbPBPyzaOM2wXlSY62pNAL0ZMKs+usFBD9FO5JbEdo=;
        b=iFiaaehCNYH/+yJs6IBIB2rzr5pYQyw6SxS8MymTipjPO1srQf106YjzWs4wGsdPqk
         som/9UW3awFkHSpiufOqnm3IoCaCkeZygLeA8xa5jrvy7fQ6Ki1Fa4pt/07v4jhKsUsJ
         irgF3wZYP99kiYCcCJiH8dalIV+4w3uxaZ6ymYkAax7mp5NWoI/fgUeX+B9JJ5HanTRy
         KVEJ63mK2E4r7jTY+VzJtZJw6e8pOGjQvhh1mX1++y5WH4Wb5t6jP1oM0W682sxJ12MZ
         VU6bkzh7QBSjJMBCgihAgSgqXsikZqcimBWicMHrjSZsDyRQxXk2C0XA6b6dtH4r5Kv1
         IOOg==
X-Forwarded-Encrypted: i=1; AKwUvByhwcMzfG3z+6MI/quuqerFeMW0mdjHY1Nasu2owM/MHgL09raWVcWMVac+95cJo9zSQzsIyDur@vger.kernel.org
X-Gm-Message-State: AFuF++lSzTFelo+BqQlR9dbDXPfjdj9SSNYAi15Pv7WgKkeVjFF/biQD
	5EnnOqYbEgvrU5EJo4XTjPRa+r+U/nzlrlFcdn0uT9GaDgpa7K2rzW63
X-Gm-Gg: AYBFou33YEb2Ve2FFZaYnqclVzaGZ2y/t/Cnl0jad3oIfNKaznkx3xFc+oVoJFZD5EP
	P+SghR4s872Bk2WBS4+rvd1ClEH3svQBJKoVsSuWAR5S8HFjfpPxywUAKnonKq4DUK8QHGJy2fo
	hzvsc/LyGYjDBjuGKt8E+0/HNiXr6hS2d/bD4HIZy6QLZ+AJfzXz7kCAP+vGuCxIUfe+N592PMk
	VUxNVfcdXCK9cmpJkfUv7TPuxCqx7BW0qoyY6XUJd/nnO57Wf4XqZiOy+4/11dFDMV13ElRmOd1
	kEIBccX24xYaJsWZ51YAwBEHGxp0WJRuEgQrcmhqEFwDNNwcw06vVA8942T+unmEHFUfRjWVxdc
	0znGBf2T6+0V7GTfnEEqpIj1vcFrarGG0foxuHpphdP1xQ3vjXfiQWVYwRNXu0sNXqmpX3WPtpN
	87mfmH3wPvjug/lpm5ICi31Ozpcsmk9ol0hLeosGYRHTWvWWq7x+SKP49wAp6lpNL6JPBg1Viqb
	zGXkjv7nTKhOgpJ0luqSj5boPXU
X-Received: by 2002:a05:6830:610f:b0:806:e047:cd7d with SMTP id 46e09a7af769-80de045b1d3mr12860708a34.7.1790031833370;
        Mon, 21 Sep 2026 16:03:53 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:f::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-814e648bd3asm184805a34.17.2026.09.21.16.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 16:03:52 -0700 (PDT)
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
Subject: Re: [PATCH 2/2] mm/memcg: migrate per-node hugetlb lruvec stat together with hugetlb folio
Date: Mon, 21 Sep 2026 16:03:49 -0700
Message-ID: <20260921230350.3649114-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260921-for-hugetlb_state-v1-2-8a6eec92661f@kylinos.cn>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 21 Sep 2026 17:12:35 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:

> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> memory.numa_stat exposes per-node hugetlb counters from per-node lruvec
> stats. These stats are accounted against folio_nid(): incremented on
> the folio's node when handed to a user, decremented when the folio is
> returned to the pool.
> 
> During hugetlb folio migration, mem_cgroup_migrate() moves the charge
> to the new folio and drops the memcg data of the old one, so the free
> of the old folio right after the migration skips the memcg per-node
> lruvec decrement. The hugetlb count stays attributed to the old node
> for the rest of the life of the charge, while the target folio gets no
> increment on the new node; its later free decrements a counter that
> was never incremented.
> 
> Migrate the per-node lruvec accounting alongside migration. Global
> memcg totals remain balanced because they track resource consumption,
> not node placement.

Hi Hongfu,

This is another great catch, thank you for working on the fix!
I was able to confirm that the issue exists and was fixed by this patch.

Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

> Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
