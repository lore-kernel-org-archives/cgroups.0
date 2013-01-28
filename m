From: Lord Glauber Costa of Sealand <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v4 3/6] memcg: fast hierarchy-aware child test.
Date: Mon, 28 Jan 2013 12:30:11 +0400
Message-ID: <51063713.90902@parallels.com>
References: <1358862461-18046-1-git-send-email-glommer@parallels.com> <1358862461-18046-4-git-send-email-glommer@parallels.com> <20130125155901.4d3fb00c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130125155901.4d3fb00c.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org

On 01/26/2013 03:59 AM, Andrew Morton wrote:
> On Tue, 22 Jan 2013 17:47:38 +0400
> Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> 
>> Currently, we use cgroups' provided list of children to verify if it is
>> safe to proceed with any value change that is dependent on the cgroup
>> being empty.
>>
>> This is less than ideal, because it enforces a dependency over cgroup
>> core that we would be better off without. The solution proposed here is
>> to iterate over the child cgroups and if any is found that is already
>> online, we bounce and return: we don't really care how many children we
>> have, only if we have any.
>>
>> This is also made to be hierarchy aware. IOW, cgroups with  hierarchy
>> disabled, while they still exist, will be considered for the purpose of
>> this interface as having no children.
> 
> The code comments are a bit unclear.  Did this improve them?
Both versions seem clear to me, so I'll go with yours as a tie breaker =p

One thing to keep in mind:

> - * must be called with cgroup_lock held, unless the cgroup is guaranteed to be
> - * already dead (like in mem_cgroup_force_empty, for instance).  This is
> - * different than mem_cgroup_count_children, in the sense that we don't really
> - * care how many children we have, we only need to know if we have any. It is
> - * also count any memcg without hierarchy as infertile for that matter.
> + * Must be called with cgroup_lock held, unless the cgroup is guaranteed to be
> + * already dead (in mem_cgroup_force_empty(), for instance).  This is different
> + * from mem_cgroup_count_children(), in the sense that we don't really care how
> + * many children we have; we only need to know if we have any.  It also counts
> + * any memcg without hierarchy as infertile.
>   */

In a later patch, I update this text to reflect the fact that the
memcg_mutex will now play this role instead of the cgroup_lock. So I am
just mentioning the cgroup lock here for temporary consistency. We need
to make sure that the later patch still applies, or we'll be left with a
bogus comment.

