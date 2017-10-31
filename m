From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [RESEND v12 3/6] mm, oom: cgroup-aware OOM killer
Date: Tue, 31 Oct 2017 08:04:19 -0700
Message-ID: <CALvZod7V1iNACeDJuuSDrMMGMo7YX+gZ87gq=S4rP=Eh9Wh5kQ@mail.gmail.com>
References: <20171019185218.12663-1-guro@fb.com> <20171019185218.12663-4-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=rSdjpoJ51xCJGhQ+AeLnDJahDfocYgM5zz3QyU9AoBU=;
        b=O597vT7pnVRzD6U6epjvqLuNphVJz7uOKIXEjiJadC4RfU/WK1x3lgW5IlokZmx2LO
         /JtROnPMdD1TwItBBTjY5mQIY8wBn0nNVeKhEEk+WLa7bmBkyEvYWd75G1MxOjxG0rhK
         wBzxE0K3iy6IzQuRaIc9jexjXzVXCrZdD+9v6YQXr5D1YDzdbBZQmdJq664KC9Ug+8XA
         221hno5FJt0S6/Mmjk3McTaP26E6kjcMta32s+mZ+LQSFZGqWqII6c7JMYkt7lCUWEZg
         c4tmjEkBNBa3fI7j4LKVis4nvX1UPDQXHlFqzBsDLBoPtTd3bpG/ZGZuBBNtdR8jOtR7
         PMHw==
In-Reply-To: <20171019185218.12663-4-guro@fb.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Linux MM <linux-mm@kvack.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

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
> +               if (memcg_has_children(iter) && iter != root_mem_cgroup)
> +                       continue;
> +

Cgroup v2 does not support charge migration between memcgs. So, there
can be intermediate nodes which may contain the major charge of the
processes in their leave descendents. Skipping such intermediate nodes
will kind of protect such processes from oom-killer (lower on the list
to be killed). Is it ok to not handle such scenario? If yes, shouldn't
we document it?

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
