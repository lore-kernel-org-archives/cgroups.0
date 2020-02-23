From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v3 2/3] mm: Charge active memcg when no mm is set
Date: Sun, 23 Feb 2020 11:08:56 -0800 (PST)
Message-ID: <alpine.LSU.2.11.2002231058520.5735@eggly.anvils>
References: <cover.1582216294.git.schatzberg.dan@gmail.com> <0a27b6fcbd1f7af104d7f4cf0adc6a31e0e7dd19.1582216294.git.schatzberg.dan@gmail.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=htLN1mwGdJtRnyqYUCPJp+OPGglRrhjiWXYVtDt/NKM=;
        b=JSZ7Tv7F6nQ3YH2jP3HFLdPAhZhy2Y/RM9Au69XuF7TR0GzciTC0aj+0Tv4uRV+9XJ
         S4Wu6jcRiaRdgV38hOL3giTmwn97IzhRnjQRKVCoYK+wbKxwIa24ektK26DJ43CkLtwN
         ZT9IiL8y9//RQ99zTTNcqBJXNSogX2r+AwY/uH8cqaruxnp5gzlWpx+9El5byimG0jnA
         gwXKIGTFa3/cNEDFtAyjXJOHNCZOiszkR89nBIjCVQRfXSF+Sr/HRB0GuxP8BmqtZijN
         wiRvUQvVfqVjVfedH3LtBOG9DpYU+DUoB1Db0YG0GDCRe4xQFuaaRpiYbX5PICYUsE9L
         PPqw==
In-Reply-To: <0a27b6fcbd1f7af104d7f4cf0adc6a31e0e7dd19.1582216294.git.schatzberg.dan@gmail.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Yang Shi <yang.shi@linux.alibaba.com>, Thomas Gleixner <tglx@linutronix.de>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>

On Thu, 20 Feb 2020, Dan Schatzberg wrote:

> memalloc_use_memcg() worked for kernel allocations but was silently
> ignored for user pages.
> 
> This patch establishes a precedence order for who gets charged:
> 
> 1. If there is a memcg associated with the page already, that memcg is
>    charged. This happens during swapin.
> 
> 2. If an explicit mm is passed, mm->memcg is charged. This happens
>    during page faults, which can be triggered in remote VMs (eg gup).
> 
> 3. Otherwise consult the current process context. If it has configured
>    a current->active_memcg, use that. Otherwise, current->mm->memcg.
> 
> Previously, if a NULL mm was passed to mem_cgroup_try_charge (case 3) it
> would always charge the root cgroup. Now it looks up the current
> active_memcg first (falling back to charging the root cgroup if not
> set).
> 
> Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Tejun Heo <tj@kernel.org>

Acked-by: Hugh Dickins <hughd@google.com>

Yes, internally we have some further not-yet-upstreamed complications
here (mainly, the "memcg=" mount option for all charges on a tmpfs to
be charged to that memcg); but what you're doing here does not obstruct
adding that later, they fit in well with the hierarchy that you (and
Johannes) mapped out above, and it's really an improvement for shmem
not to be referring to current there - thanks.

> ---
>  mm/memcontrol.c | 11 ++++++++---
>  mm/shmem.c      |  2 +-
>  2 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6f6dc8712e39..b174aff4f069 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6317,7 +6317,8 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
>   * @compound: charge the page as compound or small page
>   *
>   * Try to charge @page to the memcg that @mm belongs to, reclaiming
> - * pages according to @gfp_mask if necessary.
> + * pages according to @gfp_mask if necessary. If @mm is NULL, try to
> + * charge to the active memcg.
>   *
>   * Returns 0 on success, with *@memcgp pointing to the charged memcg.
>   * Otherwise, an error code is returned.
> @@ -6361,8 +6362,12 @@ int mem_cgroup_try_charge(struct page *page, struct mm_struct *mm,
>  		}
>  	}
>  
> -	if (!memcg)
> -		memcg = get_mem_cgroup_from_mm(mm);
> +	if (!memcg) {
> +		if (!mm)
> +			memcg = get_mem_cgroup_from_current();
> +		else
> +			memcg = get_mem_cgroup_from_mm(mm);
> +	}
>  
>  	ret = try_charge(memcg, gfp_mask, nr_pages);
>  
> diff --git a/mm/shmem.c b/mm/shmem.c
> index c8f7540ef048..7c7f5acf89d6 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1766,7 +1766,7 @@ static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
>  	}
>  
>  	sbinfo = SHMEM_SB(inode->i_sb);
> -	charge_mm = vma ? vma->vm_mm : current->mm;
> +	charge_mm = vma ? vma->vm_mm : NULL;
>  
>  	page = find_lock_entry(mapping, index);
>  	if (xa_is_value(page)) {
> -- 
> 2.17.1
