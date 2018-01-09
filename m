From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] string: drop __must_check from strscpy() and restore
 strscpy() usages in cgroup
Date: Tue, 9 Jan 2018 07:21:15 -0800
Message-ID: <20180109152115.GH3668920@devbig577.frc2.facebook.com>
References: <20180108145223.GS3668920@devbig577.frc2.facebook.com>
 <CA+55aFzLYgX5WVAFASH65LkTtvSbn_g6eibxe1Psoc1Uc2hFkw@mail.gmail.com>
 <CA+55aFxSbAJe9gnL7jXHUO8KzY8TbrvSt7+jWsTZTJt7EMMzuw@mail.gmail.com>
 <20180108192801.GZ3668920@devbig577.frc2.facebook.com>
 <CA+55aFyQu8wTOJ8HdUjRA2NnLLdXRPvPyEyaws=5VULVJrDSxg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=4+1oOApDQyrjS+kff9uKbSVgf/I9/DQScN1VIe3Ogbc=;
        b=k+F9lg/irAKmWNzfNXhHOiH35uown/ukjFVf6UsNBv2CJv4ttEIPN5niUdCRnXTjRm
         ZiBvFQb74D2gDYa1VIpTEHUXYqrEZa3I32U8J4I6+4vPcI1P2Nwy4VWvz125ni+QG++y
         cthPSQJt3fNZkxKcUPqIQZwfQPLjirIUKgMpXz7TBmS4ztiGFuRdIGYAbFN3XzgaHXvo
         nCiAXLMl7QRIyZRlgu/3HrqyxRyWyNXqrqQhKgQi5oUvNCZjG4oYfvAtR8QkKTeyFffy
         vSaauO9F4AutsuLZJLTMNRWLPiQIQsX+hQXubeTiFEzZtPAKxQCFkOAqlVX34i4/wMo+
         fZsA==
Content-Disposition: inline
In-Reply-To: <CA+55aFyQu8wTOJ8HdUjRA2NnLLdXRPvPyEyaws=5VULVJrDSxg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ma Shimiao <mashimiao.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>

From ceb2d2b2e496f180be95adb670337bb254f89323 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Tue, 9 Jan 2018 07:00:29 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

e7fd37ba1217 ("cgroup: avoid copying strings longer than the buffers")
converted possibly unsafe strncpy() usages in cgroup to strscpy().
However, although the callsites are completely fine with truncated
copied, because strscpy() is marked __must_check, it led to the
following warnings.

  kernel/cgroup/cgroup.c: In function ‘cgroup_file_name’:
  kernel/cgroup/cgroup.c:1400:10: warning: ignoring return value of ‘strscpy’, declared with attribute warn_unused_result [-Wunused-result]
     strscpy(buf, cft->name, CGROUP_FILE_NAME_MAX);
	       ^

To avoid the warnings, 50034ed49645 ("cgroup: use strlcpy() instead of
strscpy() to avoid spurious warning") switched them to strlcpy().

strlcpy() is worse than strlcpy() because it unconditionally runs
strlen() on the source string, and the only reason we switched to
strlcpy() here was because it was lacking __must_check, which doesn't
reflect any material differences between the two function.  It's just
that someone added __must_check to strscpy() and not to strlcpy().

These basic string copy operations are used in variety of ways, and
one of not-so-uncommon use cases is safely handling truncated copies,
where the caller naturally doesn't care about the return value.  The
__must_check doesn't match the actual use cases and forces users to
opt for inferior variants which lack __must_check by happenstance or
spread ugly (void) casts.

Remove __must_check from strscpy() and restore strscpy() usages in
cgroup.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Suggested-by: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Ma Shimiao <mashimiao.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
---
 include/linux/string.h | 2 +-
 kernel/cgroup/cgroup.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/string.h b/include/linux/string.h
index cfd83eb..96115bf 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -28,7 +28,7 @@ extern char * strncpy(char *,const char *, __kernel_size_t);
 size_t strlcpy(char *, const char *, size_t);
 #endif
 #ifndef __HAVE_ARCH_STRSCPY
-ssize_t __must_check strscpy(char *, const char *, size_t);
+ssize_t strscpy(char *, const char *, size_t);
 #endif
 #ifndef __HAVE_ARCH_STRCAT
 extern char * strcat(char *, const char *);
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 2cf06c2..480f2a7 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1397,7 +1397,7 @@ static char *cgroup_file_name(struct cgroup *cgrp, const struct cftype *cft,
 			 cgroup_on_dfl(cgrp) ? ss->name : ss->legacy_name,
 			 cft->name);
 	else
-		strlcpy(buf, cft->name, CGROUP_FILE_NAME_MAX);
+		strscpy(buf, cft->name, CGROUP_FILE_NAME_MAX);
 	return buf;
 }
 
@@ -1864,9 +1864,9 @@ void init_cgroup_root(struct cgroup_root *root, struct cgroup_sb_opts *opts)
 
 	root->flags = opts->flags;
 	if (opts->release_agent)
-		strlcpy(root->release_agent_path, opts->release_agent, PATH_MAX);
+		strscpy(root->release_agent_path, opts->release_agent, PATH_MAX);
 	if (opts->name)
-		strlcpy(root->name, opts->name, MAX_CGROUP_ROOT_NAMELEN);
+		strscpy(root->name, opts->name, MAX_CGROUP_ROOT_NAMELEN);
 	if (opts->cpuset_clone_children)
 		set_bit(CGRP_CPUSET_CLONE_CHILDREN, &root->cgrp.flags);
 }
-- 
2.9.5
