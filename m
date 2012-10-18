From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v5 09/14] memcg: kmem accounting lifecycle management
Date: Thu, 18 Oct 2012 13:42:11 +0400
Message-ID: <507FCEF3.2050801@parallels.com>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com> <1350382611-20579-10-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1210171624540.20813@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1210171624540.20813-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 10/18/2012 03:28 AM, David Rientjes wrote:
> On Tue, 16 Oct 2012, Glauber Costa wrote:
> 
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 1182188..e24b388 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -344,6 +344,7 @@ struct mem_cgroup {
>>  /* internal only representation about the status of kmem accounting. */
>>  enum {
>>  	KMEM_ACCOUNTED_ACTIVE = 0, /* accounted by this cgroup itself */
>> +	KMEM_ACCOUNTED_DEAD, /* dead memcg, pending kmem charges */
> 
> "dead memcg with pending kmem charges" seems better.
> 
ok.

>>  };
>>  
>>  #define KMEM_ACCOUNTED_MASK (1 << KMEM_ACCOUNTED_ACTIVE)
>> @@ -353,6 +354,22 @@ static void memcg_kmem_set_active(struct mem_cgroup *memcg)
>>  {
>>  	set_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_accounted);
>>  }
>> +
>> +static bool memcg_kmem_is_active(struct mem_cgroup *memcg)
>> +{
>> +	return test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_accounted);
>> +}
> 
> I think all of these should be inline.
> 
They end up being, to be best of my knowledge the compiler can and will
inline such simple functions regardless of their marking, unless you
explicitly mark them noinline.


>> +
>> +static void memcg_kmem_mark_dead(struct mem_cgroup *memcg)
>> +{
>> +	if (test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_accounted))
>> +		set_bit(KMEM_ACCOUNTED_DEAD, &memcg->kmem_accounted);
>> +}
> 
> The set_bit() doesn't happen atomically with the test_bit(), what 
> synchronization is required for this?
> 

I believe the explanation Michal gave in answer to this is comprehensive.
