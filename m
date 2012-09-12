From: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [cgroup:for-next 5/6] fs/xattr.c:882 __simple_xattr_set() error:
 potential NULL dereference 'new_xattr'.
Date: Wed, 12 Sep 2012 10:28:13 +0800
Message-ID: <20120912022813.GA17922@localhost>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Hi Aristeu,

FYI, there are new smatch warnings show up in

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
head:   9814e970d7947dcc5ab7b37a53514c0098bfacc9
commit: 38f38657444d15e1a8574eae80ed3de9f501737a xattr: extract simple_xattr code from tmpfs


fs/xattr.c:882 __simple_xattr_set() error: potential NULL dereference 'new_xattr'.

vim +882 fs/xattr.c
   872				} else {
   873					list_del(&xattr->list);
   874				}
   875				goto out;
   876			}
   877		}
   878		if (flags & XATTR_REPLACE) {
   879			xattr = new_xattr;
   880			err = -ENODATA;
   881		} else {
 > 882			list_add(&new_xattr->list, &xattrs->head);
   883			xattr = NULL;
   884		}
   885	out:
   886		spin_unlock(&xattrs->lock);
   887		if (xattr) {
   888			kfree(xattr->name);
   889			kfree(xattr);
   890		}
   891		return err;
   892	

---
0-DAY kernel build testing backend         Open Source Technology Centre
Fengguang Wu <wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>                     Intel Corporation
