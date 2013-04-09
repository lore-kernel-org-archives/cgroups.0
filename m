From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/8] cgroup: implement cgroup_from_id()
Date: Tue, 9 Apr 2013 11:12:09 +0800
Message-ID: <51638709.207@huawei.com>
References: <51627DA9.7020507@huawei.com> <51627DEB.4090104@huawei.com> <20130408154319.GD3021@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130408154319.GD3021-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 2013/4/8 23:43, Tejun Heo wrote:
> On Mon, Apr 08, 2013 at 04:20:59PM +0800, Li Zefan wrote:
>> +/**
>> + * cgroup_from_id - lookup cgroup by id
>> + * @ss: cgroup subsys to be looked into.
>> + * @id: the id
>> + *
>> + * Returns pointer to cgroup if there is valid one with id.
>> + * NULL if not. Should be called under rcu_read_lock()
>> + */
>> +struct cgroup *cgroup_from_id(struct cgroup_subsys *ss, int id)
>> +{
> 
> 	rcu_lockdep_assert(rcu_read_lock_held(), ..
.);

will update

> 
>> +	return idr_find(&ss->root->cgroup_idr, id);
