From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: protect the memory in cgroup from being
 oom killed
Date: Wed, 30 Nov 2022 17:27:54 +0100
Message-ID: <Y4eEiqwMMkHv9ELM@dhcp22.suse.cz>
References: <CAAWJmAYPUK+1GBS0R460pDvDKrLr9zs_X2LT2yQTP_85kND5Ew@mail.gmail.com>
 <7EF16CB9-C34A-410B-BEBE-0303C1BB7BA0@didiglobal.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1669825675; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nXfNG6Sww8fGURySTb8eVABizwa45hjeSXnodgsxL7A=;
        b=K5AhfMD1mmeSLfJHmy5N+Z9Fp6PpPk7Tg6j3Gg7JBI1HUIpk9Q1kujuQk6AXGNNyV145KQ
        d9PwmobJ2stCSZPjUM0avskb5R4vue2G5ijhEc6FYiczmjflCS0mD9rGkb6uCxCJrsuy3j
        g3oV+3D2ydZVm0DCiTt0qtKaJSdI6oU=
Content-Disposition: inline
In-Reply-To: <7EF16CB9-C34A-410B-BEBE-0303C1BB7BA0-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?utf-8?B?56iL5Z6y5rab?= Chengkaitao Cheng <chengkaitao-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>
Cc: Tao pilgrim <pilgrimtao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "corbet-T1hC0tSOHrs@public.gmane.org" <corbet-T1hC0tSOHrs@public.gmane.org>, "roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org" <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "ran.xiaokai-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org" <ran.xiaokai-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "zhengqi.arch-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <zhengqi.arch-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Liam.Howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <Liam.Howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "chengzhihao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <chengzhihao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Wed 30-11-22 15:46:19, 程垲涛 Chengkaitao Cheng wrote:
> On 2022-11-30 21:15:06, "Michal Hocko" <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > On Wed 30-11-22 15:01:58, chengkaitao wrote:
> > > From: chengkaitao <pilgrimtao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > >
> > > We created a new interface <memory.oom.protect> for memory, If there is
> > > the OOM killer under parent memory cgroup, and the memory usage of a
> > > child cgroup is within its effective oom.protect boundary, the cgroup's
> > > tasks won't be OOM killed unless there is no unprotected tasks in other
> > > children cgroups. It draws on the logic of <memory.min/low> in the
> > > inheritance relationship.
> >
> > Could you be more specific about usecases?

This is a very important question to answer.

> > How do you tune oom.protect
> > wrt to other tunables? How does this interact with the oom_score_adj
> > tunining (e.g. a first hand oom victim with the score_adj 1000 sitting
> > in a oom protected memcg)?
> 
> We prefer users to use score_adj and oom.protect independently. Score_adj is 
> a parameter applicable to host, and oom.protect is a parameter applicable to cgroup. 
> When the physical machine's memory size is particularly large, the score_adj 
> granularity is also very large. However, oom.protect can achieve more fine-grained 
> adjustment.

Let me clarify a bit. I am not trying to defend oom_score_adj. It has
it's well known limitations and it is is essentially unusable for many
situations other than - hide or auto-select potential oom victim.

> When the score_adj of the processes are the same, I list the following cases 
> for explanation,
> 
>           root
>            |
>         cgroup A
>        /        \
>  cgroup B      cgroup C
> (task m,n)     (task x,y)
> 
> score_adj(all task) = 0;
> oom.protect(cgroup A) = 0;
> oom.protect(cgroup B) = 0;
> oom.protect(cgroup C) = 3G;

How can you enforce protection at C level without any protection at A
level? This would easily allow arbitrary cgroup to hide from the oom
killer and spill over to other cgroups.

> usage(task m) = 1G
> usage(task n) = 2G
> usage(task x) = 1G
> usage(task y) = 2G
> 
> oom killer order of cgroup A: n > m > y > x
> oom killer order of host:     y = n > x = m
> 
> If cgroup A is a directory maintained by users, users can use oom.protect 
> to protect relatively important tasks x and y.
> 
> However, when score_adj and oom.protect are used at the same time, we 
> will also consider the impact of both, as expressed in the following formula. 
> but I have to admit that it is an unstable result.
> score = task_usage + score_adj * totalpage - eoom.protect * task_usage / local_memcg_usage

I hope I am not misreading but this has some rather unexpected
properties. First off, bigger memory consumers in a protected memcg are
protected more. Also I would expect the protection discount would
be capped by the actual usage otherwise excessive protection
configuration could skew the results considerably.
 
> > I haven't really read through the whole patch but this struck me odd.
> 
> > > @@ -552,8 +552,19 @@ static int proc_oom_score(struct seq_file *m, struct pid_namespace *ns,
> > > 	unsigned long totalpages = totalram_pages() + total_swap_pages;
> > > 	unsigned long points = 0;
> > > 	long badness;
> > > +#ifdef CONFIG_MEMCG
> > > +	struct mem_cgroup *memcg;
> > > 
> > > -	badness = oom_badness(task, totalpages);
> > > +	rcu_read_lock();
> > > +	memcg = mem_cgroup_from_task(task);
> > > +	if (memcg && !css_tryget(&memcg->css))
> > > +		memcg = NULL;
> > > +	rcu_read_unlock();
> > > +
> > > +	update_parent_oom_protection(root_mem_cgroup, memcg);
> > > +	css_put(&memcg->css);
> > > +#endif
> > > +	badness = oom_badness(task, totalpages, MEMCG_OOM_PROTECT);
> >
> > the badness means different thing depending on which memcg hierarchy
> > subtree you look at. Scaling based on the global oom could get really
> > misleading.
> 
> I also took it into consideration. I planned to change "/proc/pid/oom_score" 
> to a writable node. When writing to different cgroup paths, different values 
> will be output. The default output is root cgroup. Do you think this idea is 
> feasible?

I do not follow. Care to elaborate?
-- 
Michal Hocko
SUSE Labs
