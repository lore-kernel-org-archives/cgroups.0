From: Wanpeng Li <liwanp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v2] mm/memcg: use exist interface to get css from memcg
Date: Thu, 19 Jul 2012 18:28:18 +0800
Message-ID: <20120719102818.GA20171@kernel>
References: <1342609734-22437-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <20120719092928.GA2864@tiehlicka.suse.cz>
 <5007E00B.6000802@jp.fujitsu.com>
Reply-To: Wanpeng Li <liwanp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5007E00B.6000802-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gavin Shan <shangw-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Bob Liu <lliubbo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu, Jul 19, 2012 at 07:23:07PM +0900, Kamezawa Hiroyuki wrote:
>(2012/07/19 18:29), Michal Hocko wrote:
>>On Wed 18-07-12 19:08:54, Wanpeng Li wrote:
>>>use exist interface mem_cgroup_css instead of &mem->css.
>>
>>This interface has been added to enable mem->css outside of
>>mm/memcontrol.c (where we define struct mem_cgroup). There is one user
>>left (hwpoison_filter_task) after recent clean ups.
>>
>>I think we shouldn't spread the usage inside the mm/memcontrol.c. The
>>compiler inlines the function for all callers added by this patch but I
>>wouldn't rely on it. It is also unfortunate that we cannot convert all
>>dereferences (e.g. const mem_cgroup).
>>Moreover it doesn't add any additional type safety. So I would vote for
>>not taking the patch but if others like it I will not block it.
>>
>
>Agreed.

Hmm, I see, thank you. :-)

Best Regards,
Wanpeng Li
>
>-Kame
