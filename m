From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 5/9] memcg: use css_get/put when charging/uncharging
 kmem
Date: Fri, 14 Jun 2013 09:17:40 +0800
Message-ID: <51BA6F34.30001@huawei.com>
References: <51B98D17.2050902@huawei.com> <20130613155319.GJ23070@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130613155319.GJ23070-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

>>  static void memcg_kmem_mark_dead(struct mem_cgroup *memcg)
>>  {
>> +	/*
>> +	 * We need to call css_get() first, because memcg_uncharge_kmem()
>> +	 * will call css_put() if it sees the memcg is dead.
>> +	 */
>> +	smb_wmb();
>>  	if (test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags))
>>  		set_bit(KMEM_ACCOUNTED_DEAD, &memcg->kmem_account_flags);
> 
> I do not feel strongly about that but maybe open coding this in
> mem_cgroup_css_offline would be even better. There is only single caller
> and there is smaller chance somebody will use the function incorrectly
> later on.
> 
> So I leave the decision on you because this doesn't matter much.
> 

Yeah, it should go away soon. I'll post a patch after this patchset gets
merged into -mm tree and then we can discuss there.
