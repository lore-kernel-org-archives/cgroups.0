From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] vmpressure: make sure memcg stays alive until all
 users are signaled
Date: Thu, 11 Jul 2013 08:44:08 -0700
Message-ID: <20130711154408.GA9229@mtj.dyndns.org>
References: <20130710184254.GA16979@mtj.dyndns.org>
 <20130711083110.GC21667@dhcp22.suse.cz>
 <51DE701C.6010800@huawei.com>
 <20130711092542.GD21667@dhcp22.suse.cz>
 <51DE7AAF.6070004@huawei.com>
 <20130711093300.GE21667@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=1MSNIh/iz+R4IGe0HntCsAGQyB+XOp2lHgjbtaMem40=;
        b=E1xpSBan5Rg0ZpDq6E69tA3sNQMmo+cWkveoJgjw2PspCr3RMMIRXY/9bB185cxb5E
         3nQgap/u8ROltK4b3pdiePWNa/PYIZmsm1n1tNNG/LGb+j3s979vQe6s8+NuoD+cIhB/
         paUsXbGlN1MGjJxXDON3XrIXeLrFGelYNqXmlF1i44hzGRUhrO/0KCvf5QIwQxLZgd20
         w6P4/k9qiQVfL5+tObgjfiaFBnFkMBrNXjJRB4m2rKHCNeiKsWwjf35gKgY6a9TEed+7
         D96O1842W3nP1c4vVxooVaZmGFj/YIjickOf3LvFt1on2qRqrfg6dE4OTjciHWQLleAH
         bC7A==
Content-Disposition: inline
In-Reply-To: <20130711093300.GE21667@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizefan@huawei.com>, Anton Vorontsov <anton.vorontsov@linaro.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Hello, Michal.

On Thu, Jul 11, 2013 at 11:33:00AM +0200, Michal Hocko wrote:
> +static inline
> +struct mem_cgroup *vmpressure_to_mem_cgroup(struct vmpressure *vmpr)
> +{
> +	return container_of(vmpr, struct mem_cgroup, vmpressure);
> +}
> +
> +void vmpressure_pin_memcg(struct vmpressure *vmpr)
> +{
> +	struct mem_cgroup *memcg = vmpressure_to_mem_cgroup(vmpr);
> +
> +	css_get(&memcg->css);
> +}
> +
> +void vmpressure_unpin_memcg(struct vmpressure *vmpr)
> +{
> +	struct mem_cgroup *memcg = vmpressure_to_mem_cgroup(vmpr);
> +
> +	css_put(&memcg->css);
> +}

So, while this *should* work, can't we just cancel/flush the work item
from offline?  There doesn't seem to be any possible deadlocks from my
shallow glance and those mutexes don't seem to be held for long (do
they actually need to be mutexes?  what blocks inside them?).

Also, while at it, can you please remove the work_pending() check?
They're almost always spurious or racy and should be avoided in
general.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
