From: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [RFC 0/2] Introduce cgroup.top interface
Date: Fri, 26 Aug 2022 09:15:01 +0800
Message-ID: <20220826011503.103894-1-lujialin4@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Xiu Jianfeng <xiujianfeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Cgroup is used to organize and manage resource available processes.
Currently there are no handy tool for gathering reousrce usage
information for each and every child cgroups, makes it hard to detect
resource outage and debug resource issues.

To overcome this, we present the cgroup.top interface. Just like the
top command, user is able to easily gather resource usage information
, allowing user to detect and respond to resource outage in child
cgroups

Show case:
/ # mount -t cgroup2 none /sys/fs/cgroup
/ # cd /sys/fs/cgroup/
/sys/fs/cgroup # echo "+memory" > cgroup.subtree_control
/sys/fs/cgroup # mkdir test1
/sys/fs/cgroup # mkdir test2
/sys/fs/cgroup # mkdir test3
/sys/fs/cgroup # echo $$ > test2/cgroup.procs
/sys/fs/cgroup # cd /test
/test # ./memcg_malloc 512000 &
/test # ./memcg_malloc 512000 &
/test # ./memcg_malloc 512000 &
/test # cd /sys/fs/cgroup
/sys/fs/cgroup # echo $$ > test1/cgroup.procs
/sys/fs/cgroup # cd /test
/test # ./memcg_malloc 512000 &
/test # cd /sys/fs/cgroup
/sys/fs/cgroup # echo $$ > test3/cgroup.procs
/sys/fs/cgroup # cat cgroup.top
memory top:
name            usage           anon            file            kernel
test2           1974272         1671168         0               270336
test1           700416          569344          0               94208
test3           196608          86016           0               86016


Lu Jialin (1):
  memcg: Adapt cgroup.top into per-memcg

Xiu Jianfeng (1):
  cgroup: Introduce per-cgroup resource top show interface

 include/linux/cgroup-defs.h |  1 +
 kernel/cgroup/cgroup.c      | 20 +++++++++
 mm/memcontrol.c             | 87 +++++++++++++++++++++++++++++++++++++
 3 files changed, 108 insertions(+)

-- 
2.17.1

