From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] allow a task to join a pid namespace
Date: Tue, 5 Jun 2012 15:33:34 +0400
Message-ID: <4FCDEE8E.8000005@parallels.com>
References: <1338816828-25312-1-git-send-email-glommer@parallels.com> <4FCDD315.502@free.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------030509020909040506050907"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FCDD315.502-GANU6spQydw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Daniel Lezcano <daniel.lezcano-GANU6spQydw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kir-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--------------030509020909040506050907
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

On 06/05/2012 01:36 PM, Daniel Lezcano wrote:
> On 06/04/2012 03:33 PM, Glauber Costa wrote:
>> Currently, it is possible for a process  to join existing
>> net, uts and ipc namespaces. This patch allows a process to join an
>> existing pid namespace as well.
>>
>> For that to remain sane, some restrictions are made in the calling process:
>>
>> * It needs to be in the parent namespace of the namespace it wants to jump to
>> * It needs to sit in its own session and group as a leader.
>>
>> The rationale for that, is that people want to trigger actions in a Container
>> from the outside. For instance, mainstream linux recently gained the ability
>> to safely reboot a container. It would be desirable, however, that this
>> action is triggered from an admin in the outside world, very much like a
>> power switch in a physical box.
>>
>> This would also allow us to connect a console to the container, provide a
>> repair mode for setups without networking (or with a broken one), etc.
>
> Hi Glauber,
>
> I am in favor of this patch but I think the pidns support won't be
> complete and some corner-cases are not handled.
>
> May be you can look at Eric's patchset [1] where, IMO, everything is
> taken into account. Some of the patches may be already upstream.
>
> Thanks
>    -- Daniel
>

Daniel,

Please let me know what you think of the attached patch. It is ontop of 
Eric's tree that you pointed me to, but I am not really using any of its 
functionality, so this would be equally doable in current mainline 
kernel - but I wanted to make sure it integrates well with what Eric is 
doing as well.

It is a bit wasteful space-wise, but this approach pretty much 
guarantees we don't need to update pointers anywhere - therefore, 
totally lock-free. pid->level is only updated after 
switch_task_namespaces(), so every call before that will see correct 
information up to the previous level.



--------------030509020909040506050907
Content-Type: text/x-patch;
	name="0001-pid_ns-expand-the-current-pid-namespace-to-a-new-nam.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-pid_ns-expand-the-current-pid-namespace-to-a-new-nam.pa";
	filename*1="tch"

From 1192e0ff3c854f4690d44fadccbc575fff653578 Mon Sep 17 00:00:00 2001
From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Date: Tue, 5 Jun 2012 15:23:12 +0400
Subject: [PATCH] pid_ns: expand the current pid namespace to a new namespace

install pid_ns doesn't go as far as needed. Things like
ns_of_pid() will rely on the current level to get to the
right task. So when attaching a task to a new pid namespace,
we need to make sure the upid vector grows as needed, and the
level updated accordingly

To do that, this patch leaves room for one more upid at the end
of the structure at all times. It also stores the original level so
we know afterwards which cache to free from.

Although this is, of course, a bit wasteful, it has the advantage
that we never need to touch the existing struct pid, nor the existing
upid vectors. That would be racy in nature, and may require us to pick
locks here and there - which seems to me like a big no.

Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
---
 include/linux/pid.h    |    3 +++
 kernel/nsproxy.c       |    2 ++
 kernel/pid.c           |   54 +++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/pid_namespace.c |   30 +++++++++++++++++++++++++--
 4 files changed, 86 insertions(+), 3 deletions(-)

diff --git a/include/linux/pid.h b/include/linux/pid.h
index b152d44..2f01763 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -58,6 +58,7 @@ struct pid
 {
 	atomic_t count;
 	unsigned int level;
+	unsigned int orig_level;
 	/* lists of tasks that use this pid */
 	struct hlist_head tasks[PIDTYPE_MAX];
 	struct rcu_head rcu;
@@ -121,6 +122,8 @@ int next_pidmap(struct pid_namespace *pid_ns, unsigned int last);
 
 extern struct pid *alloc_pid(struct pid_namespace *ns);
 extern void free_pid(struct pid *pid);
+extern int expand_pid(struct pid *pid, struct pid_namespace *ns);
+extern void  update_expanded_pid(struct task_struct *task);
 
 /*
  * ns_of_pid() returns the pid namespace in which the specified pid was
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index b956079..9851f11 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -267,6 +267,8 @@ SYSCALL_DEFINE2(setns, int, fd, int, nstype)
 		goto out;
 	}
 	switch_task_namespaces(tsk, new_nsproxy);
+	if (nstype == CLONE_NEWPID)
+		update_expanded_pid(current);
 out:
 	fput(file);
 	return err;
diff --git a/kernel/pid.c b/kernel/pid.c
index 8c51c26..f2b1bd7 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -247,7 +247,7 @@ void put_pid(struct pid *pid)
 	if (!pid)
 		return;
 
-	ns = pid->numbers[pid->level].ns;
+	ns = pid->numbers[pid->orig_level].ns;
 	if ((atomic_read(&pid->count) == 1) ||
 	     atomic_dec_and_test(&pid->count)) {
 		kmem_cache_free(ns->pid_cachep, pid);
@@ -306,6 +306,7 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 
 	get_pid_ns(ns);
 	pid->level = ns->level;
+	pid->orig_level = ns->level;
 	atomic_set(&pid->count, 1);
 	for (type = 0; type < PIDTYPE_MAX; ++type)
 		INIT_HLIST_HEAD(&pid->tasks[type]);
@@ -329,6 +330,57 @@ out_free:
 	goto out;
 }
 
+int expand_pid(struct pid *pid, struct pid_namespace *ns)
+{
+	int i, nr;
+	struct pid_namespace *tmp;
+	struct upid *upid;
+
+	if  ((ns->level - pid->orig_level) > 1)
+		return -EINVAL;
+
+	if (ns->parent != pid->numbers[pid->orig_level].ns)
+		return -EINVAL;
+
+	tmp = ns;
+	for (i = ns->level; i > pid->level; i--) {
+		if (ns->dead)
+			goto out_free;
+		nr = alloc_pidmap(tmp);
+		if (nr < 0)
+			goto out_free;
+
+		pid->numbers[i].nr = nr;
+		pid->numbers[i].ns = tmp;
+		tmp = tmp->parent;
+	}
+
+	upid = pid->numbers + ns->level;
+	spin_lock_irq(&pidmap_lock);
+	for (i = ns->level; i > pid->level; i--) {
+		upid = &pid->numbers[i];
+		hlist_add_head_rcu(&upid->pid_chain,
+				&pid_hash[pid_hashfn(upid->nr, upid->ns)]);
+	}
+	spin_unlock_irq(&pidmap_lock);
+
+	return 0;
+
+out_free:
+	while (++i <= ns->level)
+		free_pidmap(pid->numbers + i);
+
+	return -ENOMEM;
+}
+
+void update_expanded_pid(struct task_struct *task)
+{
+	struct pid *pid;
+	pid = get_task_pid(task, PIDTYPE_PID);
+
+	pid->level++;
+}
+
 struct pid *find_pid_ns(int nr, struct pid_namespace *ns)
 {
 	struct hlist_node *elem;
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 79bf459..0f3a521 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -49,8 +49,12 @@ static struct kmem_cache *create_pid_cachep(int nr_ids)
 		goto err_alloc;
 
 	snprintf(pcache->name, sizeof(pcache->name), "pid_%d", nr_ids);
+	/*
+	 * nr_ids - 1 would provide room for upids up to the right level.
+	 * We leave room for one in the end for usage with setns.
+	 */
 	cachep = kmem_cache_create(pcache->name,
-			sizeof(struct pid) + (nr_ids - 1) * sizeof(struct upid),
+			sizeof(struct pid) + (nr_ids) * sizeof(struct upid),
 			0, SLAB_HWCACHE_ALIGN, NULL);
 	if (cachep == NULL)
 		goto err_cachep;
@@ -244,8 +248,30 @@ static void pidns_put(void *ns)
 	put_pid_ns(ns);
 }
 
-static int pidns_install(struct nsproxy *nsproxy, void *ns)
+static int pidns_install(struct nsproxy *nsproxy, void *_ns)
 {
+	int ret = 0;
+	struct pid *pid;
+	struct pid_namespace *ns = _ns;
+
+	rcu_read_lock();
+	pid = task_pid(current);
+	rcu_read_unlock();
+
+	if (is_container_init(current) || (get_nr_threads(current) > 1))
+		return -EINVAL;
+
+	read_lock(&tasklist_lock);
+	if ((task_pgrp(current) != pid) || task_session(current) != pid)
+		ret = -EPERM;
+	read_unlock(&tasklist_lock);
+	if (ret)
+		return ret;
+
+	ret = expand_pid(pid, ns);
+	if (ret)
+		return ret;
+
 	put_pid_ns(nsproxy->pid_ns);
 	nsproxy->pid_ns = get_pid_ns(ns);
 	return 0;
-- 
1.7.10.2


--------------030509020909040506050907--
