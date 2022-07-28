From: Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup/cpuset: Keep current cpus list if cpus
 affinity was explicitly set
Date: Thu, 28 Jul 2022 17:50:01 +0100
Message-ID: <xhsmhbkt9dvwm.mognet@vschneid.remote.csb>
References: <20220728005815.1715522-1-longman@redhat.com>
 <20220728144420.GA27407@blackbody.suse.cz>
 <a58852b4-313a-9271-f31d-f79a91ec188b@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659027005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kIy76qh/yn6fLhiFpSUVtVzXiaOXTimgQYvl1mAlPk8=;
        b=izCOrgwX+vubwJogOZbdPORq/zVRGFxL1KvCRJypQH5E3BE541Tu8S/40Vp3HI8khUEmwG
        VvrsAEJA3necD53s72ICswVda39IiiZQ6zmz4n/8oUwz4NaFa8k6DszEhFCNLUFFdIEX0p
        rAQuDAjsSvRbUBiTueQJkIaZsXknUNU=
In-Reply-To: <a58852b4-313a-9271-f31d-f79a91ec188b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 28/07/22 10:59, Waiman Long wrote:
> On 7/28/22 10:44, Michal Koutn=C3=BD wrote:
>> This should apply only to tasks that were extracted out of the root
>> cgroup, no? (OK, those are all processes practically.)
> The reset is done on all cgroups in a particular subtree. In the case of
> cgroup root, it is all the processes in the system.
>>

I've been briefly playing with this, tasks in the cgroup root don't seem
affected on my end (QEMU + buildroot + latest tip/sched/core):

  $ mount -t cgroup2 none /sys/fs/cgroup
  $ /root/loop.sh &
  $ PID=3D$!
  $ taskset -pc 2-3 $PID
  pid 177's current affinity list: 0-3
  pid 177's new affinity list: 2,3
  $ echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
  $ taskset -pc $PID
  pid 177's current affinity list: 2,3

However tasks extracted out as mentioned by Michal definitely are:

  $ mount -t cgroup2 none /sys/fs/cgroup
  $ /root/loop.sh &
  $ PID=3D$!
  $ taskset -pc 2-3 $PID
  pid 172's current affinity list: 0-3
  pid 172's new affinity list: 2,3
  $ mkdir /sys/fs/cgroup/foobar
  $ echo $PID > /sys/fs/cgroup/foobar/cgroup.procs
  $ taskset -pc $PID
  pid 172's current affinity list: 2,3
  $ echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
  $ taskset -pc $PID
  pid 172's current affinity list: 0-3

IIUC this is just what happens anytime a task gets migrated to a new
cpuset. Initially loop.sh remains attached to the root cpuset, and the echo
+cpuset migrates it to the /foobar one.

Does that match what you're seeing?

