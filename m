From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC 5/6] mm, cpuset: always use seqlock when changing task's
 nodemask
Date: Wed, 12 Apr 2017 10:18:21 +0200
Message-ID: <3a978d8c-c5c6-fc5d-cb40-85c7d7811146@suse.cz>
References: <20170411140609.3787-1-vbabka@suse.cz>
 <20170411140609.3787-6-vbabka@suse.cz>
 <0c2d01d2b364$4eaba920$ec02fb60$@alibaba-inc.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0c2d01d2b364$4eaba920$ec02fb60$@alibaba-inc.com>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Hillf Danton <hillf.zj-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Li Zefan' <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, 'Michal Hocko' <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Mel Gorman' <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, 'David Rientjes' <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, 'Christoph Lameter' <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, 'Hugh Dickins' <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, 'Andrea Arcangeli' <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Anshuman Khandual' <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "'Kirill A. Shutemov'" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

On 04/12/2017 10:10 AM, Hillf Danton wrote:
> On April 11, 2017 10:06 PM Vlastimil Babka wrote: 
>>
>>  static void cpuset_change_task_nodemask(struct task_struct *tsk,
>>  					nodemask_t *newmems)
>>  {
>> -	bool need_loop;
>> -
>>  	task_lock(tsk);
>> -	/*
>> -	 * Determine if a loop is necessary if another thread is doing
>> -	 * read_mems_allowed_begin().  If at least one node remains unchanged and
>> -	 * tsk does not have a mempolicy, then an empty nodemask will not be
>> -	 * possible when mems_allowed is larger than a word.
>> -	 */
>> -	need_loop = task_has_mempolicy(tsk) ||
>> -			!nodes_intersects(*newmems, tsk->mems_allowed);
>>
>> -	if (need_loop) {
>> -		local_irq_disable();
>> -		write_seqcount_begin(&tsk->mems_allowed_seq);
>> -	}
>> +	local_irq_disable();
>> +	write_seqcount_begin(&tsk->mems_allowed_seq);
>>
>> -	nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);
>>  	mpol_rebind_task(tsk, newmems);
>>  	tsk->mems_allowed = *newmems;
>>
>> -	if (need_loop) {
>> -		write_seqcount_end(&tsk->mems_allowed_seq);
>> -		local_irq_enable();
>> -	}
>> +	write_seqcount_end(&tsk->mems_allowed_seq);
>>
> Doubt if we'd listen irq again.

Ugh, thanks for catching this. Looks like my testing config didn't have
lockup detectors enabled.

>>  	task_unlock(tsk);
>>  }
>> --
>> 2.12.2
> 
