From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] xattr: mark variable as uninitialized to make both gcc and
 smatch happy
Date: Wed, 12 Sep 2012 10:31:13 -0400
Message-ID: <20120912143112.GE19694@redhat.com>
References: <20120912022813.GA17922@localhost>
 <20120912075517.GZ19396@mwanda>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120912075517.GZ19396@mwanda>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

new_xattr in __simple_xattr_set() is only initialized with a valid
pointer if value is not NULL, which only happens if this function is
called directly with the intention to remove an existing extended
attribute. Even being safe to be this way, smatch warns about possible
NULL dereference. Dan Carpenter suggested using uninitialized_var()
which will make both gcc and smatch happy.

Cc: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

---
 fs/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xattr.c	2012-09-12 09:57:35.000000000 -0400
+++ b/fs/xattr.c	2012-09-12 09:58:25.619387047 -0400
@@ -845,7 +845,7 @@ static int __simple_xattr_set(struct sim
 			      const void *value, size_t size, int flags)
 {
 	struct simple_xattr *xattr;
-	struct simple_xattr *new_xattr = NULL;
+	struct simple_xattr *uninitialized_var(new_xattr);
 	int err = 0;
 
 	/* value == NULL means remove */
