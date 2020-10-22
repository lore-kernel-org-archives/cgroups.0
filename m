From: Gabriel Krisman Bertazi <krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Subject: [PATCH v2 0/2] Fixes to blkg_conf_prep
Date: Thu, 22 Oct 2020 16:58:40 -0400
Message-ID: <20201022205842.1739739-1-krisman@collabora.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, khazhy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Gabriel Krisman Bertazi <krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>, kernel-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org

Hi Tejun,

In addition to addressing your comments the previously submitted fix to
pre-allocate the radix node on blkg_conf_prep, this series fixes a small
memleak on the same function.

Gabriel Krisman Bertazi (2):
  blk-cgroup: Fix memleak on error path
  blk-cgroup: Pre-allocate tree node on blkg_conf_prep

 block/blk-cgroup.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

-- 
2.28.0

