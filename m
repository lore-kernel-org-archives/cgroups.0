From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 2/5] memcg: provide root figures from system totals
Date: Tue, 19 Mar 2013 13:55:09 +0100
Message-ID: <20130319125509.GF7869@dhcp22.suse.cz>
References: <1362489058-3455-1-git-send-email-glommer@parallels.com>
 <1362489058-3455-3-git-send-email-glommer@parallels.com>
 <20130319124650.GE7869@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130319124650.GE7869-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>

On Tue 19-03-13 13:46:50, Michal Hocko wrote:
> On Tue 05-03-13 17:10:55, Glauber Costa wrote:
> > For the root memcg, there is no need to rely on the res_counters if hierarchy
> > is enabled The sum of all mem cgroups plus the tasks in root itself, is
> > necessarily the amount of memory used for the whole system. Since those figures
> > are already kept somewhere anyway, we can just return them here, without too
> > much hassle.
> > 
> > Limit and soft limit can't be set for the root cgroup, so they are left at
> > RESOURCE_MAX. Failcnt is left at 0, because its actual meaning is how many
> > times we failed allocations due to the limit being hit. We will fail
> > allocations in the root cgroup, but the limit will never the reason.
> 
> I do not like this very much to be honest. It just adds more hackery...
> Why cannot we simply not account if nr_cgroups == 1 and move relevant
> global counters to the root at the moment when a first group is
> created?

OK, it seems that the very next patch does what I was looking for. So
why all the churn in this patch?
Why do you want to make root even more special?
[...]
-- 
Michal Hocko
SUSE Labs
