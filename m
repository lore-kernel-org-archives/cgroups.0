From: Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH net-next v2 0/4] cgroup: bpf: cgroup2 membership test on skb
Date: Wed, 22 Jun 2016 14:17:28 -0700
Message-ID: <1466630252-3822277-1-git-send-email-kafai@fb.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fb.com; h=from : to : cc : subject :
 date : message-id : mime-version : content-type; s=facebook;
 bh=GDjsWDr6TkASKNk31Fy5Wl3TujYKyXS8P6N+ddLipJs=;
 b=Yq2Py5/aAPjFcM8Z73xs7BtTBwyuJauu3fIcWn+LpgmpHpBAOPlufevbwHPlNr8KUqZI
 B5zzvTNTObl3uO4DgraSnzNqMx8DlSvhk4U4O+xilu1LlyYR+MZ3pbA2aKsoDCdrhYq+
 kuH1PuZoPAkcaidGy7Nhqzy6tL5k0MBvhno= 
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: Alexei Starovoitov <ast@fb.com>, Daniel Borkmann <daniel@iogearbox.net>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com

v2:
- Fix two return cases in cgroup_get_from_fd()
- Fix compilation errors when CONFIG_CGROUPS is not used:
  - arraymap.c: avoid registering BPF_MAP_TYPE_CGROUP_ARRAY
  - filter.c: tc_cls_act_func_proto() returns NULL on BPF_FUNC_skb_in_cgroup
- Add comments to BPF_FUNC_skb_in_cgroup and cgroup_get_from_fd()

v1 cover letter:
This series is to implement a bpf-way to
check the cgroup2 membership of a skb (sk_buff).

It is similar to the feature added in netfilter:
c38c4597e4bf ("netfilter: implement xt_cgroup cgroup2 path match")

The current target is the tc-like usage.

