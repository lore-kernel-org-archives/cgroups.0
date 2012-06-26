From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [patch 1/3] mm, oom: move declaration for mem_cgroup_out_of_memory
 to oom.h
Date: Tue, 26 Jun 2012 12:12:27 +0900
Message-ID: <4FE9289B.2050105@jp.fujitsu.com>
References: <alpine.DEB.2.00.1206251846020.24838@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.00.1206251846020.24838@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org

(2012/06/26 10:47), David Rientjes wrote:
> mem_cgroup_out_of_memory() is defined in mm/oom_kill.c, so declare it in
> linux/oom.h rather than linux/memcontrol.h.
>
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
