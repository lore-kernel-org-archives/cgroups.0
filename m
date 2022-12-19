From: Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 01/10] docs: cgroup-v1: extend underline of section 8
Date: Mon, 19 Dec 2022 11:22:00 +0700
Message-ID: <20221219042209.22898-2-bagasdotme@gmail.com>
References: <20221219042209.22898-1-bagasdotme@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rf1ACU1p6R9dNKmN5MUoIBYgA/aDmrGTefWeFw4FNFs=;
        b=VVMSfTlUA9HuhH9vvEonzOiWvAjByqAsh2y6ihUJpOuzLOlRxVdAkLfNeqbgB7+jiV
         d4PUUkwZjROAjnuSiuOXJuaumnRRKMFKmX+3ii+MFBcQEGk7orUj/VXGC5/ZzxMHMMKK
         s/K7XksauWGoqPHEoVii9LOZFwR7B1plzXiad4PktoblqlbNXJhiBBTXFxwNMeYHz/uz
         P6il3KL0zXD/Yyig85v008Cl4r4AWYuO+g4f96/sJXngmDBKIKapc3Vt5HTZdz8Fo96G
         f7r2t+Dg4DytpKegAj6jU2kpEgWAnH9sYDGmaxF4wbwIRicVejpWwdZw0XQ1DirZ28ey
         wl4Q==
In-Reply-To: <20221219042209.22898-1-bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1318; i=bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; h=from:subject; bh=0T+nIwJE0sYswok26CNbNxcSAtUv7ROGjQG7VnVQn2o=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDMnzn71NK+ZaFhzc2aXak8LgGWHHYbhsgYtg6swzgg+TxHY0 XvnYUcrCIMbFICumyDIpka/p9C4jkQvtax1h5rAygQxh4OIUgIlkcTIyLJWR8X/FmmKllbdoCVviWs tEk6mP/c6cYhAU2hQbGnFCkuGfdtXiks0XNS6t+VKZce3olRLBlsg6oTkyWwuXXXOxFNvIAAA=
X-Developer-Key: i=bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>

kernel test robot and Stephen Rothwell reported htmldocs warning:

Documentation/admin-guide/cgroup-v1/memory.rst:723: WARNING: Title underline too short.

Extend underline in section 8 heading to match the text in order to fix
the warning.

Link: https://lore.kernel.org/linux-doc/202212180030.OzPG7QHL-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/
Link: https://lore.kernel.org/linux-next/20221218062235.443758ae-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org/
Fixes: f8bc956f6ea695 ("mm: memcontrol: deprecate charge moving")
Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reported-by: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Signed-off-by: Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v1/memory.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 87d7877b98ec79..258e45cc3b2db1 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -720,7 +720,7 @@ NOTE2:
        otherwise the hard limit will take precedence.
 
 8. Move charges at task migration (DEPRECATED!)
-=================================
+===============================================
 
 THIS IS DEPRECATED!
 
-- 
An old man doll... just what I always wanted! - Clara

