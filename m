From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] memcg: add RCU locking around
 css_for_each_descendant_pre() in memcg_offline_kmem()
Date: Fri, 27 May 2016 13:19:35 -0400
Message-ID: <20160527171934.GA2531@cmpxchg.org>
References: <20160526203018.GG23194@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160526203018.GG23194-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, May 26, 2016 at 04:30:18PM -0400, Tejun Heo wrote:
> memcg_offline_kmem() may be called from memcg_free_kmem() after a css
> init failure.  memcg_free_kmem() is a ->css_free callback which is
> called without cgroup_mutex and memcg_offline_kmem() ends up using
> css_for_each_descendant_pre() without any locking.  Fix it by adding
> rcu read locking around it.
>=20
>  mkdir: cannot create directory =E2=80=9865530=E2=80=99: No space lef=
t on device
>  [  527.241361] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  [  527.241845] [ INFO: suspicious RCU usage. ]
>  [  527.242367] 4.6.0-work+ #321 Not tainted
>  [  527.242730] -------------------------------
>  [  527.243220] kernel/cgroup.c:4008 cgroup_mutex or RCU read lock re=
quired!
>  [  527.243970]
>  [  527.243970] other info that might help us debug this:
>  [  527.243970]
>  [  527.244715]
>  [  527.244715] rcu_scheduler_active =3D 1, debug_locks =3D 0
>  [  527.245463] 2 locks held by kworker/0:5/1664:
>  [  527.245939]  #0:  ("cgroup_destroy"){.+.+..}, at: [<ffffffff81060=
ab5>] process_one_work+0x165/0x4a0
>  [  527.246958]  #1:  ((&css->destroy_work)#3){+.+...}, at: [<fffffff=
f81060ab5>] process_one_work+0x165/0x4a0
>  [  527.248098]
>  [  527.248098] stack backtrace:
>  [  527.249565] CPU: 0 PID: 1664 Comm: kworker/0:5 Not tainted 4.6.0-=
work+ #321
>  [  527.250429] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)=
, BIOS 1.9.1-1.fc24 04/01/2014
>  [  527.250555] Workqueue: cgroup_destroy css_free_work_fn
>  [  527.250555]  0000000000000000 ffff880178747c68 ffffffff8128bfc7 f=
fff880178b8ac40
>  [  527.250555]  0000000000000001 ffff880178747c98 ffffffff8108c297 0=
000000000000000
>  [  527.250555]  ffff88010de54138 000000000000fffb ffff88010de537e8 f=
fff880178747cc0
>  [  527.250555] Call Trace:
>  [  527.250555]  [<ffffffff8128bfc7>] dump_stack+0x68/0xa1
>  [  527.250555]  [<ffffffff8108c297>] lockdep_rcu_suspicious+0xd7/0x1=
10
>  [  527.250555]  [<ffffffff810ca03d>] css_next_descendant_pre+0x7d/0x=
b0
>  [  527.250555]  [<ffffffff8114d14a>] memcg_offline_kmem.part.44+0x4a=
/0xc0
>  [  527.250555]  [<ffffffff8114d3ac>] mem_cgroup_css_free+0x1ec/0x200
>  [  527.250555]  [<ffffffff810ccdc9>] css_free_work_fn+0x49/0x5e0
>  [  527.250555]  [<ffffffff81060b15>] process_one_work+0x1c5/0x4a0
>  [  527.250555]  [<ffffffff81060ab5>] ? process_one_work+0x165/0x4a0
>  [  527.250555]  [<ffffffff81060e39>] worker_thread+0x49/0x490
>  [  527.250555]  [<ffffffff81060df0>] ? process_one_work+0x4a0/0x4a0
>  [  527.250555]  [<ffffffff81060df0>] ? process_one_work+0x4a0/0x4a0
>  [  527.250555]  [<ffffffff810672ba>] kthread+0xea/0x100
>  [  527.250555]  [<ffffffff814cbcff>] ret_from_fork+0x1f/0x40
>  [  527.250555]  [<ffffffff810671d0>] ? kthread_create_on_node+0x200/=
0x200
>=20
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
