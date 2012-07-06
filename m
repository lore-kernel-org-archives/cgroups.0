From: Wanpeng Li <liwp.linux@gmail.com>
Subject: Re: [PATCH] mm/memcg: swappiness should between 0 and 100
Date: Fri, 6 Jul 2012 13:24:21 +0800
Message-ID: <20120706052421.GC5929@kernel>
References: <1341550312-6815-1-git-send-email-liwp.linux@gmail.com>
 <20120706051642.GA29829@shangw>
Reply-To: Wanpeng Li <liwp.linux@gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=l8ZLl+jhGTj42QmInHAcxiMqQrrZjK17PjkjiFNJAUo=;
        b=tA0Cz6SHu8sMNtyfbA+PS5TiYcGBTnfr1JVWv/sKwB04bmaA0lWzNjnsSx/SZ2RhIv
         n9DEYJ5FsPbUaIkCVsi8q6OHQMvl+CjWYvDG5PHJuF3/D24gpAjK3UOOdXRfHEtUDOVx
         3ZYvSAIY7lmNGNSczDJ890ShN/iYvD2ogrjSOyiqNSfjYVy6J7tvZKAmEW2+UGFVsfTY
         79RHrhj1qkFu5TEMUWjx/7nPy/3ZdVYDasuEmWkn7D+H5semFD5sEIJAUqLR8Ihasu4d
         rOhI9Wtj5AFUnFEmJTegOgOl85NEW34MlK4/U+a+Xj0SsbUnEsJSriM/BUY3NmH5CNwG
         3AOA==
Content-Disposition: inline
In-Reply-To: <20120706051642.GA29829@shangw>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 01:16:43PM +0800, Gavin Shan wrote:
>On Fri, Jul 06, 2012 at 12:51:52PM +0800, Wanpeng Li wrote:
>>From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>>
>>Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
>>---
>> mm/memcontrol.c |    2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>
>>diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>index 5e4d1ab..69a7d45 100644
>>--- a/mm/memcontrol.c
>>+++ b/mm/memcontrol.c
>>@@ -4176,7 +4176,7 @@ static int mem_cgroup_swappiness_write(struct cgroup *cgrp, struct cftype *cft,
>> 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
>> 	struct mem_cgroup *parent;
>>
>>-	if (val > 100)
>>+	if (val > 100 || val < 0)
>
>Wanpeng, the "val" was defined as "u64". So how it could be less than 0?
>
>static int mem_cgroup_swappiness_write(struct cgroup *cgrp, struct cftype *cft,
>                                       u64 val)
>
Oh, thank you! Just ignore this patch.

Regards,
Wanpeng Li 

>Thanks,
>Gavin
>
>> 		return -EINVAL;
>>
>> 	if (cgrp->parent == NULL)
>>-- 
>>1.7.5.4
>>
>>--
>>To unsubscribe, send a message with 'unsubscribe linux-mm' in
>>the body to majordomo@kvack.org.  For more info on Linux MM,
>>see: http://www.linux-mm.org/ .
>>Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
