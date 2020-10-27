From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 2/5] mm: memcg/slab: Fix use after free in
 obj_cgroup_charge
Date: Tue, 27 Oct 2020 11:31:32 -0700
Message-ID: <20201027183132.GC725724@carbon.dhcp.thefacebook.com>
References: <20201027080256.76497-1-songmuchun@bytedance.com>
 <20201027080256.76497-3-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=CaNNTAePTb/2NKJ5qDb+sog4vtTEV6NufAX37X6coe8=;
 b=OR8DIjj171ekol9EyXRSIQLLV2ow9RGUu6w37G66Ae0caNmw/2cJHRUF1Ry/VLtYFGua
 gvUSFJNxw7b+gR8spWgwhzsnNl0T3R0VeL33FQ8Gd+lvc7WXqe6AGimlLPWS9VNdMIpd
 /RSGP7atDlKEzgVeduzqbXoriQ9nbj8WMc8= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CaNNTAePTb/2NKJ5qDb+sog4vtTEV6NufAX37X6coe8=;
 b=ERGoWPm9/13BoZepIBZgMlL0npkLSzOS6b8fZXVGlkdN4HVyMzMGhK3OOa297mv2u4ehl6VjDWqeyjDeIjofQa8/GnkXmOtZQtcWkTPKgHz4yz9zGEJbucsODr9al6xg/zsHie0Yu7BSwfwERPVPwUmT8rgTzfbcoRvfLHyQTPA=
Content-Disposition: inline
In-Reply-To: <20201027080256.76497-3-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, laoar.shao@gmail.com, chris@chrisdown.name, christian.brauner@ubuntu.com, peterz@infradead.org, mingo@kernel.org, keescook@chromium.org, tglx@linutronix.de, esyr@redhat.com, surenb@google.com, areber@redhat.com, elver@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Tue, Oct 27, 2020 at 04:02:53PM +0800, Muchun Song wrote:
> The rcu_read_lock/unlock only can guarantee that the memcg will
> not be freed, but it cannot guarantee the success of css_get to
> memcg. This can be happened when we reparent the memcg. So using
> css_tryget instead of css_get.

Hm, I really doubt that it can be reproduced in the real life, but
I think you're formally correct.

If the whole process of a cgroup offlining is completed between reading
a objcg->memcg pointer and bumping the css reference on another CPU,
and there are exactly 0 external references to this memory cgroup
(how we get to the obj_cgroup_charge() then?), css_get() can change
the ref counter from 0 back to 1.
Is this a good description of the problem?

If so, I think it's worth a more detailed description and mentioning that
it's not a real-life bug. It also probably doesn't deserve a stable@ backport.

> 
> Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  mm/memcontrol.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index fcbd79c5023e..c0c27bee23ad 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3223,8 +3223,10 @@ int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
>  	 * independently later.
>  	 */
>  	rcu_read_lock();
> +retry:
>  	memcg = obj_cgroup_memcg(objcg);
> -	css_get(&memcg->css);
> +	if (!css_tryget(&memcg->css))

  	if (unlikely(!css_tryget(&memcg->css)))
            ^^^^^^^^
	    maybe?

> +		goto retry;

Otherwise the fix looks good to me.

Please, feel free to add
Acked-by: Roman Gushchin <guro@fb.com>
after extending the commit description.

Thanks!
