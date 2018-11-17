From: Andrei Vagin <avagin@gmail.com>
Subject: linux-next: Unable to mount a cgroup file system
Date: Sat, 17 Nov 2018 13:18:06 -0800
Message-ID: <CANaxB-wD3JYsnqP1=fw0qQfvc=qtEJN9Va0tUg64iHEHKcajAQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=KhH8xCamSqNRp3Ejs9BDBB0c9QFFTmbr8QUWAeX2qG0=;
        b=jeJHDryKt7n5/75taGa64hNdSJR9NXXvDFfR6Dk+lZNUl9QZO+tK+p1outEJb6TQGG
         mJqEvNWYgqtChFtnhP2k9uSfdAUrrpjNjK5++5psRtHBi11xVg4TR6oJelv+m4uiGCWL
         kOy7XblmW345bB/ATP8NHlceJt7EomNDudRaeQBs4aSPvPMMS6Z59e1C2FnMsaK5A8oE
         tWqOQ5raJDNKw8DpK2bmXjD0qpT8v6OX7wNDdNwBdhygrcjVCkWotUZzUcLLWqziBfli
         2ntbH23IIMphEzBkIgC+1nPXV3NRQQHeobC43uV1hrPicbnymyEzlfscxeOTivRCRwnA
         fUtQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Howells <dhowells@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Cyrill Gorcunov <gorcunov@openvz.org>

Hello,

We run CRIU tests on linux-next kernels. Today, I found that our test
robot hangs up on mounting a cgroup file system.

https://travis-ci.org/avagin/linux/jobs/455732006

  632 ?        Ssl    0:00 /usr/bin/containerd
  843 ?        Sl     0:00  \_ containerd-shim -namespace moby
-workdir /var/lib/containerd/io.containerd.runtime.v1.linux/moby/c2311352d53eed1f5094580102e41c2a02eaf98b8626c86ccf314599101b26
  862 pts/0    Ss+    0:00      \_ python test/zdtm.py run -T
zdtm/static/cgroup.*
 1652 pts/0    S+     0:00          \_ flock zdtm_mount_cgroups.lock
./zdtm_umount_cgroups
 1653 pts/0    S+     0:00              \_ /bin/sh ./zdtm_umount_cgroups
 1659 pts/0    D+     0:06                  \_ mount -t cgroup -o
none,name=zdtmtst.defaultroot zdtm zdtm.9QFGko

[root@fc24 ~]# cat /proc/1659/stack
[<0>] msleep+0x38/0x40
[<0>] cgroup1_get_tree+0x4e1/0x749
[<0>] vfs_get_tree+0x5e/0x140
[<0>] do_mount+0x326/0xc70
[<0>] ksys_mount+0xba/0xd0
[<0>] __x64_sys_mount+0x21/0x30
[<0>] do_syscall_64+0x60/0x210
[<0>] entry_SYSCALL_64_after_hwframe+0x49/0xbe
[<0>] 0xffffffffffffffff

[root@fc24 ~]# cat /proc/1659/cgroup  | grep zdtm
13:name=zdtmtst.defaultroot:/
12:name=zdtmtst:/

[root@fc24 ~]# strace -fp 1659
strace: Process 1659 attached
mount("zdtm", "/criu/test/zdtm.9QFGko", "cgroup", MS_MGC_VAL,
"none,name=zdtmtst.defaultroot") = ? ERESTARTNOINTR (To be restarted)
mount("zdtm", "/criu/test/zdtm.9QFGko", "cgroup", MS_MGC_VAL,
"none,name=zdtmtst.defaultroot") = ? ERESTARTNOINTR (To be restarted)
mount("zdtm", "/criu/test/zdtm.9QFGko", "cgroup", MS_MGC_VAL,
"none,name=zdtmtst.defaultroot") = ? ERESTARTNOINTR (To be restarted)
mount("zdtm", "/criu/test/zdtm.9QFGko", "cgroup", MS_MGC_VAL,
"none,name=zdtmtst.defaultroot") = ? ERESTARTNOINTR (To be restarted)
mount("zdtm", "/criu/test/zdtm.9QFGko", "cgroup", MS_MGC_VAL,
"none,name=zdtmtst.defaultroot") = ? ERESTARTNOINTR (To be restarted)

Steps to reproduce:
I don't know how to reproduce this issue without running criu tests. I
tried to create a simple reproducer, but I failed. So I created a
docker container and the problem can be reproduced by running this
command:
docker run --rm -it --privileged -v /lib/modules:/lib/modules --tmpfs
/run docker.io/avagin/criu-fc29-cgroup python test/zdtm.py run -T
'zdtm/static/cgroup.*'

I found that something wrong is in
[16ec1a5d58ea67ba737d3a66efe9e53c6bb149f7] kernfs, sysfs, cgroup,
intel_rdt: Support fs_context

https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?h=next-20181116&id=16ec1a5d58ea67ba737d3a66efe9e53c6bb149f7

Thanks,
Andrei
