From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2 19/29] skip memcg kmem allocations in specified code
 regions
Date: Wed, 16 May 2012 10:19:15 +0400
Message-ID: <4FB346E3.5060507@parallels.com>
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-20-git-send-email-glommer@parallels.com> <4FB1C398.1010000@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FB1C398.1010000-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On 05/15/2012 06:46 AM, KAMEZAWA Hiroyuki wrote:
> (2012/05/12 2:44), Glauber Costa wrote:
> 
>> This patch creates a mechanism that skip memcg allocations during
>> certain pieces of our core code. It basically works in the same way
>> as preempt_disable()/preempt_enable(): By marking a region under
>> which all allocations will be accounted to the root memcg.
>>
>> We need this to prevent races in early cache creation, when we
>> allocate data using caches that are not necessarily created already.
>>
>> Signed-off-by: Glauber Costa<glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>> CC: Christoph Lameter<cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
>> CC: Pekka Enberg<penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>
>> CC: Michal Hocko<mhocko-AlSwsSmVLrQ@public.gmane.org>
>> CC: Kamezawa Hiroyuki<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>> CC: Johannes Weiner<hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>> CC: Suleiman Souhlal<suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> 
> The concept seems okay to me but...
> 
>> ---
>>   include/linux/sched.h |    1 +
>>   mm/memcontrol.c       |   25 +++++++++++++++++++++++++
>>   2 files changed, 26 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 81a173c..0501114 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -1613,6 +1613,7 @@ struct task_struct {
>>   		unsigned long nr_pages;	/* uncharged usage */
>>   		unsigned long memsw_nr_pages; /* uncharged mem+swap usage */
>>   	} memcg_batch;
>> +	atomic_t memcg_kmem_skip_account;
> 
> 
> If only 'current' thread touch this, you don't need to make this atomic counter.
> you can use 'long'.
> 
You're absolutely right, Kame, thanks.
I first used atomic_t because I had it tested against current->mm->owner.

Do you, btw, agree to use current instead of owner here?
You can find the rationale in earlier mails between me and Suleiman.

