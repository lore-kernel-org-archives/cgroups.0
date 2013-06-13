From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 5/9] memcg: use css_get/put when charging/uncharging
 kmem
Date: Thu, 13 Jun 2013 12:53:00 -0700
Message-ID: <20130613195300.GE13970@mtj.dyndns.org>
References: <51B98D17.2050902@huawei.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=xMwjNCoby2P8P1Mfp6z5P6G5IReszuoVvK3p8Xkbh1c=;
        b=tHRO7jvoVlKtzAeJDCpdqOSpT3Ea/yh/SAqxY3ZCjBiWKfIP1/BD2R1jRY04Ad7eDz
         vspVyZx5H19ORje00TQLzIiM76ZyfbVOL71RjUAIjm21WfgecutJkFuVBVoT2hkOfv/B
         kjdxghnognfQr3UKr01vvbP3QZZW5MbvrVd9/MCP6XB4Ir/gQIMZW+G/dcbqUhmLSoGB
         yJq46hnxZLjfFNOoMrF7GBE1TxUNFCQs5JgTUfwjyVG+Z86hUbFhnnPlYE9BBTFRyQZS
         uljSjfXPJA14T3GmhVj7pFoW3cstENKMlb/smgPTCeM+1b4tqTdpnEW9gp/5rBUUbzHv
         dYMw==
Content-Disposition: inline
In-Reply-To: <51B98D17.2050902@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: Michal Hocko <mhocko@suse.cz>, Glauber Costa <glommer@parallels.com>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

On Thu, Jun 13, 2013 at 05:12:55PM +0800, Li Zefan wrote:
> Sorry for updating the patchset so late.
> 
> I've made some changes for the memory barrier thing, and I agree with
> Michal that there can be improvement but can be a separate patch.
> 
> If this version is ok for everyone, I'll send the whole patchset out
> to Andrew.

Can you please post an updated patch as reply to the original patch?
It's a bit difficult to follow things.

> =========================
> 
> Use css_get/put instead of mem_cgroup_get/put.
> 
> We can't do a simple replacement, because here mem_cgroup_put()
> is called during mem_cgroup_css_free(), while mem_cgroup_css_free()
> won't be called until css refcnt goes down to 0.
> 
> Instead we increment css refcnt in mem_cgroup_css_offline(), and
> then check if there's still kmem charges. If not, css refcnt will
> be decremented immediately, otherwise the refcnt won't be decremented
> when kmem charges goes down to 0.
> 
> v3:
> - changed wmb() to smp_smb(), and moved it to memcg_kmem_mark_dead(),
>   and added comment.
> 
> v2:
> - added wmb() in kmem_cgroup_css_offline(), pointed out by Michal
> - revised comments as suggested by Michal
> - fixed to check if kmem is activated in kmem_cgroup_css_offline()
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> Acked-by: Michal Hocko <mhocko@suse.cz>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Reviewed-by: Tejun Heo <tj@kernel.org>

But let's please remove the barrier dancing.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
