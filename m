From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: Re: [RFC PATCH v2 1/8] mm, memcontrol.c: make memcg lru stats
 thread-safe without lru_lock
Date: Wed, 12 Sep 2018 09:28:58 -0400
Message-ID: <a81f27b1-00c0-53ac-4d0b-241effdca9a6@oracle.com>
References: <20180911004240.4758-1-daniel.m.jordan@oracle.com>
 <20180911004240.4758-2-daniel.m.jordan@oracle.com>
 <e62ef1a0-9518-5a16-df5b-86977b4e8881@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=NMVqQB9SiIeRZTH2H/BUYZ35VOohkeIZGngJMh06Exc=;
 b=vih8bRpWLpgDKKX1qtMNYHMoMNlZZUJ6i+bE0+XCYhGttTyOqyV2Hf8tk1NcgrTtz84f
 zRaSoKLVUgHVj3+NUBBeUjYSN4AXQb6U6LlyhUssLHX/moRSb+z8K1TLBrX4YQc4FyyR
 KtYTQkF2qQZzFmc0zT0gat8V8h+PnbsrDw6jZcl6/s9trgqX7EoI4i8NlrXoQrgwmY9g
 sM/xYj4s9xGZsXszDYAUkIbCGN6l6r3amd8CxKwzUIe3gq/4HUs3VYA7iYqS7JiO+Yju
 mPRXpQE3xbEF1xauoG1rrikQEpaIGvf/cfQMBonclGDt8yk6PHmet16nZrTvjZ3EDQMx 0w== 
In-Reply-To: <e62ef1a0-9518-5a16-df5b-86977b4e8881@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Laurent Dufour <ldufour@linux.vnet.ibm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: aaron.lu@intel.com, ak@linux.intel.com, akpm@linux-foundation.org, dave.dice@oracle.com, dave.hansen@linux.intel.com, hannes@cmpxchg.org, levyossi@icloud.com, mgorman@techsingularity.net, mhocko@kernel.org, Pavel.Tatashin@microsoft.com, steven.sistare@oracle.com, tim.c.chen@intel.com, vdavydov.dev@gmail.com, ying.huang@intel.com, daniel.m.jordan@oracle.com

On 9/11/18 12:32 PM, Laurent Dufour wrote:
> On 11/09/2018 02:42, Daniel Jordan wrote:
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index d99b71bc2c66..6377dc76dc41 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -99,7 +99,8 @@ struct mem_cgroup_reclaim_iter {
>>   };
>>
>>   struct lruvec_stat {
>> -	long count[NR_VM_NODE_STAT_ITEMS];
>> +	long node[NR_VM_NODE_STAT_ITEMS];
>> +	long lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
> 
> It might be better to use different name for the lru_zone_size field to
> distinguish it from the one in the mem_cgroup_per_node structure.

Yes, not very grep-friendly.  I'll change it to this:

struct lruvec_stat {
	long node_stat_cpu[NR_VM_NODE_STAT_ITEMS];
	long lru_zone_size_cpu[MAX_NR_ZONES][NR_LRU_LISTS];
};

So the fields are named like the corresponding fields in the mem_cgroup_per_node structure, plus _cpu.  And I'm certainly open to other ideas.
