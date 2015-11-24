From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: WARNING in handle_mm_fault
Date: Tue, 24 Nov 2015 17:31:16 -0500
Message-ID: <20151124223116.GA2874@cmpxchg.org>
References: <CACT4Y+ZCkv0BPOdo3aiheA5LXzXhcnuiw7kCoWL=b9FcC8-wqg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+ZCkv0BPOdo3aiheA5LXzXhcnuiw7kCoWL=b9FcC8-wqg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, syzkaller <syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, Kostya Serebryany <kcc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hi Dmitry,

On Tue, Nov 24, 2015 at 02:50:26PM +0100, Dmitry Vyukov wrote:
> As a blind guess, I've added the following BUG into copy_process:
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index b4dc490..c5667e8 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1620,6 +1620,8 @@ static struct task_struct *copy_process(unsigned
> long clone_flags,
>         trace_task_newtask(p, clone_flags);
>         uprobe_copy_process(p, clone_flags);
> 
> +       BUG_ON(p->memcg_may_oom);
> +
>         return p;

Thanks for your report.

I don't see how this could happen through the legitimate setters of
p->memcg_may_oom. Something must clobber it. What happens with the
following patch applied?

diff --git a/include/linux/sched.h b/include/linux/sched.h
index edad7a4..42e1285 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1463,9 +1463,11 @@ struct task_struct {
 	unsigned sched_reset_on_fork:1;
 	unsigned sched_contributes_to_load:1;
 	unsigned sched_migrated:1;
+	unsigned dummy_a:1;
 #ifdef CONFIG_MEMCG
 	unsigned memcg_may_oom:1;
 #endif
+	unsigned dummy_b:1;
 #ifdef CONFIG_MEMCG_KMEM
 	unsigned memcg_kmem_skip_account:1;
 #endif
diff --git a/kernel/fork.c b/kernel/fork.c
index f97f2c4..ab6f7ba 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1617,6 +1617,12 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	trace_task_newtask(p, clone_flags);
 	uprobe_copy_process(p, clone_flags);
 
+	if (p->dummy_a || p->dummy_b || p->memcg_may_oom) {
+		printk(KERN_ALERT "dummy_a:%d dummy_b:%d memcg_may_oom:%d\n",
+		       p->dummy_a, p->dummy_b, p->memcg_may_oom);
+		BUG();
+	}
+
 	return p;
 
 bad_fork_cancel_cgroup:
