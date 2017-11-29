From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm, memcg: fix mem_cgroup_swapout() for THPs
Date: Wed, 29 Nov 2017 10:17:13 +0000
Message-ID: <20171129101713.GA28244@cmpxchg.org>
References: <20171128161941.20931-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=v3mEICMWWdxZdhxMQP8wumpnws5IR+m7a4JlgcSTCnQ=; b=2p0aMEAH8gTQw5XN5jr+lHKCeY
	x/gv6cHa/d0phhfKzBd/Gwz7+E+/zHWjMD/pGMXIk81rEyvw/SuqgGW2iXTva76fx7M8/ouUx3k6J
	M1W6UqHIsKBBw4UXPUs8wz3t+6PcBSbmzGRbcViIba2uyoZ5CYBJMQPFP4zrx38ocZOw=;
Content-Disposition: inline
In-Reply-To: <20171128161941.20931-1-shakeelb@google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Huang Ying <ying.huang@intel.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@kernel.org>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, stable@vger.kernel.org

On Tue, Nov 28, 2017 at 08:19:41AM -0800, Shakeel Butt wrote:
> The commit d6810d730022 ("memcg, THP, swap: make mem_cgroup_swapout()
> support THP") changed mem_cgroup_swapout() to support transparent huge
> page (THP). However the patch missed one location which should be
> changed for correctly handling THPs. The resulting bug will cause the
> memory cgroups whose THPs were swapped out to become zombies on
> deletion.
> 
> Fixes: d6810d730022 ("memcg, THP, swap: make mem_cgroup_swapout() support THP")
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Cc: stable@vger.kernel.org

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
