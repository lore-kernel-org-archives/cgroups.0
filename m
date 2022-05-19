From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC] Add swappiness argument to memory.reclaim
Date: Thu, 19 May 2022 10:51:53 +0200
Message-ID: <YoYFKdqayKRw2npp@dhcp22.suse.cz>
References: <CAJD7tkbDpyoODveCsnaqBBMZEkDvshXJmNdbk51yKSNgD7aGdg@mail.gmail.com>
 <YoNHJwyjR7NJ5kG7@dhcp22.suse.cz>
 <CAJD7tkYnBjuwQDzdeo6irHY=so-E8z=Kc_kZe52anMOmRL+8yA@mail.gmail.com>
 <YoQAVeGj19YpSMDb@cmpxchg.org>
 <CAAPL-u8pZ_p+SQZnr=8UV37yiQpWRZny7g9p6YES0wa+g_kMJw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652950315; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FCjPr++xl8KWyokuomIbrLcBjRsIcgmfUkDoWFF5TfQ=;
        b=bdEsvTECKnnG+/TGmv9Jm6Uix+LiSfB64gpLouR5lZEGtMlNKGmBc+PQ+c0zUdzWgdnJei
        LV6TEuLx2lhInScjYrlGK5Z60rG2ozef/uM1tvsbAXvmYoHTY3VJjc0edx9JUzLjC9tQji
        dk3ppAYpQPph5pconNU2KexH9Q4yNys=
Content-Disposition: inline
In-Reply-To: <CAAPL-u8pZ_p+SQZnr=8UV37yiQpWRZny7g9p6YES0wa+g_kMJw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chen Wandun <chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Wed 18-05-22 22:44:13, Wei Xu wrote:
> On Tue, May 17, 2022 at 1:06 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
[...]
> > But I don't think an anon/file bias will capture this coefficient?
> 
> It essentially provides the userspace proactive reclaimer an ability
> to define its own reclaim policy by adding an argument to specify
> which type of pages to reclaim via memory.reclaim.

I am not sure the swappiness is really a proper interface for that.
Historically this tunable has changed behavior several times and the
reclaim algorithm is free to ignore it completely in many cases. If you
want to build a userspace reclaim policy, then it really has to have a
predictable and stable behavior. That would mean that the semantic would
have to be much stronger than the global vm_swappiness.
-- 
Michal Hocko
SUSE Labs
