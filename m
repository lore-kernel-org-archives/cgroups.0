From: Jianyu Zhan <nasa4836@gmail.com>
Subject: Re: [PATCH 2/4] mm/memcontrol.c: use accessor to get id from css
Date: Tue, 22 Apr 2014 15:03:31 +0800
Message-ID: <CAHz2CGW+yjt6yXDDn-pjykSf-q03YsD5acmuhDkSCg_iXKA88Q@mail.gmail.com>
References: <cover.1398147734.git.nasa4836@gmail.com> <2c63c535f8202c6b605300a834cdf1c07d1bafc3.1398147734.git.nasa4836@gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=NT5d15uUEwfeFRI5YQCsXcYtDQDoFv191Y/X3XABoZY=;
        b=VC10xYJWXCqDvE8yK/i9PQUnIm3QiQbKWsPGVNMKVxObuOoAT1rgNASgO5UH+E3AqO
         Pxhe6D3LulKNQXvf5E/kvaA8X2G9ndYw92NpolGTAKYEScv+G4mEfmcYmz8GH1n3yPi9
         awdmG09z46Z1lWi0AXLQ4+6YDLghXB7e7wZqvd9uZ3X2aJ96cDY25gW5oubqHwBIu7+9
         6suDODS/RiznEQ+b2BBOcVIar/jY1SjgWLlsNjN3m2NssWAMUYLpxn3ORe3wG08IYAyr
         MU5RyDin17wJzF7Gryf6IxsFS3oKDKTn9cvwMohCoU6U52MDdsUMWLLvy/3J38fV2pmo
         SVIQ==
In-Reply-To: <2c63c535f8202c6b605300a834cdf1c07d1bafc3.1398147734.git.nasa4836@gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>, kamezawa.hiroyu@jp.fujitsu.com
Cc: Cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Jianyu Zhan <nasa4836@gmail.com>, Andrew Morton <akpm@linux-foundation.org>

Cc Andrew.

Thanks,
Jianyu Zhan


On Tue, Apr 22, 2014 at 2:30 PM, Jianyu Zhan <nasa4836@gmail.com> wrote:
> This is a prepared patch for converting from per-cgroup id to
> per-subsystem id.
>
> We should not access per-cgroup id directly, since this is implemetation
> detail. Use the accessor css_from_id() instead.
>
> This patch has no functional change.
>
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
> ---
>  mm/memcontrol.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 80d9e38..46333cb 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -528,10 +528,10 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
>  static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
>  {
>         /*
> -        * The ID of the root cgroup is 0, but memcg treat 0 as an
> -        * invalid ID, so we return (cgroup_id + 1).
> +        * The ID of css for the root cgroup is 0, but memcg treat 0 as an
> +        * invalid ID, so we return (id + 1).
>          */
> -       return memcg->css.cgroup->id + 1;
> +       return css_to_id(&memcg->css) + 1;
>  }
>
>  static inline struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
> @@ -6407,7 +6407,7 @@ mem_cgroup_css_online(struct cgroup_subsys_state *css)
>         struct mem_cgroup *memcg = mem_cgroup_from_css(css);
>         struct mem_cgroup *parent = mem_cgroup_from_css(css_parent(css));
>
> -       if (css->cgroup->id > MEM_CGROUP_ID_MAX)
> +       if (css_to_id(css) > MEM_CGROUP_ID_MAX)
>                 return -ENOSPC;
>
>         if (!parent)
> --
> 2.0.0-rc0
>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
