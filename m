From: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] mm/cgroup: delay soft limit data allocation
Date: Thu, 23 Feb 2017 10:15:03 +0100
Message-ID: <d301eb31-9c95-60c2-3d41-fc2fcb53f2eb@linux.vnet.ibm.com>
References: <1487779091-31381-1-git-send-email-ldufour@linux.vnet.ibm.com>
 <1487779091-31381-3-git-send-email-ldufour@linux.vnet.ibm.com>
 <20170223011644.GB8841@balbir.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170223011644.GB8841@balbir.ozlabs.ibm.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Balbir Singh <bsingharora@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On 23/02/2017 02:16, Balbir Singh wrote:
> On Wed, Feb 22, 2017 at 04:58:11PM +0100, Laurent Dufour wrote:
>> Until a soft limit is set to a cgroup, the soft limit data are useless
>> so delay this allocation when a limit is set.
>>
>> Suggested-by: Michal Hocko <mhocko@kernel.org>
>> Signed-off-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
>> ---
> <snip>
>> @@ -3000,6 +3035,8 @@ static ssize_t mem_cgroup_write(struct kernfs_open_file *of,
>>  		}
>>  		break;
>>  	case RES_SOFT_LIMIT:
>> +		if (!soft_limit_initialized)
>> +			soft_limit_initialize();
> 
> What happens if this fails? Do we disable this interface?
> It's a good idea, but I wonder if we can deal with certain
> memory cgroups not supporting soft limits due to memory
> shortage at the time of using them.

Thanks Balbir for the review.

Regarding this point, Michal sent a new proposal which will return
-ENOMEM in the case the initialization failed. I'll send a new series in
that way.

> 
>>  		memcg->soft_limit = nr_pages;
>>  		ret = 0;
>>  		break;
> 
> Balbir Singh.
> 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
