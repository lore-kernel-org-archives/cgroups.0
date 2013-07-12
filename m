From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] vmpressure: make sure memcg stays alive until all
 users are signaled
Date: Fri, 12 Jul 2013 14:03:31 +0800
Message-ID: <51DF9C33.7040708@huawei.com>
References: <20130710184254.GA16979@mtj.dyndns.org> <20130711083110.GC21667@dhcp22.suse.cz> <51DE701C.6010800@huawei.com> <20130711092542.GD21667@dhcp22.suse.cz> <51DE7AAF.6070004@huawei.com> <20130711093300.GE21667@dhcp22.suse.cz> <20130711154408.GA9229@mtj.dyndns.org> <20130711162215.GM21667@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130711162215.GM21667-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On 2013/7/12 0:22, Michal Hocko wrote:
> On Thu 11-07-13 08:44:08, Tejun Heo wrote:
>> Hello, Michal.
>>
>> On Thu, Jul 11, 2013 at 11:33:00AM +0200, Michal Hocko wrote:
>>> +static inline
>>> +struct mem_cgroup *vmpressure_to_mem_cgroup(struct vmpressure *vmpr)
>>> +{
>>> +	return container_of(vmpr, struct mem_cgroup, vmpressure);
>>> +}
>>> +
>>> +void vmpressure_pin_memcg(struct vmpressure *vmpr)
>>> +{
>>> +	struct mem_cgroup *memcg = vmpressure_to_mem_cgroup(vmpr);
>>> +
>>> +	css_get(&memcg->css);
>>> +}
>>> +
>>> +void vmpressure_unpin_memcg(struct vmpressure *vmpr)
>>> +{
>>> +	struct mem_cgroup *memcg = vmpressure_to_mem_cgroup(vmpr);
>>> +
>>> +	css_put(&memcg->css);
>>> +}
>>
>> So, while this *should* work, can't we just cancel/flush the work item
>> from offline? 
> 
> I would rather not put vmpressure clean up code into memcg offlining.
> We have reference counting for exactly this purposes so it feels strange
> to overcome it like that.

I'd agree with Tejun here. Asynchrously should be avoided if not necessary,
and the change would be simpler. There's already a vmpressure_init() in
mem_cgroup_css_alloc(), so it doesn't seem bad to do vmpressure cleanup
in memcg.
