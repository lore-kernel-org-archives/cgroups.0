From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/7] memcg: move charges to root at rmdir()
Date: Mon, 16 Apr 2012 15:30:12 -0700
Message-ID: <20120416223012.GD12421@google.com>
References: <4F86B9BE.8000105@jp.fujitsu.com>
 <4F86BB02.2060607@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=0bGLclZh2u05b/O6CbrFpFhZovK/IQL3aH70iaG0Jgw=;
        b=nzJ66LWWlUefaEIvWLMkt4nkpspPUMPy9F2dR5lBbAjkHgmZOgmFMptO+6f6aEwwDp
         YK15BFhN9p6hC6kKVBnoVjwHcjrYakbmW4G0nmrga++rflhtC2oer5O823HrN+ofNZia
         FhWgfqQf7oBxsiUpkDtAFyYSHmabEYY+bhyxlQCamN5+hWh6Lym2Ck5twP3bhCvMdTgM
         ZuuLYNcYwQNhaBEJvMaSnhb4QNGzULiYhWNKhaD2rm01BFJ/w924VQ/AFLXz+w2vckDN
         29wqLKnGu7Ao7HSpkdVdqEwb5YnR88JhHkyjDDAa5J43DD6+twcr7buvv8XQtAywmW0t
         97kw==
Content-Disposition: inline
In-Reply-To: <4F86BB02.2060607-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello,

On Thu, Apr 12, 2012 at 08:22:42PM +0900, KAMEZAWA Hiroyuki wrote:
> As recently discussed, Tejun Heo, the cgroup maintainer, tries to
> remove ->pre_destroy() and cgroup will never return -EBUSY at rmdir().

I'm not trying to remove ->pre_destory() per-se.  I want to remove css
ref draining and ->pre_destroy() vetoing cgroup removal.  Probably
better wording would be "tries to simplify removal path such that
removal always succeeds".

> To do that, in memcg, handling case of use_hierarchy==false is a problem.
> 
> We move memcg's charges to its parent at rmdir(). If use_hierarchy==true,
> it's already accounted in the parent, no problem. If use_hierarchy==false,
> we cannot guarantee we can move all charges to the parent.
> 
> This patch changes the behavior to move all charges to root_mem_cgroup
> if use_hierarchy=false. It seems this matches semantics of use_hierarchy==false,which means parent and child has no hierarchical relationship.

Maybe better to break the above line?

Thanks.

-- 
tejun
