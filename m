From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/7] Per-cgroup page stat accounting
Date: Thu, 28 Jun 2012 18:54:45 +0800
Message-ID: <1340880885-5427-1-git-send-email-handai.szj@taobao.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=tZ9rrzXInGnHCMSKV0JcetD26OkWcMBeaXTpZDgE7dY=;
        b=X7OFCxkA1ra7NJDUYY52yU5PYkYCGn9kiW7rd9kJmk/TO6xPLrQrIx5q7KQ12PSSIR
         rHL6NQYfCO2/767Ykt4va10DKme9IaHZySM+Gyiyzd4g/xN/mcl71FIqGzFbjd1jTKnD
         ZaQVVNHRnL/XkNBXaiBY4ll2/Rd0V1q5nUshCgvVKBJb1CqCuaVgoLYq+Zfqb7UsTm0m
         FoGYU8Z6vzPprtaQ4fXci2KzhOlkYPy0fWzre69glxZ9T11Yg4lmpAYzBpffSd75JL9u
         SBRd4c7gZ9BJvHU3WyIwSImgxwHf/YmcDLmnc6rfDxx3VgfhWuf0C0rR0CJyPlR3HHvH
         Cz9w==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

This patch series provide the ability for each memory cgroup to have independent
dirty/writeback page stats. This can provide some information for per-cgroup direct
reclaim. Meanwhile, we add more detailed dump messages for memcg OOMs.

Three features are included in this patch series:
 (0).prepare patches for page accounting
  1. memcg dirty page accounting
  2. memcg writeback page accounting
  3. memcg OOMs dump info

In (0) prepare patches, we have reworked vfs set page dirty routines to make "modify
page info" and "dirty page accouting" stay in one function as much as possible for
the sake of memcg bigger lock.

These patches are cooked based on Andrew's akpm tree.

Sha Zhengju (7):
	memcg-update-cgroup-memory-document.patch
	memcg-remove-MEMCG_NR_FILE_MAPPED.patch
	Make-TestSetPageDirty-and-dirty-page-accounting-in-o.patch
	Use-vfs-__set_page_dirty-interface-instead-of-doing-.patch
	memcg-add-per-cgroup-dirty-pages-accounting.patch
	memcg-add-per-cgroup-writeback-pages-accounting.patch
	memcg-print-more-detailed-info-while-memcg-oom-happe.patch	

 Documentation/cgroups/memory.txt |    2 +
 fs/buffer.c                      |   36 +++++++++-----
 fs/ceph/addr.c                   |   20 +-------
 include/linux/buffer_head.h      |    2 +
 include/linux/memcontrol.h       |   27 +++++++---
 mm/filemap.c                     |    5 ++
 mm/memcontrol.c                  |   99 +++++++++++++++++++++++--------------
 mm/page-writeback.c              |   42 ++++++++++++++--
 mm/rmap.c                        |    4 +-
 mm/truncate.c                    |    6 ++
 10 files changed, 159 insertions(+), 84 deletions(-)
