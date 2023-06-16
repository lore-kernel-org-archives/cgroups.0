From: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] mm/memcontrol: add check for allocation failure in
 mem_cgroup_init()
Date: Fri, 16 Jun 2023 16:47:17 +0800
Message-ID: <69cea432-f784-a734-f93e-50b0f897767c@shopee.com>
References: <20230615073226.1343-2-haifeng.xu@shopee.com>
 <ZIrLLmb+o77Wy2sY@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1686905242; x=1689497242;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=14jtraihfDQYuZKnWqtYB4vhXjv2bj/la1fKtOJoayo=;
        b=d+2AVHZsTy1E9KJtZsJvVVIyla7VzuCveJTq0FID83gOrCC7aVgr8vXcIuC65p7y+t
         HYPlVbzUYU+h2icnfnip4UwI5FywmONNI/kPFPFF9vEj5fRZqpJto8QVv7mdi7rS3MHK
         W7KuNCQkLcdtegaVBZfWp4lrUveeUdg658RxbJ34/yLhNlXG/c4U8fEcYhZo838ulhVy
         WDHZ1HXAlUmVqKGCI+DDDEw1E35RTcqsghoZOYqGHbPZgXWCsXKHUGVBCn9e1liIIzGd
         TBbUtCAJxZ1XmbK4m0E4CTseD8E3dPQoVkuN312wIj9IxC05IkX7dpdKJL2xuH6fjvRo
         VUNA==
In-Reply-To: <ZIrLLmb+o77Wy2sY-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2023/6/15 16:26, Michal Hocko wrote:
> On Thu 15-06-23 07:32:26, Haifeng Xu wrote:
>> If mem_cgroup_init() fails to allocate mem_cgroup_tree_per_node, we
>> should not try to initilaize it. Add check for this case to avoid
>> potential NULL pointer dereference.
> 
> Technically yes and it seems that all users of soft_limit_tree.rb_tree_per_node
> correctly check for NULL so this would be graceful failure handling. At
> least superficially because the feature itself would be semi-broken when
> used. But more practically this is a 24B allocation and if we fail to
> allocate that early during the boot we are screwed anyway. Would such
> a system have any chance to boot all the way to userspace? Woul any
> userspace actually work?
> 

The memory request is too small and It's unlikely to fail during early init.
If it fails, I think the system won't work.

> Is this patch motivated by a code reading or is there any actual
> practical upside of handling the error here?
>  

There is no real world problem, just from code review.

>> Signed-off-by: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
>> ---
>>  mm/memcontrol.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index c73c5fb33f65..7ebf64e48b25 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -7422,6 +7422,8 @@ static int __init mem_cgroup_init(void)
>>  		struct mem_cgroup_tree_per_node *rtpn;
>>  
>>  		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, node);
>> +		if (!rtpn)
>> +			continue;
>>  
>>  		rtpn->rb_root = RB_ROOT;
>>  		rtpn->rb_rightmost = NULL;
>> -- 
>> 2.25.1
> 
