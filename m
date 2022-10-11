From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v1 1/3] Revert "cgroup: enable cgroup_get_from_file() on
 cgroup1"
Date: Mon, 10 Oct 2022 14:03:08 -1000
Message-ID: <Y0SyvJvzFQOhSFsC@slm.duckdns.org>
References: <20221010235845.3379019-1-yosryahmed@google.com>
 <20221010235845.3379019-2-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l+llQOs1rDUP1s79HRj7eRagiprARX+HG1GAmZurmEA=;
        b=bFHvYCEQLjSfzroDOuLQ9Iu9SAR9bjDwReNKR9N1SoBlWDmZ+SRcBe52uoZWup5vkr
         mSOWD5Le1Sj0AS20ah3a5X5YUWs0Khm3JrUy/4ElGslNB2ryYstN+Q7hOBW1z0FDOr5x
         nnPyXM7UqK7Gs+bel7pTZ2GxXMn6BTKiSVBYKsf2GMunWfpQWiT/aaMLCmvGRZciJCUb
         S+kdQY8YaWhT/c2wMqcE7cscmzsW4pKvYN/uG5qGcHQyySgn4L9CCMVEBjRbLNX7mfZk
         K6jw2UrKqcezN517aTlL7K7gOdnTIr32jkOK8kSba7wokCrMsycBHLxRKP9hLtpO10U5
         Il+A==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20221010235845.3379019-2-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, "Christian A . Ehrhardt" <lk@c--e.de>

Hello,

Already queued the following to cgroup/for-6.1-fixes. Will send it out soon.

Thanks.

----- 8< -----
From 03db7716159477b595e9af01be8003b7e994cc79 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Mon, 10 Oct 2022 11:08:17 -1000
Subject: [PATCH] Revert "cgroup: enable cgroup_get_from_file() on cgroup1"

This reverts commit f3a2aebdd6fb90e444d595e46de64e822af419da.

The commit enabled looking up v1 cgroups via cgroup_get_from_file().
However, there are multiple users, including CLONE_INTO_CGROUP, which have
been assuming that it would only look up v2 cgroups. Returning v1 cgroups
breaks them.

Let's revert the commit and retry later with a separate lookup interface
which allows both v1 and v2.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/000000000000385cbf05ea3f1862@google.com
Cc: Yosry Ahmed <yosryahmed@google.com>
---
 kernel/cgroup/cgroup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index ecf409e3c3a7..6d8a5a40c24d 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6234,6 +6234,11 @@ static struct cgroup *cgroup_get_from_file(struct file *f)
 		return ERR_CAST(css);
 
 	cgrp = css->cgroup;
+	if (!cgroup_on_dfl(cgrp)) {
+		cgroup_put(cgrp);
+		return ERR_PTR(-EBADF);
+	}
+
 	return cgrp;
 }
 
-- 
2.37.3
