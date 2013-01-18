From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2 3/7] memcg: provide online test for memcg
Date: Fri, 18 Jan 2013 11:41:47 -0800
Message-ID: <50F9A57B.6080603@parallels.com>
References: <1357897527-15479-1-git-send-email-glommer@parallels.com> <1357897527-15479-4-git-send-email-glommer@parallels.com> <20130118153715.GG10701@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130118153715.GG10701-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 01/18/2013 07:37 AM, Michal Hocko wrote:
> On Fri 11-01-13 13:45:23, Glauber Costa wrote:
>> Since we are now splitting the memcg creation in two parts, following
>> the cgroup standard, it would be helpful to be able to determine if a
>> created memcg is already online.
>>
>> We can do this by initially forcing the refcnt to 0, and waiting until
>> the last minute to flip it to 1.
> 
> Is this useful, though? What does it tell you? mem_cgroup_online can say
> false even though half of the attributes have been already copied for
> example. I think it should be vice versa. It should mark the point when
> we _start_ copying values. mem_cgroup_online is not the best name then
> of course. It depends what it is going to be used for...
> 

I think you are right in the sense that setting it before copying any
fields is the correct behavior - thanks.

In this sense, this works as a commitment that we will have a complete
child, rather than a statement that we have a complete child.

>> During memcg's lifetime, this value
>> will vary. But if it ever reaches 0 again, memcg will be destructed. We
>> can therefore be sure that any value different than 0 will mean that
>> our group is online.
>>
>> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>> ---
>>  mm/memcontrol.c | 15 ++++++++++++---
>>  1 file changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 2229945..2ac2808 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -475,6 +475,11 @@ enum res_type {
>>  static void mem_cgroup_get(struct mem_cgroup *memcg);
>>  static void mem_cgroup_put(struct mem_cgroup *memcg);
>>  
>> +static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
>> +{
>> +	return atomic_read(&memcg->refcnt) > 0;
>> +}
>> +
>>  static inline
>>  struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *s)
>>  {
>> @@ -6098,7 +6103,7 @@ mem_cgroup_css_alloc(struct cgroup *cont)
>>  
>>  	memcg->last_scanned_node = MAX_NUMNODES;
>>  	INIT_LIST_HEAD(&memcg->oom_notify);
>> -	atomic_set(&memcg->refcnt, 1);
>> +	atomic_set(&memcg->refcnt, 0);
> 
> I would prefer a comment rather than an explicit atomic_set. The value
> is zero already.
> 
Yes, Sir!

>>  	memcg->move_charge_at_immigrate = 0;
>>  	mutex_init(&memcg->thresholds_lock);
>>  	spin_lock_init(&memcg->move_lock);
>> @@ -6116,10 +6121,13 @@ mem_cgroup_css_online(struct cgroup *cont)
>>  	struct mem_cgroup *memcg, *parent;
>>  	int error = 0;
>>
> 	
> as I said above atomic_set(&memc->refcnt, 1) should be set here before
> we start copying anything.
> 
> But maybe I have missed your intention and later patches in the series
> will convince me...
> 

It went the other way around...
