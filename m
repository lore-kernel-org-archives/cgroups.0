From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/4] get rid of populate for memcg
Date: Tue, 20 Mar 2012 11:31:49 -0700
Message-ID: <20120320183149.GB20832@google.com>
References: <1332262256-13407-1-git-send-email-glommer@parallels.com>
 <1332262256-13407-5-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=FqZVjaLioTuYPu2FzEUQRFh51pi3gT/nGiT7lHOUdAI=;
        b=ZIbRHJaiCHu48QR8l2UqxZlo6ngikxwDDSX7OH82go4pa0u4LbfsDdfdTOymKGskkJ
         Nb6kka+E6mN1Uxx94WdgSJti1X01bPlkl1PQ+pxrzKpaxypLWp50weJrCK04xcrkCC6s
         PS4BOepSBWQ8GIV/p0rae9HdS1eTnlcGR5gIimh4t4nqu5GDn7qsc6muuR1RRyYrqKOY
         T2nXOFulTquth3MhAHMgi/2SXqInnrZoEim/77bdLdYxZLQnyW5boMR+F1LQZwfoGZmg
         n3NKOJruXEIIvNOIBoBdVeAaUFT4hFSFwDXHVgC628JcXMs7Ep2615s9J4AXvsB4bNVB
         HQVA==
Content-Disposition: inline
In-Reply-To: <1332262256-13407-5-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

Hello, Glauber.

On Tue, Mar 20, 2012 at 08:50:56PM +0400, Glauber Costa wrote:
> @@ -4929,7 +4929,9 @@ mem_cgroup_create(struct cgroup *cont)
>  	atomic_set(&memcg->refcnt, 1);
>  	memcg->move_charge_at_immigrate = 0;
>  	mutex_init(&memcg->thresholds_lock);
> -	return &memcg->css;
> +
> +	if (!register_kmem_files(memcg, &mem_cgroup_subsys))
> +		return &memcg->css;

After the change, I think register_kmem_files() is a quite misleading
name.

> @@ -2484,6 +2484,11 @@ int proto_register(struct proto *prot, int alloc_slab)
>  		}
>  	}
>  
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
> +	if (prot->init_cgroup)
> +		prot->init_cgroup(NULL, NULL);
> +#endif

So, init_cgroup() is overloaded to do two things - one load time init
and per-cgroup init, depending on the args.

> @@ -37,7 +37,6 @@ static struct cftype tcp_files[] = {
>  	},
>  	{ }	/* terminate */
>  };
> -CGROUP_SUBSYS_CFTYPES(mem_cgroup_subsys, tcp_files);

What I don't get is why you can't just keep this.  Is it because the
files might appear before the protocol is registered?  Wouldn't it be
much better to add ipv4_tcp_init_cgroup() or whatever call to
inet_init() instead of overloading init_cgroup() with mostly unrelated
stuff?

Thanks.

-- 
tejun
