Received: from mta0.migadu.com (out-151.mta0.migadu.com [91.218.175.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BFE4B8DE8
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 17:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788458189; cv=none; b=pWIifwrLzrPXuR3fFHSyvq0xJQJ1OKmc+VP0YFBsWUgnJrpVdR9Q+8THcZ8/URAjU4A2ekJ61+DLB810uWtmW+cd9tqR/fvlpLJdd9FkJOFwW9b0IvQ3x0H0mDVf1IqzI89J+w3HXVWh4c4ekpyIvW+WsPXMWBx/GNN7JgrSj6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788458189; c=relaxed/simple;
	bh=L3+7YRmfESLibVZakMPl0uWAeXL3XzaW/tLxNhJw+VI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kPas3wgB0W8diaLUUS2RCMLqljw3JTNMK7qtFr7Vo6kEzg+hqW9p0cA/mQKmwnIPPvg0ejiTxRMUz9yGh5g0160SCj0wph8yaPE/bUxkf3bRFus9pHmYFb6XN8W5MeCEBBcyHc/hBfqRcc6lIAkIAGYtiitQYWmucbZ3H5PaxzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GkqDu/f/; arc=none smtp.client-ip=91.218.175.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GkqDu/f/"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=L3+7YRmfESLibVZakMPl0uWAeXL3XzaW/tLxNhJw+VI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788458183; v=1; x=1789062983;
 b=GkqDu/f/acM8xjZ2oIqmjySdRKIgfYfzIbyQbI1tITB467RZ9GR9SDBOkcOjuTsW2gHWGL7t
 oAMyv/EPMr6u+9upWNjo6UdE3cX/M7xkOjAQ0kUCdEIeTGEPNfkfi6TacgOPlOfmM/5DFUs1Zid
 4JLRgvZceBtK9ZzHFZR2Etag=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a4bed8d3f0db8ac7;
	Thu, 03 Sep 2026 17:56:23 +0000
X-Mizu-Trace-ID: a4bed8d3f0db8ac7
X-Migadu-Flow: FLOW_OUT
Date: Thu, 3 Sep 2026 10:56:22 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH v2 2/3] mm: memcg: redirect stats updates of dying memcgs
 for all hierarchies
Message-ID: <apm0nHGog6c0o3iO@linux.dev>
References: <cover.1788169145.git.zhuhui@kylinos.cn>
 <0214c0228695db474b86d3b4778b681a6c47a6e2.1788169145.git.zhuhui@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0214c0228695db474b86d3b4778b681a6c47a6e2.1788169145.git.zhuhui@kylinos.cn>

On Mon, Aug 31, 2026 at 05:46:10PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> get_non_dying_memcg_start() redirects the stat updates of a dying memcg to
> its closest non-dying ancestor, but only on cgroup v1; on cgroup v2 the
> stats keep being accounted to the dying memcg itself.
> 
> The previous patch restored lruvec_page_state_local() in
> count_shadow_nodes(), which reads those state_locals on cgroup v2 too, so
> apply the redirection to all hierarchies.  Offlining is rare, so the added
> cost on the stat update fast path is limited to an rcu_read_lock() and a
> css_is_dying() check; the upward walk happens only while a memcg is dying.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>

Please CC to stable and add a sentence on user visible impact of the bug in the
commit message. With that:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

