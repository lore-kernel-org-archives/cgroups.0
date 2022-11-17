From: "Aneesh Kumar K.V" <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Subject: cgroup v1 and balance_dirty_pages
Date: Thu, 17 Nov 2022 12:24:13 +0530
Message-ID: <87wn7uf4ve.fsf@linux.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=pp1;
 bh=Hk/EAP4iIsWuxnIHQZ7PaULbopZTcRAEqmsstFZ1L/s=;
 b=Az7KE5xNl8WbNkwdBspdwxRIkcG41yLwAf2RVkIEOY49150X+b3MDDlRz2HWdA/3R0i0
 WzOxcHsi9Bywe89p8Nr32Nn3ZPVCjmkYEqV5x9QnR7+LDdYSoXRDhBoF8qkAwSCTWIxY
 8zNlKFfdKnJKXLMyKpxpi05AL6CaxWZRCuv6MuK09uSkZ5GaL9/W2o6nTq/adHwjczA/
 RjvR9x+j2uHnJMeiD+fLzCjuV+/VNcyEDyIniyk/KENGyKWHYVmlty2FqGKkj67jq4Q/
 CRPZjr/4jxq1LMsN+vEf7PrR6nmJEqPOBGIcMXmV7GSZsiTJIpHSR0htcv/mlZ0SoD9e fA== 
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Hi,

Currently, we don't pause in balance_dirty_pages with cgroup v1 when we
have task dirtying too many pages w.r.t to memory limit in the memcg.
This is because with cgroup v1 all the limits are checked against global
available resources. So on a system with a large amount of memory, a
cgroup with a smaller limit can easily hit OOM if the task within the
cgroup continuously dirty pages.

Shouldn't we throttle the task based on the memcg limits in this case?
commit 9badce000e2c ("cgroup, writeback: don't enable cgroup writeback
on traditional hierarchies") indicates we run into issues with enabling
cgroup writeback with v1. But we still can keep the global writeback
domain, but check the throtling needs against memcg limits in
balance_dirty_pages()?

-aneesh
