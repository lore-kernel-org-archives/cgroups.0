From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: Re: [RFC PATCH v2 2/8] mm: make zone_reclaim_stat updates thread-safe
Date: Wed, 12 Sep 2018 09:30:28 -0400
Message-ID: <7e0c2fe0-c867-3ea2-83a2-c3bcb35057d7@oracle.com>
References: <20180911004240.4758-1-daniel.m.jordan@oracle.com>
 <20180911004240.4758-3-daniel.m.jordan@oracle.com>
 <fe814c4f-f049-9b7f-0f4c-7238f159f144@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=wIQl5Jcc5252bXoEoaBBGvv+myxEy41bsq+Hf3UwZVQ=;
 b=nv3XL8FzNHlHBdxxvRLLEKbQxGSNyUVkSD+kwXSEqtQl2PChFLtA3z5yDNj7YgwRplS4
 ZOYmqvhwMDEMtBJvWpEA5J6avN+0ESdWO/l6CSTLMLAqKIykfNo0Gs8TRWgJJ3Wbq9it
 aKSkSVyqhsfRvAwx603FK5CM8msAS2Cdn8w+KNs73bCKlu1rkXUspYU/4wVzmiardvY+
 F5gh7gd0hUA9/BFTS9rYOHeSwU9MlCaNhuPtImHx5jSlRywwB8Y2xEHINP8DtVT500LT
 A+UO9RwppHuHN7rIM7pLN+vR2Xi1dYkIZJww/ogJwfJzC52B+U5B9kQqGjf8G/D78VZO fw== 
In-Reply-To: <fe814c4f-f049-9b7f-0f4c-7238f159f144@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Laurent Dufour <ldufour@linux.vnet.ibm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: aaron.lu@intel.com, ak@linux.intel.com, akpm@linux-foundation.org, dave.dice@oracle.com, dave.hansen@linux.intel.com, hannes@cmpxchg.org, levyossi@icloud.com, mgorman@techsingularity.net, mhocko@kernel.org, Pavel.Tatashin@microsoft.com, steven.sistare@oracle.com, tim.c.chen@intel.com, vdavydov.dev@gmail.com, ying.huang@intel.com

On 9/11/18 12:40 PM, Laurent Dufour wrote:
> On 11/09/2018 02:42, Daniel Jordan wrote:
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index 32699b2dc52a..6d4c23a3069d 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -229,6 +229,12 @@ struct zone_reclaim_stat {
>>   	 *
>>   	 * The anon LRU stats live in [0], file LRU stats in [1]
>>   	 */
>> +	atomic_long_t		recent_rotated[2];
>> +	atomic_long_t		recent_scanned[2];
> 
> It might be better to use a slightly different name for these fields to
> distinguish them from the ones in the zone_reclaim_stat_cpu structure.

Sure, these are now named recent_rotated_cpu and recent_scanned_cpu, absent better names.

Thanks for your comments.
