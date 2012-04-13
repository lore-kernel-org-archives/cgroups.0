From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 4/7] memcg: remove 'uncharge' argument from mem_cgroup_move_account()
Date: Fri, 13 Apr 2012 10:01:13 +0900
Message-ID: <4F877AD9.6040504@jp.fujitsu.com>
References: <4F86B9BE.8000105@jp.fujitsu.com> <4F86BB5E.6080509@jp.fujitsu.com> <4F86D84C.1050508@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <4F86D84C.1050508@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer@parallels.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>

(2012/04/12 22:27), Glauber Costa wrote:

> On 04/12/2012 08:24 AM, KAMEZAWA Hiroyuki wrote:
>> Only one call passes 'true'. remove it and handle it in caller.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> I like the change. I won't ack the patch itself, though, because it has
> a dependency with the "need_cancel" thing you introduced in your last
> patch - that I need to think a bit more.
> 


I'll check the logic again. Firstly, maybe name of the variable is wrong..

Thanks,
-Kame

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
