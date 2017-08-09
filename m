From: wang Yu <yuwang668899-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: memcg Can't context between v1 and v2 because css->refcnt not released
Date: Wed, 9 Aug 2017 15:06:34 +0800
Message-ID: <CADK2BfzM9V=C3Kk6v714K3NVX58Q6pEaAMiHDGSyr6PakC2O=w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=o3i7lxL0wX5yewEsdPrEB6qIZoIOm1CHsL+UBTok9mM=;
        b=MrQmRAMfi6rvxc5xl4fQSOlBJURRvxMgqI1hT0ybqB5+zX8rQAyeQbvkS3Z8zBEc49
         Fm5uN9CCpM919Y09sQWzv3Sn9T9Jyp7Ns5gLN1loKM3yOVY2ILGLXYI21caSa4K3NcHt
         u1mX5smgtU4vsBOlaVIXQtg5zhQf0UeEvD6OD6vJnsYWGtQa6x8vhWd7VgKL0fd0ioke
         JT+exp6Pj0rVhkNAQoH52NQOyDxRQH1izqlt+StFKbTCHznogFJxc/GrzKSbex+Yn9Em
         Ep/qi1OSZlj6VRxKolF2bOHuX8Ft2XkpFRQLg0GiHPQP/SVd+oIcZKpkFkoJ1CbvPbI1
         6WYA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hello Johannes ,Michal,and Tejun:

  i using memcg v1,  but some reason  i want to context to  memcg v2,
but i can't, here is my step:
#cat /proc/cgroups
#subsys_name hierarchy num_cgroups enabled
 memory 5 1 1
#cd /sys/fs/cgroup/memory
#mkdir a
#echo 0 > a/cgroup.procs
#sleep 1
#echo 0 > cgroup.procs
#cat /proc/cgroups
#subsys_name hierarchy num_cgroups enabled
 memory 5 2 1
the num_cgroups not go to "1"
so it will lead to can't context to memcg 2
#cd ..
#umount memory
umount: /sys/fs/cgroup/memory: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))

  and i have tracked  the root cause, i found that "b2052564e66d mm:
memcontrol: continue cache reclaim from offlined groups"from Johannes
Weiner, remove mem_cgroup_reparent_charges when mem_cgroup_css_offline, so
the css->refcount  not go to "0", so the css_release not call when rmdir
cgroup, and nr_cgroups not released.
  so i want to ask does it reasonable can't context between v1 and v2
