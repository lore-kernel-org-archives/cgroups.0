From: Muchun Song <songmuchun@bytedance.com>
Subject: Re: [External] [PATCH 1/2] mm: memcg: fix memcg file_dirty numa stat
Date: Mon, 28 Dec 2020 13:40:54 +0800
Message-ID: <CAMZfGtWqDLJkP1zk_W16F+ssiW5NujRF-LFoV2GJ-+gXvBswMQ@mail.gmail.com>
References: <20201227181310.3235210-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KdC1UTvK3n3P54mNUc/2MJ7F1GE6qXAssfNlwctQq5A=;
        b=VgitC5bh7LY0I34mSYBnKJCn+g46m7lfhWc+52EAtE4Jtpn1zF5sEmiOiHFhniymQu
         75MVFKMKs2DbndOSgVA22lLlgtsoO+s8idjhSQU0xCV0oAzbeoMRXt68n0RAtd9hFkFV
         TKkOVCLHYeXHo3OJaDiiHCJpKpos4gOwZSSh4g0eeAdNHb2wU7CBUTdJfv38wDQqlWo4
         b5gpSyPsRZ4xY+KUA4FLZryRruATzIIMSVW6aWoFBnS/G/Bws41pXp3vetiEl78tNJiD
         +5GyYwHlJPG5buRTpVXncrX6sgDfBBj6k77xNvtNdNfDdAIIFMI8uhol7rByABB7Irvp
         7FIA==
In-Reply-To: <20201227181310.3235210-1-shakeelb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Cgroups <cgroups@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux- stable <stable@vger.kernel.org>

On Mon, Dec 28, 2020 at 2:13 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> The kernel updates the per-node NR_FILE_DIRTY stats on page migration
> but not the memcg numa stats. That was not an issue until recently the
> commit 5f9a4f4a7096 ("mm: memcontrol: add the missing numa_stat interface
> for cgroup v2") exposed numa stats for the memcg. So fixing the
> file_dirty per-memcg numa stat.
>
> Fixes: 5f9a4f4a7096 ("mm: memcontrol: add the missing numa_stat interface for cgroup v2")

Thanks for catching this problem.

Reviewed-by: Muchun Song <songmuchun@bytedance.com>

> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Cc: <stable@vger.kernel.org>
> ---
>  mm/migrate.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index ee5e612b4cd8..613794f6a433 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -500,9 +500,9 @@ int migrate_page_move_mapping(struct address_space *mapping,
>                         __inc_lruvec_state(new_lruvec, NR_SHMEM);
>                 }
>                 if (dirty && mapping_can_writeback(mapping)) {
> -                       __dec_node_state(oldzone->zone_pgdat, NR_FILE_DIRTY);
> +                       __dec_lruvec_state(old_lruvec, NR_FILE_DIRTY);
>                         __dec_zone_state(oldzone, NR_ZONE_WRITE_PENDING);
> -                       __inc_node_state(newzone->zone_pgdat, NR_FILE_DIRTY);
> +                       __inc_lruvec_state(new_lruvec, NR_FILE_DIRTY);
>                         __inc_zone_state(newzone, NR_ZONE_WRITE_PENDING);
>                 }
>         }
> --
> 2.29.2.729.g45daf8777d-goog
>


--
Yours,
Muchun
