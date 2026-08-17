Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269114477E1;
	Mon, 17 Aug 2026 15:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980293; cv=none; b=bVbbDtWu35uHCx/U+ylCzdtvtMW/AkTgBX9miAoRDWk1TCfuABzFOZDtdfc+Q3MSiPAgFk8Pr+a3B/eEvatOg0xiQ5j3Z3HIM7xW/heSg7K78wZHclDKfZJiiSCRsOKO47tF1HlaE0EHZDJR2hKn7+oH9Z6u9VYceOCNxMW5oGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980293; c=relaxed/simple;
	bh=xTDhPPZ5tM5HpqgrbjCYZ0QQOuugleY81WlIXGMoAHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVqNS7WUVwwsonxDCc4lidMgyU3Y/fp5YearODy8cBYxFT+n1BZVzDcT6tXu5lmFQEvRy3pWHwv4FhpttlJc4R49nYEj546FiEi0xQPJa5Oazyak6XTSy+6L2HBugJAiKasFK02XFv812a0+e+7U6240vljZRpWrH1Vd7xlUyl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NilYUMbb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NilYUMbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AD21F000E9;
	Mon, 17 Aug 2026 15:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786980292;
	bh=ZAoVoukcfk8YQ8w/0yFAiC+Eyz8oCqkazB7WcGrnj/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NilYUMbbilI4RQjUGfcn58Vwrg+9D0LLpAdWCTgds7ae60PYotSnpJNzs6UKRkcEx
	 8WG5WAPCoYDTQM2B7hlX/vmX+j96zoGKAYoKsh9ehz8SmPtrrPgl0DSkQHc1crub1a
	 7hH3NkrzgEsnwv30WHxWhQ50m6D1dVkcIMBkqkIUIDS8nlfATsMzygomGgIkCNa1+p
	 7Dsv7LLkNpuN5AN/GVcoVMUTMUdeI5dEe0pzityoUCbm9Eufc/ppNCR0GQSBPEBNIw
	 lsRs0y4VvPefoLW87NBvnT2cSTpXK5IZ0RuBz3CZ06dK7uoePZLpSFqlRCsVJ4BrN7
	 OoY1oqLq2RdzA==
From: Sasha Levin <sashal@kernel.org>
To: shakeel.butt@linux.dev
Cc: Sasha Levin <sashal@kernel.org>,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	cgroups@vger.kernel.org,
	chenxinxin@xiaomi.com,
	david@kernel.org,
	david@redhat.com,
	gregkh@linuxfoundation.org,
	hannes@cmpxchg.org,
	hughd@google.com,
	jose.fernandez@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mambaxin@163.com,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	ryncsn@gmail.com,
	shakeelb@google.com,
	stable@vger.kernel.org,
	syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com,
	v-songbaohua@oppo.com
Subject: Re: [PATCH] mm: swap_cgroup: fix NULL deref in lookup_swap_cgroup_id on swapless host
Date: Mon, 17 Aug 2026 11:24:42 -0400
Message-ID: <20260817150000.4@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260817032622.1135640-1-mambaxin@163.com>
References: <20260817032622.1135640-1-mambaxin@163.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Yes, we would like to backport this patch to the 6.6.y stable tree.
> We have encountered the same issue on a product running the Android GKI 6.6 kernel.

This is not a 6.6.y fix. The NULL deref is only reachable through the
batching added by bea67dcc5eea ("mm: attempt to batch free swap entries
for zap_pte_range()"), which is v6.12 and newer. 6.6.y has no
swap_pte_batch() at all, so the exit_mmap -> zap_pte_range ->
lookup_swap_cgroup_id path you are hitting does not exist there and the
guard would be dead code.

Your oops is on Android GKI 6.6, which carries the batching backport
downstream - that is the tree that should carry this fix, alongside the
commit that makes it reachable.

-- 
Thanks,
Sasha
