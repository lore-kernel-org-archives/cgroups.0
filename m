From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 1/2] mm: memcg: fix memcg file_dirty numa stat
Date: Mon, 28 Dec 2020 11:40:50 -0800
Message-ID: <20201228194050.GA318614@carbon.dhcp.thefacebook.com>
References: <20201227181310.3235210-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=3jWrNH8bNIYlCChXjhVKfCvw+Hz/BLtjGtZCWgGWf28=;
 b=JBwXRUZv08A9l/+SaiyPLAFHICAeKA1mI28zJu9lcFCKFGyZ93iBzcsDlNzijdbRwDUf
 J3wibNyDUjxVGLlxrMUnqSPmxJTv6ANCArhEgSNIotwjuk95sGfBI3G+If8Yv0H454Lu
 xIOhhHZS8hvNeemFB2w3ltvojfZZUk7COa0= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3jWrNH8bNIYlCChXjhVKfCvw+Hz/BLtjGtZCWgGWf28=;
 b=WuQo+qCcpm2DK9HOXC4ImC3nuO6PegnUh65osYJNN+az++qNKyjkOdeUiLLwsnx190b8rCbVpWgvOiL0vWAoDlAjasJQTMLW4PV8ztqUsDQCqoreAbrxExvdiqatvOhIbZYjhrtS9OSnQn0mH9nNjBxPlti6wBOmL/zj8Yc7Zus=
Content-Disposition: inline
In-Reply-To: <20201227181310.3235210-1-shakeelb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org

On Sun, Dec 27, 2020 at 10:13:09AM -0800, Shakeel Butt wrote:
> The kernel updates the per-node NR_FILE_DIRTY stats on page migration
> but not the memcg numa stats. That was not an issue until recently the
> commit 5f9a4f4a7096 ("mm: memcontrol: add the missing numa_stat interface
> for cgroup v2") exposed numa stats for the memcg. So fixing the
> file_dirty per-memcg numa stat.
> 
> Fixes: 5f9a4f4a7096 ("mm: memcontrol: add the missing numa_stat interface for cgroup v2")
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Cc: <stable@vger.kernel.org>

Reviewed-by: Roman Gushchin <guro@fb.com>

Thanks!

> ---
>  mm/migrate.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index ee5e612b4cd8..613794f6a433 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -500,9 +500,9 @@ int migrate_page_move_mapping(struct address_space *mapping,
>  			__inc_lruvec_state(new_lruvec, NR_SHMEM);
>  		}
>  		if (dirty && mapping_can_writeback(mapping)) {
> -			__dec_node_state(oldzone->zone_pgdat, NR_FILE_DIRTY);
> +			__dec_lruvec_state(old_lruvec, NR_FILE_DIRTY);
>  			__dec_zone_state(oldzone, NR_ZONE_WRITE_PENDING);
> -			__inc_node_state(newzone->zone_pgdat, NR_FILE_DIRTY);
> +			__inc_lruvec_state(new_lruvec, NR_FILE_DIRTY);
>  			__inc_zone_state(newzone, NR_ZONE_WRITE_PENDING);
>  		}
>  	}
> -- 
> 2.29.2.729.g45daf8777d-goog
> 
