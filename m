From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH 1/7] res_counter: add a function res_counter_move_parent().
Date: Wed, 18 Apr 2012 16:04:42 +0900
Message-ID: <4F8E678A.8000805@jp.fujitsu.com>
References: <4F86B9BE.8000105@jp.fujitsu.com> <4F86BA66.2010503@jp.fujitsu.com> <20120416223157.GE12421@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120416223157.GE12421-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

(2012/04/17 7:31), Tejun Heo wrote:

> On Thu, Apr 12, 2012 at 08:20:06PM +0900, KAMEZAWA Hiroyuki wrote:
>> +/*
>> + * In hierarchical accounting, child's usage is accounted into ancestors.
>> + * To move local usage to its parent, just forget current level usage.
>> + */
>> +void res_counter_move_parent(struct res_counter *counter, unsigned long val)
>> +{
>> +	unsigned long flags;
>> +
>> +	BUG_ON(!counter->parent);
>> +	spin_lock_irqsave(&counter->lock, flags);
>> +	res_counter_uncharge_locked(counter, val);
>> +	spin_unlock_irqrestore(&counter->lock, flags);
>> +}
> 
> On the second thought, do we need this at all?  It's as good as doing
> nothing after all, no?
> 


I considered that, but I think it may make it hard to debug memcg leakage.
I'd like to confirm res->usage == 0 at removal of memcg.

Thanks,
-Kame
