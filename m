From: Glauber Costa <glommer@parallels.com>
Subject: Re: [RFC 5/7] use percpu_counters for res_counter usage
Date: Fri, 30 Mar 2012 15:53:16 +0200
Message-ID: <4F75BACC.7050704@parallels.com>
References: <1333094685-5507-1-git-send-email-glommer@parallels.com> <1333094685-5507-6-git-send-email-glommer@parallels.com> <4F757DEB.4030006@jp.fujitsu.com> <4F7583AB.3070304@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <4F7583AB.3070304@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>, devel@openvz.org, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Linux MM <linux-mm@kvack.org>, Pavel Emelyanov <xemul@parallels.com>

On 03/30/2012 11:58 AM, KAMEZAWA Hiroyuki wrote:
> ==
> 
> Now, we do consume 'reserved' usage, we can avoid css_get(), an heavy atomic
> ops. You may need to move this code as
> 
> 	rcu_read_lock()
> 	....
> 	res_counter_charge()
> 	if (failure) {
> 		css_tryget()
> 		rcu_read_unlock()
> 	} else {
> 		rcu_read_unlock()
> 		return success;
> 	}
> 
> to compare performance. This css_get() affects performance very very much.

thanks for the tip.

But one thing:

To be sure: it effectively mean that we are drawing from a dead memcg
(because we pre-allocated, right?




--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
