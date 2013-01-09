From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: use new hashtable implementation
Date: Wed, 9 Jan 2013 09:55:12 +0800
Message-ID: <50ECCE00.6040902@huawei.com>
References: <50EBD011.7040801@huawei.com> <20130108181729.GB3926@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130108181729.GB3926-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2013/1/9 2:17, Tejun Heo wrote:
> Hello, Li.
> 
> On Tue, Jan 08, 2013 at 03:51:45PM +0800, Li Zefan wrote:
>> -static struct hlist_head *css_set_hash(struct cgroup_subsys_state *css[])
>> +static unsigned long css_set_hash(struct cgroup_subsys_state *css[])
>>  {
>>  	int i;
>> -	int index;
>> -	unsigned long tmp = 0UL;
>> +	unsigned long key = 0UL;
>>  
>>  	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++)
>> -		tmp += (unsigned long)css[i];
>> -	tmp = (tmp >> 16) ^ tmp;
>> +		key += (unsigned long)css[i];
>> +	key = (key >> 16) ^ key;
> 
> @key is gonna go through hash function anyway.  Do we still need the
> above (key >> 16) ^ key?  It's not gonna help anything.
> 

Nothing's changed after this patch, so the key will still be passed to
hash_long().

I tested this hash function long ago, and the original version was
without (key >> 16) ^ key, and it produced worse hash collision.

>> -	index = hash_long(tmp, CSS_SET_HASH_BITS);
>> -
>> -	return &css_set_table[index];
>> +	return key;
>>  }
>>  
>>  /* We don't maintain the lists running through each css_set to its
>> @@ -4503,23 +4498,17 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
>>  	 * this is all done under the css_set_lock.
>>  	 */
>>  	write_lock(&css_set_lock);
>> -	for (i = 0; i < CSS_SET_TABLE_SIZE; i++) {
>> -		struct css_set *cg;
>> -		struct hlist_node *node, *tmp;
>> -		struct hlist_head *bucket = &css_set_table[i], *new_bucket;
>> -
>> -		hlist_for_each_entry_safe(cg, node, tmp, bucket, hlist) {
>> -			/* skip entries that we already rehashed */
>> -			if (cg->subsys[ss->subsys_id])
>> -				continue;
>> -			/* remove existing entry */
>> -			hlist_del(&cg->hlist);
>> -			/* set new value */
>> -			cg->subsys[ss->subsys_id] = css;
>> -			/* recompute hash and restore entry */
>> -			new_bucket = css_set_hash(cg->subsys);
>> -			hlist_add_head(&cg->hlist, new_bucket);
>> -		}
>> +	hash_for_each_safe(css_set_table, i, node, tmp, cg, hlist) {
>> +		/* skip entries that we already rehashed */
>> +		if (cg->subsys[ss->subsys_id])
>> +			continue;
>> +		/* remove existing entry */
>> +		hlist_del(&cg->hlist);
> 
> 		hash_del()?
> 

will fix.
