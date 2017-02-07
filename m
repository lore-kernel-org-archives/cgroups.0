From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] slub: make sysfs directories for memcg sub-caches
 optional
Date: Tue, 7 Feb 2017 12:10:06 -0500
Message-ID: <20170207171006.GB6164@htj.duckdns.org>
References: <20170204145203.GB26958@mtj.duckdns.org>
 <20170206162213.30f909b5ce4c681e2217fb4f@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RfrNCjkVTdyda8uuHQVwrrKiD534+WB0g6RDrBMO+8Q=;
        b=Lfuig8Oz5bFadL+ARHlRRpYXlNP4fPRShYZxGci0TTBTerzmL1jqckz9AwK2ocbpOm
         dkaAP21WgP+vhfUhhSHksog02Eo3peUi4ObNJv9irPLoSXhYVo0XOs8TG7100iIeJjtS
         L+8lj8pAy3L0n9TxcGDbVAfh/NcKgtyyvg3AG10Kf+7/pO2AV4J9ObUaGFPtSh3ayXE0
         R9QunR25mKsmgVr7ZSENHWRDuBF0ypwsDMPoCIjJTbLXZl1V+JjZ5oK2h13yte9lChAk
         9GfTeGYjnhRmnv538YO47B8KwzD1PQy4Tz1BfiqZjNtX9FduonZ/g13yyqNLzxeX22SQ
         s6vw==
Content-Disposition: inline
In-Reply-To: <20170206162213.30f909b5ce4c681e2217fb4f-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org

Hello, Andrew.

On Mon, Feb 06, 2017 at 04:22:13PM -0800, Andrew Morton wrote:
> >  #ifdef CONFIG_MEMCG
> > -	if (is_root_cache(s)) {
> > +	if (is_root_cache(s) && memcg_sysfs_enabled) {
> 
> This could be turned on and off after bootup but I guess the result
> could be pretty confusing.
> 
> However there would be useful use cases?  The user would normally have
> this disabled but if he wants to do a bit of debugging then turn this
> on, create a memcg, have a poke around then turn the feature off again.

Hmm... maybe.  It's somewhat nasty to do after-the-fact.  You would
have to re-walk all the caches to create and destroy the sysfs
entries.  Given that it's a pretty fringe debug feature, I'm not sure
the added complexity would be justified.

> >  		s->memcg_kset = kset_create_and_add("cgroup", NULL, &s->kobj);
> >  		if (!s->memcg_kset) {
> >  			err = -ENOMEM;
> > @@ -5673,7 +5695,8 @@ static void sysfs_slab_remove(struct kme
> >  		return;
> >  
> >  #ifdef CONFIG_MEMCG
> > -	kset_unregister(s->memcg_kset);
> > +	if (s->memcg_kset)
> > +		kset_unregister(s->memcg_kset);
> 
> kset_unregister(NULL) is legal
> 
> --- a/mm/slub.c~slub-make-sysfs-directories-for-memcg-sub-caches-optional-fix
> +++ a/mm/slub.c
> @@ -5699,8 +5699,7 @@ static void sysfs_slab_remove(struct kme
>  		return;
>  
>  #ifdef CONFIG_MEMCG
> -	if (s->memcg_kset)
> -		kset_unregister(s->memcg_kset);
> +	kset_unregister(s->memcg_kset);
>  #endif
>  	kobject_uevent(&s->kobj, KOBJ_REMOVE);
>  	kobject_del(&s->kobj);

Ah, of course, looks good to me.

Thanks.

-- 
tejun
