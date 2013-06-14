From: Glauber Costa <glommer@gmail.com>
Subject: Re: [PATCH v3 5/9] memcg: use css_get/put when charging/uncharging
 kmem
Date: Fri, 14 Jun 2013 14:56:13 +0400
Message-ID: <20130614105611.GA4292@localhost.localdomain>
References: <51B98D17.2050902@huawei.com>
 <20130613155319.GJ23070@dhcp22.suse.cz>
 <51BA6F34.30001@huawei.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=F9aut/mM1zHoWHlJPTd8ToyZr8tY2DfY3cWf/frFU14=;
        b=O4Jw1h2Nul1SEQqqKVvp+pCl/okQbRr6lHSWa1nEd5th/d4tD44XQ2k5lD0vzR2e/+
         AMjVA96VyXkTAlNHioccOzXSNfuJxpS1NXTuhWVmwqGuG2YN6tkgpAekhGNxoHdWLDAX
         98t0ea/0Vcf56Zodk6yaRwYBOWDNljCMlNnfHb++qRHFpiH2+kV9BBqFkyYBZ0fbN7iP
         /Nlxgt0oYdSpfg9Pvm9Uf9rjAWAJog1dJFmfBjPwViO+QuzPF4xJvRgmtEnTXaEmolxv
         LtsqDceTP3eFaHDuAnZSx5mchRY2DGZRUR32oaDl1jx1g8TnYUOS5bxvxNP5jE/KKmmf
         FIxw==
Content-Disposition: inline
In-Reply-To: <51BA6F34.30001@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: Michal Hocko <mhocko@suse.cz>, Tejun Heo <tj@kernel.org>, Glauber Costa <glommer@openvz.org>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

On Fri, Jun 14, 2013 at 09:17:40AM +0800, Li Zefan wrote:
> >>  static void memcg_kmem_mark_dead(struct mem_cgroup *memcg)
> >>  {
> >> +	/*
> >> +	 * We need to call css_get() first, because memcg_uncharge_kmem()
> >> +	 * will call css_put() if it sees the memcg is dead.
> >> +	 */
> >> +	smb_wmb();
> >>  	if (test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags))
> >>  		set_bit(KMEM_ACCOUNTED_DEAD, &memcg->kmem_account_flags);
> > 
> > I do not feel strongly about that but maybe open coding this in
> > mem_cgroup_css_offline would be even better. There is only single caller
> > and there is smaller chance somebody will use the function incorrectly
> > later on.
> > 
> > So I leave the decision on you because this doesn't matter much.
> > 
> 
> Yeah, it should go away soon. I'll post a patch after this patchset gets
> merged into -mm tree and then we can discuss there.
 
I don't care if it is open coded or not. If there is any strong preference
from anyone on this matter, feel free to change it.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
