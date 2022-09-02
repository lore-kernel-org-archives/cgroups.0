From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH bpf-next v3 08/13] bpf: Use bpf_map_kzalloc in arraymap
Date: Fri,  2 Sep 2022 02:29:58 +0000
Message-ID: <20220902023003.47124-9-laoar.shao@gmail.com>
References: <20220902023003.47124-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=V0gc6AUiAQY/WQln3OGyPk91MKpBrNPoI3+sFkmiGew=;
        b=YdKJPsj3wxmrtdhJ63cf//SS9jJ7JPgMY5Ex1l+fOx9UNzapxQ7i8fyfCKfg4DC/fk
         SKCqoIu3Lb00g2SEoCnPl+BmSgfvaKisdl966nvF6kLOv46V4GjP7QAko0FRxIpQUgDP
         +BAUY24JOpf1j9T/XcBIZ1nzFMUebVEKtDxZ3QHbKE/m/bDB7+h36BTsKpp/lHfXQVv6
         GmxW8iDrtqqVi0VcXAO6aBbWMwwAb6hXr2tJE3pBNIxaczYssgaQaXmHSMnehmD0T9In
         MbelyenA6iu3l7pz8fEFlMFkPExLSWN/gjke+3if8/R7WdY2vWMLVfeC38NKGyCWOiVt
         Vhjw==
In-Reply-To: <20220902023003.47124-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
index 114fbda..f953acc 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -1096,20 +1096,20 @@ static struct bpf_map *prog_array_map_alloc(union bpf_attr *attr)
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

