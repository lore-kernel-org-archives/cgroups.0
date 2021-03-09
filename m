From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH 4/9] memcg: accounting for fib_rules
Date: Tue, 9 Mar 2021 11:04:14 +0300
Message-ID: <b0147a6c-ccf3-a7c1-0336-63304b811962@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IYB3aQq5E5HSxpjVSG+RHcLXuDkNoT5fOy83l0MSG1Q=;
 b=k9S/36PajArzsIo02GjKwQZKxmP52OEds/5ZnENgAWXME1kSyNJnxaYOf2qaR7QWMd5BWy0jViliduedeeS/Xup9xuUMzvTvcmSb/Mw/M7Ru/D17i5ozCl3O3bijo0+HFreYaY50VqkP5d3yo0IQLez651yR0KMVFOWHxMF51Yw=
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Objects can be created from memcg-limited tasks
but its misuse may lead to host OOM.

Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 net/core/fib_rules.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index cd80ffe..65d8b1d 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -57,7 +57,7 @@ int fib_default_rule_add(struct fib_rules_ops *ops,
 {
 	struct fib_rule *r;
 
-	r = kzalloc(ops->rule_size, GFP_KERNEL);
+	r = kzalloc(ops->rule_size, GFP_KERNEL_ACCOUNT);
 	if (r == NULL)
 		return -ENOMEM;
 
@@ -541,7 +541,7 @@ static int fib_nl2rule(struct sk_buff *skb, struct nlmsghdr *nlh,
 			goto errout;
 	}
 
-	nlrule = kzalloc(ops->rule_size, GFP_KERNEL);
+	nlrule = kzalloc(ops->rule_size, GFP_KERNEL_ACCOUNT);
 	if (!nlrule) {
 		err = -ENOMEM;
 		goto errout;
-- 
1.8.3.1

