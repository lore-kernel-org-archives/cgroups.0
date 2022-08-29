From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] cgroup: Fix build failure when CONFIG_SHRINKER_DEBUG
Date: Sun, 28 Aug 2022 18:00:05 -1000
Message-ID: <Yww5xZtKLgBFCuY2@slm.duckdns.org>
References: <20220829132951.1f175865@canb.auug.org.au>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc;
        bh=xORpSpkCLQjB00fE/w41wxtlc3w+yIV5elX70E62Eso=;
        b=KiwyJmOUs55sjpXqlc+BHYz3sI41VDESyMnkSIVReWpVFP3s1pwXaTLA9LURs/q6dW
         DPQY4CRZaZHELQpA8MxUf+Qlih8jhsew0X1tjoml3+BIuKFafa1i6qwla7W3MufJ88sz
         r3Ua+lsaR8A3cxvlhYrR5i3I82MkZ16wxsb822x7upPhexjbgJPVIWSHo72yb57xKVrX
         CoKvxGjSY1howJWGreAlSixBHMgp7zDySDCaXp4CrXql62yaHHdUn09oIHUIdfZYCTBV
         +9ZAyGJDSvpS3oyE/dELfVlsDlMRZubVg4OK43r92PdsgLYMCndYL9wfYueizcAjGo1j
         RBXw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220829132951.1f175865-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Next Mailing List <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From c0f2df49cf2471289d5aabf16f50ac26eb268f7d Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Sun, 28 Aug 2022 17:54:15 -1000
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

fa7e439cf90b ("cgroup: Homogenize cgroup_get_from_id() return value") broken
build when CONFIG_SHRINKER_DEBUG by trying to return an errno from
mem_cgroup_get_from_ino() which returns struct mem_cgroup *. Fix by using
ERR_CAST() instead.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-by: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Cc: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>f
Fixes: fa7e439cf90b ("cgroup: Homogenize cgroup_get_from_id() return value")
---
Sorry about that. Applied this fix to cgroup/for-6.1.

Thanks.

 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 86f5ca8c6fa6..e9fc364d5e96 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5111,7 +5111,7 @@ struct mem_cgroup *mem_cgroup_get_from_ino(unsigned l=
ong ino)
=20
 	cgrp =3D cgroup_get_from_id(ino);
 	if (IS_ERR(cgrp))
-		return PTR_ERR(cgrp);
+		return ERR_CAST(cgrp);
=20
 	css =3D cgroup_get_e_css(cgrp, &memory_cgrp_subsys);
 	if (css)
--=20
2.37.2

