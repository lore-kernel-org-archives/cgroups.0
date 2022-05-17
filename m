From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC] Add swappiness argument to memory.reclaim
Date: Tue, 17 May 2022 08:56:39 +0200
Message-ID: <YoNHJwyjR7NJ5kG7@dhcp22.suse.cz>
References: <CAJD7tkbDpyoODveCsnaqBBMZEkDvshXJmNdbk51yKSNgD7aGdg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652770600; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YyW7EIH3WdepBr8smb4cheN1ADPHu7QpG6rwte21Qjg=;
        b=m/oYQcAlGSR8cd3cSSa95oAkOufK1I7s2sxcoa6y+R7OGFiMvaPHPclIN1g+nPqyCbKcql
        TYd9OdyuYfZEt21pg+XTSz4TwLd3Q9t9OUyyosOVF2J3jW6SAJwKL137fL8ZS5nyxUByqe
        911RSUPqMjG4vbAJlroiO9ipgHFvUiU=
Content-Disposition: inline
In-Reply-To: <CAJD7tkbDpyoODveCsnaqBBMZEkDvshXJmNdbk51yKSNgD7aGdg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chen Wandun <chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Mon 16-05-22 15:29:42, Yosry Ahmed wrote:
> The discussions on the patch series [1] to add memory.reclaim has
> shown that it is desirable to add an argument to control the type of
> memory being reclaimed by invoked proactive reclaim using
> memory.reclaim.
> 
> I am proposing adding a swappiness optional argument to the interface.
> If set, it overwrites vm.swappiness and per-memcg swappiness. This
> provides a way to enforce user policy on a stateless per-reclaim
> basis. We can make policy decisions to perform reclaim differently for
> tasks of different app classes based on their individual QoS needs. It
> also helps for use cases when particularly page cache is high and we
> want to mainly hit that without swapping out.

Can you be more specific about the usecase please? Also how do you
define the semantic? Behavior like vm_swappiness is rather vague because
the kernel is free to ignore (and it does indeed) this knob in many
situations. What is the expected behavior when user explicitly requests
a certain swappiness?
-- 
Michal Hocko
SUSE Labs
