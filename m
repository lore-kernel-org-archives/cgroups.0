From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v2] memcg: execute partial memcg freeing in mem_cgroup_destroy
Date: Tue, 21 Aug 2012 17:34:44 +0400
Message-ID: <50338E74.9020507@parallels.com>
References: <1345114903-20627-1-git-send-email-glommer@parallels.com> <xr93vcgiazok.fsf@gthelen.mtv.corp.google.com> <502DCDD0.3060502@parallels.com> <xr93a9xu9g7z.fsf@gthelen.mtv.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <xr93a9xu9g7z.fsf@gthelen.mtv.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Greg Thelen <gthelen@google.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>

On 08/17/2012 10:37 AM, Greg Thelen wrote:
>> >
>> > Can we demonstrate that? I agree there might be a potential problem, and
>> > that is why I sent this separately. But the impression I got after
>> > testing and reading the code, was that the memcg information in
>> > pc->mem_cgroup would be updated to the parent.
>> >
>> > This means that any later call to uncharge or uncharge_swap would just
>> > uncharge from the parent memcg and we'd have no problem.
> I am by no means a swap expert, so I may be heading in the weeds.  But I
> think that a swapped out page is not necessarily in any memcg lru.  So
> the mem_cgroup_pre_destroy() call to mem_cgroup_force_empty() will not
> necessarily see swapped out pages.
> 
> I think this demonstrates the problem.

Ok, thanks Greg.
This seem to happen solely because we use the css_id in swap_cgroup
structure, and that needs to stay around. If we stored the memcg address
instead, we'd have no such problem. (I believe so atm, still need to go
dig deeper)

But this would lead to a 4 times bigger memory usage for that. Quite a
waste considering this tend to be sparsely used most of the time.






--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
