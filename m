From: Daniel Mack <daniel@zonque.org>
Subject: [PATCH net-next v2] bpf: cgroup: fix documentation of __cgroup_bpf_update()
Date: Mon, 28 Nov 2016 14:11:04 +0100
Message-ID: <1480338664-22616-1-git-send-email-daniel@zonque.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ast@fb.com
Cc: daniel@iogearbox.net, davem@davemloft.net, netdev@vger.kernel.org, roszenrami@gmail.com, cgroups@vger.kernel.org, Daniel Mack <daniel@zonque.org>

There's a 'not' missing in one paragraph. Add it.

Signed-off-by: Daniel Mack <daniel@zonque.org>
Reported-by: Rami Rosen <roszenrami@gmail.com>
Fixes: 3007098494be ("cgroup: add support for eBPF programs")
---
 kernel/bpf/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index a0ab43f..8c784f8 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -66,8 +66,8 @@ void cgroup_bpf_inherit(struct cgroup *cgrp, struct cgroup *parent)
  * Each cgroup has a set of two pointers for bpf programs; one for eBPF
  * programs it owns, and which is effective for execution.
  *
- * If @prog is %NULL, this function attaches a new program to the cgroup and
- * releases the one that is currently attached, if any. @prog is then made
+ * If @prog is not %NULL, this function attaches a new program to the cgroup
+ * and releases the one that is currently attached, if any. @prog is then made
  * the effective program of type @type in that cgroup.
  *
  * If @prog is %NULL, the currently attached program of type @type is released,
-- 
2.7.4

