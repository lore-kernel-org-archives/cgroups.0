From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: cgroup: introduce cgroup namespaces
Date: Wed, 17 Feb 2016 21:58:11 +0300
Message-ID: <20160217185811.GA3472@mwanda>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello Aditya Kali,

The patch a79a908fd2b0: "cgroup: introduce cgroup namespaces" from
Jan 29, 2016, leads to the following static checker warning:

	kernel/cgroup.c:6091 copy_cgroup_ns()
	error: 'new_ns' dereferencing possible ERR_PTR()

kernel/cgroup.c
  6085  
  6086          err = -ENOMEM;
  6087          new_ns = alloc_cgroup_ns();
  6088          if (!new_ns)
                    ^^^^^^^
This should be an IS_ERR() check.

  6089                  goto err_out;
  6090  
  6091          new_ns->user_ns = get_user_ns(user_ns);

regards,
dan carpenter
