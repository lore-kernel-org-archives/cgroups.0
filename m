From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Q: cgroup: Questions about possible issues in cgroup locking
Date: Wed, 21 Dec 2011 04:43:36 +0100
Message-ID: <20111221034334.GD17668@somewhere>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=9ycnbWUCbSQWvBoaZc+6wgootHSC8tkAmuQlXKjkP58=;
        b=BNT2Z5sTqI9WtNepENkEXNBgXgS1Sa+MCue3T3kzHP8hEV6Jhq9q+KZYShj6RkoDL+
         HeXINmg1fRf4gFdZA4hMeHhwP4e1GvWqiyZEjNSlMAe/b/wo1zcSyjsiuCHWGjbxbdC4
         uF5w6nKBCMoB05cpjbyghxEyQ6yyFdO1ahsdw=
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Hi,

Starring at some parts of cgroups, I have a few questions:

- Is cgroup_enable_task_cg_list()'s while_each_thread() safe
against concurrent exec()? The leader may change in de_thread()
and invalidate the test done in while_each_thread().

- do_each_thread() also needs RCU and cgroup_enable_task_cg_list()
seems to remind it. But it seems there is at least one caller that
doesn't call rcu_read_lock(): update_cpu_mask() -> update_tasks_cpumask() -> cgroup_scan_tasks()

- By the time we call cgroup_post_fork(), it is ready to be woken up
and usable by the scheduler. I was thinking about a possible race
where somebody kills the child just before we call cgroup_post_fork()
and then it ends up calling cgroup_exit(). In this case should we perhaps
check for PF_EXITING. Of course I'm talking about a race that will certainly
never happen.
If I'm mistaken and the task can not exit concurrently, probably we don't need
the task_lock() there.

- Is the check for use_task_css_set_links in cgroup_post_fork() safe? given
it is checked outside css_set_lock?

Imagine this:

CPU 0                                                        CPU 1
----                                                         -----

cgroup_enable_task_cg() {                            
	uset_tasks_css_set_links = 1
	for_each_thread() {
		add tasks in the list
	}
}
                                                           do_fork() {
                                                               cgroup_post_fork() {
                                                                     use_tasks_css_set_links appears
                                                                     to be equal to 0 due to write/read
                                                                      not flushed. New task won't
                                                                      appear to the list.


- Is the read_lock() in cgroup_attach_proc() still necessary? It was added to protect
against exec() but now I think it is useless. rcu_read_lock() would be necessary to protect
against group_entry removal though I think.

Thanks.
