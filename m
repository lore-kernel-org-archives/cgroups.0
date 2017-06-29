From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [v3 1/6] mm, oom: use oom_victims counter to synchronize oom
 victim selection
Date: Thu, 29 Jun 2017 11:04:31 +0200
Message-ID: <20170629090431.GG31603@dhcp22.suse.cz>
References: <1498079956-24467-1-git-send-email-guro@fb.com>
 <1498079956-24467-2-git-send-email-guro@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1498079956-24467-2-git-send-email-guro-b10kYP2dOMg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 21-06-17 22:19:11, Roman Gushchin wrote:
> Oom killer should avoid unnecessary kills. To prevent them, during
> the tasks list traverse we check for task which was previously
> selected as oom victims. If there is such a task, new victim
> is not selected.
> 
> This approach is sub-optimal (we're doing costly iteration over the task
> list every time) and will not work for the cgroup-aware oom killer.
> 
> We already have oom_victims counter, which can be effectively used
> for the task.

A global counter will not work properly, I am afraid. a) you should
consider the oom domain and do not block oom on unrelated domains and b)
you have no guarantee that the oom victim will terminate reasonably.
That is why we have MMF_OOM_SKIP check in oom_evaluate_task.

I think you should have something similar for your memcg victim selection.
If you see a memcg in the oom hierarchy with oom victims which are alive
and not MMF_OOM_SKIP, you should abort the scanning.
-- 
Michal Hocko
SUSE Labs
