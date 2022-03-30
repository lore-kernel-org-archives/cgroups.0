From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/3] mm/memcg: set pos to prev unconditionally
Date: Wed, 30 Mar 2022 14:22:05 +0000
Message-ID: <20220330142205.iaw6apqxkngp3bdz@master>
References: <20220225003437.12620-1-richard.weiyang@gmail.com>
 <20220225003437.12620-3-richard.weiyang@gmail.com>
 <YkNUZYrSHPjJ1XOb@cmpxchg.org>
 <20220330004750.fx4jr4bnehz4ynpf@master>
 <YkRIUbEGHVIbVRNO@cmpxchg.org>
Reply-To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4iTANxmONAKu4RDVv0y+koCJEtwISqaQFOKub5KCpYY=;
        b=ARDCeatE6ITj6RrVssEpi4soZXUTx10fHOsOPABcN7zK7iIsBrhSpbv2Mi3z4nezHM
         XGnjs2pQBWfUgxWDY1Byh5zkoIucQsUZ2Pim338F7IkFcpYpQY5cdrYy8oKnm1UGsXIl
         /R1JQXydQ6N4QMnX2+PLyOntQjkcwYNpfO/f43dmHUEAMTWp9tZzD4zmrRwFqJXFnDOa
         6mnpTxbxUh0DQN6mH1jNcIgCf67RAsDnR4Mbb99c8M/CSvWszvQ5GThgYys4Gh5ndMcd
         +4B4cLdEnUnPJtoxiYwi3yr28PPlraTvMkSygErs72lyr2tVIz+zI4tjPc1K4anGFQp8
         xeyA==
Content-Disposition: inline
In-Reply-To: <YkRIUbEGHVIbVRNO-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, Mar 30, 2022 at 08:08:49AM -0400, Johannes Weiner wrote:
>On Wed, Mar 30, 2022 at 12:47:50AM +0000, Wei Yang wrote:
>> Something like this?
>> 
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index eed9916cdce5..5d433b79ba47 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -1005,9 +1005,6 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>>  	if (!root)
>>  		root = root_mem_cgroup;
>>  
>> -	if (prev && !reclaim)
>> -		pos = prev;
>> -
>>  	rcu_read_lock();
>>  
>>  	if (reclaim) {
>> @@ -1033,6 +1030,8 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>>  			 */
>>  			(void)cmpxchg(&iter->position, pos, NULL);
>>  		}
>> +	} else if (prev) {
>> +		pos = prev;
>>  	}
>>  
>>  	if (pos)
>
>Yep!

Sure, I would prepare a v2.

BTW, do you have some comment on patch 3?

-- 
Wei Yang
Help you, Help me
