From: "=?GBK?B?0/fN+w==?=" <yuwang.yuwang-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>
Subject: memcg Can't context between v1 and v2 because css->refcnt not
 released
Date: Wed, 09 Aug 2017 14:44:23 +0800
Message-ID: <D5B0D047.344%yuwang.yuwang@alibaba-inc.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1502261058; h=Date:Subject:From:To:Message-ID:Mime-version:Content-type;
        bh=o3i7lxL0wX5yewEsdPrEB6qIZoIOm1CHsL+UBTok9mM=;
        b=GXJ0Vf3C/ycjcAfqmOEPaJEl0erRpxo8gcr3eWA4ZBNPq583GS3dRclcRW3JsY4MROhX67ozBTg9Nx5D9Hp9yTyrYa0Tm35lkwYqzjOoGjQeXSAvuumEWp2xP4G69S+YzihWgwMT7wy5S1ZL3J8koE+rC+Z/5Rwexp4PA6zg44w=
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
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

