From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: cgroup: use a per-cgroup work for release agent
Date: Fri, 19 Sep 2014 19:09:06 +0300
Message-ID: <20140919160906.GA1575@mwanda>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello Zefan Li,

The patch 971ff4935538: "cgroup: use a per-cgroup work for release
agent" from Sep 18, 2014, leads to the following static checker
warning:

	kernel/cgroup.c:5310 cgroup_release_agent()
	warn: 'mutex:&cgroup_mutex' is sometimes locked here and sometimes unlocked.

kernel/cgroup.c
  5279  static void cgroup_release_agent(struct work_struct *work)
  5280  {
  5281          struct cgroup *cgrp =
  5282                  container_of(work, struct cgroup, release_agent_work);
  5283          char *pathbuf = NULL, *agentbuf = NULL, *path;
  5284          char *argv[3], *envp[3];
  5285  
  5286          mutex_lock(&cgroup_mutex);
  5287  
  5288          pathbuf = kmalloc(PATH_MAX, GFP_KERNEL);
  5289          agentbuf = kstrdup(cgrp->root->release_agent_path, GFP_KERNEL);
  5290          if (!pathbuf || !agentbuf)
  5291                  goto out;
  5292  
  5293          path = cgroup_path(cgrp, pathbuf, PATH_MAX);
  5294          if (!path)
  5295                  goto out;

Should unlock before the goto.

  5296  
  5297          argv[0] = agentbuf;
  5298          argv[1] = path;
  5299          argv[2] = NULL;
  5300  
  5301          /* minimal command environment */
  5302          envp[0] = "HOME=/";
  5303          envp[1] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
  5304          envp[2] = NULL;
  5305  
  5306          mutex_unlock(&cgroup_mutex);
  5307          call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
  5308  out:
  5309          kfree(agentbuf);
  5310          kfree(pathbuf);
  5311  }

regards,
dan carpenter
