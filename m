From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v4 3/6] memcg: fast hierarchy-aware child test.
Date: Tue, 29 Jan 2013 09:14:51 +0900
Message-ID: <5107147B.9080805@jp.fujitsu.com>
References: <1358862461-18046-1-git-send-email-glommer@parallels.com> <1358862461-18046-4-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1358862461-18046-4-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>

(2013/01/22 22:47), Glauber Costa wrote:
> Currently, we use cgroups' provided list of children to verify if it is
> safe to proceed with any value change that is dependent on the cgroup
> being empty.
> 
> This is less than ideal, because it enforces a dependency over cgroup
> core that we would be better off without. The solution proposed here is
> to iterate over the child cgroups and if any is found that is already
> online, we bounce and return: we don't really care how many children we
> have, only if we have any.
> 
> This is also made to be hierarchy aware. IOW, cgroups with  hierarchy
> disabled, while they still exist, will be considered for the purpose of
> this interface as having no children.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> Acked-by: Michal Hocko <mhocko@suse.cz>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
