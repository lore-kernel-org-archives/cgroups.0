From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] mm: memcontrol: Fix do not put the css reference
Date: Sun, 14 Jun 2020 10:22:38 -0700
Message-ID: <20200614172238.GA755479@carbon.DHCP.thefacebook.com>
References: <20200614122653.98829-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=UC2t9cOPa56YyaDDRH7B20GO+AqGGxmlmTJko6c2T1A=;
 b=ppYV3pfuK1afmjx1JrpgTEKCyvuXDoJYdaA9O1T23HP+HBF577dv0596fyu8nZzJJ00k
 B+wCq8KUpE6iixH4yZNO/pdSJeODdTBQcXSMLfPh4Jb7CFMJoAweYLGfsLGRRUst9Bf2
 1nTxr8k3SwajUxhCp3lzCxxI4DndbDTpJow= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UC2t9cOPa56YyaDDRH7B20GO+AqGGxmlmTJko6c2T1A=;
 b=HWv8dzFQondlfTV5au2JyQmIXTrUOooWABTGitN1aK6F5scQoynVw/e22gMs9NZPql0OJ4Xzo+BBUX6TAzqpi1UBavUwxlj3ns/qfUz37xpV9Ssds2j2sbk9p72un2VH6CbB0Z9XUvvXAG6Iyc8fdwnAymrx3yIKHHBMzdKBDIM=
Content-Disposition: inline
In-Reply-To: <20200614122653.98829-1-songmuchun@bytedance.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, cai@lca.pw, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Sun, Jun 14, 2020 at 08:26:53PM +0800, Muchun Song wrote:
> We should put the css reference when memory allocation failed.
> 
> Fixes: f0a3a24b532d ("mm: memcg/slab: rework non-root kmem_cache lifecycle management")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  mm/memcontrol.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Good catch, thank you!

Acked-by: Roman Gushchin <guro@fb.com>

> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 0b38b6ad547d..2323d811ee8e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2772,8 +2772,10 @@ static void memcg_schedule_kmem_cache_create(struct mem_cgroup *memcg,
>  		return;
>  
>  	cw = kmalloc(sizeof(*cw), GFP_NOWAIT | __GFP_NOWARN);
> -	if (!cw)
> +	if (!cw) {
> +		css_put(&memcg->css);
>  		return;
> +	}
>  
>  	cw->memcg = memcg;
>  	cw->cachep = cachep;
> -- 
> 2.11.0
> 
