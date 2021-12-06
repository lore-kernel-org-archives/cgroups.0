From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: add group_oom_kill memory event
Date: Mon, 6 Dec 2021 10:19:29 -0500
Message-ID: <Ya4qAWzz6Ozq07Sl@cmpxchg.org>
References: <20211203162426.3375036-1-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nefXY9GnrKTvs8NuB1vTMpAOilGrkfP6qgHIvnqCGyA=;
        b=HzYh2WxY8Q+EgOkB2smBNZ25CT3P5TCbZA91IuxwSLyZw7X7AbSYLmJEljM3LlDwFx
         lY8VvbF9xOM4Psmx2Kh9WX8lRdwFEMYfS6mr3MXhAhkjeVWwSXTdCzxNGP0M8Eqaa7dN
         D+lH/ekiFAwEukjTTKRP3Q43Qqa54gnyAeHmk61hhdv8zarhymwU5U6GvAoB4ZZ+K3ZH
         bQKCen1R+8SJvC0WKy2eNUOCPB9kXlRoY1KVCNh7vY0q+agMYnkTfCD5Ao7FANJOiaWD
         HzvM+F48qhwpHiZkY/rH7viLoFAKAMa+9dHA6Pkfvuzu/pW7n45fUfXm6CSS0BFdRnbs
         B7NQ==
Content-Disposition: inline
In-Reply-To: <20211203162426.3375036-1-schatzberg.dan@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Muchun Song <songmuchun@bytedance.com>, Alex Shi <alexs@kernel.org>, Wei Yang <richard.weiyang@gmail.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>

This makes perfect sense, just one minor point:

On Fri, Dec 03, 2021 at 08:24:23AM -0800, Dan Schatzberg wrote:
> @@ -4390,6 +4390,9 @@ static int mem_cgroup_oom_control_read(struct seq_file *sf, void *v)
>  	seq_printf(sf, "under_oom %d\n", (bool)memcg->under_oom);
>  	seq_printf(sf, "oom_kill %lu\n",
>  		   atomic_long_read(&memcg->memory_events[MEMCG_OOM_KILL]));
> +	seq_printf(sf, "oom_group_kill %lu\n",
> +		   atomic_long_read(
> +			&memcg->memory_events[MEMCG_OOM_GROUP_KILL]));
>  	return 0;
>  }

oom_control is a cgroup1 file, but group-oom is a cgroup2-only
feature. Best to drop this hunk.

With that, please add:
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
