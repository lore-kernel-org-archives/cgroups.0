From: Chen Gang <gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org>
Subject: [Suggestion] kernel/cgroup.c: about kfree after 'get_new_cssid'
Date: Tue, 07 May 2013 18:46:43 +0800
Message-ID: <5188DB93.2080504@asianux.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello Maintainers:

After call get_new_cssid(), I can not find the related free function
(it seems free_css_id() is for that, but not used).

The memory location is:
  get_new_cssid() --> kzalloc() for 'struct css_id'
  get_new_cssid() --> idr_alloc() for 'ss->idr'

One work flow:
  cgroup_load_subsys() --> cgroup_init_idr() --> get_new_cssid()
  when get_new_cssid() fails, it will:
  cgroup_load_subsys() --> cgroup_unload_subsys() --> idr_destroy(),
  and also:
  cgroup_load_subsys() --> cgroup_unload_subsys() --> ss->css_free();
    ('css_free' may 'debug_css_free', or 'freezer_css_free' ...)

It seems the work flow above is not 'kfree' 'struct css_id', is it true?

BTW: I also guess, for cgroup_init_idr() in cgroup_init(), need check
the return value.

Please help check.


Thanks.

--
 Chen Gang

 Asianux Corporation
