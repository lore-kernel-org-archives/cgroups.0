From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] device_cgroup: fix RCU usage
Date: Tue, 6 Nov 2012 09:17:37 -0800
Message-ID: <20121106171737.GJ30069@mtj.dyndns.org>
References: <20121106171612.GH30069@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5j7BnmGK7q3YFcSqZS1ZWOu1x08T7o4kZ0ZGtJmeS5w=;
        b=IPBX8aIb/AoZhGkJ3nJvytx7jsuXDx/xf3TlMboFqnSI0jjcKDsfhEP7XKuvggC67l
         qitZoRWXcSiZl4EHFdM6faea4VRTHwJahrJ+3GsUUjVR7XlqRlpB6QOKHVPSI8orRw4+
         IvCvLVOJGGBDWtmOFSLk7BI7JSuQJ0FsLjF0LU4WjxbmEdNMcStEEXEC6JlNcARzMbMK
         h6sDP7PBgfNfw4oyKjgawSfBbNXAoEwhCOFhTQegChJgR7kc+m5AB9j0n61Q+FJnqri0
         ty3sUJNmn2xqlo16S+BAXhjGbMcOlLEJcRk4aHdela3RBsDXD6I2rs8e7x9KnyZUxI8A
         baHg==
Content-Disposition: inline
In-Reply-To: <20121106171612.GH30069-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

dev_cgroup->exceptions is protected with devcgroup_mutex for writes
and RCU for reads; however, RCU usage isn't correct.

* dev_exception_clean() doesn't use RCU variant of list_del() and
  kfree().  The function can race with may_access() and may_access()
  may end up dereferencing already freed memory.  Use list_del_rcu()
  and kfree_rcu() instead.

* may_access() may be called only with RCU read locked but doesn't use
  RCU safe traversal over ->exceptions.  Use list_for_each_entry_rcu().

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Serge E. Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
Oops, wrong patch.  This is the correct one.

Thanks.

 security/device_cgroup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -164,8 +164,8 @@ static void dev_exception_clean(struct d
 	struct dev_exception_item *ex, *tmp;
 
 	list_for_each_entry_safe(ex, tmp, &dev_cgroup->exceptions, list) {
-		list_del(&ex->list);
-		kfree(ex);
+		list_del_rcu(&ex->list);
+		kfree_rcu(ex, rcu);
 	}
 }
 
@@ -298,7 +298,7 @@ static int may_access(struct dev_cgroup
 	struct dev_exception_item *ex;
 	bool match = false;
 
-	list_for_each_entry(ex, &dev_cgroup->exceptions, list) {
+	list_for_each_entry_rcu(ex, &dev_cgroup->exceptions, list) {
 		if ((refex->type & DEV_BLOCK) && !(ex->type & DEV_BLOCK))
 			continue;
 		if ((refex->type & DEV_CHAR) && !(ex->type & DEV_CHAR))
