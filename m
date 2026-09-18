Received: from mta0.migadu.com (out-157.mta0.migadu.com [91.218.175.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E41D4E73A8
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 12:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789733305; cv=none; b=bjq5bc2fuCOWHfsHoUr9P0uQoljnJvLJAFD+EJ5QNsd2n7MuhFjh769iAwYsqQqFSTO200itwVFRDLfWCHZ3u888P37Upvw3EcxJ6cosz/Ex29kDkUDEAqnBwszy4v+V0Lj7w8zVr9nQuPhVgyO5OZL/ety2ObZW28dnlWnmIuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789733305; c=relaxed/simple;
	bh=e6Sc8d6TCv1Hiij+M19oHz2OIgibmXC/82dg97Yi2uY=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=nGoj3NiQtuR1SYGx47nZyGDr2FYPfH7DrKnbNKxuHX+nDl0MR0vFTczG16Le5UDGsF38I0UIagpJUkisyYjhMQT5EMDDbWo+D43uO6Nc6egcWEuKT/DfeVtbEDn4PNXuOOv7RMx6hyBIc1bK1yVAU7hfZ0VC3Yv9MmiRgi4gAjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=W+p2LRty; arc=none smtp.client-ip=91.218.175.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="W+p2LRty"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=e6Sc8d6TCv1Hiij+M19oHz2OIgibmXC/82dg97Yi2uY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789733301; v=1; x=1790338101;
 b=W+p2LRtyH0cD8luUar7ncxicH5z3+LEiL2RytsSSbPlZaL1AnSkNyXVEjUzCMVOMWrPV1IIo
 LNbNuMwZ/qDI5ZYoztb1ecqpYe/9mg/4YXOIrgJrkqTiPyp6Q8B7A+njv0eQ3KDHcMt2I/rzITp
 03etA0c0yf68ljwq0WJZ4SlU=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id ac9122ca51626832;
	Fri, 18 Sep 2026 12:08:21 +0000
X-Mizu-Trace-ID: ac9122ca51626832
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 1/4] memcg: keep swap charging under RCU protection
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260918-bingfangguo-memcgid-rework-v1-1-5bbf3220d88f@tencent.com>
Date: Fri, 18 Sep 2026 20:07:59 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Bingfang Guo <bfguo@icloud.com>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <CEA43253-5A6F-46EF-A7CF-645D5EC95E05@linux.dev>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
 <20260918-bingfangguo-memcgid-rework-v1-1-5bbf3220d88f@tencent.com>
To: bingfangguo@tencent.com
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 18, 2026, at 17:18, Bingfang Guo via B4 Relay =
<devnull+bingfangguo.tencent.com@kernel.org> wrote:
>=20
> From: Bingfang Guo <bingfangguo@tencent.com>
>=20
> This is a preparatory work for unbinding memcgid from memcg. No
> functional change.
>=20
> The swap charging path currently drops its RCU read lock after =
acquiring
> a private ID reference. This is safe because the ID reference pins the
> memcg's CSS.
>=20
> Moving private ID references to objcgs will remove that lifetime
> guarantee. Keep the RCU read lock held while accessing the memcg for
> counter charging, statistics and failure handling. (This matches what
> __memcg1_swapout() already does.).
>=20
> Save the private ID before dropping the RCU read lock, and use the =
saved
> value when recording the swap entry. The swap cluster locking remains
> outside the RCU read-side critical section.
>=20
> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.

