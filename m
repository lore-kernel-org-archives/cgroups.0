From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH bpf-next 07/10] bpf: Use bpf_map_kzalloc in arraymap
Date: Wed, 21 Sep 2022 16:59:59 +0000
Message-ID: <20220921170002.29557-8-laoar.shao@gmail.com>
References: <20220921170002.29557-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=gqCnXF6pL1DkeQyk82Z43CJDm8euemRLx+k6VOog8Uc=;
        b=UGRZwVaZmlJMU25ZsQipxPfiqXs+wsllhJ+tOSSDcAUjFGAX7DQpWyoztud6+XklKC
         nu8mtVQhAabPURghaZx7jg8BVskiJM/UYMNF3dkH8+cvzz/onhdgh3QlOUj/uLvR9tcc
         2H31ALd6zzINn3zaoG/SK9MPdeYtU7JXkF7VliyTYP/e66MQ/ut7KGcJQZeoJUkXcYcH
         js+Cz02F2TZtIl25SDE8O4d9j6s9E8shiwIAPCn/yl46O+Envod6GqXKimJU0wpKiFxq
         HbAdN9rj34msRsmvaFGVBspvNxRmwm3ZAnxbroDnhMw2M3KrHWP120R2b3iMAiyReA34
         93Wg==
In-Reply-To: <20220921170002.29557-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kafai-b10kYP2dOMg@public.gmane.org, songliubraving-b10kYP2dOMg@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Allocates memory after map creation, then we can use the generic helper
bpf_map_kzalloc() instead of the open-coded kzalloc().

Signed-off-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/bpf/arraymap.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index dd79d0d..7f1766c 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -1111,20 +1111,20 @@ static struct bpf_map *prog_array_map_alloc(union bpf_attr *attr)
 	struct bpf_array_aux *aux;
 	struct bpf_map *map;
 
-	aux = kzalloc(sizeof(*aux), GFP_KERNEL_ACCOUNT);
-	if (!aux)
+	map = array_map_alloc(attr);
+	if (IS_ERR(map))
 		return ERR_PTR(-ENOMEM);
 
+	aux = bpf_map_kzalloc(map, sizeof(*aux), GFP_KERNEL);
+	if (!aux) {
+		array_map_free(map);
+		return ERR_PTR(-ENOMEM);
+	}
+
 	INIT_WORK(&aux->work, prog_array_map_clear_deferred);
 	INIT_LIST_HEAD(&aux->poke_progs);
 	mutex_init(&aux->poke_mutex);
 
-	map = array_map_alloc(attr);
-	if (IS_ERR(map)) {
-		kfree(aux);
-		return map;
-	}
-
 	container_of(map, struct bpf_array, map)->aux = aux;
 	aux->map = map;
 
-- 
1.8.3.1

