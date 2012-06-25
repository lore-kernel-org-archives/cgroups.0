From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 09/11] memcg: propagate kmem limiting information to children
Date: Tue, 26 Jun 2012 02:36:27 +0400
Message-ID: <4FE8E7EB.2020804@parallels.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-10-git-send-email-glommer@parallels.com> <20120625182907.GF3869@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120625182907.GF3869-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 06/25/2012 10:29 PM, Tejun Heo wrote:
> Feeling like a nit pervert but..
>
> On Mon, Jun 25, 2012 at 06:15:26PM +0400, Glauber Costa wrote:
>> @@ -287,7 +287,11 @@ struct mem_cgroup {
>>   	 * Should the accounting and control be hierarchical, per subtree?
>>   	 */
>>   	bool use_hierarchy;
>> -	bool kmem_accounted;
>> +	/*
>> +	 * bit0: accounted by this cgroup
>> +	 * bit1: accounted by a parent.
>> +	 */
>> +	volatile unsigned long kmem_accounted;
>
> Is the volatile declaration really necessary?  Why is it necessary?
> Why no comment explaining it?

Seems to be required by set_bit and friends. gcc will complain if it is 
not volatile (take a look at the bit function headers)

>> +
>> +		for_each_mem_cgroup_tree(iter, memcg) {
>> +			struct mem_cgroup *parent;
>
> Blank line between decl and body please.
ok.

>
>> +			if (iter == memcg)
>> +				continue;
>> +			/*
>> +			 * We should only have our parent bit cleared if none of
>> +			 * ouri parents are accounted. The transversal order of
>
>                                ^ type
>
>> +			 * our iter function forces us to always look at the
>> +			 * parents.
>
> Also, it's okay here but the text filling in comments and patch
> descriptions tend to be quite inconsistent.  If you're on emacs, alt-q
> is your friend and I'm sure vim can do text filling pretty nicely too.
>
>> +			 */
>> +			parent = parent_mem_cgroup(iter);
>> +			while (parent && (parent != memcg)) {
>> +				if (test_bit(KMEM_ACCOUNTED_THIS, &parent->kmem_accounted))
>> +					goto noclear;
>> +					
>> +				parent = parent_mem_cgroup(parent);
>> +			}
>
> Better written in for (;;)?  Also, if we're breaking on parent ==
> memcg, can we ever hit NULL parent in the above loop?

I can simplify to test parent != memcg only, indeed it is not expected 
to be NULL (but if it happens to be due to any kind of bug, we protect 
against NULL-dereference, that is why I like to write this way)

>> +			continue;
>> +		}
>> +	}
>> +out:
>> +	mutex_unlock(&set_limit_mutex);
>
> Can we please branch on val != RECOURSE_MAX first?  I'm not even sure
> whether the above conditionals are correct.  If the user updates an
> existing kmem limit, the first test_and_set_bit() returns non-zero, so
> the code proceeds onto clearing KMEM_ACCOUNTED_THIS, which succeeds
> but val == RESOURCE_MAX fails so it doesn't do anything.  If the user
> changes it again, it will set ACCOUNTED_THIS again.  So, changing an
> existing kmem limit toggles KMEM_ACCOUNTED_THIS, which just seems
> wacky to me.
>

I will take a look at that tomorrow as well.


