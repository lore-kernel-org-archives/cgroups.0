From: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: add a helper function to check may oom condition
Date: Tue, 10 Sep 2013 08:57:03 +0800
Message-ID: <522E6E5F.7050006@huawei.com>
References: <522D2FE5.3080606@huawei.com> <alpine.DEB.2.02.1309091317570.16291@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1309091317570.16291-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On 2013/9/10 4:22, David Rientjes wrote:
> On Mon, 9 Sep 2013, Qiang Huang wrote:
> 
>> diff --git a/include/linux/oom.h b/include/linux/oom.h
>> index da60007..d061c63 100644
>> --- a/include/linux/oom.h
>> +++ b/include/linux/oom.h
>> @@ -82,6 +82,11 @@ static inline void oom_killer_enable(void)
>>  	oom_killer_disabled = false;
>>  }
>>
>> +static inline bool may_oom(gfp_t gfp_mask)
> 
> Makes sense, but I think the name should be more specific to gfp flags to 
> make it clear what it's using to determine eligibility, maybe oom_gfp_allowed()? 
> We usually prefix oom killer functions with "oom".

Yes, oom_gfp_allowed() seems better, I'll send a second version,
thanks for you advice, David.

> 
> Nice taste.
> 
>> +{
>> +	return (gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY);
>> +}
>> +
>>  extern struct task_struct *find_lock_task_mm(struct task_struct *p);
>>
>>  /* sysctls */
> 
> 

