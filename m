From: Juri Lelli <juri.lelli@arm.com>
Subject: Re: [PATCH] cgroup: disable irqs while holding css_set_lock
Date: Tue, 7 Jun 2016 14:30:09 +0100
Message-ID: <20160607133009.GS9340@e106622-lin>
References: <aa70cd2645974808785960bfb0ddfebdec6e3095.1465243518.git.bristot@redhat.com>
 <20160607101402.GP9340@e106622-lin>
 <bda9f957-6f4b-5b95-f752-1c6a9a26aa79@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bda9f957-6f4b-5b95-f752-1c6a9a26aa79@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Bristot de Oliveira <daolivei@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>, "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org

On 07/06/16 09:39, Daniel Bristot de Oliveira wrote:
> Ciao Juri,
> 

Ciao, :-)

> On 06/07/2016 07:14 AM, Juri Lelli wrote:
> > Interesting. And your test is using cpuset controller to partion
> > DEADLINE tasks and then modify groups concurrently?
> 
> Yes. I was studying the partitioning/admission control of the
> deadline scheduler, to document it.
> 
> I was using the minimal task from sched deadline's documentation
> as the load (the ./m in the bellow script). 
> 
> Here is the script I was using in the test:

Thanks for sharing it. It is somewhat similar to some of my test
scripts, but I've got a question below.

> -----------%<------------------------------------------------------------
> #!/bin/sh
> 
> # I am running on a 8 cpus box, you need to adjust the
> # cpu mask to match to your cpu topology.
> 
> cd /sys/fs/cgroup/cpuset
> 
> # global settings
> # echo 1 > cpuset.cpu_exclusive
> echo 0 > cpuset.sched_load_balance
> 
> # a cpuset to run ordinary load:
> 
> if [ ! -d ordinary ]; then
> 	mkdir ordinary
> 	echo 0-3 > ordinary/cpuset.cpus
> 	echo 0 > ordinary/cpuset.mems
> 	echo 0 > ordinary/cpuset.cpu_exclusive
> 	# the load balance can be enabled on this cpuset.
> 	echo 1 > ordinary/cpuset.sched_load_balance
> fi
> 
> # move all threads to ordinary cpuset 
> ps -eL -o lwp | while read tid; do
> 	echo $tid >> ordinary/tasks 2> /dev/null || echo "thread $tid is pinned or died"
> done
> 
> echo $$ > ordinary/tasks
> cat /proc/self/cpuset
> ~/m &
> 
> # a single cpu cpuset (partitioned)
> if [ ! -d partitioned ]; then
> 	mkdir partitioned
> 	echo 4 > partitioned/cpuset.cpus
> 	echo 0 > partitioned/cpuset.mems
> 	echo 0 > partitioned/cpuset.cpu_exclusive
> fi
> 
> echo $$ > partitioned/tasks
> cat /proc/self/cpuset
> ~/m &
> 
> # a set of cpus (clustered)
> if [ ! -d clustered ]; then
> 	mkdir clustered
> 	echo 5-7 > clustered/cpuset.cpus
> 	echo 0 > clustered/cpuset.mems
> 	echo 0 > clustered/cpuset.cpu_exclusive

So, this and the partitioned one could actually overlap, since we don't
set cpu_exclusive. Is that right?

I guess affinity mask of both m processes gets set correclty, but I'm
not sure if we are missing one check in the admission control. Can you
actually create two overlapping sets and get DEADLINE tasks running in
them? For example, what happens if partitioned is [4] and clustered is
[4-7]? Does setattr() fail?

It is not really related to this patch, I'm just wondering if there is
another problem lying around.

Thanks,

- Juri

> 	# the load balance can be enabled on this cpuset.
> 	echo 1 > clustered/cpuset.sched_load_balance
> fi
> 
> echo $$ > clustered/tasks
> cat /proc/self/cpuset
> ~/m
> ----------->%------------------------------------------------------------
> 
> The problem rarely reproduces.
> 
> -- Daniel
> 
