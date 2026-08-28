Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6671D5174;
	Fri, 28 Aug 2026 13:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.67.55.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787924793; cv=none; b=Z8XSDNaahkNZEqcS629I5KaUwuOCpXgbXETjWpku3qC23MuVpTrpKq//s5xkLiCWgq3iU/ifd2dgR1gK0IAhwVG8dgyQMTR61c5HUfUwNZHDKrLBD0WwdJTqgC3yrLV8UIqrpE/HQDP7KP8OoL/f5yFWkrB12sI9tmRmyo8PbWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787924793; c=relaxed/simple;
	bh=dghLXZksgi/8QR1Jj4OFGkmGGanPSc7LDUx9fSK0eA8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=to5583byLWteIFp6PUjQedltqO5Zhxy83PevdH13BL534itRf09pzVTgMjxuy7dZhfCNSRd220myxR7zbXpNntRL52wm/KvtI2GgP+nNPa74G1wyUomqGm7+7pdU2Ta8H5RGLZD1amew5E9wyziylSQYarOzaqnrayD7+DWCm2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com; spf=pass smtp.mailfrom=surriel.com; dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b=CtA7DgdF; arc=none smtp.client-ip=96.67.55.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=surriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b="CtA7DgdF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:Cc
	:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References; bh=R/cHZ9f+AKwXbLDV25J27rvOAvjlInOdxrZWedG8Pdw=; b=Ct
	A7DgdFdcRGEn0sKd2G2viWBh8uaj1wTRdnaUh6IcaSw/IdC4/QQqHBlxnZSR1XBriu7JOoUKySgLr
	PSCS5uSahp774QactqKZFVTlF6+rx30I989eGTwQSd357AMXvcuSemJUMxAMwJGWcbXzGm3WT0/Nw
	GyDQ9tDSRj/c26SdnoaBYPMdFQjaG3Yd6PLc5Ktu8foXZJHNpBjuvXhOnVtkp0CrqT6yT47uOl2ph
	rLaNu2AtqzRhsxHzzfQ4TniOtrXt5rlB11eFjt7sLglfhYALVWkPQi6i85o4iL78wNOu9alUko6dL
	+LR/HfLjI/zV9W5VvZm3IR52ebbe8A7w==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wzwuY-00000008zmT-0fEt;
	Fri, 28 Aug 2026 13:46:26 +0000
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Rik van Riel <riel@surriel.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH 0/2] mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit on isolated cpus
Date: Fri, 28 Aug 2026 09:46:19 -0400
Message-ID: <cover.1787890328.git.riel@surriel.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

drain_all_stock() can leave FLUSHING_CACHED_CHARGE set after the
work is dropped.  It sets the bit before checking isolation and
schedule_drain_work() checks isolation and queues in a separate RCU
critical section, so housekeeping_update()'s synchronize_rcu() can
race the second check.

drain_local_stock() only clears the bit for work that ran, so the bit
remains set and the stock is never drained again.

Patch 1 extracts the stock drain predicates into helpers.

Patch 2 reorganizes the drain_all_stock() loop, reducing nesting,
splitting out local vs remote cpu handling, and skipping everything
on isolated cpus, which solves the stuck FLUSHING_CACHED_CHARGE flag.

Link: https://sashiko.dev/#/patchset/20260827124211.3b94b103@fangorn

Rik van Riel (2):
  mm/memcontrol: extract stock drain predicates into helpers
  mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit on isolated cpus

 mm/memcontrol.c | 61 ++++++++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 26 deletions(-)

--
2.55.0
