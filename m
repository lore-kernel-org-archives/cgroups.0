From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH bpf-next 5/5] bpf: allow to disable bpf prog memory accounting
Date: Sun,  5 Feb 2023 06:58:05 +0000
Message-ID: <20230205065805.19598-6-laoar.shao@gmail.com>
References: <20230205065805.19598-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UUYnykaARkkOFageVVuRXJFo/+sLEm/iUIcvMP09NQo=;
        b=a57J4S2w9eyKDMZ9OBUJ6kf6vR1VHJuYUOYq6cGgNDezvgehxMQxiQLzN51fOnil+5
         DlIcYvlG4h0xQaPY+WdBD9SdZIQsg67KK4axSoellK3vUZSqXtJocopfFVARTJnLQbk4
         xGzbd3RY72M2M5MSGcfKyymLNNeBoSbRbgxq8BZo9nqCyaZDW83JoZ98YMhPHNIIUdQH
         AplmWxymxSsBbTx3vRXRWPAve2uLvQTLdcAEMGTrQeiRQJ+2zB1nbaw+WBuBwBQaXiuW
         T8HRsVyFsv8OzuyK0mXraJ8183a5zu/RW4pS7pQ7r/omuWkXLEv8TbXEHyl5OEJmZyfP
         HLsQ==
In-Reply-To: <20230205065805.19598-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kafai-b10kYP2dOMg@public.gmane.org, songliubraving-b10kYP2dOMg@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

We can simply disable the bpf prog memory accouting by not setting the
GFP_ACCOUNT.

Signed-off-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/bpf/core.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 16da510..3390961 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -35,6 +35,7 @@
 #include <linux/bpf_verifier.h>
 #include <linux/nodemask.h>
 #include <linux/bpf_mem_alloc.h>
+#include <linux/memcontrol.h>
 
 #include <asm/barrier.h>
 #include <asm/unaligned.h>
@@ -87,7 +88,7 @@ void *bpf_internal_load_pointer_neg_helper(const struct sk_buff *skb, int k, uns
 
 struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flags)
 {
-	gfp_t gfp_flags = GFP_KERNEL_ACCOUNT | __GFP_ZERO | gfp_extra_flags;
+	gfp_t gfp_flags = bpf_memcg_flags(GFP_KERNEL | __GFP_ZERO | gfp_extra_flags);
 	struct bpf_prog_aux *aux;
 	struct bpf_prog *fp;
 
@@ -96,12 +97,12 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
 	if (fp == NULL)
 		return NULL;
 
-	aux = kzalloc(sizeof(*aux), GFP_KERNEL_ACCOUNT | gfp_extra_flags);
+	aux = kzalloc(sizeof(*aux), bpf_memcg_flags(GFP_KERNEL | gfp_extra_flags));
 	if (aux == NULL) {
 		vfree(fp);
 		return NULL;
 	}
-	fp->active = alloc_percpu_gfp(int, GFP_KERNEL_ACCOUNT | gfp_extra_flags);
+	fp->active = alloc_percpu_gfp(int, bpf_memcg_flags(GFP_KERNEL | gfp_extra_flags));
 	if (!fp->active) {
 		vfree(fp);
 		kfree(aux);
@@ -126,7 +127,7 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
 
 struct bpf_prog *bpf_prog_alloc(unsigned int size, gfp_t gfp_extra_flags)
 {
-	gfp_t gfp_flags = GFP_KERNEL_ACCOUNT | __GFP_ZERO | gfp_extra_flags;
+	gfp_t gfp_flags = bpf_memcg_flags(GFP_KERNEL | __GFP_ZERO | gfp_extra_flags);
 	struct bpf_prog *prog;
 	int cpu;
 
@@ -159,7 +160,7 @@ int bpf_prog_alloc_jited_linfo(struct bpf_prog *prog)
 
 	prog->aux->jited_linfo = kvcalloc(prog->aux->nr_linfo,
 					  sizeof(*prog->aux->jited_linfo),
-					  GFP_KERNEL_ACCOUNT | __GFP_NOWARN);
+					  bpf_memcg_flags(GFP_KERNEL | __GFP_NOWARN));
 	if (!prog->aux->jited_linfo)
 		return -ENOMEM;
 
@@ -234,7 +235,7 @@ void bpf_prog_fill_jited_linfo(struct bpf_prog *prog,
 struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
 				  gfp_t gfp_extra_flags)
 {
-	gfp_t gfp_flags = GFP_KERNEL_ACCOUNT | __GFP_ZERO | gfp_extra_flags;
+	gfp_t gfp_flags = bpf_memcg_flags(GFP_KERNEL | __GFP_ZERO | gfp_extra_flags);
 	struct bpf_prog *fp;
 	u32 pages;
 
-- 
1.8.3.1

