Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD8943DA56;
	Wed, 15 Jul 2026 10:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784110280; cv=none; b=m3d5eqWJQ0b8pcd4lsRuoRnUymt2k+yNBYmJRVU4WFe6dK7+D9VFHoVn75KngIEMIAAnxE4FM3ENOTPUy9a8hGn56Yw1p1YMOppYV636pp2rY7NAraViWbqOM6v0VYbfY4AVGGfdYVWkBYKOftuCEOdIfozSINIHOrql+6AXdCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784110280; c=relaxed/simple;
	bh=Mxf3aQzzm1ZlIgi0DL+4j9W5p2xB6gAnyg59IfYqc3Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=reXHuoslmRmc6yIBE1pmHcV0WxEHJzxw3PWy6FlkSXye0B1BYUH4QAO1PC5FqzINRcj3kJ0U7D2hsotI6G5/yA+8fPjCl2k4mJEJKAA8jQKawoslByVxTAjc5V3x3yGW9g9IZH1DUVMdGK/Opqkl9ZwfA1vVqxYi/BHUvdyYyCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jdrxhmen; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jdrxhmen"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E2D1F00A3A;
	Wed, 15 Jul 2026 10:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784110278;
	bh=B2kW+nJ77Mj5M53RnXhGqydD3hqQWm7pjmVwGgIrn1U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jdrxhmenWOsGlFcFe34zNIcdL7yScchP+BGEXwVOT4VENtyhZdFST8n9qyp6/L4Yp
	 SWFYyCccxOp3weHr3MOPD+5gneEjf5ugtTQL+LgQOryTgr1mAnLlydiRjoqmwR4TYu
	 +Bpzf045bXGHBWADEZiVvUV2JsqNsXcQlm0/YrEgD6O34cGoIO6UrbfWpQRH0giKWs
	 CF3htpkQHU4rW8ss6v/x9sreGGx95uCcmruWcL01MlduUv/6CNnJRhuHkrKnSIVCa4
	 462mibkP9u12I9xjfmgn+Zf4E0JAtqA23X+lHwr3La55OrIyWgykAuBm0rq7nq2Hwl
	 5jFoqHW+fSK5w==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 15 Jul 2026 12:10:50 +0200
Subject: [PATCH RFC 10/12] mm/slab: reduce slabobj_ext memory with
 allocation profiling disabled
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260715-b4-objext_split-v1-10-9a49c4ccf4c3@kernel.org>
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
In-Reply-To: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
To: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2

When memory allocation profiling is compiled in but permanently disabled
on boot with (implicit or explicit) "never" parameter, stop allocating
(wasting) memory for the codetag_ref parts of slabobj_ext metadata.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slab.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slab.h b/mm/slab.h
index dcca86799fc9..a50347c9dbe3 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -587,7 +587,7 @@ static inline size_t static_obj_ext_size(void)
 	if (IS_ENABLED(CONFIG_MEMCG))
 		sz += 1;
 
-	if (IS_ENABLED(CONFIG_MEM_ALLOC_PROFILING))
+	if (slab_obj_ext_has_codetag())
 		sz += 1;
 
 	return sizeof(struct slabobj_ext) * sz;

-- 
2.55.0

