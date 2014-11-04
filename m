From: David Miller <davem@davemloft.net>
Subject: Re: [patch 1/3] mm: embed the memcg pointer directly into struct
 page
Date: Tue, 04 Nov 2014 11:34:09 -0500 (EST)
Message-ID: <20141104.113409.1013929072623558759.davem@davemloft.net>
References: <20141104132701.GA18441@phnom.home.cmpxchg.org>
	<20141104134110.GD22207@dhcp22.suse.cz>
	<20141104140937.GA18602@phnom.home.cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20141104140937.GA18602@phnom.home.cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: hannes@cmpxchg.org
Cc: mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org, vdavydov@parallels.com, tj@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>
Date: Tue, 4 Nov 2014 09:09:37 -0500

> You either need cgroup memory accounting and limiting or not.  There
> is no possible trade-off to be had.

I couldn't have said it better myself, +1.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
