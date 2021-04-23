From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH v3 16/16] memcg: enable accounting for ldt_struct objects
Date: Fri, 23 Apr 2021 06:13:30 +0300
Message-ID: <29fe6b29-d56a-6ea1-2fe7-2b015f6b74ef@virtuozzo.com>
References: <dddf6b29-debd-dcb5-62d0-74909d610edb@virtuozzo.com>
 <94dd36cb-3abb-53fc-0f23-26c02094ddf4@virtuozzo.com>
 <20210422122615.GA7021@zn.tnic>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=0NvUuvrWo3QAz8EIqcQBZaREE776KfZc12xPpNwjQWw=; b=g1poiREG0JAGILOf7
        +I7E+w+lXdutXm4LvYN63DqRAH5nnBD/yBz74tbY2XMuXHlgWZ6Y7U/YJ+YkhBMuoAtVjOFdpNECS
        zO0nzNi7numBF0yFvG6ATil3JZCklXb6HcgcDpZ2CXeiFvvOQUjNJQqgKzPprMVfIVCCWw4emAZxc
        =;
In-Reply-To: <20210422122615.GA7021-Jj63ApZU6fQ@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 4/22/21 3:26 PM, Borislav Petkov wrote:
> On Thu, Apr 22, 2021 at 01:38:01PM +0300, Vasily Averin wrote:
> 
> You have forgotten to Cc LKML on your submission.
I think it's OK, patch set is addressed to cgroups subsystem amiling list.
Am I missed something and such patches should be sent to LKML anyway?

>> @@ -168,9 +168,10 @@ static struct ldt_struct *alloc_ldt_struct(unsigned int num_entries)
>>  	 * than PAGE_SIZE.
>>  	 */
>>  	if (alloc_size > PAGE_SIZE)
>> -		new_ldt->entries = vzalloc(alloc_size);
>> +		new_ldt->entries = __vmalloc(alloc_size,
>> +					     GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> 
> You don't have to break that line - just let it stick out.
Hmm. I missed that allowed line limit was increased up to 100 bytes,
Thank you, I will fix it in next patch version. 
