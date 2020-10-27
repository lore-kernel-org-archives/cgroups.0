From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 1/5] mm: memcg/slab: Fix return child memcg objcg for
 root memcg
Date: Tue, 27 Oct 2020 12:05:49 -0700
Message-ID: <20201027190549.GC827280@carbon.dhcp.thefacebook.com>
References: <20201027080256.76497-1-songmuchun@bytedance.com>
 <20201027080256.76497-2-songmuchun@bytedance.com>
 <20201027174236.GB725724@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=0yVIa6zqsaXdlZ8tq9gri3+NMQxI8VO/iI2YTFptDRE=;
 b=D8+gdzfUcnHY09aCEHUaB895h3qFd9BBqbz547f8ymmsg7QSidtNfngXpkH3d8FVV73f
 CA/ZiRIRRkmgakRdz5brW/bjaF+5NcrkT3g/yb6ZE3BAOZQFvROHG5s9WjcbAWeYWDEi
 NTnMb32/xFJB8ds4NiEtQAMJwCMaChd12Uw= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0yVIa6zqsaXdlZ8tq9gri3+NMQxI8VO/iI2YTFptDRE=;
 b=RKLe2omN7EdQLRWW+KGG18nXwq1Dk+UUfyUU/Jiq9j7yLmYiqa7EOwv0cM92mVg9PJmM23Tx2Co9Ow82/bTGhzukPacUsAcZ7grzziv1tMisXl3Cu+avZ7w/UtfhfuMVED1IT00BAu3ldhEIn16mG5FdtSxH7iBuDWLWiXLDDzk=
Content-Disposition: inline
In-Reply-To: <20201027174236.GB725724-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, areber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Oct 27, 2020 at 10:42:36AM -0700, Roman Gushchin wrote:
> On Tue, Oct 27, 2020 at 04:02:52PM +0800, Muchun Song wrote:
> > Consider the following memcg hierarchy.
> > 
> >                     root
> >                    /    \
> >                   A      B
> > 
> > If we get the objcg of memcg A failed, the get_obj_cgroup_from_current
> > can return the wrong objcg for the root memcg.
> > 
> > Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
> > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> > ---
> >  mm/memcontrol.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> Hi Muchun,
> 
> thank you for the patchset!
> 
> A generic note: it's usually not a good idea to group fixes with non-fixes
> in one patchset if fixes are planned to be backported to stable.
> 
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 1337775b04f3..fcbd79c5023e 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2945,7 +2945,7 @@ struct mem_cgroup *mem_cgroup_from_obj(void *p)
> >  
> >  __always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
> >  {
> > -	struct obj_cgroup *objcg = NULL;
> > +	struct obj_cgroup *objcg;
> >  	struct mem_cgroup *memcg;
> >  
> >  	if (memcg_kmem_bypass())
> > @@ -2964,6 +2964,9 @@ __always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
> >  	}
> >  	rcu_read_unlock();
> >  
> > +	if (memcg == root_mem_cgroup)
> > +		return NULL;
> > +
> >  	return objcg;
> >  }
> 
> I agree, it's a bug. Good catch, thanks!
> 
> I would prefer a slightly different fix though. Because we're going to change how
> the root memory cgroup is handled (an rfc version posted here:
> https://lkml.org/lkml/2020/10/21/612), it's better to not use a comparison
> with the root_mem_cgroup and handle the obj_cgroup_tryget() return code instead.
> Something like this:
> 
> @@ -2973,6 +2973,7 @@ __always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
>  		objcg = rcu_dereference(memcg->objcg);
>  		if (objcg && obj_cgroup_tryget(objcg))
>  			break;
> +		objcg = NULL;
>  	}
>  	rcu_read_unlock();
> 
> Or a more explicit:
>    if (obj_cgroup_tryget(objcg)) {
>      ...
>    } else {
>      ...
>    }
> 
> Also, please, add:
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

After a second thought, it's also a highly theoretical race. In order to have
obj_cgroup_tryget() failed we need to enter get_obj_cgroup_from_current()
racing with cgroup offlining (which is already tricky) and then have
memcg_reparent_objcgs() finish in between reading memcg->objcg and bumping
the reference counter.

So I'm not sure we need a stable@ backport, sorry for the confusion.

Thanks!
