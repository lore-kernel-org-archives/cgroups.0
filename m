From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [v10 3/6] mm, oom: cgroup-aware OOM killer
Date: Wed, 4 Oct 2017 12:48:03 -0700
Message-ID: <CALvZod6bwyoSWTv139y0wMidpZm5HcDu8RzVjF8U7GHxAzxSQw@mail.gmail.com>
References: <20171004154638.710-1-guro@fb.com> <20171004154638.710-4-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=Px/worLUEqc7v7NkCMpPzb0GQz4qkBwzYlEECgdBgBM=;
        b=ZLOVwmjUl5L0c/N7O95LBp+KaoyQj8wY8X38JvRliaohzaH3b+GkpNgOZf+5fV5H9E
         uILsh/YXuJQxLU4sF9p9e1FkdJ14xuwjIJgSPCaETFuYcjB/ZCXvILPpi/4zw/+yufqY
         F52zKFM4TSD3cv4KkMEBYwHr0YxvoGxMGGtA2mSDRzYjNQa8x1SuEfgSjowM73zK6jc/
         a6Hn+g7AZGHiL/LZomkXpL1sE3Taa4NbXXAYL3x/n1ty6WMPWKCYL/rzgO83YVK0YCmG
         Gs/YJxEl/Dnm9gFv0YooW4/BqNkfByGXM0wOr4WwEjT2ItXs5Yx9pNYsz12aa9yUCGRC
         gvpQ==
In-Reply-To: <20171004154638.710-4-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Linux MM <linux-mm@kvack.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

> +
> +static void select_victim_memcg(struct mem_cgroup *root, struct oom_control *oc)
> +{
> +       struct mem_cgroup *iter;
> +
> +       oc->chosen_memcg = NULL;
> +       oc->chosen_points = 0;
> +
> +       /*
> +        * The oom_score is calculated for leaf memory cgroups (including
> +        * the root memcg).
> +        */
> +       rcu_read_lock();
> +       for_each_mem_cgroup_tree(iter, root) {
> +               long score;
> +
> +               if (memcg_has_children(iter))
> +                       continue;

&& iter != root_mem_cgroup ?

> +
> +               score = oom_evaluate_memcg(iter, oc->nodemask, oc->totalpages);
> +
> +               /*
> +                * Ignore empty and non-eligible memory cgroups.
> +                */
> +               if (score == 0)
> +                       continue;
> +
> +               /*
> +                * If there are inflight OOM victims, we don't need
> +                * to look further for new victims.
> +                */
> +               if (score == -1) {
> +                       oc->chosen_memcg = INFLIGHT_VICTIM;
> +                       mem_cgroup_iter_break(root, iter);
> +                       break;
> +               }
> +

Shouldn't there be a CSS_ONLINE check? Also instead of css_get at the
end why not css_tryget_online() here and css_put for the previous
selected one.

> +               if (score > oc->chosen_points) {
> +                       oc->chosen_points = score;
> +                       oc->chosen_memcg = iter;
> +               }
> +       }
> +
> +       if (oc->chosen_memcg && oc->chosen_memcg != INFLIGHT_VICTIM)
> +               css_get(&oc->chosen_memcg->css);
> +
> +       rcu_read_unlock();
> +}
> +

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
