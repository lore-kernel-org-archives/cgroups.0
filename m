From: Glauber Costa <glommer@parallels.com>
Subject: Re: [RFC][PATCH 3/7 v2] res_counter: add res_counter_uncharge_until()
Date: Fri, 27 Apr 2012 14:08:28 -0300
Message-ID: <4F9AD28C.60508@parallels.com>
References: <4F9A327A.6050409@jp.fujitsu.com> <4F9A343F.7020409@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <4F9A343F.7020409@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Frederic Weisbecker <fweisbec@gmail.com>, Tejun Heo <tj@kernel.org>, Han Ying <yinghan@google.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, kamezawa.hiroyuki@gmail.com

On 04/27/2012 02:53 AM, KAMEZAWA Hiroyuki wrote:
>  From bb0168d5c85f62f36434956e4728a67d0cc41e55 Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> Date: Thu, 26 Apr 2012 18:48:07 +0900
> Subject: [PATCH 3/9] memcg: add res_counter_uncharge_until()
> 
> At killing res_counter which is a child of other counter,
> we need to do
> 	res_counter_uncharge(child, xxx)
> 	res_counter_charge(parent, xxx)
> 
> This is not atomic and wasting cpu. This patch adds
> res_counter_uncharge_until(). This function's uncharge propagates
> to ancestors until specified res_counter.
> 
> 	res_counter_uncharge_until(child, parent, xxx)
> 
> This ops is atomic and more efficient.
> 
> Originaly-written-by: Frederic Weisbecker<fweisbec@gmail.com>
> Signed-off-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
I have been carrying Frederic's patch itself in my code for a while now.

Why not just use it? What are you doing differently to justify writing a
patch yourself? It's a bit of credit giving as well

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
