From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/6] cgroup: make cftype->private a unsigned long
Date: Thu, 25 Jun 2015 17:38:52 -0400
Message-ID: <1435268337-1738-2-git-send-email-tj@kernel.org>
References: <1435268337-1738-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FxoiENMtuKd9o4xi/T8DNoNR1DaOiLZJOX43N1bFRR8=;
        b=sL6MN8wFZUyvsvPi4aqxJ5zHSmPj3COUhgi07O2zoCcECQSTmTf25K+i6JGtoQkW2n
         9yAqPlGPQ0pwGA0U2MxanCLtsSYGsT8f5GFIPZoqjZ9Kcf+Hm5m3xF6jE7uJC8pFUCqF
         J/JnHqvG2kEVE5u27owwh+E0XV0DpkqZcg8eJ2kJSHTgsQIPOHvjqZp9WpK+hpAToFmG
         aujVExaCx5RLdMqRT4kD/BSiOI8xzP5d2WFGr7gj3rZjYK6sILStMIze9U/rl97N/kIJ
         3CREVfGiol/8oPQjZ5Ec7+PADcYG8hISwpCC60kvjg6MJU71CatPtsAjB8cZqHwsERP6
         75hg==
In-Reply-To: <1435268337-1738-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

It's pretty unusual to have an int as a private data field and it
makes it impossible to carray a pointer value through it.  Let's make
it an unsigned long.  AFAICS, this shouldn't break anything.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index e7da0aa..5571f9f 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -417,7 +417,7 @@ struct cftype {
 	 * end of cftype array.
 	 */
 	char name[MAX_CFTYPE_NAME];
-	int private;
+	unsigned long private;
 	/*
 	 * If not 0, file mode is set to this value, otherwise it will
 	 * be figured out automatically
-- 
2.4.3
