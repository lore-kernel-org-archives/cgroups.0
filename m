From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [RFC 5/7] use percpu_counters for res_counter usage
Date: Mon, 09 Apr 2012 10:48:42 +0900
Message-ID: <4F823FFA.8000401@jp.fujitsu.com>
References: <1333094685-5507-1-git-send-email-glommer@parallels.com> <1333094685-5507-6-git-send-email-glommer@parallels.com> <4F757DEB.4030006@jp.fujitsu.com> <4F7583AB.3070304@jp.fujitsu.com> <4F75BACC.7050704@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F75BACC.7050704-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

(2012/03/30 22:53), Glauber Costa wrote:

> On 03/30/2012 11:58 AM, KAMEZAWA Hiroyuki wrote:
>> ==
>>
>> Now, we do consume 'reserved' usage, we can avoid css_get(), an heavy atomic
>> ops. You may need to move this code as
>>
>> 	rcu_read_lock()
>> 	....
>> 	res_counter_charge()
>> 	if (failure) {
>> 		css_tryget()
>> 		rcu_read_unlock()
>> 	} else {
>> 		rcu_read_unlock()
>> 		return success;
>> 	}
>>
>> to compare performance. This css_get() affects performance very very much.
> 
> thanks for the tip.
> 
> But one thing:
> 
> To be sure: it effectively mean that we are drawing from a dead memcg
> (because we pre-allocated, right?

Cached stock is consumed by the current task. It blocks removal of memcg.
It's not dead.

Thanks,
-Kame

 


