From: Jianyu Zhan <nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/4] cgroup: substitude per-cgroup id with per-subsys id
Date: Tue, 22 Apr 2014 14:30:09 +0800
Message-ID: <cover.1398147734.git.nasa4836@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=from:to:cc:subject:date:message-id;
	bh=icU2/hi50KQuritw/vCdd0cmRzfS+49Km2XdlK7RL9M=;
	b=vZscYqvBKj3Zb7d+2sCfsl0S1zJbOHeww4MziAj7k54Ap0zb3KxxHVNItD/HCmNSIA
	5sGqJKbGwgObZGL2junT5D+OIFkfimh2ho1I10kLfitwaEO+y4G51JFFUR7kgJl22ftA
	kRV9TeLn+BLy64yIroZDE2sYeY7uM93Cn/VRkxqYnejEsxfn61NUa0TfkRfwAIzjV6zq
	KgMoatNVF0Vp+uhSqj/L1y+LHlp+xLPxxc7KW+iKD5LaG1ZRcDdx24NzgE2w5gRyihDw
	26Re0OE+OwExAKZQiwDZszTqiM671ChFal4uyyRcgnC3Kux1hqpvI59uAWP1OIT1+xJO
	U8pw==
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Currently, cgrp->id is only used to look up css's.  As cgroup and
css's lifetimes is now decoupled, it should be made per-subsystem
and moved to css->css_id so that lookups are successful until the
target css is released.

Patch 1-3 are prep patches.
Patch 4 do the coverting job.

Thanks!

Jianyu Zhan (4):
  cgroup: introduce helper css_to_id()
  mm/memcontrol.c: use accessor to get id from css
  netprio_cgroup: use accessor to get id from css
  cgroup: convert from per-cgroup id to per-subsys id

 include/linux/cgroup.h    | 27 ++++++-------
 kernel/cgroup.c           | 96 +++++++++++++++++++++++++----------------------
 mm/memcontrol.c           |  8 ++--
 net/core/netprio_cgroup.c |  8 ++--
 4 files changed, 74 insertions(+), 65 deletions(-)

-- 
2.0.0-rc0
