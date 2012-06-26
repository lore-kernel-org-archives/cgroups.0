From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 11/11] protect architectures where THREAD_SIZE >= PAGE_SIZE
 against fork bombs
Date: Tue, 26 Jun 2012 11:23:04 +0400
Message-ID: <4FE96358.6080601@parallels.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-12-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1206252157000.30072@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1206252157000.30072-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 06/26/2012 08:57 AM, David Rientjes wrote:
> On Mon, 25 Jun 2012, Glauber Costa wrote:
>
>> diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
>> index ccc1899..914ec07 100644
>> --- a/include/linux/thread_info.h
>> +++ b/include/linux/thread_info.h
>> @@ -61,6 +61,12 @@ extern long do_no_restart_syscall(struct restart_block *parm);
>>   # define THREADINFO_GFP		(GFP_KERNEL | __GFP_NOTRACK)
>>   #endif
>>
>> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
>> +# define THREADINFO_GFP_ACCOUNTED (THREADINFO_GFP | __GFP_KMEMCG)
>> +#else
>> +# define THREADINFO_GFP_ACCOUNTED (THREADINFO_GFP)
>> +#endif
>> +
>
> This type of requirement is going to become nasty very quickly if nobody
> can use __GFP_KMEMCG without testing for CONFIG_CGROUP_MEM_RES_CTLR_KMEM.
> Perhaps define __GFP_KMEMCG to be 0x0 if it's not enabled, similar to how
> kmemcheck does?
>
That is what I've done in my first version of this patch. At that time, 
Christoph wanted it to be this way so we would make sure it would never 
be used with #CONFIG_CGROUP_MEM_RES_CTLR_KMEM defined. A value of zero 
will generate no errors. Undefined value will.

Now, if you ask me, I personally prefer following what kmemcheck does 
here...

