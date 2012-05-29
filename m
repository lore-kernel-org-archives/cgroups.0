From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v3 16/28] memcg: kmem controller charge/uncharge infrastructure
Date: Tue, 29 May 2012 20:00:23 +0400
Message-ID: <4FC4F297.4080202@parallels.com>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-17-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205290944040.4666@router.home>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.00.1205290944040.4666@router.home>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>, Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@cs.helsinki.fi>

On 05/29/2012 06:47 PM, Christoph Lameter wrote:
> On Fri, 25 May 2012, Glauber Costa wrote:
>
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -696,7 +696,7 @@ config CGROUP_MEM_RES_CTLR_SWAP_ENABLED
>>   	  then swapaccount=0 does the trick).
>>   config CGROUP_MEM_RES_CTLR_KMEM
>>   	bool "Memory Resource Controller Kernel Memory accounting (EXPERIMENTAL)"
>> -	depends on CGROUP_MEM_RES_CTLR&&  EXPERIMENTAL
>> +	depends on CGROUP_MEM_RES_CTLR&&  EXPERIMENTAL&&  !SLOB
>>   	default n
>
> Ok so SLOB is not supported at all.
>
Yes, at least I see no reason to.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
