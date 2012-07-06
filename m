From: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: swappiness should between 0 and 100
Date: Fri, 6 Jul 2012 13:08:20 +0800
Message-ID: <20120706050820.GB5929@kernel>
References: <1341550312-6815-1-git-send-email-liwp.linux@gmail.com>
 <20120706050013.GA15372@shangw>
 <20120706050430.GA27704@shangw>
Reply-To: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=NhvpGpMo4PGTE19iW14lK+8XpJ9+w7WnV3ug4uMxV3s=;
        b=OjQkmcbqWCSSlXcyEW6ffTpPncz+p12R5+4WGgMB1h0FhKHOFQpvuyj8VGpJUQDYjr
         UeB54lPpNUMzlQWLf8csvvdXACgxOW8GKZrKxDTN3DtQJkiqVM+bDrkEskR64krW9NAi
         d2+Py31xCI2Y7g4ESNzMQGD0nbPL+uR1y05xBED3A/lvVdvk4K4MrQmHO8Y13WbcBoIo
         YzZVdVCQO9EyJx4pTHccXGQHTvzQN3F4XkmEyUA5/qFT6nfT1uYvpJk7EFMaxAowKKRR
         E+DvZNy3v/z0XSjfJ1WUSe76F61S6r+oTBAFat4RrlmZowFLVhFWR2dGC/Fdby4nIbJm
         QaEg==
Content-Disposition: inline
In-Reply-To: <20120706050430.GA27704@shangw>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gavin Shan <shangw-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jul 06, 2012 at 01:04:30PM +0800, Gavin Shan wrote:
>On Fri, Jul 06, 2012 at 01:00:13PM +0800, Gavin Shan wrote:
>>On Fri, Jul 06, 2012 at 12:51:52PM +0800, Wanpeng Li wrote:
>>>From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>>>
>>>Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>---
>>> mm/memcontrol.c |    2 +-
>>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>>diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>>index 5e4d1ab..69a7d45 100644
>>>--- a/mm/memcontrol.c
>>>+++ b/mm/memcontrol.c
>>>@@ -4176,7 +4176,7 @@ static int mem_cgroup_swappiness_write(struct cgroup *cgrp, struct cftype *cft,
>>
>>It seems that we don't have the function in mainline.
>>
>>shangw@shangw:~/sandbox/linux/mm$ grep mem_cgroup_swappiness_write -r .
>>shangw@shangw:~/sandbox/linux/mm$ 
>>
>
>Please ignore that cause my git tree has some problems and everything
>in linux/mm has been cleared :-)

No problem. :-)

Best Regards,
Wanpeng Li

>
>Thanks,
>Gavin
>
>>Thanks,
>>Gavin
>>
>>> 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
>>> 	struct mem_cgroup *parent;
>>>
>>>-	if (val > 100)
>>>+	if (val > 100 || val < 0)
>>> 		return -EINVAL;
>>>
>>> 	if (cgrp->parent == NULL)
>>>-- 
>>>1.7.5.4
>>>
>>>--
>>>To unsubscribe, send a message with 'unsubscribe linux-mm' in
>>>the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
>>>see: http://www.linux-mm.org/ .
>>>Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>
>>>
>>
>>--
>>To unsubscribe, send a message with 'unsubscribe linux-mm' in
>>the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
>>see: http://www.linux-mm.org/ .
>>Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>
>>
