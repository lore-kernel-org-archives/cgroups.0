From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v3 4/6] memcg: replace cgroup_lock with memcg specific
 memcg_lock
Date: Mon, 21 Jan 2013 18:37:31 +0100
Message-ID: <20130121173729.GA24410@dhcp22.suse.cz>
References: <1358766813-15095-1-git-send-email-glommer@parallels.com>
 <1358766813-15095-5-git-send-email-glommer@parallels.com>
 <20130121144919.GO7798@dhcp22.suse.cz>
 <50FD5AC0.9020406@parallels.com>
 <20130121152032.GP7798@dhcp22.suse.cz>
 <50FD6003.8060703@parallels.com>
 <20130121160731.GQ7798@dhcp22.suse.cz>
 <50FD68E1.2070303@parallels.com>
 <20130121163349.GR7798@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=/Ek85fBce3kd6/OfPcKUaJ6Mbc4RfzvhxcP3Y434Eh4=;
        b=nCC/xkkwhIiOxdOuEHlUDzHNJEM29Pz4xejkos+vQCZNOp8n9SJHG5LuaNV2M9mkr/
         PVPmWlkLPPNmIF6k2TT0VRMNxytIBNiGZ1Y0NmRA/puNAw1D9eybNF2rTD0GH/6IXA+Y
         +pXTGwUAkS4/5kxoH2wrW/EIYzLxNkdww8MrYbrbSmMYBkVninx7mCny/2a84MmUgMAu
         LX+DqazJKY9N9mHVGK84lO4GRBtmNbNJyx4D6SOiSSPZYgZp+afQNgxEQNDgocK8IUr4
         N0zJiGP0ysTtyE1Dl4OcFeeHS1Q69ZdX/6x+TxXqf0nnmN+euLI+F7HTjb/UFef32I/w
         fVoA==
Content-Disposition: inline
In-Reply-To: <20130121163349.GR7798-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org

On Mon 21-01-13 17:33:49, Michal Hocko wrote:
> On Mon 21-01-13 20:12:17, Glauber Costa wrote:
> > On 01/21/2013 08:07 PM, Michal Hocko wrote:
> > >> > And the reason why kmemcg holds the set_limit mutex
> > >> > is just to protect from itself, then there is no *need* to hold any
> > >> > extra lock (and we'll never be able to stop holding the creation lock,
> > >> > whatever it is). So my main point here is not memcg_mutex vs
> > >> > set_limit_mutex, but rather, memcg_mutex is needed anyway, and once it
> > >> > is taken, the set_limit_mutex *can* be held, but doesn't need to.
> > > So you can update kmem specific usage of set_limit_mutex.
> > Meaning ?
> 
> I thought you've said it is not needed and the code says that:
> - memcg_propagate_kmem is called with memcg_mutex held in css_alloc
> - memcg_update_kmem_limit takes both of them
> - kmem_cache_destroy_memcg_children _doesn't_ take both
> 
> So one obvious way to go would be changing
> kmem_cache_destroy_memcg_children to memcg_mutex and removing
> set_limit_mutex from other two paths.
> 
> This would leave set_limit_mutex lock for its original intention.

And then we could use a more suitable name: memcg_create_lock

-- 
Michal Hocko
SUSE Labs
