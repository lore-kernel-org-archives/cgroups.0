From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] memcg: make it work on sparse non-0-node systems
Date: Mon, 29 Apr 2019 13:55:26 +0200
Message-ID: <465a4b50-490c-7978-ecb8-d122b655f868@suse.cz>
References: <359d98e6-044a-7686-8522-bdd2489e9456@suse.cz>
 <20190429105939.11962-1-jslaby@suse.cz>
 <20190429112916.GI21837@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190429112916.GI21837@dhcp22.suse.cz>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

On 29. 04. 19, 13:30, Michal Hocko wrote:
> On Mon 29-04-19 12:59:39, Jiri Slaby wrote:
> [...]
>>  static inline bool list_lru_memcg_aware(struct list_lru *lru)
>>  {
>> -	/*
>> -	 * This needs node 0 to be always present, even
>> -	 * in the systems supporting sparse numa ids.
>> -	 */
>> -	return !!lru->node[0].memcg_lrus;
>> +	return !!lru->node[first_online_node].memcg_lrus;
>>  }
>>  
>>  static inline struct list_lru_one *
> 
> How come this doesn't blow up later - e.g. in memcg_destroy_list_lru
> path which does iterate over all existing nodes thus including the
> node 0.

If the node is not disabled (i.e. is N_POSSIBLE), lru->node is allocated
for that node too. It will also have memcg_lrus properly set.

If it is disabled, it will never be iterated.

Well, I could have used first_node. But I am not sure, if the first
POSSIBLE node is also ONLINE during boot?

thanks,
-- 
js
suse labs
