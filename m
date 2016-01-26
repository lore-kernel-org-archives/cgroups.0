From: "Rosen, Rami" <rami.rosen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] cgroup: Fix misspelling of CONFIG_SOCK_CGROUP_DATA in
 comments
Date: Tue, 26 Jan 2016 15:08:48 +0000
Message-ID: <9B0331B6EBBD0E4684FBFAEDA55776F92CB53E91@HASMSX110.ger.corp.intel.com>
References: <1453819158-25380-1-git-send-email-andreas.ziegler@fau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453819158-25380-1-git-send-email-andreas.ziegler-d40JDW7QUjc@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Andreas Ziegler <andreas.ziegler-d40JDW7QUjc@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Rosen, Rami" <rami.rosen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Hi, 

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -604,11 +604,11 @@ static inline struct cgroup *sock_cgroup_ptr(struct sock_cgroup_data *skcd)
 #endif
 }

In this occasion, seems that maybe something else is also missing:
Shouldn't it be hereafter : +#else /* !CONFIG_SOCK_CGROUP_DATA */ 
instead ? 
   
-#else	/* CONFIG_CGROUP_DATA */
+#else	/* CONFIG_SOCK_CGROUP_DATA */
 

Regards,
Rami Rosen
Intel Corporation
