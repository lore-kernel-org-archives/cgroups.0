Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6EA3E9589
	for <cgroups@vger.kernel.org>; Wed, 25 Feb 2026 17:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772039761; cv=none; b=LvBjXB1/WmlnAtC7hS4O6oGzhKLePAXqQAMrNH1Gh7Cr/rbLfzI76I3Hbattkjs2sii4jYjZPHcqhvDzq3Exz34ZBm4sGJSxar3Q57BpFFHysf63ew+cWL7r3pdi+KNrssG7QpOXv0EhEKMI7p9oIfHK3cXY3htQjd4yAc6KGm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772039761; c=relaxed/simple;
	bh=jJdzvVKMl5cn0QuJzc7vXdV0mAMHYhsXz6osLCyQqkg=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=Zu1Pq08pBIudDOyhEtmzSB9FXYP8rXJxNsZSqZ/pMdz81X1OUPHXyyBRxpPN8ZHaGzWmHA5tLjp1aodaJDCxf1ZokIihKuM5zQREFRTuhrUF7EeBm6IAa7JfAlpA2mGMb1ZQ6MdTHXlMPTDYkZ0a/48HSNOzl1JYeLS7muR07aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=emxViB2P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="emxViB2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385F6C2BCB2;
	Wed, 25 Feb 2026 17:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772039761;
	bh=jJdzvVKMl5cn0QuJzc7vXdV0mAMHYhsXz6osLCyQqkg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=emxViB2PRoqwP7d4rpdwXv6bTCYQD9BI/qjOXLPFK0TrQPZzPJGxNADxmpSJnb37j
	 YpsCB0CfrboereOvxHKjW58gmH5ODcAIpLzVpFXnau81eTf4/oEKThJrlILMhCa0NQ
	 5KXqx6V3m4mzhaaCgKvjZnIPAFc1A3MM+tPLkeDQnMwSAaNBHqxx2xckYmt8WUdztq
	 troKRrGbl8HVYsfLjzzNWQM6mHPPTvcSLErcfeQQlE16h8IMb6l34FJyk6p6w5IycN
	 mOp7VkzMrw8hL5bq4l92ZUNJ4TxTjkX2Ko4X1faJJ5API/6d1qrpQHFL2aI7+/KUJD
	 q1tpj4XcO9Tug==
Date: Wed, 25 Feb 2026 07:16:00 -1000
Message-ID: <a9027a23743a2ec1511d8555ce3ef382@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Natalie Vock <natalie.vock@gmx.de>
Cc: Maarten Lankhorst <dev@lankhorst.se>,
 Maxime Ripard <mripard@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Koutny <mkoutny@suse.com>,
 Christian Koenig <christian.koenig@amd.com>,
 Huang Rui <ray.huang@amd.com>,
 Matthew Auld <matthew.auld@intel.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 Tvrtko Ursulin <tursulin@ursulin.net>,
 cgroups@vger.kernel.org,
 dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v4 2/6] cgroup/dmem: Add dmem_cgroup_common_ancestor
 helper
In-Reply-To: <20260225-dmemcg-aggressive-protect-v4-2-de847ab35184@gmx.de>
References: <20260225-dmemcg-aggressive-protect-v4-0-de847ab35184@gmx.de>
 <20260225-dmemcg-aggressive-protect-v4-2-de847ab35184@gmx.de>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Each cgroup already knows all its ancestors in cgrp->ancestors[] along with
its depth in cgrp->level (see cgroup_is_descendant() and cgroup_ancestor()).
This can be used to implement a generic cgroup_common_ancestor() a lot more
efficiently. Something like:

  static inline struct cgroup *cgroup_common_ancestor(struct cgroup *a,
                                                      struct cgroup *b)
  {
          int level;

          for (level = min(a->level, b->level); level >= 0; level--)
                  if (a->ancestors[level] == b->ancestors[level])
                          return a->ancestors[level];
          return NULL;
  }

This is O(depth) instead of O(n*m). Can you add a helper like the above in
include/linux/cgroup.h and use it here?

Thanks.
-- 
tejun
