From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v2] mm/memcg: use exist interface to get css from memcg
Date: Thu, 19 Jul 2012 19:23:07 +0900
Message-ID: <5007E00B.6000802@jp.fujitsu.com>
References: <1342609734-22437-1-git-send-email-liwanp@linux.vnet.ibm.com> <20120719092928.GA2864@tiehlicka.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20120719092928.GA2864@tiehlicka.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko@suse.cz>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Gavin Shan <shangw@linux.vnet.ibm.com>, Bob Liu <lliubbo@gmail.com>

(2012/07/19 18:29), Michal Hocko wrote:
> On Wed 18-07-12 19:08:54, Wanpeng Li wrote:
>> use exist interface mem_cgroup_css instead of &mem->css.
>
> This interface has been added to enable mem->css outside of
> mm/memcontrol.c (where we define struct mem_cgroup). There is one user
> left (hwpoison_filter_task) after recent clean ups.
>
> I think we shouldn't spread the usage inside the mm/memcontrol.c. The
> compiler inlines the function for all callers added by this patch but I
> wouldn't rely on it. It is also unfortunate that we cannot convert all
> dereferences (e.g. const mem_cgroup).
> Moreover it doesn't add any additional type safety. So I would vote for
> not taking the patch but if others like it I will not block it.
>

Agreed.

-Kame

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
