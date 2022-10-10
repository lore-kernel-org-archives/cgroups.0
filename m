From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 0/3] Fix cgroup1 support in get from fd/file interfaces
Date: Mon, 10 Oct 2022 23:58:02 +0000
Message-ID: <20221010235802.3378436-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=32G3k93Ulqw+bBT8wloqCvMkNp9uoyXmylHiGN2Ypxc=;
        b=LcWt5IjwCcy3rAad+wx5DSEJeu4bbnR1UwRvydSMhWPJLCVVIhiV3sdwaiTUIjBUbt
         AwITg2e81qFFFEtOCWDrKdow2ER0lA/l4S/JNM2JP+v0ZWrdG39lvd8rPH1dfn6TZQQu
         76My+esp98qhz7FQrF8bxlLcyRAHtUNelF+oJHIqMQ7/1JlULihRngFRjGq+CsdrC7JL
         pyc2BCkq7cxAxQCd3YlkgYqYXYOKvydwutn/bGtBWCJYKOCmNo8ywgrQenJoHqDDJrLW
         ciqwgnPm2h+kpnsB/B33ihE6QHIppIccsEQAkr1f8JnZ/6aJ28iETmFw9Ei0RjxuUfiF
         e5pQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

commit f3a2aebdd6fb ("cgroup: enable cgroup_get_from_file() on cgroup1")
enabled using cgroup_get_from_file() and cgroup_get_from_fd() on
cgroup1, to enable bpf cgroup_iter to attach to cgroup1.

Apparently, other callers depended on these functions only supporting
cgroup2. Revert f3a2aebdd6 and add new separate interfaces that support
both cgroup1 and cgroup2.

Yosry Ahmed (3):
  Revert "cgroup: enable cgroup_get_from_file() on cgroup1"
  cgroup: add cgroup_all_get_from_[fd/file]()
  bpf: cgroup_iter: support cgroup1 using cgroup fd

 include/linux/cgroup.h   |  1 +
 kernel/bpf/cgroup_iter.c |  2 +-
 kernel/cgroup/cgroup.c   | 55 +++++++++++++++++++++++++++++++++++-----
 3 files changed, 51 insertions(+), 7 deletions(-)

-- 
2.38.0.rc1.362.ged0d419d3c-goog

