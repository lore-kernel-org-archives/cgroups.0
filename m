From: <xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Subject: [PATCH 2/2] docs: cgroup-v1: fix typo
Date: Fri, 21 Jul 2023 13:49:38 +0800
Message-ID: <20230721054938.1666475-2-xiongwei.song@windriver.com>
References: <20230721054938.1666475-1-xiongwei.song@windriver.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
         h=from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding:content-type; s=
        PPS06212021; bh=Y7PvSi6Jz/OCrGdAUcZr7M636MU29kh116d0H+MDGEA=; b=
        I/d6EqMCqjTlA3ovVY1WGqsspYwCRtaZhLkhDBq8WSwd0vGxGzQu9lO5CUI3tF1m
        BxiJAJJmgH2wV3SFz4SID/lf6dftuaM5Fmf8v1JUgtHYcicH13ht1o9l+AR7zsOh
        JkveqU1yZt962/Zi3X8xFRBqEGAOlaGEJQuhLF1vapFwjFr8vhyxKPz0f/x1eADz
        PRl0NqCivIJgf8Ydg/SEcR4FP2pNeT+LmjA2+oFFK/clrWSBSB+oVGlG1AyJdyrr
        nWOz2uDgcb4sdgEZdf2z5Wqlm8nSNTYrOR84ZrSbic2QxaaTdVj9n23Oj1rCMzSI
        df7/qKoCVbgm9llOAcfisA==
In-Reply-To: <20230721054938.1666475-1-xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Xiongwei Song <xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>

"listers" -> "listeners"

Signed-off-by: Xiongwei Song <xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v1/memory.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index dcb65b49bb22..1f239fa938c2 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -909,7 +909,7 @@ experiences some pressure. In this situation, only group C will receive the
 notification, i.e. groups A and B will not receive it. This is done to avoid
 excessive "broadcasting" of messages, which disturbs the system and which is
 especially bad if we are low on memory or thrashing. Group B, will receive
-notification only if there are no event listers for group C.
+notification only if there are no event listeners for group C.
 
 There are three optional modes that specify different propagation behavior:
 
-- 
2.25.1

