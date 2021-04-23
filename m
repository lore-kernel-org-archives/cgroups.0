From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH v3 08/16] memcg: enable accounting of ipc resources
Date: Fri, 23 Apr 2021 15:32:01 +0300
Message-ID: <dd9b1767-55e0-6754-3ac5-7e01de12f16e@virtuozzo.com>
References: <dddf6b29-debd-dcb5-62d0-74909d610edb@virtuozzo.com>
 <4ed65beb-bda3-1c93-fadf-296b760a32b2@virtuozzo.com>
 <YIK6ttdnfjOo6XCN@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=R3m4pVHRhL2mIR6ypt7iJreGEiDdyMSHemfDUd6NDlY=; b=bQBiHSB5vbUYH32wz
        AAYVsQNDtTNMObyz5GPJvdkA4EtY+HYz9EELeX9OUTA7rb4wf1g+akbOoVZkt9u9fudbEHLItwUWz
        3kjDnlpYG6oKryqW9QKrBYUWup4kX70eoF6LfdcF7EHFvQyBaKKwEWGh7y6K/iFnXXAXKpTmZ8QfU
        =;
In-Reply-To: <YIK6ttdnfjOo6XCN-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dmitry Safonov <0x7f454c46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 4/23/21 3:16 PM, Alexey Dobriyan wrote:
> On Thu, Apr 22, 2021 at 01:37:02PM +0300, Vasily Averin wrote:
>> When user creates IPC objects it forces kernel to allocate memory for
>> these long-living objects.
>>
>> It makes sense to account them to restrict the host's memory consumption
>> from inside the memcg-limited container.
>>
>> This patch enables accounting for IPC shared memory segments, messages
>> semaphores and semaphore's undo lists.
> 
>> --- a/ipc/msg.c
>> +++ b/ipc/msg.c
>> @@ -147,7 +147,7 @@ static int newque(struct ipc_namespace *ns, struct ipc_params *params)
>>  	key_t key = params->key;
>>  	int msgflg = params->flg;
>>  
>> -	msq = kvmalloc(sizeof(*msq), GFP_KERNEL);
>> +	msq = kvmalloc(sizeof(*msq), GFP_KERNEL_ACCOUNT);
> 
> Why this requires vmalloc? struct msg_queue is not big at all.
> 
>> --- a/ipc/shm.c
>> +++ b/ipc/shm.c
>> @@ -619,7 +619,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
>>  			ns->shm_tot + numpages > ns->shm_ctlall)
>>  		return -ENOSPC;
>>  
>> -	shp = kvmalloc(sizeof(*shp), GFP_KERNEL);
>> +	shp = kvmalloc(sizeof(*shp), GFP_KERNEL_ACCOUNT);
> 
> Same question.
> Kmem caches can be GFP_ACCOUNT by default.

It is side effect: previously all these objects was allocated via ipc_alloc/ipc_alloc_rcu
function called kvmalloc inside.

Should I replace it to kmalloc right in this patch?

Thank you,
	Vasily Averin

