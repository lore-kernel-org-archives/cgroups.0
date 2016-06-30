From: Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH net-next v3 0/4] cgroup: bpf: cgroup2 membership test on skb
Date: Thu, 30 Jun 2016 10:28:41 -0700
Message-ID: <1467307725-1948415-1-git-send-email-kafai@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fb.com; h=from : to : cc : subject :
 date : message-id : mime-version : content-type; s=facebook;
 bh=WndIvkiJmiutuWeirBtnZa8wTnjkVF8s2iMPfeNdSeA=;
 b=hgQZZRbil7/znP2Obg2uJEBAakao1J1mg69lEnscon6ArzI0sSPc0zWJggjznf1uScbk
 7wjJhwdm7w0G/8HHOxK3rL/cauT+bjtEzmxTOEj1YZlan+84erJNkhm6XeGwFeHtIdCn
 k3BXmveF2TfT4VG9ZJrA5dG/k89GsU7OEjk= 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: Alexei Starovoitov <ast@fb.com>, Daniel Borkmann <daniel@iogearbox.net>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com

v3:
- Remove WARN_ON_ONCE(!rcu_read_lock_held())
- Stop BPF_MAP_TYPE_CGROUP_ARRAY usage in patch 2/4
- Avoid mounting bpf fs manually in patch 4/4

- Thanks for Daniel's review and the above suggestions

- Check CONFIG_SOCK_CGROUP_DATA instead of CONFIG_CGROUPS.  Thanks to
  the kbuild bot's report.
  Patch 2/4 only needs CONFIG_CGROUPS while patch 3/4 needs
  CONFIG_SOCK_CGROUP_DATA.  Since a single bpf cgrp2 array alone is
  not useful for now, CONFIG_SOCK_CGROUP_DATA is also used in
  patch 2/4.  We can fine tune it later if we find other use cases
  for the cgrp2 array.
- Return EAGAIN instead of ENOENT if the cgrp2 array entry is
  NULL.  It is to distinguish these two cases: 1) the userland has
  not populated this array entry yet. or 2) not finding cgrp2 from the skb.

- Be-lated thanks to Alexei and Tejun on reviewing v1 and giving advice on
  this work.

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

