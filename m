From: "yingooyim" <ygyim@konkuk.ac.kr>
Subject: [PATCH] cgroup/cpu: Fix tg_has_rt_task() malfunction
Date: Sun, 18 Sep 2016 23:23:10 +0900
Message-ID: <1474208588556845.0.mail@mail>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; format="flowed"; charset="windows-1252"; reply-type="original"
To: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, jinh@konkuk.ac.kr

Hi,
I am a graduate student of System Software Lab. at Konkuk University
(http://sslab.konkuk.ac.kr).

This patch is to fix the malfunction of tg_has_rt_tasks(). The
tg_has_rt_tasks() function is supposed to determine whether a task
group includes an "rt task" or not. However, it returns true for
"dl task" too. The origin of this problem is that rt_task() called
by tg_has_rt_tasks() returns true for dl tasks. Because of this
problem, tg_rt_schedulable() that calls tg_has_rt_tasks() returns
=E2=80=93EBUSY if we try to initialize an rt task group, while a dl task
is running. That is, you cannot run an rt task group when there
exists a dl task in the system. Our patch provided in this post
simply makes the tg_has_rt_tasks() function return false for dl
tasks by calling dl_task() in the conditional statement.

Previously we have provided another patch for rt_task() (more
precisely rt_prio()) to resolve this problem as follows:
https://patchwork.kernel.org/patch/9299267/
However, a dependency issue were raised. So, we think that it is
better to modify tg_has_rt_tasks() instead of rt_task() itself.

Signed-off-by: Yin-goo Yim <ygyim@konkuk.ac.kr>
----
kernel/sched/core.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2a906f2..ee5ab2f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7846,7 +7846,7 @@ static inline int tg_has_rt_tasks(struct task_group=20
*tg)
   return 0;

   for_each_process_thread(g, p) {
- if (rt_task(p) && task_group(p) =3D=3D tg)
+ if (rt_task(p) && !dl_task(p) && task_group(p) =3D=3D tg)
   return 1;
   }



