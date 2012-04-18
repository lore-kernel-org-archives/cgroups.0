From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH 6/7] memcg: remove pre_destroy()
Date: Wed, 18 Apr 2012 16:12:18 +0900
Message-ID: <4F8E6952.9030909@jp.fujitsu.com>
References: <4F86B9BE.8000105@jp.fujitsu.com> <4F86BCCE.5050802@jp.fujitsu.com> <20120416223800.GF12421@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120416223800.GF12421-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

(2012/04/17 7:38), Tejun Heo wrote:

> Hello,
> 
> On Thu, Apr 12, 2012 at 08:30:22PM +0900, KAMEZAWA Hiroyuki wrote:
>> +/*
>> + * This function is called after ->destroy(). So, we cannot access cgroup
>> + * of this memcg.
>> + */
>> +static void mem_cgroup_recharge(struct work_struct *work)
> 
> So, ->pre_destroy per-se isn't gonna go away.  It's just gonna be this
> callback which cgroup core uses to unilaterally notify that the cgroup
> is going away, so no need to do this cleanup asynchronously from
> ->destroy().  It's okay to keep doing it synchronously from
> ->pre_destroy().  The only thing is that it can't fail.
> 


I see. 

Thanks,
-Kame


