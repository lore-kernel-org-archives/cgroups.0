From: Waiman Long <longman9394@gmail.com>
Subject: Re: [PATCH v4 5/7] mm: rework non-root kmem_cache lifecycle
 management
Date: Mon, 20 May 2019 10:54:24 -0400
Message-ID: <5e3c4646-3e4f-414a-0eca-5249956d68a5@gmail.com>
References: <20190514213940.2405198-1-guro@fb.com>
 <20190514213940.2405198-6-guro@fb.com>
 <CALvZod6Zb_kYHyG02jXBY9gvvUn_gOug7kq_hVa8vuCbXdPdjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=8cXCSMG/utY4UucWb4ekygNexeTn9aJiisIiVvtivhA=;
        b=ZU1x/Bp2X6efOLs6VCJ6w1Y0/Tx//zW4Ud90lRRbRSmCiz5AojOo473KCRA1bw98rL
         Xr8VvLNK5CrMk2GXwtG407SUCkWPF3GcdHtkGzyYxq9CO0MN8PeXxCh2EVJV95XXloKQ
         ts6dEhyIdh71+h7iYVn147d+/97Sj7jezcx+AncoJt0Js2Pki95HdfKfeuxQ4aK0LrEg
         L8w8tHdtnJzu6vuHtsCmaj698Jci8ICsaiU5knDuPLCDSgalX75JuSBfVb/yntUmDFBz
         guLP5Ak5FGNc8SFTBSYNfxGmPH3qKxIYZspdEBK9dNELQhFtZteuW8hrYaPt9WWJauX4
         qMNw==
In-Reply-To: <CALvZod6Zb_kYHyG02jXBY9gvvUn_gOug7kq_hVa8vuCbXdPdjQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <kernel-team@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Christoph Lameter <cl@linux.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Cgroups <cgroups@vger.kernel.org>

On 5/14/19 8:06 PM, Shakeel Butt wrote:
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 4e5b4292a763..1ee967b4805e 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -45,6 +45,8 @@ static void slab_caches_to_rcu_destroy_workfn(struct work_struct *work);
>  static DECLARE_WORK(slab_caches_to_rcu_destroy_work,
>                     slab_caches_to_rcu_destroy_workfn);
>
> +static void kmemcg_queue_cache_shutdown(struct percpu_ref *percpu_ref);
> +

kmemcg_queue_cache_shutdown is only defined if CONFIG_MEMCG_KMEM is
defined. If it is not defined, a compilation warning can be produced.
Maybe putting the declaration inside a CONFIG_MEMCG_KMEM block:

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 61d7a96a917b..57ba6cf3dc39 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -45,7 +45,9 @@ static void slab_caches_to_rcu_destroy_workfn(struct
work_stru
ct *work);
 static DECLARE_WORK(slab_caches_to_rcu_destroy_work,
             slab_caches_to_rcu_destroy_workfn);
 
+#ifdef CONFIG_MEMCG_KMEM
 static void kmemcg_queue_cache_shutdown(struct percpu_ref *percpu_ref);
+#endif
 
 /*
  * Set of flags that will prevent slab merging
-- 

Cheers,
Longman

