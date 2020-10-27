From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 1/5] mm: memcg/slab: Fix return child memcg objcg for
 root memcg
Date: Tue, 27 Oct 2020 10:42:36 -0700
Message-ID: <20201027174236.GB725724@carbon.dhcp.thefacebook.com>
References: <20201027080256.76497-1-songmuchun@bytedance.com>
 <20201027080256.76497-2-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=HKF61jpSHkELrGyeUZ9KBZQCL+Wm+QFL2+V/mDIllu8=;
 b=VxGGc7C9Lx9fEkCDg9Q/5lSOHDj5noPu0z4WI0KizQ0OOl9j03sm+4R6lyfqjxcKU+CO
 wLVo0qqcmrEWhZv3eeCgWsWOmv17rMAza1kJOzf4LijX778fpmrdxSNBtF971j2UzIIi
 pMsqDrkAOCHYyMi2bLEo4qCYAZHSOTirp80= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HKF61jpSHkELrGyeUZ9KBZQCL+Wm+QFL2+V/mDIllu8=;
 b=Ce5ijDAj/UD3WkJSCDSdZ60kGJJ7B7wpiqrTSIeUErSZpxhZd4kGut9YKCwhhqDSkDwmZGUDXA68+Mb8vAzs1O2mHdf2OvGjB5SnJl3aJyu2dyYvFVIVyYY7wVCcEyF6UfRG8BqU20F+jAmo3+WHTopvfRmDI6SlHCPMbZawsls=
Content-Disposition: inline
In-Reply-To: <20201027080256.76497-2-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, laoar.shao@gmail.com, chris@chrisdown.name, christian.brauner@ubuntu.com, peterz@infradead.org, mingo@kernel.org, keescook@chromium.org, tglx@linutronix.de, esyr@redhat.com, surenb@google.com, areber@redhat.com, elver@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Tue, Oct 27, 2020 at 04:02:52PM +0800, Muchun Song wrote:
> Consider the following memcg hierarchy.
> 
>                     root
>                    /    \
>                   A      B
> 
> If we get the objcg of memcg A failed, the get_obj_cgroup_from_current
> can return the wrong objcg for the root memcg.
> 
> Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  mm/memcontrol.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Hi Muchun,

thank you for the patchset!

A generic note: it's usually not a good idea to group fixes with non-fixes
in one patchset if fixes are planned to be backported to stable.

> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1337775b04f3..fcbd79c5023e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2945,7 +2945,7 @@ struct mem_cgroup *mem_cgroup_from_obj(void *p)
>  
>  __always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
>  {
> -	struct obj_cgroup *objcg = NULL;
> +	struct obj_cgroup *objcg;
>  	struct mem_cgroup *memcg;
>  
>  	if (memcg_kmem_bypass())
> @@ -2964,6 +2964,9 @@ __always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
>  	}
>  	rcu_read_unlock();
>  
> +	if (memcg == root_mem_cgroup)
> +		return NULL;
> +
>  	return objcg;
>  }

I agree, it's a bug. Good catch, thanks!

I would prefer a slightly different fix though. Because we're going to change how
the root memory cgroup is handled (an rfc version posted here:
https://lkml.org/lkml/2020/10/21/612), it's better to not use a comparison
with the root_mem_cgroup and handle the obj_cgroup_tryget() return code instead.
Something like this:

@@ -2973,6 +2973,7 @@ __always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
 		objcg = rcu_dereference(memcg->objcg);
 		if (objcg && obj_cgroup_tryget(objcg))
 			break;
+		objcg = NULL;
 	}
 	rcu_read_unlock();

Or a more explicit:
   if (obj_cgroup_tryget(objcg)) {
     ...
   } else {
     ...
   }

Also, please, add:
Cc: stable@vger.kernel.org

Thanks!
