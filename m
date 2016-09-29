From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [bug report] cgroup: make cgroup_path() and friends behave in the
 style of strlcpy()
Date: Thu, 29 Sep 2016 12:27:22 +0300
Message-ID: <20160929092722.GA5513@mwanda>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello Tejun Heo,

The patch 4c737b41de7f: "cgroup: make cgroup_path() and friends
behave in the style of strlcpy()" from Aug 10, 2016, leads to the
following static checker warning:

	kernel/cpuset.c:2732 proc_cpuset_show()
	warn: signed compare with PATH_MAX 'retval'

kernel/cpuset.c
  2715  int proc_cpuset_show(struct seq_file *m, struct pid_namespace *ns,
  2716                       struct pid *pid, struct task_struct *tsk)
  2717  {
  2718          char *buf;
  2719          struct cgroup_subsys_state *css;
  2720          int retval;
  2721  
  2722          retval = -ENOMEM;
  2723          buf = kmalloc(PATH_MAX, GFP_KERNEL);
  2724          if (!buf)
  2725                  goto out;
  2726  
  2727          retval = -ENAMETOOLONG;
  2728          css = task_get_css(tsk, cpuset_cgrp_id);
  2729          retval = cgroup_path_ns(css->cgroup, buf, PATH_MAX,
  2730                                  current->nsproxy->cgroup_ns);
  2731          css_put(css);
  2732          if (retval >= PATH_MAX)
  2733                  goto out_free;
  2734          seq_puts(m, buf);
  2735          seq_putc(m, '\n');
  2736          retval = 0;
  2737  out_free:
  2738          kfree(buf);
  2739  out:
  2740          return 0;

Theoretically the out label should make this code totally future proof
but something broke somehow.  The comments imply that cgroup_path_ns()
returns negative error codes.

  2741  }

regards,
dan carpenter
