From: chenzhou <chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [QUESTION] Dying cgroups in subsystem cpu, pids and named hierarchy
 systemd
Date: Tue, 15 Dec 2020 14:36:48 +0800
Message-ID: <35659595-5a3f-e0e4-1f61-15af6f1367e3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yang Yingliang <yangyingliang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Libin (Huawei)" <huawei.libin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi all,

When i do some tests with kernel-4.19.x=EF=BC=8Ci found some dying cgroups.

There are dying cgroup in subsystem cpu/cpuacct, memory, pids and named hie=
rarchy systemd.

The root cause of dying cgroups in memory subsystem is that some charged pa=
ges aren't gone.

I don't figure out why there are dying cgroup in cpu, pids and named hierar=
chy systemd.

I used to turn on/off Delegate and do operation "systemctl daemon-reload" i=
n the machine,

but now can't reproduce it.

Is this normal and what may cause this or any suggestions about this?


The details about the machine with problem is as below:
# mount -t cgroup
cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relati=
me,seclabel,xattr,release_agent=3D/usr/lib/systemd/systemd-cgroups-agent,na=
me=3Dsystemd)
cgroup on /sys/fs/cgroup/pids type cgroup (rw,nosuid,nodev,noexec,relatime,=
seclabel,pids)
cgroup on /sys/fs/cgroup/memory type cgroup (rw,nosuid,nodev,noexec,relatim=
e,seclabel,memory)
cgroup on /sys/fs/cgroup/blkio type cgroup (rw,nosuid,nodev,noexec,relatime=
,seclabel,blkio)
cgroup on /sys/fs/cgroup/devices type cgroup (rw,nosuid,nodev,noexec,relati=
me,seclabel,devices)
cgroup on /sys/fs/cgroup/perf_event type cgroup (rw,nosuid,nodev,noexec,rel=
atime,seclabel,perf_event)
cgroup on /sys/fs/cgroup/rdma type cgroup (rw,nosuid,nodev,noexec,relatime,=
seclabel,rdma)
cgroup on /sys/fs/cgroup/freezer type cgroup (rw,nosuid,nodev,noexec,relati=
me,seclabel,freezer)
cgroup on /sys/fs/cgroup/net_cls,net_prio type cgroup (rw,nosuid,nodev,noex=
ec,relatime,seclabel,net_cls,net_prio)
cgroup on /sys/fs/cgroup/cpuset type cgroup (rw,nosuid,nodev,noexec,relatim=
e,seclabel,cpuset)
cgroup on /sys/fs/cgroup/hugetlb type cgroup (rw,nosuid,nodev,noexec,relati=
me,seclabel,hugetlb)
memory on /cgroup/memory type cgroup (rw,relatime,seclabel,memory)
cpu,cpuacct on /sys/fs/cgroup/cpu,cpuacct type cgroup (rw,relatime,seclabel=
,cpu,cpuacct)

# cat /proc/cgroups
#subsys_name    hierarchy    num_cgroups    enabled
cpuset    12    109    1
cpu    10    110    1
cpuacct    10    110    1
blkio    4    109    1
memory    3    2571    1
devices    5    109    1
freezer    9    109    1
net_cls    11    1    1
perf_event    6    1    1
net_prio    11    1    1
hugetlb    13    1    1
pids    2    480    1
...

# crash vmlinux /proc/kcore
crash> list cgroup_roots
ffff000081272558
...

list -H ffff000081272558 -s cgroup_root.subsys_mask,hierarchy_id,cgrp.nr_dy=
ing_descendants -l cgroup_root.root_list
ffff8007ff67c6f8        // cpu,cpuacct
  subsys_mask =3D 6
  hierarchy_id =3D 10
  cgrp.nr_dying_descendants =3D 1,
...
ffff8007ff6726f8        // memory
  subsys_mask =3D 16
  hierarchy_id =3D 3
  cgrp.nr_dying_descendants =3D 2036,
ffff800fb579c6f8        // pids
  subsys_mask =3D 2048
  hierarchy_id =3D 2
  cgrp.nr_dying_descendants =3D 1,
ffff800fb57986f8        // named systemd
  subsys_mask =3D 0
  hierarchy_id =3D 1
  cgrp.nr_dying_descendants =3D 1,
...


For the cpu subsystem, the dying cgroup is /sys/fs/cgroup/cpu/user.slice:

crash> p root_task_group.css.cgroup
$4 =3D (struct cgroup *) 0xffff8007ff67c010
crash> cgroup_subsys_state ffff8007ff67c010 -ox
struct cgroup_subsys_state {
  [ffff8007ff67c010] struct cgroup *cgroup;
  [ffff8007ff67c018] struct cgroup_subsys *ss;
  [ffff8007ff67c020] struct percpu_ref refcnt;
  [ffff8007ff67c058] struct list_head sibling;
  [ffff8007ff67c068] struct list_head children;
  [ffff8007ff67c078] struct list_head rstat_css_node;
  [ffff8007ff67c088] int id;
  [ffff8007ff67c08c] unsigned int flags;
  [ffff8007ff67c090] u64 serial_nr;
  [ffff8007ff67c098] atomic_t online_cnt;
  [ffff8007ff67c0a0] struct work_struct destroy_work;
  [ffff8007ff67c0e0] struct rcu_work destroy_rwork;
  [ffff8007ff67c138] struct cgroup_subsys_state *parent;
}
SIZE: 0x130
crash> list -H ffff8007ff67c068 -s cgroup_subsys_state.cgroup -l cgroup_sub=
sys_state.sibling
ffff800faff65848
  cgroup =3D 0xffff800faff65800
ffff800fa18b1048
  cgroup =3D 0xffff800fa18b1000
ffff800fa22c0848
  cgroup =3D 0xffff800fa22c0800
ffff800fa940e048
  cgroup =3D 0xffff800fa940e000
crash>
crash> cgroup.self.refcnt,flags,kn 0xffff800fa18b1000 -x
  self.refcnt =3D {
    count =3D {
      counter =3D 0x3
    },
    percpu_count_ptr =3D 0xfffefdf041334c83,
    release =3D 0xffff0000801c1ea0 <css_release>,
    confirm_switch =3D 0x0,
    force_atomic =3D 0x0,
    rcu =3D {
      next =3D 0xffff80083365da30,
      func =3D 0xffff0000804fb748 <percpu_ref_switch_to_atomic_rcu>
    }
  },
  flags =3D 0x0
  kn =3D 0xffff800bbdb1b110
crash>
crash> kernfs_node.name 0xffff800bbdb1b110
  name =3D 0xffff800fa54d9c00 "user.slice"


Thanks,

Chen Zhou

