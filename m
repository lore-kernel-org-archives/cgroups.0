From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 4/6] memcg: move recent_rotated and recent_scanned
 informations
Date: Sat, 23 Jun 2012 11:51:13 +0200
Message-ID: <20120623095112.GO27816@cmpxchg.org>
References: <1340432259-5317-1-git-send-email-liwp.linux@gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1340432259-5317-1-git-send-email-liwp.linux@gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Gavin Shan <shangw@linux.vnet.ibm.com>

On Sat, Jun 23, 2012 at 02:17:39PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> Move recent_rotated and recent_scanned prints next to inactive_anon,
> ative_anon, inactive_file, active_file, and unevictable prints to
> save developers' time. Since they have to go a long way(when cat memory.stat)
> to find recent_rotated and recent_scanned prints which has relationship
> with the memory cgroup we care. These prints are behind total_* which
> not just focus on the memory cgroup we care currently.

The hierarchical stats are about that memcg, too.  And I don't want to
turn on debugging and then look for the extra information hiding in
the middle of regular stats.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
