From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [Patch v2] mm: thp: grab the lock before manipulation defer list
Date: Sat, 11 Jan 2020 03:03:52 +0300
Message-ID: <20200111000352.efy6krudecpshezh@box>
References: <20200109143054.13203-1-richardw.yang@linux.intel.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0dV0HpLb0SFVmBzU2FxcT9u699TRcir0XtuMO7iJ5Rk=;
        b=jLj7968mfYKL2VYZr0TuLfiNgEm5+DSR9KdJ7zlbQDt/OA7icoEp8yEMnyLppqBrue
         3NcMP+/XLLUMQj7Tk8Ede7FOYr8o9bc2tL4Wqsl08zcoZFkqXB9vNlaQS9kd6XhnhAYa
         uLKfVHKK3ZcR0lMjU2IQbPTpuHVY+C0O4ylgpVM9nFwKVM/+4xnm7yYBzpTkvlEvVwwg
         Cf7J2R+hdmjc9S5e5ra4dZ3oIn7TmzBc8WMZPbgzzMJUBj6BCtwcvkOa0AxYMorFQVPh
         sk5+IEgmkdM4y1F3gxQqL1rQvdHZrj0kRrSzdfoHeqNk6/HSxWPpfmUzTrJK2rwYZtM/
         SzTA==
Content-Disposition: inline
In-Reply-To: <20200109143054.13203-1-richardw.yang@linux.intel.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richardw.yang@linux.intel.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kirill.shutemov@linux.intel.com, yang.shi@linux.alibaba.com, alexander.duyck@gmail.com, rientjes@google.com

On Thu, Jan 09, 2020 at 10:30:54PM +0800, Wei Yang wrote:
> As all the other places, we grab the lock before manipulate the defer list.
> Current implementation may face a race condition.
> 
> For example, the potential race would be:
> 
>     CPU1                      CPU2
>     mem_cgroup_move_account   split_huge_page_to_list
>       !list_empty
>                                 lock
>                                 !list_empty
>                                 list_del
>                                 unlock
>       lock
>       # !list_empty might not hold anymore
>       list_del_init
>       unlock

I don't think this particular race is possible. Both parties take page
lock before messing with deferred queue, but anytway:

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

> 
> When this sequence happens, the list_del_init() in
> mem_cgroup_move_account() would crash if CONFIG_DEBUG_LIST since the
> page is already been removed by list_del in split_huge_page_to_list().
> 
> Fixes: 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg aware")
> 
> Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
> Acked-by: David Rientjes <rientjes@google.com>
> 
> ---
> v2:
>   * move check on compound outside suggested by Alexander
>   * an example of the race condition, suggested by Michal
> ---
>  mm/memcontrol.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index bc01423277c5..1492eefe4f3c 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5368,10 +5368,12 @@ static int mem_cgroup_move_account(struct page *page,
>  	}
>  
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	if (compound && !list_empty(page_deferred_list(page))) {
> +	if (compound) {
>  		spin_lock(&from->deferred_split_queue.split_queue_lock);
> -		list_del_init(page_deferred_list(page));
> -		from->deferred_split_queue.split_queue_len--;
> +		if (!list_empty(page_deferred_list(page))) {
> +			list_del_init(page_deferred_list(page));
> +			from->deferred_split_queue.split_queue_len--;
> +		}
>  		spin_unlock(&from->deferred_split_queue.split_queue_lock);
>  	}
>  #endif
> @@ -5385,11 +5387,13 @@ static int mem_cgroup_move_account(struct page *page,
>  	page->mem_cgroup = to;
>  
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	if (compound && list_empty(page_deferred_list(page))) {
> +	if (compound) {
>  		spin_lock(&to->deferred_split_queue.split_queue_lock);
> -		list_add_tail(page_deferred_list(page),
> -			      &to->deferred_split_queue.split_queue);
> -		to->deferred_split_queue.split_queue_len++;
> +		if (list_empty(page_deferred_list(page))) {
> +			list_add_tail(page_deferred_list(page),
> +				      &to->deferred_split_queue.split_queue);
> +			to->deferred_split_queue.split_queue_len++;
> +		}
>  		spin_unlock(&to->deferred_split_queue.split_queue_lock);
>  	}
>  #endif
> -- 
> 2.17.1
> 
> 

-- 
 Kirill A. Shutemov

