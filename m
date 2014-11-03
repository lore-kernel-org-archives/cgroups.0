From: David Miller <davem@davemloft.net>
Subject: Re: [patch 2/3] mm: page_cgroup: rename file to mm/swap_cgroup.c
Date: Sun, 02 Nov 2014 23:22:52 -0500 (EST)
Message-ID: <20141102.232252.289821233794405148.davem@davemloft.net>
References: <1414898156-4741-1-git-send-email-hannes@cmpxchg.org>
	<1414898156-4741-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1414898156-4741-2-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: hannes@cmpxchg.org
Cc: akpm@linux-foundation.org, mhocko@suse.cz, vdavydov@parallels.com, tj@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>
Date: Sat,  1 Nov 2014 23:15:55 -0400

> Now that the external page_cgroup data structure and its lookup is
> gone, the only code remaining in there is swap slot accounting.
> 
> Rename it and move the conditional compilation into mm/Makefile.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: David S. Miller <davem@davemloft.net>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
