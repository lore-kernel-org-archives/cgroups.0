From: Tejun Heo <tj@kernel.org>
Subject: [PATCH] memcg: add RCU locking around css_for_each_descendant_pre()
 in memcg_offline_kmem()
Date: Thu, 26 May 2016 16:30:18 -0400
Message-ID: <20160526203018.GG23194@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding:user-agent;
        bh=fEvIuWU1zHx+PAn6F4QtypVDmTJkik+1mCs7I7TkZmc=;
        b=i/HS2WHY71fVuZzErpXmlaS15E3nmzg7VHzIfjgnU0dtE1y/xQ4cJy7HzKThKbx0TJ
         Hnjzksz25tPnhEMY1zJj0353mi1O7ZjH0v38hFmKfH1yUvNxaDj/IsFWfUXOtdKc2bWA
         0kBMrrC4Qbk3Gj3BR1A3X5U+X2Eble2D+VkViKCsLcuFs6ljm15j3Zn0/6VZcLHqFVld
         NlaxitDRqCDhi6CJypnXh+gyAwMSmHmJK6bP67H9Mfm5/FU5EEizC8vGl2A1+C8RBNN0
         GZKdib1OOxbRZ+AayryvUe5xas57lNVDAVzdbmZZs/bPdiaCsZ7mqeKkKUO4651zIZip
         yn+A==
Content-Disposition: inline
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

memcg_offline_kmem() may be called from memcg_free_kmem() after a css
init failure.  memcg_free_kmem() is a ->css_free callback which is
called without cgroup_mutex and memcg_offline_kmem() ends up using
css_for_each_descendant_pre() without any locking.  Fix it by adding
rcu read locking around it.

 mkdir: cannot create directory =E2=80=9865530=E2=80=99: No space left on=
 device
 [  527.241361] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 [  527.241845] [ INFO: suspicious RCU usage. ]
 [  527.242367] 4.6.0-work+ #321 Not tainted
 [  527.242730] -------------------------------
 [  527.243220] kernel/cgroup.c:4008 cgroup_mutex or RCU read lock requir=
ed!
 [  527.243970]
 [  527.243970] other info that might help us debug this:
 [  527.243970]
 [  527.244715]
 [  527.244715] rcu_scheduler_active =3D 1, debug_locks =3D 0
 [  527.245463] 2 locks held by kworker/0:5/1664:
 [  527.245939]  #0:  ("cgroup_destroy"){.+.+..}, at: [<ffffffff81060ab5>=
] process_one_work+0x165/0x4a0
 [  527.246958]  #1:  ((&css->destroy_work)#3){+.+...}, at: [<ffffffff810=
60ab5>] process_one_work+0x165/0x4a0
 [  527.248098]
 [  527.248098] stack backtrace:
 [  527.249565] CPU: 0 PID: 1664 Comm: kworker/0:5 Not tainted 4.6.0-work=
+ #321
 [  527.250429] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BI=
OS 1.9.1-1.fc24 04/01/2014
 [  527.250555] Workqueue: cgroup_destroy css_free_work_fn
 [  527.250555]  0000000000000000 ffff880178747c68 ffffffff8128bfc7 ffff8=
80178b8ac40
 [  527.250555]  0000000000000001 ffff880178747c98 ffffffff8108c297 00000=
00000000000
 [  527.250555]  ffff88010de54138 000000000000fffb ffff88010de537e8 ffff8=
80178747cc0
 [  527.250555] Call Trace:
 [  527.250555]  [<ffffffff8128bfc7>] dump_stack+0x68/0xa1
 [  527.250555]  [<ffffffff8108c297>] lockdep_rcu_suspicious+0xd7/0x110
 [  527.250555]  [<ffffffff810ca03d>] css_next_descendant_pre+0x7d/0xb0
 [  527.250555]  [<ffffffff8114d14a>] memcg_offline_kmem.part.44+0x4a/0xc=
0
 [  527.250555]  [<ffffffff8114d3ac>] mem_cgroup_css_free+0x1ec/0x200
 [  527.250555]  [<ffffffff810ccdc9>] css_free_work_fn+0x49/0x5e0
 [  527.250555]  [<ffffffff81060b15>] process_one_work+0x1c5/0x4a0
 [  527.250555]  [<ffffffff81060ab5>] ? process_one_work+0x165/0x4a0
 [  527.250555]  [<ffffffff81060e39>] worker_thread+0x49/0x490
 [  527.250555]  [<ffffffff81060df0>] ? process_one_work+0x4a0/0x4a0
 [  527.250555]  [<ffffffff81060df0>] ? process_one_work+0x4a0/0x4a0
 [  527.250555]  [<ffffffff810672ba>] kthread+0xea/0x100
 [  527.250555]  [<ffffffff814cbcff>] ret_from_fork+0x1f/0x40
 [  527.250555]  [<ffffffff810671d0>] ? kthread_create_on_node+0x200/0x20=
0

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/memcontrol.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cf428d7..8d42c6d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2892,6 +2892,7 @@ static void memcg_offline_kmem(struct mem_cgroup *m=
emcg)
 	 * ordering is imposed by list_lru_node->lock taken by
 	 * memcg_drain_all_list_lrus().
 	 */
+	rcu_read_lock(); /* can be called from css_free w/o cgroup_mutex */
 	css_for_each_descendant_pre(css, &memcg->css) {
 		child =3D mem_cgroup_from_css(css);
 		BUG_ON(child->kmemcg_id !=3D kmemcg_id);
@@ -2899,6 +2900,8 @@ static void memcg_offline_kmem(struct mem_cgroup *m=
emcg)
 		if (!memcg->use_hierarchy)
 			break;
 	}
+	rcu_read_unlock();
+
 	memcg_drain_all_list_lrus(kmemcg_id, parent->kmemcg_id);
=20
 	memcg_free_cache_id(kmemcg_id);

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
