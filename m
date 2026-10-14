Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6A94EDCC3;
	Wed, 14 Oct 2026 23:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792022388; cv=none; b=nAs4AcICS/vsfODrmZKH6cwfsZrcIEsKeo84BQ2TJEBq6zfXny/bUqxXN+1OSUiWAK+UL5uxfrqfuxODo6T6KVXm0yjRjvNs0vShUpBVIrz3wY1f6XE1vrPquEGEKF/LEhuQ6NqWikiAi9lxdR/paWFhqdt1aQfGgC4/w97BY5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792022388; c=relaxed/simple;
	bh=nXhd8Xu0p7RT7+l9wH6swVnTjTvFwHU1lQCjT6dzVM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cAbwZ7Y2F/bM0/KOme18Fwe6zXbx2jTnZaVicCGi1qGkLBufwFC3j0jz16TqiJWi0LZcxcLbq0jabDfP2OmnMBSws2jegpPq4LRcAhlhXL1FcLsN60MhzIRLuL8XCd+9vOywivYSj/a39dEVCjxndE3bisI89aDgQNuj/aWHf24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bipez7Ht; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bipez7Ht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4CC1F000C4;
	Wed, 14 Oct 2026 23:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792022387;
	bh=u79nAdAkK0/gGpKFfO0nUzFOj1lq5Wr2kWciwdFQTiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bipez7Ht4bxO5601jdtc2fcZcO6bY2C/SWuclR1gQz3fXPfL/ED0fEvKsKH8QHi8V
	 EfWHR5+sqRGDCCQ0nkJAZ/sg1SU2cLrq1d2ZDQpzXx5XA4wbzxCLmos1DAB7j0Bek/
	 tAI/o+f+b/gMV5R1T/nOa9rzq9mkY+46RGbWJl2cYJY5RESbz70p4/HEbvmOcSzpCS
	 nuy8401E1lYan8/hj3lnx3W1F/cNVOp8aasyjdP2EgXEqjdzKpeEmrDPpVmARYkVeg
	 +lJDIynx3l2P7rmIqNgXObASjaFts72hWCoeDp3Rfbmn4Si/1aTIVkilTy8yIfow5m
	 i/Hi/UN85q4SQ==
From: SJ Park <sj@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: SJ Park <sj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: memcontrol: remove page_memcg_check()
Date: Wed, 14 Oct 2026 16:59:39 -0700
Message-ID: <20261014235939.3830-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261014-memcg-unused-page-helpers-v1-2-240b37c53831@columbia.edu>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 14 Oct 2026 13:08:21 -0400 Tal Zussman <tz2294@columbia.edu> wrote:

> The last caller was removed in commit 90f095b816e2 ("mm/page_owner: use
> memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()").
> Remove it.

Makes sense to me.

> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]
