From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: Fix incorrect warning from
 cgroup_apply_control_disable()
Date: Mon, 13 Sep 2021 14:35:03 -0400
Message-ID: <125c4202-68d1-1a4e-03d6-2b18f0794ba4@redhat.com>
References: <20210910024256.7615-1-longman@redhat.com>
 <YT+TA6ItnF9xM3cR@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631558107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5isvOFNgXlqIatGmtfTkUEKNgVy1/GCmO2C5vtiGe3M=;
        b=Q+ko2pgeWQHh2iiOUPgfH+DXQia+fIJvRzuTgMBQTO3oGX/8zjL1K2U6aKTm3YI0JQjUbG
        2WqG8QwCRKRVQi8TSph+vvAZdDw3K3+CjGJdxjOdfjXffcIU/VjW2z47yMvYELgA8VwsfQ
        Pxded/YSPX+xNV7uTbd3FrPv1BpefKo=
In-Reply-To: <YT+TA6ItnF9xM3cR-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 9/13/21 2:05 PM, Tejun Heo wrote:
> Hello,
>
> On Thu, Sep 09, 2021 at 10:42:55PM -0400, Waiman Long wrote:
>> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
>> index 881ce1470beb..e31bca9fcd46 100644
>> --- a/kernel/cgroup/cgroup.c
>> +++ b/kernel/cgroup/cgroup.c
>> @@ -3140,7 +3140,16 @@ static void cgroup_apply_control_disable(struct cgroup *cgrp)
>>   			if (!css)
>>   				continue;
>>   
>> -			WARN_ON_ONCE(percpu_ref_is_dying(&css->refcnt));
>> +			/*
>> +			 * A kill_css() might have been called previously, but
>> +			 * the css may still linger for a while before being
>> +			 * removed. Skip it in this case.
>> +			 */
>> +			if (percpu_ref_is_dying(&css->refcnt)) {
>> +				WARN_ON_ONCE(css->parent &&
>> +					cgroup_ss_mask(dsct) & (1 << ss->id));
>> +				continue;
>> +			}
> This warning did help me catch some gnarly bugs. Any chance we can keep it
> for normal cases and elide it just for remounting?

The problem with percpu_ref_is_dying() is the fact that it becomes true 
after percpu_ref_exit() is called in css_free_rwork_fn() which has an 
RCU delay. If you want to catch the fact that kill_css() has been 
called, we can check the CSS_DYING flag which is set in kill_css() by 
commit 33c35aa481786 ("cgroup: Prevent kill_css() from being called more 
than once"). Will that be an acceptable alternative?

Cheers,
Longman

