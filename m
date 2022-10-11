From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/2] Support cgroup1 in get from fd/file interfaces
Date: Tue, 11 Oct 2022 00:33:57 +0000
Message-ID: <20221011003359.3475263-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5MPkIEvXfnmsvTKOk4MDlNi99CiZEm9rCw/f8+9aBJE=;
        b=mWfPotsftp8geA/L8mN84Y3UjYw9VeNIycJIvsZyy5yDxqJzmCwGBb9gaWdJV61voB
         JNWi/dHUJ/RKSzdweI2aUtBeEA+hnuFilAe+ELgKi/1CDGO4GXwIWUgcOkpdDmSZmgYl
         S+X4BhUfpqX/yE7TDRp17TnlXuDPRpO6dv2MjS/WXn/JvLIhp+pYDO3Nxx0fz/B6YiMB
         EhiVkK0IGiVr8h1wl1gyzrcd9vj2+d1meBbENrZruSwWxcfYRDhbE+atKn/PT9AUkTHS
         SexkE8P88iGSv/ALoOaI5BRuHiTcO+mFd2hM7eBBwp+Ciop7u/rpi8M7PIC1eIMl8mx3
         Rc/g==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

commit f3a2aebdd6fb ("cgroup: enable cgroup_get_from_file() on cgroup1")
enabled using cgroup_get_from_file() and cgroup_get_from_fd() on
cgroup1, to enable bpf cgroup_iter to attach to cgroup1.

Apparently, other callers depended on these functions only supporting
cgroup2, so f3a2aebdd6 was reverted. Instead, add new separate interfaces
that support both cgroup1 and cgroup2 and use them in bpf cgroup_iter.

Yosry Ahmed (2):
  cgroup: add cgroup_v1v2_get_from_[fd/file]()
  bpf: cgroup_iter: support cgroup1 using cgroup fd

 include/linux/cgroup.h   |  1 +
 kernel/bpf/cgroup_iter.c |  2 +-
 kernel/cgroup/cgroup.c   | 50 +++++++++++++++++++++++++++++++++++-----
 3 files changed, 46 insertions(+), 7 deletions(-)

-- 
2.38.0.rc1.362.ged0d419d3c-goog

