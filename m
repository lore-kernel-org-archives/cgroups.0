From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v1 0/3] Fix cgroup1 support in get from fd/file interfaces
Date: Mon, 10 Oct 2022 23:58:42 +0000
Message-ID: <20221010235845.3379019-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=32G3k93Ulqw+bBT8wloqCvMkNp9uoyXmylHiGN2Ypxc=;
        b=oBamiBMlwevwaWtK9/MK/DT9KKivXxO2BxJN593yqX6pYjoGISML+X3eegUtf6A2M5
         4iA2KIkdw4Sa2t3eOKZT3OrwBQCo8yzMbPa7sEEiMxRHAUJzqmE8fikOru5PvKc3xLKp
         7pBhjHTEQuE239jf1M8tJM2axFb+arNmTjtVlvz9nWLtrXVa2bgjE1lgBqheC+oaMxPV
         buJwf/w9KTYkdmjq4x2mUZ67/K32gzGzfrn+c8T3b3ekZOISsbXD9cufr41n2pvvZnd4
         2U5PTZALuINUVBwjM1H5EV2MwG9mT5ARQpFgxKTCSTKgM98LAeeMrpsjT5iMKRDZqt+F
         TL8Q==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

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

