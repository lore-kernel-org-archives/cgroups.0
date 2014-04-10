From: xiexiangyou <xiexiangyou-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: A issue when migrating a process's memory using cgroup
Date: Thu, 10 Apr 2014 15:34:08 +0800
Message-ID: <53464970.8060404@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: zhouxiangjiu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, luonengjun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Hi all,

I met a problem when I migrate a process's memory using cgroup.
Two processes, process A and Process B. Process A has 20G memory, I migrate it from node0 to node1, by writing "1" to "cpuset.mems".
It will consume 20s time. At the time, I write process B's "cpuset.cpus" to bind the cpus. But setting "cpuset.cpus" is block untill
the first operation is finished.


So I read the cpuset code in kernel. In the function of "cpuset_write_resmask", Common handling for a write to a "cpus" or "mems" file,
It grabs the "cgroup_mutex" first, and release it until finish writing "cpus" or "mems". But if migrate large size memory
of a process using cpuset, it will consume much time. At the time, other handling for write to "cpuset.cpus" and "cpuset.mems"
will blocked because of "cgroup_mutex".

In this case, I think the "cgroup_mutex" in "cpuset_write_resmask" should be replace by littler granularity lock.


Regards,
-xie
