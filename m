From: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Subject: Getting a process cgroup's path without sleeping
Date: Wed, 20 May 2015 15:51:31 +0300
Message-ID: <555C8353.2090002@kyup.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello list,


I'm currently working on a modification to the kernel and I need to
query if the current is in the root cgroup or not. This can easily be
achieved by using task_cgroup_path, however it acquires cgroup_mutex
which can sleep. Unfortunately my usecase involves calling
task_cgroup_path in rcu read-side critical section and as you can
imagine this makes the RCU lock checking code to splat.

So my question is how to be able to safely get the cgroup path of the
current process (or any process) under rcu read side critical sections
e.g. not having to acquire the cgroup_mutex?


Regards,
Nikolay
