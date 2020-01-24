From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: cgroup.procs output problem
Date: Fri, 24 Jan 2020 15:02:16 +0300
Message-ID: <ff3de0d7-b7fe-a12f-f816-3d6f0166e93f@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Dear Tejun and cgroups mailing list users.

During validation of patches for cgoups I've noticed strange behaviour in cgroup v2 

dd with bs=1 reads each 2nd line of cgroup.proc and cgroup.threads file

on Fedora 31 node

[test@localhost ~]$ dd if=/sys/fs/cgroup/cgroup.procs  bs=1 | wc
195+0 records in
195+0 records out
195 bytes copied, 0,000149534 s, 1,3 MB/s
     54      54     195

VvS: it reads 54 lines

[test@localhost ~]$ dd if=/sys/fs/cgroup/cgroup.procs  bs=1000 | wc
0+1 records in
0+1 records out
389 bytes copied, 6,6956e-05 s, 5,8 MB/s
    108     108     389

following one reads twice more, 108 lines.

[test@localhost ~]$ dd if=/sys/fs/cgroup/cgroup.procs  bs=1 | wc
195+0 records in
195+0 records out
195 bytes copied, 0,000123775 s, 1,6 MB/s
     54      54     195

following dd bs=1 reads 54 lines again

[test@localhost ~]$ uname -a
Linux localhost.localdomain 5.5.0-rc6-00150-g82efece #7 SMP Fri Jan 24 12:05:04 MSK 2020 x86_64 x86_64 x86_64 GNU/Linux
[test@localhost ~]$ mount | grep cgroup
cgroup2 on /sys/fs/cgroup type cgroup2 (rw,nosuid,nodev,noexec,relatime,nsdelegate)

I prepared patches for .next seq_file funictions.
https://bugzilla.kernel.org/show_bug.cgi?id=206283
during its validation I've noticed described problem,
and did not found its reason yet.

Thank you,
   Vasily Averin
