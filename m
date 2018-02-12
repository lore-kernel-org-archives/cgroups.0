From: Chengguang Xu <cgxu519-mVuRI66OGLPQT0dZR+AlfA@public.gmane.org>
Subject: Question about  strange phenomenon of cgroup blkio stat
Date: Mon, 12 Feb 2018 10:50:11 +0800
Message-ID: <BF15784C-1B05-4294-8994-018A0D82F6D6@icloud.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;     s=04042017;
 t=1518403817;  bh=hucwcXf4MeShUglcnSJ/sJlq3CQoDTYkY9AsIFrjWrg=;
        h=From:Content-type:MIME-version:Subject:Message-id:Date:To;
        b=C7TuWaSiKQihk81HuQz0Sn/toqmAAMY7H/n0NwitDsCTK07ZY+V0V5ZZiZX9cWgQc
 UEb1Sv4IAclKaD71o4W+8beeYgJMOd/JYmVHUb5Nu9KXkOzPWs0wtR8k3jO+dqQw38
 yw5pF9lsJ9lvLiDC8mviVLBD87+ggCKwcLWgStGDY9gBwlFJWFz64Fm2ji0RbG7JRA
 YwFVmv9n6YeBXI756hH00aFuJjVfoj3PKhekuGd3Cbh20fCZSOOVyOVfQUn86yxJFs
 fjnU1TS+5ZS3drGf6i6tVUfTcR3c4vFLj4TggaI0UhmrJBt1sGHGbCtoeZLv0w3In9
 JtcQNY1Uh8nhw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi All

I=A1=AFm new to cgroup and block layer, recently I found a strange =
phenomenon in cgroup blkio stat as blow.

I setup a blkio cgroup and wrote 1GB data in direct mode, but the stat =
indicated almost wrote 2.56GB,=20

I tested several times in physical machine on cgroup v1 & v2 and both =
were same results, but interesting

thing is when testing on VM(virtual machine) the stat is exactly the =
same as the data size had written.

Could anyone give me a hint or explanation for this?


testing info:
-------------------------------------------------------------

$ uname -r
4.15.2

$ echo $$
4242

$ cat /cgroup2/22/cgroup.procs
4242
13868

$ cat cgroup.controllers
io memory

$ df /mnt/sdb1
Filesystem     1K-blocks     Used Available Use% Mounted on
/dev/sdb1      209612800 18102292 191510508   9% /mnt/sdb1

$ lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sdb      8:16   0 557.9G  0 disk
=A9=C0=A9=A4sdb2   8:18   0 357.9G  0 part
=A9=B8=A9=A4sdb1   8:17   0   200G  0 part /mnt/sdb1
sdc      8:32   0 557.9G  0 disk
=A9=C0=A9=A4sdc2   8:34   0   100G  0 part
=A9=C0=A9=A4sdc3   8:35   0   100G  0 part
=A9=C0=A9=A4sdc1   8:33   0   100G  0 part
=A9=B8=A9=A4sdc4   8:36   0 257.9G  0 part
sda      8:0    0 557.9G  0 disk
=A9=C0=A9=A4sda2   8:2    0 542.2G  0 part /
=A9=B8=A9=A4sda1   8:1    0  15.6G  0 part [SWAP]


$ dd if=3D/dev/zero of=3D/mnt/sdb1/22/test bs=3D1M count=3D1024 =
oflag=3Ddirect
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 2.47852 s, 433 MB/s


$ cat /cgroup2/22/io.stat
8:0 rbytes=3D1105920 wbytes=3D36864 rios=3D59 wios=3D4
8:16 rbytes=3D10330624 wbytes=3D2693799936 rios=3D102 wios=3D4105




Thanks,
Chengguang.


