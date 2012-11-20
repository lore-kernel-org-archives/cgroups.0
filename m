From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/7] netprio_cgroup: shorten variable names in
	extend_netdev_table()
Date: Tue, 20 Nov 2012 00:30:07 -0800
Message-ID: <1353400211-5182-4-git-send-email-tj@kernel.org>
References: <1353400211-5182-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
	:references; bh=sxJE6ulWl83GREpglOjecgmrZKtxrG3QdFhzFownVEM=;
	b=Uo1MYYmHE2mR8jlSeTnPLdcCl1eIGD+q941DMoUU8wXp+OGDzAZvf8cZ91Bj+UWfK5
	zUYOOj2QMcXd4lo2sbIZtTl2OdGKGdTaJcmT8Op7yGWZqNAIRdYEUvtPOM8bjxAiRSTq
	9xBAx2d1/mNb7aUK0Mgcm4c+XGHoA5o+/LAV0otH88c4FoJ/cjbFLKigZEnbCo7YyG6b
	GRwo5V6FXpDh/bZP8QDRpGQfN8CCdCoOWTYd60N774NdcOgO68uEYKyBNE7R6Eg1vNrG
	nYmSTI4LeOnge+pMnDak+cCnyHfZ79Y9jzyMTA3ddw44jwoR1d06KI721xTZEj94SxKb
	COnQ==
In-Reply-To: <1353400211-5182-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org, serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, tgraf-G/eBtMaohhA@public.gmane.org
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org

The function is about to go through a rewrite.  In preparation,
shorten the variable names so that we don't repeat "priomap" so often.

This patch is cosmetic.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Acked-by: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
---
 net/core/netprio_cgroup.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index 66d98da..92cc54c 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -71,26 +71,25 @@ static int extend_netdev_table(struct net_device *dev, u32 new_len)
 {
 	size_t new_size = sizeof(struct netprio_map) +
 			   ((sizeof(u32) * new_len));
-	struct netprio_map *new_priomap = kzalloc(new_size, GFP_KERNEL);
-	struct netprio_map *old_priomap;
+	struct netprio_map *new = kzalloc(new_size, GFP_KERNEL);
+	struct netprio_map *old;
 
-	old_priomap  = rtnl_dereference(dev->priomap);
+	old = rtnl_dereference(dev->priomap);
 
-	if (!new_priomap) {
+	if (!new) {
 		pr_warn("Unable to alloc new priomap!\n");
 		return -ENOMEM;
 	}
 
-	if (old_priomap)
-		memcpy(new_priomap->priomap, old_priomap->priomap,
-		       old_priomap->priomap_len *
-		       sizeof(old_priomap->priomap[0]));
+	if (old)
+		memcpy(new->priomap, old->priomap,
+		       old->priomap_len * sizeof(old->priomap[0]));
 
-	new_priomap->priomap_len = new_len;
+	new->priomap_len = new_len;
 
-	rcu_assign_pointer(dev->priomap, new_priomap);
-	if (old_priomap)
-		kfree_rcu(old_priomap, rcu);
+	rcu_assign_pointer(dev->priomap, new);
+	if (old)
+		kfree_rcu(old, rcu);
 	return 0;
 }
 
-- 
1.7.11.7
