From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 04/12] netprio_cgroup: convert away from cftype->read_map()
Date: Wed, 27 Nov 2013 18:42:31 -0500
Message-ID: <1385595759-17656-5-git-send-email-tj@kernel.org>
References: <1385595759-17656-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+AxBcQWrXPJwtsG5EHrDopcrqLQOtKgxpZkoYPspFkA=;
        b=tGV+RhixJ2XNv8WAKNfAdMfx3BMvS+vKU66ZCfq7hZiP8ABalYMA3q7pCHuSC4uc1k
         9i7dW/1pEDeHxwtxFxXcwiPW/xpnx7pkwIo78yQBQDpgqesNGqbNbIeWcWnW7+vdauIx
         JeoRYAZ4rEgQIAWcEi4brzv3fHgH/spTx/bs/9uHVFxgdjXu52BCQuJRQNmI1GZprWch
         zSE1oYz5Lzy6OjyAgtgmb+yvm1Ym1S6lqD06EIJVI9qFdsJdb4P4/NyKQUg+b3sq6Ggy
         5mHhb48zBpN0xZexKBt6Xop8XkuKb+TEvC+gZYBl0DL0JpY2Gqi0+FF8b/IKt1s+LFc8
         EeOQ==
In-Reply-To: <1385595759-17656-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org, arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

In preparation of conversion to kernfs, cgroup file handling is being
consolidated so that it can be easily mapped to the seq_file based
interface of kernfs.

cftype->read_map() doesn't add any value and being replaced with
->read_seq_string().  Update read_priomap() to use ->read_seq_string()
instead.

This patch doesn't make any visible behavior changes.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
Cc: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
---
 net/core/netprio_cgroup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index 9b7cf6c..498710d 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -174,13 +174,13 @@ static u64 read_prioidx(struct cgroup_subsys_state *css, struct cftype *cft)
 }
 
 static int read_priomap(struct cgroup_subsys_state *css, struct cftype *cft,
-			struct cgroup_map_cb *cb)
+			struct seq_file *sf)
 {
 	struct net_device *dev;
 
 	rcu_read_lock();
 	for_each_netdev_rcu(&init_net, dev)
-		cb->fill(cb, dev->name, netprio_prio(css, dev));
+		seq_printf(sf, "%s %u\n", dev->name, netprio_prio(css, dev));
 	rcu_read_unlock();
 	return 0;
 }
@@ -238,7 +238,7 @@ static struct cftype ss_files[] = {
 	},
 	{
 		.name = "ifpriomap",
-		.read_map = read_priomap,
+		.read_seq_string = read_priomap,
 		.write_string = write_priomap,
 	},
 	{ }	/* terminate */
-- 
1.8.4.2
