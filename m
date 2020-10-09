From: Ralph Campbell <rcampbell-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] mm/memcg: fix device private memcg accounting
Date: Fri, 9 Oct 2020 14:59:52 -0700
Message-ID: <20201009215952.2726-1-rcampbell@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602280794; bh=7mbqnLRSmP8gyFcv2CaKHAGuiDlEp5BFChE0DK1AomM=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         X-NVConfidentiality:Content-Transfer-Encoding:Content-Type;
        b=GeXxS06CgAM4OOs4VCnOprIky8XoMeqlb13IWp0IGbvVpb7B8gd+hqzTalJC/zNQy
         wqBVq14+n5Sn4XP6sXOxEMREEzyaO7RQXpwh00B/1HXhMrUJXKm6747f8MNxqTAovl
         RMHcyxNBZo/hWbb4hatQSFNc2MqflrLJCFYTod+GkNE6Rm4eIOjVfeVKsgWm5pa0ta
         T0bUuVSRMbG740o3HCQ5e89pmK/+o+j31QFnM4S85NaLtML/52R0fzfQN3RHTsuJKT
         Y0Xg08kvpmukYGORsuuNmYdLYb4jE1bR00IypKYRojk7PVJADHRkW0mGzF4VnQCS1y
         +dRqbzURrmy8g==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ralph Campbell <rcampbell-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The code in mc_handle_swap_pte() checks for non_swap_entry() and returns
NULL before checking is_device_private_entry() so device private pages
are never handled.
Fix this by checking for non_swap_entry() after handling device private
swap PTEs.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Fixes: c733a82874a7 ("mm/memcontrol: support MEMORY_DEVICE_PRIVATE")
Signed-off-by: Ralph Campbell <rcampbell-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
---

I'm not sure exactly how to test this. I ran the HMM self tests but
that is a minimal sanity check. I think moving the self test from one
memory cgroup to another while it is running would exercise this patch.
I'm looking at how the test could move itself to another group after
migrating some anonymous memory to the test driver.

This applies cleanly to linux-5.9.0-rc8-mm1 and is for Andrew Morton's
tree.

 mm/memcontrol.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2636f8bad908..3a24e3b619f5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5549,7 +5549,7 @@ static struct page *mc_handle_swap_pte(struct vm_area=
_struct *vma,
 	struct page *page =3D NULL;
 	swp_entry_t ent =3D pte_to_swp_entry(ptent);
=20
-	if (!(mc.flags & MOVE_ANON) || non_swap_entry(ent))
+	if (!(mc.flags & MOVE_ANON))
 		return NULL;
=20
 	/*
@@ -5568,6 +5568,9 @@ static struct page *mc_handle_swap_pte(struct vm_area=
_struct *vma,
 		return page;
 	}
=20
+	if (non_swap_entry(ent))
+		return NULL;
+
 	/*
 	 * Because lookup_swap_cache() updates some statistics counter,
 	 * we call find_get_page() with swapper_space directly.
--=20
2.20.1

