From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH bpf-next 7/9] cgroup: Add cgroup_put() in !CONFIG_CGROUPS case
Date: Tue, 10 May 2022 00:18:05 +0000
Message-ID: <20220510001807.4132027-8-yosryahmed@google.com>
References: <20220510001807.4132027-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2lpWRE3YG+N9rpa27nVaVWWHXRfllKAdvtsLrNhKAK8=;
        b=E2tVTWuknXlQ+T7MTDseqm2kLasAoY5TbquTKQN6G7HFagvNqmuYGwrGCvXPasSU3N
         X7Hfaz6BkAsSlJCS8floN1LW1Ls3ez8PP3Qk4CDVxNmG8LczACkldG8ojDGR0v0+Q7lZ
         21MumA+UYt52X45SeiI4gFrF5deapKiOdu+hj+4jT0AI8QNFnGPAtcYnE+rE1vLh3I/p
         DgTM+ee4LV0B+gFa0sepONWuiGDP56tlAl4OGQqNbhtSDbkgWBB0l4UraO/yy1Apvxzl
         ZeZuNJv+q2z07LlTR07+RdQp7xf+QnHW2FhcVMIRWFBWLCQI9fLvZVExE5a870tRXnw3
         sazg==
In-Reply-To: <20220510001807.4132027-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

From: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

There is already a cgroup_get_from_id() in the !CONFIG_CGROUPS case,
let's have a matching cgroup_put() in !CONFIG_CGROUPS too.

Signed-off-by: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 5408c74d5c44..4f1d8febb9fd 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -759,6 +759,9 @@ static inline struct cgroup *cgroup_get_from_id(u64 id)
 {
 	return NULL;
 }
+
+static inline struct cgroup *cgroup_put(void)
+{}
 #endif /* !CONFIG_CGROUPS */
 
 #ifdef CONFIG_CGROUPS
-- 
2.36.0.512.ge40c2bad7a-goog

