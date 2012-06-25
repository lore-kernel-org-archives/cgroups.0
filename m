From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 10/11] memcg: allow a memcg with kmem charges to be destructed.
Date: Tue, 26 Jun 2012 02:25:46 +0400
Message-ID: <4FE8E56A.6080601@parallels.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-11-git-send-email-glommer@parallels.com> <20120625183442.GG3869@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120625183442.GG3869-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 06/25/2012 10:34 PM, Tejun Heo wrote:
> On Mon, Jun 25, 2012 at 06:15:27PM +0400, Glauber Costa wrote:
>> Because the ultimate goal of the kmem tracking in memcg is to
>> track slab pages as well, we can't guarantee that we'll always
>> be able to point a page to a particular process, and migrate
>> the charges along with it - since in the common case, a page
>> will contain data belonging to multiple processes.
>>
>> Because of that, when we destroy a memcg, we only make sure
>> the destruction will succeed by discounting the kmem charges
>> from the user charges when we try to empty the cgroup.
>>
>> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>> CC: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
>> CC: Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>
>> CC: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
>> CC: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>> CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>> CC: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> ---
>>   mm/memcontrol.c |   10 +++++++++-
>>   1 file changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index a6a440b..bb9b6fe 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -598,6 +598,11 @@ static void disarm_kmem_keys(struct mem_cgroup *memcg)
>>   {
>>   	if (test_bit(KMEM_ACCOUNTED_THIS, &memcg->kmem_accounted))
>>   		static_key_slow_dec(&mem_cgroup_kmem_enabled_key);
>> +	/*
>> +	 * This check can't live in kmem destruction function,
>> +	 * since the charges will outlive the cgroup
>> +	 */
>> +	BUG_ON(res_counter_read_u64(&memcg->kmem, RES_USAGE) != 0);
>
> WARN_ON() please.  Misaccounted kernel usually is better than dead
> kernel.
>

You're absolutely right, will change.

