From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: Re: [PATCH] memcg: add RCU locking around
 css_for_each_descendant_pre() in memcg_offline_kmem()
Date: Fri, 27 May 2016 11:17:32 +0300
Message-ID: <20160527081732.GB26059@esperanza>
References: <20160526203018.GG23194@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:To:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=NlLwEGAGRpjcrqPqEUtq3KmsJADmCTYVzvKPIq1NVX0=;
 b=PJ7X4OYKBPiDuB/XQKN4pl6vY13tl1QRRmLxk7cx4smxm61jETRGuZ8gEw+x3dWBRiiWJ/mGQ4Up8Zc+YnNXE7uaHg5W1nhaiV5c0ywDpWre6AQ8dhjgEoNf9BRxGceznD107aAc2WWo+7+3n119ukxWrjfqyYcf1MKIkLO0B28=
Content-Disposition: inline
In-Reply-To: <20160526203018.GG23194@mtj.duckdns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

On Thu, May 26, 2016 at 04:30:18PM -0400, Tejun Heo wrote:
> memcg_offline_kmem() may be called from memcg_free_kmem() after a css
> init failure.  memcg_free_kmem() is a ->css_free callback which is
> called without cgroup_mutex and memcg_offline_kmem() ends up using
> css_for_each_descendant_pre() without any locking.  Fix it by adding
> rcu read locking around it.
>=20
>  mkdir: cannot create directory =E2=80=9865530=E2=80=99: No space left =
on device
>  [  527.241361] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  [  527.241845] [ INFO: suspicious RCU usage. ]
>  [  527.242367] 4.6.0-work+ #321 Not tainted
>  [  527.242730] -------------------------------
>  [  527.243220] kernel/cgroup.c:4008 cgroup_mutex or RCU read lock requ=
ired!
>  [  527.243970]
>  [  527.243970] other info that might help us debug this:
>  [  527.243970]
>  [  527.244715]
>  [  527.244715] rcu_scheduler_active =3D 1, debug_locks =3D 0
>  [  527.245463] 2 locks held by kworker/0:5/1664:
>  [  527.245939]  #0:  ("cgroup_destroy"){.+.+..}, at: [<ffffffff81060ab=
5>] process_one_work+0x165/0x4a0
>  [  527.246958]  #1:  ((&css->destroy_work)#3){+.+...}, at: [<ffffffff8=
1060ab5>] process_one_work+0x165/0x4a0
>  [  527.248098]
>  [  527.248098] stack backtrace:
>  [  527.249565] CPU: 0 PID: 1664 Comm: kworker/0:5 Not tainted 4.6.0-wo=
rk+ #321
>  [  527.250429] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), =
BIOS 1.9.1-1.fc24 04/01/2014
>  [  527.250555] Workqueue: cgroup_destroy css_free_work_fn
>  [  527.250555]  0000000000000000 ffff880178747c68 ffffffff8128bfc7 fff=
f880178b8ac40
>  [  527.250555]  0000000000000001 ffff880178747c98 ffffffff8108c297 000=
0000000000000
>  [  527.250555]  ffff88010de54138 000000000000fffb ffff88010de537e8 fff=
f880178747cc0
>  [  527.250555] Call Trace:
>  [  527.250555]  [<ffffffff8128bfc7>] dump_stack+0x68/0xa1
>  [  527.250555]  [<ffffffff8108c297>] lockdep_rcu_suspicious+0xd7/0x110
>  [  527.250555]  [<ffffffff810ca03d>] css_next_descendant_pre+0x7d/0xb0
>  [  527.250555]  [<ffffffff8114d14a>] memcg_offline_kmem.part.44+0x4a/0=
xc0
>  [  527.250555]  [<ffffffff8114d3ac>] mem_cgroup_css_free+0x1ec/0x200
>  [  527.250555]  [<ffffffff810ccdc9>] css_free_work_fn+0x49/0x5e0
>  [  527.250555]  [<ffffffff81060b15>] process_one_work+0x1c5/0x4a0
>  [  527.250555]  [<ffffffff81060ab5>] ? process_one_work+0x165/0x4a0
>  [  527.250555]  [<ffffffff81060e39>] worker_thread+0x49/0x490
>  [  527.250555]  [<ffffffff81060df0>] ? process_one_work+0x4a0/0x4a0
>  [  527.250555]  [<ffffffff81060df0>] ? process_one_work+0x4a0/0x4a0
>  [  527.250555]  [<ffffffff810672ba>] kthread+0xea/0x100
>  [  527.250555]  [<ffffffff814cbcff>] ret_from_fork+0x1f/0x40
>  [  527.250555]  [<ffffffff810671d0>] ? kthread_create_on_node+0x200/0x=
200
>=20
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Vladimir Davydov <vdavydov@virtuozzo.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
