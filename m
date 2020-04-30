From: Dmitry Yakunin <zeil-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Subject: [PATCH iproute2-next 0/2] ss: add support for cgroup v2 information and filtering
Date: Thu, 30 Apr 2020 18:52:43 +0300
Message-ID: <20200430155245.83364-1-zeil@yandex-team.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1588261974; bh=IwWYfZ95VkylOXCM3VJO+DrpjWTgky1qDpEwYCiPyRI=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=PCtz+7jQwduzLeildSxc/5dR74mBbGa2uoIZoH5jN8kj2hK1CRQd2zh2ID5T4qY64
         zYOHRLWdTaVkHv4Hv67Iad6lDL2VXmzdaFy8kznlr6w//0T9sVY4yIw2i7hS2Yt8VG
         Cfmjv3HLzEjbwbefPwdxQz2S2CazZ8foC3zasQcE=
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This patch series adds usage of two proposed kernel features:
cgroup bytecode filter (INET_DIAG_BC_CGROUP_COND) and
cgroup v2 ID attribute (INET_DIAG_CGROUP_ID)
for discovering and filtering sockets by cgroups.

Dmitry Yakunin (2):
  ss: introduce cgroup2 cache and helper functions
  ss: add support for cgroup v2 information and filtering

 include/cg_map.h               |   7 +++
 include/uapi/linux/inet_diag.h |   2 +
 include/utils.h                |   4 +-
 ip/ipvrf.c                     |   4 +-
 lib/Makefile                   |   2 +-
 lib/cg_map.c                   | 133 ++++++++++++++++++++++++++++++++++++++++
 lib/fs.c                       | 135 ++++++++++++++++++++++++++++++++++++++++-
 man/man8/ss.8                  |   9 +++
 misc/ss.c                      |  61 +++++++++++++++++++
 misc/ssfilter.h                |   2 +
 misc/ssfilter.y                |  22 ++++++-
 11 files changed, 374 insertions(+), 7 deletions(-)
 create mode 100644 include/cg_map.h
 create mode 100644 lib/cg_map.c

-- 
2.7.4

