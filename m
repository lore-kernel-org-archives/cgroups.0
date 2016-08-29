From: Sargun Dhillon <sargun@sargun.me>
Subject: [net-next RFC v2 1/9] net: Make cgroup sk data present when calling
 security_sk_(alloc/free)
Date: Mon, 29 Aug 2016 04:45:59 -0700
Message-ID: <20160829114557.GA20842@ircssh.c.rugged-nimbus-611.internal>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=g4BV50SpTL9vv4zjq/gxr/LKkKBTL5FDRGrTo1ELIzg=;
        b=DJq6a8f6WuYYffby9dpLajhPJ+oTryjYJ7d6fID7I1Cs5TjmvPwgr6ix0FsBtB7iY/
         6iIra5AsVPHzW0o4ZbjhDjMihNydpHvfdZ3XRdUFRk0z+gzt2Nogy8vZ4ta6OwUzemdF
         +e4I1OV3hJe5Ieh+ZKsC2JKRrzj+2VtxbURVg=
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: cgroups@vger.kernel.org, linux-security-module@vger.kernel.org, daniel@iogearbox.net, ast@fb.com

This patch changes the order of allocations / calls to allocate the
sock_cgroup_data before calling security_sk_alloc. In addition, this
patch also reorders the deallocation when calling security_sk_free
so that LSMs can examine the cgroup that a particular sk belongs to.

Signed-off-by: Sarguun Dhillon <sargun@sargun.me>
---
 net/core/sock.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 51a7304..3f12f4d 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1333,6 +1333,7 @@ static struct sock *sk_prot_alloc(struct proto *prot, gfp_t priority,
 
 	if (sk != NULL) {
 		kmemcheck_annotate_bitfield(sk, flags);
+		cgroup_sk_alloc(&sk->sk_cgrp_data);
 
 		if (security_sk_alloc(sk, family, priority))
 			goto out_free;
@@ -1340,7 +1341,6 @@ static struct sock *sk_prot_alloc(struct proto *prot, gfp_t priority,
 		if (!try_module_get(prot->owner))
 			goto out_free_sec;
 		sk_tx_queue_clear(sk);
-		cgroup_sk_alloc(&sk->sk_cgrp_data);
 	}
 
 	return sk;
@@ -1348,6 +1348,7 @@ static struct sock *sk_prot_alloc(struct proto *prot, gfp_t priority,
 out_free_sec:
 	security_sk_free(sk);
 out_free:
+	cgroup_sk_free(&sk->sk_cgrp_data);
 	if (slab != NULL)
 		kmem_cache_free(slab, sk);
 	else
@@ -1363,8 +1364,8 @@ static void sk_prot_free(struct proto *prot, struct sock *sk)
 	owner = prot->owner;
 	slab = prot->slab;
 
-	cgroup_sk_free(&sk->sk_cgrp_data);
 	security_sk_free(sk);
+	cgroup_sk_free(&sk->sk_cgrp_data);
 	if (slab != NULL)
 		kmem_cache_free(slab, sk);
 	else
-- 
2.7.4

