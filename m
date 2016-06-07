From: Daniel Bristot de Oliveira <daolivei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: disable irqs while holding css_set_lock
Date: Tue, 7 Jun 2016 09:39:13 -0300
Message-ID: <bda9f957-6f4b-5b95-f752-1c6a9a26aa79@redhat.com>
References: <aa70cd2645974808785960bfb0ddfebdec6e3095.1465243518.git.bristot@redhat.com>
 <20160607101402.GP9340@e106622-lin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160607101402.GP9340@e106622-lin>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Juri Lelli <juri.lelli-5wv7dgnIgG8@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Luis Claudio R. Goncalves" <lgoncalv-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Ciao Juri,

On 06/07/2016 07:14 AM, Juri Lelli wrote:
> Interesting. And your test is using cpuset controller to partion
> DEADLINE tasks and then modify groups concurrently?

Yes. I was studying the partitioning/admission control of the
deadline scheduler, to document it.

I was using the minimal task from sched deadline's documentation
as the load (the ./m in the bellow script). 

Here is the script I was using in the test:
-----------%<------------------------------------------------------------
#!/bin/sh

# I am running on a 8 cpus box, you need to adjust the
# cpu mask to match to your cpu topology.

cd /sys/fs/cgroup/cpuset

# global settings
# echo 1 > cpuset.cpu_exclusive
echo 0 > cpuset.sched_load_balance

# a cpuset to run ordinary load:

if [ ! -d ordinary ]; then
	mkdir ordinary
	echo 0-3 > ordinary/cpuset.cpus
	echo 0 > ordinary/cpuset.mems
	echo 0 > ordinary/cpuset.cpu_exclusive
	# the load balance can be enabled on this cpuset.
	echo 1 > ordinary/cpuset.sched_load_balance
fi

# move all threads to ordinary cpuset 
ps -eL -o lwp | while read tid; do
	echo $tid >> ordinary/tasks 2> /dev/null || echo "thread $tid is pinned or died"
done

echo $$ > ordinary/tasks
cat /proc/self/cpuset
~/m &

# a single cpu cpuset (partitioned)
if [ ! -d partitioned ]; then
	mkdir partitioned
	echo 4 > partitioned/cpuset.cpus
	echo 0 > partitioned/cpuset.mems
	echo 0 > partitioned/cpuset.cpu_exclusive
fi

echo $$ > partitioned/tasks
cat /proc/self/cpuset
~/m &

# a set of cpus (clustered)
if [ ! -d clustered ]; then
	mkdir clustered
	echo 5-7 > clustered/cpuset.cpus
	echo 0 > clustered/cpuset.mems
	echo 0 > clustered/cpuset.cpu_exclusive
	# the load balance can be enabled on this cpuset.
	echo 1 > clustered/cpuset.sched_load_balance
fi

echo $$ > clustered/tasks
cat /proc/self/cpuset
~/m
----------->%------------------------------------------------------------

The problem rarely reproduces.

-- Daniel
