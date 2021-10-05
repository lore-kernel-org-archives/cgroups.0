From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH memcg v3] memcg: prohibit unconditional exceeding the
 limit of dying tasks
Date: Tue, 5 Oct 2021 16:55:13 +0200
Message-ID: <YVxnUZzR+rjRrGU3@dhcp22.suse.cz>
References: <YUM+saaJEce0TJyF@dhcp22.suse.cz>
 <b89715b5-6df7-34a3-f7b9-efa8e0eefd3e@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1633445714; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S16oNrBuFcWuNh85hYkjoulTN4cPTW6zAgP9R8WFY7g=;
        b=KRM3Clmotf21/ys7DEwncqQlncDujGhwquNy00mM6atBKUGyELdWliY5ZR0P0QUP1a58Xl
        tngzGvs0v2qeAcZ+gK67gAhzUTwx+5jpEwqM0Jy8rAQ+qtBdGUvA+8OuvJ5xj48KltS8qo
        /rrWjruydyulK56D7kfWPCJN2nJ2ATw=
Content-Disposition: inline
In-Reply-To: <b89715b5-6df7-34a3-f7b9-efa8e0eefd3e-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Tue 05-10-21 16:52:31, Vasily Averin wrote:
> v3: no functional changes, just improved patch description

You haven't addressed my review feedback regarding the oom invocation.
Let me paste it here again:
: > @@ -1607,7 +1607,7 @@ static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
: >        * A few threads which were not waiting at mutex_lock_killable() can
: >        * fail to bail out. Therefore, check again after holding oom_lock.
: >        */
: > -     ret = should_force_charge() || out_of_memory(&oc);
: > +     ret = task_is_dying() || out_of_memory(&oc);
: 
: task_is_dying check will prevent the oom killer for dying tasks. There
: is an additional bail out at out_of_memory layer. These checks are now
: leading to a completely different behavior. Currently we simply use
: "unlimited" reserves and therefore we do not have to kill any task. Now
: the charge fails without using all reclaim measures. So I believe we
: should drop those checks for memcg oom paths. I have to think about this
: some more because I might be missing some other side effects.
-- 
Michal Hocko
SUSE Labs
