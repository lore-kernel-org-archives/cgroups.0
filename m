From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v2 3/8] memcg: accounting for fib_rules
Date: Mon, 15 Mar 2021 15:23:19 +0300
Message-ID: <cb893761-cf6e-fa92-3219-712e485259b4@virtuozzo.com>
References: <YEnWUrYOArju66ym@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iIVQCrfepn7+LB5Z6PL1HL1FmD16vJnT5AAbfB1IpTk=;
 b=Erd0aYFk2Lmb/uOJYRODKBQJEi2s8kVv7+TZvuCgLWMXEm9lU9wqtSM67qU9XQkqfiS+e7hzoyCf+Eh1m4n7cFJOdM+e1kOko6HndiDaZZMkCH/B7pNVaEQk4EVi/s5IK3pAV5BBWREtrz0QEvEO7H/Vr7ecygNerKGQ86Cn118=
In-Reply-To: <YEnWUrYOArju66ym-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>

An untrusted netadmin inside a memcg-limited container can create a
huge number of routing entries. Currently, allocated kernel objects
are not accounted to proper memcg, so this can lead to global memory
shortage on the host and cause lot of OOM kiils.

This patch enables accounting for 'struct fib_rules'
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

