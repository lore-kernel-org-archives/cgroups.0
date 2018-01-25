From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [patch -mm 3/4] mm, memcg: replace memory.oom_group with policy
 tunable
Date: Thu, 25 Jan 2018 09:11:34 +0100
Message-ID: <20180125081134.GL28465@dhcp22.suse.cz>
References: <20180117154155.GU3460072@devbig577.frc2.facebook.com>
 <alpine.DEB.2.10.1801171348190.86895@chino.kir.corp.google.com>
 <alpine.DEB.2.10.1801191251080.177541@chino.kir.corp.google.com>
 <20180120123251.GB1096857@devbig577.frc2.facebook.com>
 <alpine.DEB.2.10.1801221420120.16871@chino.kir.corp.google.com>
 <20180123155301.GS1526@dhcp22.suse.cz>
 <alpine.DEB.2.10.1801231416330.254281@chino.kir.corp.google.com>
 <20180124082041.GD1526@dhcp22.suse.cz>
 <alpine.DEB.2.10.1801241340310.24330@chino.kir.corp.google.com>
 <20180124140805.b4eb437c6fe9dadb67a32e8a@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180124140805.b4eb437c6fe9dadb67a32e8a-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed 24-01-18 14:08:05, Andrew Morton wrote:
[...]
> Can we please try to narrow the scope of this issue by concentrating on
> the userspace interfaces?  David believes that the mount option and
> memory.oom_group will disappear again in the near future, others
> disagree.

Mount option is the cgroups maintainers call. And they seemed to be OK
with it.
I've tried to explain that oom_group is something that is semantically
sane and something we want to support because there are workloads which
simply do not work properly when only a subset is torn down. As such it
is not an API hazard AFAICS.
-- 
Michal Hocko
SUSE Labs
