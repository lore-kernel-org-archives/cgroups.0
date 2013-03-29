From: Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Error: /bin/echo: write error: No space left on device
Date: Fri, 29 Mar 2013 19:32:32 +0300
Message-ID: <CAGXs5wUE5MaazKPuS9F3cyoFytCeuH9g8FFBMctHa6pDJ3P6xg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        bh=XTKknM68oq463mQUBgBubFBCJAHJspD+0DPU3GPCN3I=;
        b=VcehE6oe50HPUGnfiulGsZ5Vx1FydXJhJbtbp4rom9Nkfy3lyAmvTFzG4IiaCshEIq
         QKeXuHD0Iw5J3xlZumLMKHgALtv8kBKQCl+cC4d7wcL9vuTfxRbaM1/GioHbS5mOhLbu
         D+AMgW4SM6ycAO/lh/7r0yTBbfPzsB52bHyTjMfh4oylMrW9JhETsmD9nVhTz1Pf/tlM
         7X/+qY/ypSQq4OuK5OumMNgFzh/bNuNnkibnHc0sdUQpXqS448eEe0HE3nMvwjhAzzyK
         nWGNgfOHu6CupXx8iUTjSKACZ0HvR7pOhEAYPCTIOjoCAmyD4XGFoLLTAgzHGojWEYNv
         JsjA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

I tried this sequence of actions according to
Documentation/cgroups/cgroups.txt:

  mount -t tmpfs cgroup_root /sys/fs/cgroup
  mkdir /sys/fs/cgroup/cpuset
  mount -t cgroup cpuset -ocpuset /sys/fs/cgroup/cpuset
  cd /sys/fs/cgroup/cpuset
  mkdir Charlie
  cd Charlie
  /bin/echo 2-3 > cpuset.cpus


[root@h Charlie]# /bin/echo 1 > cpuset.mems
/bin/echo: write error: Invalid argument
[root@h Charlie]# /bin/echo $$ > tasks
/bin/echo: write error: No space left on device


Any ideas why are these two error ?
BTW:

[root@h Charlie]# df -h
df: =91/sys/fs/cgroup/systemd=92: No such file or directory
df: =91/sys/fs/cgroup/cpu,cpuacct=92: No such file or directory
df: =91/sys/fs/cgroup/memory=92: No such file or directory
df: =91/sys/fs/cgroup/devices=92: No such file or directory
df: =91/sys/fs/cgroup/freezer=92: No such file or directory
df: =91/sys/fs/cgroup/net_cls=92: No such file or directory
df: =91/sys/fs/cgroup/blkio=92: No such file or directory
df: =91/sys/fs/cgroup/perf_event=92: No such file or directory
=46ilesystem      Size  Used Avail Use% Mounted on
devtmpfs        991M     0  991M   0% /dev
tmpfs          1002M  324K 1002M   1% /dev/shm
tmpfs          1002M  2.9M  999M   1% /run
tmpfs          1002M     0 1002M   0% /sys/fs/cgroup

So it seems that there is 1002M available on  /sys/fs/cgroup

any ideas?
Kevin
