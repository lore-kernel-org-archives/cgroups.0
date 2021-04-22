From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v3 04/16] memcg: enable accounting for VLAN group array
Date: Thu, 22 Apr 2021 13:36:30 +0300
Message-ID: <4fcc28c6-8451-c7e3-b6fb-5af5dd0a3553@virtuozzo.com>
References: <dddf6b29-debd-dcb5-62d0-74909d610edb@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=uHSxH+z24mqnhtuT7lZ5lO0b/1FeyBNtouCJgBY3h2Q=; b=cohcaQzojQvriQ2f8Hy
        wZqZDZdALIYZfwXouBfTKtx9juQ4X62nixX6BQ40z7LgeST5XRTBsSK6I0k6ECVSJoSAMtAZJruPT
        /LMNsW6JEuV56/bD6zZcRneWrsv2Hmjy6+oIynD4luXiXwpjIoVyKqBvfqA4kJfFlmXQSHZhFLI=
In-Reply-To: <dddf6b29-debd-dcb5-62d0-74909d610edb-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

vlan array consume up to 8 pages of memory per net device.

It makes sense to account for them to restrict the host's memory
consumption from inside the memcg-limited container.

Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 net/8021q/vlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 8b644113..d0a579d4 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -67,7 +67,7 @@ static int vlan_group_prealloc_vid(struct vlan_group *vg,
 		return 0;
 
 	size = sizeof(struct net_device *) * VLAN_GROUP_ARRAY_PART_LEN;
-	array = kzalloc(size, GFP_KERNEL);
+	array = kzalloc(size, GFP_KERNEL_ACCOUNT);
 	if (array == NULL)
 		return -ENOBUFS;
 
-- 
1.8.3.1

