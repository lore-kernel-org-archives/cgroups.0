From: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] kernfs_path_from_node_locked: don't overwrite nlen
Date: Sat, 16 Apr 2016 00:48:16 -0500
Message-ID: <20160416054816.GA9968@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

We've calculated @len to be the bytes we need for '/..' entries from
@kn_from to the common ancestor, and calculated @nlen to be the extra
bytes we need to get from the common ancestor to @kn_to.  We use them
as such at the end.  But in the loop copying the actual entries, we
overwrite @nlen.  Use a temporary variable for that instead.

Without this, the return length, when the buffer is large enough, is
wrong - a positive value less than the actual length.  (When the buffer
is NULL or too small, the returned value is correct. The buffer contents
are also correct.)

Interestingly, no callers of this function are affected by this as of
yet.  However the upcoming cgroup_show_path() will be.

Signed-off-by: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
 fs/kernfs/dir.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 03b688d..37f9678 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -153,9 +153,9 @@ static int kernfs_path_from_node_locked(struct kernfs_node *kn_to,
 	p = buf + len + nlen;
 	*p = '\0';
 	for (kn = kn_to; kn != common; kn = kn->parent) {
-		nlen = strlen(kn->name);
-		p -= nlen;
-		memcpy(p, kn->name, nlen);
+		size_t tmp = strlen(kn->name);
+		p -= tmp;
+		memcpy(p, kn->name, tmp);
 		*(--p) = '/';
 	}
 
-- 
2.7.4
