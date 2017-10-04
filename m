From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [v10 3/6] mm, oom: cgroup-aware OOM killer
Date: Wed, 4 Oct 2017 14:24:26 -0700
Message-ID: <CALvZod45ObeQwq-pKeqyLe2bNwfKAr0majCbNfqPOEJL+AeiNw@mail.gmail.com>
References: <20171004154638.710-1-guro@fb.com> <20171004154638.710-4-guro@fb.com>
 <CALvZod6bwyoSWTv139y0wMidpZm5HcDu8RzVjF8U7GHxAzxSQw@mail.gmail.com> <20171004201524.GA4174@castle>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=kM9TQ05IPPDjp7Kc+Rg3hSYC9KdV3icPhAwDSjA+p0c=;
        b=Wok+/obMHgIt48F64O/mg6CFmOja/gkzglNdwzIgjshv/ofRG5P1uSzca5AseEMJ+F
         PQciSSnz5qiBZcZmazLIWwHYJBFD482mPV/Latwr1alEUgVopX3p0+hHE/p0GfkoRWKE
         DOcsJkD6fzY61+5f9Fe+rJuT5Rzz8cB7wkZjGaTfk96MD42gQNCVgz7VKPhbzShewZO/
         aUwp42e/Vp4EbGJ0nHTdqW/bMyMAkvQESUr1M+6k5tHMQPykImioLikbF3hVNH2xq7WE
         X4lBKmtOl49skpytKHk3/5cGzUJ7PX0amirtZsd9WeYe+vN8uUB8LlfkAV6Rzy1kEDy8
         DBBw==
In-Reply-To: <20171004201524.GA4174@castle>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Linux MM <linux-mm@kvack.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

>> > +               if (memcg_has_children(iter))
>> > +                       continue;
>>
>> && iter != root_mem_cgroup ?
>
> Oh, sure. I had a stupid bug in my test script, which prevented me from
> catching this. Thanks!
>
> This should fix the problem.
> --
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 2e82625bd354..b3848bce4c86 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2807,7 +2807,8 @@ static void select_victim_memcg(struct mem_cgroup *root, struct oom_control *oc)
>                  * We don't consider non-leaf non-oom_group memory cgroups
>                  * as OOM victims.
>                  */
> -               if (memcg_has_children(iter) && !mem_cgroup_oom_group(iter))
> +               if (memcg_has_children(iter) && iter != root_mem_cgroup &&
> +                   !mem_cgroup_oom_group(iter))
>                         continue;

I think you are mixing the 3rd and 4th patch. The root_mem_cgroup
check should be in 3rd while oom_group stuff should be in 4th.


>>
>> Shouldn't there be a CSS_ONLINE check? Also instead of css_get at the
>> end why not css_tryget_online() here and css_put for the previous
>> selected one.
>
> Hm, why do we need to check this? I do not see, how we can choose
> an OFFLINE memcg as a victim, tbh. Please, explain the problem.
>

Sorry about the confusion. There are two things. First, should we do a
css_get on the newly selected memcg within the for loop when we still
have a reference to it?

Second, for the OFFLINE memcg, you are right oom_evaluate_memcg() will
return 0 for offlined memcgs. Maybe no need to call
oom_evaluate_memcg() for offlined memcgs.
