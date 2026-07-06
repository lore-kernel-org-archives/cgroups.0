Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592543812F2
	for <cgroups@vger.kernel.org>; Mon,  6 Jul 2026 05:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.139.111.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783315492; cv=none; b=ABLNssZCdaGMRoBzZ7N6t37hsXtPoYR+spkWV+SsQELxyo+d3RBqNWHyiuEd8FYnm7qKc/9MOMXD6x4/KJ8ZWmNQzal3cbYfDj13Juqw+/w0kpjH+vkYw0EU2kxnz+omWxrSFyfs4XERnEGEW5VFx7EsOunXJaYyvDvwbgI9kPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783315492; c=relaxed/simple;
	bh=INOi3BRcSIt7TtwgJ3aD22mPs5dhPNiSTX+Krac+R5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=qCzDeH00UtV2hobeem2l8Osa0WDNAHMF2beCmNeFLvhh39fzm7P5Yv+brpz1BQpMvnzqd9LZGFvCIRprucQQSysrWqAisN+vwMvqZUOML61VM3CqaT3mZp+2y+HZ8fKVKuD/UiuTTVlKZWsrNHWPXBYXR77bKZzy2XLKZyKHZwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=fail smtp.mailfrom=gmail.com; arc=none smtp.client-ip=205.139.111.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=gmail.com
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-58-0n8T6XdSOZepQ-G3iAro5A-1; Mon,
 06 Jul 2026 01:24:45 -0400
X-MC-Unique: 0n8T6XdSOZepQ-G3iAro5A-1
X-Mimecast-MFC-AGG-ID: 0n8T6XdSOZepQ-G3iAro5A_1783315483
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D8EB1955F04;
	Mon,  6 Jul 2026 05:24:43 +0000 (UTC)
Received: from dreadlord.redhat.com (unknown [10.67.32.13])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3E19B1956096;
	Mon,  6 Jul 2026 05:24:35 +0000 (UTC)
From: Dave Airlie <airlied@gmail.com>
To: dri-devel@lists.freedesktop.org,
	tj@kernel.org,
	christian.koenig@amd.com,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>
Cc: cgroups@vger.kernel.org,
	Thomas Hellstrom <thomas.hellstrom@linux.intel.com>,
	Waiman Long <longman@redhat.com>,
	simona@ffwll.ch,
	intel-xe@lists.freedesktop.org
Subject: [PATCH 07/10] memcontrol: allow objcg api when memcg is config off.
Date: Mon,  6 Jul 2026 15:22:36 +1000
Message-ID: <20260706052330.1110909-8-airlied@gmail.com>
In-Reply-To: <20260706052330.1110909-1-airlied@gmail.com>
References: <20260706052330.1110909-1-airlied@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qctr3hkmEyFq98gbVLvMRPG1ST97xn1Vo31hRlSLYMc_1783315483
X-Mimecast-Originator: gmail.com
Content-Transfer-Encoding: quoted-printable
content-type: text/plain; charset=WINDOWS-1252; x-default=true

From: Dave Airlie <airlied@redhat.com>

amdgpu wants to use the objcg api and not have to enable ifdef
around it, so just add a dummy function for the config off path.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 include/linux/memcontrol.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 9d057f58c9d0..100b87d9652f 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1827,6 +1827,11 @@ static inline void __memcg_kmem_uncharge_page(struct=
 page *page, int order)
 {
 }
=20
+static inline struct obj_cgroup *get_obj_cgroup_from_current(void)
+{
+=09return NULL;
+}
+
 static inline struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *f=
olio)
 {
 =09return NULL;
--=20
2.54.0

