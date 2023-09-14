From: Huan Yang <link-DGpbCiVdSXo@public.gmane.org>
Subject: [PATCH 3/3] mm: multi-gen LRU: add per memcg "lru_gen" document
Date: Thu, 14 Sep 2023 18:47:45 +0800
Message-ID: <20230914104754.55-4-link@vivo.com>
References: <20230914104754.55-1-link@vivo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mkdcu0RJevDOOepNMe9zA/YQFdE14GSo/+eXT41SmFY=;
 b=JLQidermfHMYYERI+cnyDx5Uvcy9ZKUuDudM4//wKNnYDtqRrmUpVAzaIstkCXEQzklZ8oInT/Dw6HHnW9w5xptYLNSwRIzbQdVMb0MIJMva+EPw6PaGjOm5NLf87at64j/z3hVXn09Fu9dek5XzC6f1Knzog4XYAysmk48abT56Iumd41t5Nm8kkMsan1KbZFeg8q2B99ibC6QjIzAlF1ZQgZF5NTAKfs3x1pWuglpecQcwFlc1lRgEctQF0xYKWb96oHcB3o8CPtHUPWvNOwPziMYP4tIHlcoW0BgaByVnEkV58/stH9Dn00BWC9Fe5tFgRLzFuXDQuHwU919Hrg==
In-Reply-To: <20230914104754.55-1-link-DGpbCiVdSXo@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Jan Alexander Steffens (heftig)" <heftig-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Huan Yang <link-DGpbCiVdSXo@public.gmane.org>, Brian Geffon <bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Gaosheng Cui <cuigaosheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Peter Xu <peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Axel Rasmussen <axelrasmussen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Alumbaugh" <talumbau-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm@kvac
Cc: kernel-DGpbCiVdSXo@public.gmane.org

change multi-gen LRU document.

Signed-off-by: Huan Yang <link-DGpbCiVdSXo@public.gmane.org>
---
 Documentation/admin-guide/mm/multigen_lru.rst | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/admin-guide/mm/multigen_lru.rst b/Documentation/admin-guide/mm/multigen_lru.rst
index 33e068830497..078056b8cc7c 100644
--- a/Documentation/admin-guide/mm/multigen_lru.rst
+++ b/Documentation/admin-guide/mm/multigen_lru.rst
@@ -160,3 +160,13 @@ cold pages because of the overestimation, it retries on the next
 server according to the ranking result obtained from the working set
 estimation step. This less forceful approach limits the impacts on the
 existing jobs.
+
+Per memcg lru gen node
+-----------------
+In each memcg's dir, it contains ``lru_gen`` node. you can type upon cmd
+without input memcg_id to do the same thing.
+
+    ``+ node_id max_gen_nr [can_swap [force_scan]]``
+    ``- node_id min_gen_nr [swappiness [nr_to_reclaim]]``
+
+For show info, memcg's node always show the full info.
-- 
2.34.1

