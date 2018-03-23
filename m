From: Michal Hocko <mhocko@kernel.org>
Subject: Re: =?utf-8?B?562U5aSNOiDnrZTlpI06IOetlA==?=
 =?utf-8?B?5aSNOiBbUEFUQ0g=?= =?utf-8?Q?=5D?= mm/memcontrol.c: speed up to
 force empty a memory cgroup
Date: Fri, 23 Mar 2018 13:29:02 +0100
Message-ID: <20180323122902.GR23100@dhcp22.suse.cz>
References: <1521448170-19482-1-git-send-email-lirongqing@baidu.com>
 <20180319085355.GQ23100@dhcp22.suse.cz>
 <2AD939572F25A448A3AE3CAEA61328C23745764B@BC-MAIL-M28.internal.baidu.com>
 <20180319103756.GV23100@dhcp22.suse.cz>
 <2AD939572F25A448A3AE3CAEA61328C2374589DC@BC-MAIL-M28.internal.baidu.com>
 <2AD939572F25A448A3AE3CAEA61328C2374832C1@BC-MAIL-M28.internal.baidu.com>
 <20180323100839.GO23100@dhcp22.suse.cz>
 <2AD939572F25A448A3AE3CAEA61328C2374EC73E@BC-MAIL-M28.internal.baidu.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2AD939572F25A448A3AE3CAEA61328C2374EC73E@BC-MAIL-M28.internal.baidu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Li,Rongqing" <lirongqing@baidu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>

On Fri 23-03-18 12:04:16, Li,Rongqing wrote:
[...]
> shrink_slab does not reclaim any memory, but take lots of time to
> count lru
>
> maybe we can use the returning of shrink_slab to control if next
> shrink_slab should be called?

How? Different memcgs might have different amount of shrinkable memory.

> Or define a slight list_lru_empty to check if sb->s_dentry_lru is
> empty before calling list_lru_shrink_count, like below

Does it really help to improve numbers?
 
> diff --git a/fs/super.c b/fs/super.c
> index 672538ca9831..954c22338833 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -130,8 +130,10 @@ static unsigned long super_cache_count(struct shrinker *shrink,
>         if (sb->s_op && sb->s_op->nr_cached_objects)
>                 total_objects = sb->s_op->nr_cached_objects(sb, sc);
>  
> -       total_objects += list_lru_shrink_count(&sb->s_dentry_lru, sc);
> -       total_objects += list_lru_shrink_count(&sb->s_inode_lru, sc);
> +       if (!list_lru_empty(sb->s_dentry_lru))
> +               total_objects += list_lru_shrink_count(&sb->s_dentry_lru, sc);
> +       if (!list_lru_empty(sb->s_inode_lru))
> +               total_objects += list_lru_shrink_count(&sb->s_inode_lru, sc);
>  
>         total_objects = vfs_pressure_ratio(total_objects);
>         return total_objects;

-- 
Michal Hocko
SUSE Labs
