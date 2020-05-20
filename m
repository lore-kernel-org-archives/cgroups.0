From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Wed, 20 May 2020 18:07:56 +0200
Message-ID: <20200520160756.GE6462@dhcp22.suse.cz>
References: <20200520143712.GA749486@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200520143712.GA749486-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed 20-05-20 15:37:12, Chris Down wrote:
> In Facebook production, we've seen cases where cgroups have been put
> into allocator throttling even when they appear to have a lot of slack
> file caches which should be trivially reclaimable.
> 
> Looking more closely, the problem is that we only try a single cgroup
> reclaim walk for each return to usermode before calculating whether or
> not we should throttle. This single attempt doesn't produce enough
> pressure to shrink for cgroups with a rapidly growing amount of file
> caches prior to entering allocator throttling.
> 
> As an example, we see that threads in an affected cgroup are stuck in
> allocator throttling:
> 
>     # for i in $(cat cgroup.threads); do
>     >     grep over_high "/proc/$i/stack"
>     > done
>     [<0>] mem_cgroup_handle_over_high+0x10b/0x150
>     [<0>] mem_cgroup_handle_over_high+0x10b/0x150
>     [<0>] mem_cgroup_handle_over_high+0x10b/0x150
> 
> ...however, there is no I/O pressure reported by PSI, despite a lot of
> slack file pages:
> 
>     # cat memory.pressure
>     some avg10=78.50 avg60=84.99 avg300=84.53 total=5702440903
>     full avg10=78.50 avg60=84.99 avg300=84.53 total=5702116959
>     # cat io.pressure
>     some avg10=0.00 avg60=0.00 avg300=0.00 total=78051391
>     full avg10=0.00 avg60=0.00 avg300=0.00 total=78049640
>     # grep _file memory.stat
>     inactive_file 1370939392
>     active_file 661635072
> 
> This patch changes the behaviour to retry reclaim either until the
> current task goes below the 10ms grace period, or we are making no
> reclaim progress at all. In the latter case, we enter reclaim throttling
> as before.

Let me try to understand the actual problem. The high memory reclaim has
a target which is proportional to the amount of charged memory. For most
requests that would be SWAP_CLUSTER_MAX though (resp. N times that where
N is the number of memcgs in excess up the hierarchy). I can see to be
insufficient if the memcg is already in a large excess but if the
reclaim can make a forward progress this should just work fine because
each charging context should reclaim at least the contributed amount.

Do you have any insight on why this doesn't work in your situation?
Especially with such a large inactive file list I would be really
surprised if the reclaim was not able to make a forward progress.

Now to your patch. I do not like it much to be honest.
MEM_CGROUP_RECLAIM_RETRIES is quite arbitrary and I neither like it in
memory_high_write because the that is an interruptible context so there
shouldn't be a good reason to give up after $FOO number of failed
attempts. try_charge and memory_max_write are slightly different because
we are invoking OOM killer based on the number of failed attempts.

Also if the current high reclaim scaling is insufficient then we should
be handling that via memcg_nr_pages_over_high rather than effectivelly
unbound number of reclaim retries.

That being said, the changelog should be more specific about the
underlying problem and if the real problem is in the reclaim target then
it should be handled by an increased but still fixed size. If the
throttling is just too aggressive and puts task into sleep even when a
reclaim has been performed then the throttling should be fixed.
-- 
Michal Hocko
SUSE Labs
