Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31071DE4FB;
	Tue, 14 Jul 2026 00:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783988862; cv=none; b=LxvXxqJV1nK11kwKWXuggUgtj9nClYaPoUZuLAbNV7d0FtaO+mKXXuJgV1oItA2Rkyb5KVHLo+jbOyTux6ZxByLKyIqOveEYFzOJCz+NlnIwpxhHig1Me8z1vZ+ZQRE+f9/Phb42GOIZbJhJw8HYkcuEUyVLRQgYzvSCVO/B1FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783988862; c=relaxed/simple;
	bh=abzwn2wkxaBkMbJRhWXIexzZW8PwP84KneR9eWiVUHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDy1Py5KFkbNfy7/UJa7MC1uAjEro4hrDPyRxI1DMufvzKmlp+M650KV+VAoJfw+eIh4pp1Jfkyfj4Ksj+z8V8o74yxNnKdYIFWAePD+S9MOfCd9aiVqtSRQ4SJ91N20wYPb7Yk7iHDcFHfHBtPAsecFcwh64WqvG2L+9PpiGBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n+NIdeOm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n+NIdeOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F76C1F000E9;
	Tue, 14 Jul 2026 00:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783988860;
	bh=QoDq4TZKn0bzwtutz903WlltVUL0JHQTEIuXLfoz+KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n+NIdeOmm/2UIFfyqHLKJu9SjYM9TwimD//3hh2m62D0IkeJOgYIlqRTvAKGfIk0g
	 WC0ASzCbk2UXAll6ctUEWZSK0QbyFQA424v2DL4XCAJAZccaX/3X5R+VXep+dkTICP
	 PHGZoY5VcQPm10q1qvLre5Bt0xYjOLeSqgyfc5UwY13yYFWQfRnKQpCgeql/zhBjJI
	 2fK0hHLrG6/EIJBiUuqN/v7iyjC+QjVMpvE6AwiV1vwgnwd8XdNB/hxPbyxIRYHO2m
	 ZBMYIPWfgoorZ+O7v6lqUeH08kV/NnXbCS23hmSsSHKh8IU6qhB0R88Nlw2Z30kRHx
	 osT6eAj8Z1L3g==
From: SJ Park <sj@kernel.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg-v1: make mem_cgroup_oom_notify_cb() return void
Date: Mon, 13 Jul 2026 17:27:37 -0700
Message-ID: <20260714002737.85810-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260713093737.3299646-1-guopeng.zhang@linux.dev>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 13 Jul 2026 17:37:37 +0800 Guopeng Zhang <guopeng.zhang@linux.dev> wrote:

> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> Commit 7d74b06f240f ("memcg: use for_each_mem_cgroup") replaced the
> mem_cgroup_walk_tree() call in mem_cgroup_oom_notify() with
> for_each_mem_cgroup_tree(), but left mem_cgroup_oom_notify_cb() with the
> int return type required by the old callback interface.
> 
> The function now has a single direct caller and no failure path. Make it
> return void.

Makes sense to me.

> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]
