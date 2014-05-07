From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch 5/9] mm: memcontrol: use root_mem_cgroup res_counter
Date: Wed, 7 May 2014 17:14:08 +0200
Message-ID: <20140507151408.GK9489@dhcp22.suse.cz>
References: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
 <1398889543-23671-6-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1398889543-23671-6-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed 30-04-14 16:25:39, Johannes Weiner wrote:
> The root_mem_cgroup res_counter is never charged itself: there is no
> limit at the root level anyway, and any statistics are generated on
> demand by summing up the counters of all other cgroups.  This was an
> optimization to keep down costs on systems that don't create specific
> cgroups, but with per-cpu charge caches the res_counter operations do
> not even show up on in profiles anymore.  Just remove it and simplify
> the code.

It seems that only kmem and tcp thingy are left but those looks much
harder and they are not directly related.

root_mem_cgroup use also seems to be correct.

I have to look at this closer and that will be no sooner than on Monday
as I am off for the rest of the week.
[...]
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
