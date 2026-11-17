Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794922094;
	b=sxnH/xZLv41hBHT1SbG3YBvFXO+X7nBzAHWFxYceB+VStRrrXYY+d+QspA7gR3Jbf20E
	 pT0KajegEugzT/zw2dCMadslTAutozAMfya/IpuUpOTK4Cl0R1Cyxpc94FG2v8JsAe2oC
	 9YdAZLL3heS1pHW0RyhHee42fHAB0OcCcWIywfFP4JjaL+mrbNlrf8kG1U0rs/7u4/UZO
	 PT3FAiIr2OtOg/OSPuFSnynOHMNwb56BkW07fhjuOVJqHTcg9OzRxiGRa0rwI0uMaII4y
	 J3/BxwAzbzEJsqjrCJi3UuRLjsFnG3MhvzcPP8mv4UpZjQNoUm7wjgdXhCv/hHLXgNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794922094;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Developer-Signature:X-Developer-Key:
	 X-Scanned-By;
	bh=bq6R3BqIosLVAUzNBGUDBPt6z67HPJp6MUmEltWOs20=;
	b=vVqM/3aQbsGe/eVKC3Mie6BLJ17v4DoJFjLiypbAkL9WuHDjIJeHM66nCzMNrAD82B/O
	 qZFqgNp/dQA5sHWrwEkbIDHjsI1eaBtOdpkTgRkIF/G/TwYNOCNw1b2pbW4OkyR14+uA/
	 IP/oeLucjb68F4JTYxrLg23+jpJdsS7Zv8GrzXL0+ySdsiylDDA/SFiIcFjHh0JYWWKPh
	 4VT8NNPXNiU8Oma/u6E5jeYmBkBcBh6S27iuQow21WuIaZ/Liqz85cdMSzD1H5WUTjPA7
	 Ez9c7FRWepRi4nQX9iknhjQqM0QZZ/F2+jS3CP4s1QZE6IQ0sCDmoqVYxnDuypMfYOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Aq0imIxP;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849ED606A323
	for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 13:28:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 849ED606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Aq0imIxP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794922091;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bq6R3BqIosLVAUzNBGUDBPt6z67HPJp6MUmEltWOs20=;
	b=Aq0imIxPieriIO7wgSC9e+IozVkcByUqtZDRknVQ/sRDNStNSEBdMCiJQLBLIte1XgYWqz
	qPew9zyZk2pCH2LCqqQDOAvdLHZ5kuumq2L0HCHHFP90TgjkRItS6lYHVrX00wUVuyHmkG
	kkUNpLUthvp31XE2YnRGArgjmmgVJDE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-146-xzZPgCPEP-Kgpmv5Om80EA-1; Tue,
 17 Nov 2026 08:28:08 -0500
X-MC-Unique: xzZPgCPEP-Kgpmv5Om80EA-1
X-Mimecast-MFC-AGG-ID: xzZPgCPEP-Kgpmv5Om80EA_1794922086
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E45801955F54;
	Tue, 17 Nov 2026 13:28:05 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B05E8195B3C2;
	Tue, 17 Nov 2026 13:28:02 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Tue, 17 Nov 2026 14:27:47 +0100
Subject: [PATCH v7 2/3] selftests: cgroup: Add KB() helper
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-kunit_cgroups-v7-2-5bcbfe17f323@redhat.com>
References: <20261117-kunit_cgroups-v7-0-5bcbfe17f323@redhat.com>
In-Reply-To: <20261117-kunit_cgroups-v7-0-5bcbfe17f323@redhat.com>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Maarten Lankhorst <dev@lankhorst.se>, 
 Natalie Vock <nat@pixelcluster.dev>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 Albert Esteve <aesteve@redhat.com>, echanude@redhat.com, mripard@kernel.org, 
 R Nageswara Sastry <rnsastry@linux.ibm.com>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794922072; l=832;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=io48fDca3BBUAIFe/tlBE5JydAIJrbrMjKfgVtDHM0s=;
 b=VpmN8iP/Oogl0zCSUe2jFV/1Us2cmshcuya+GdRv0gTE8YNzsl5KjKhe/m+aK6WgGsnKZAz4b
 mnVfx3pUDC3ASamv564nd7NlaILXHMk8Rn8NbTUfJuAyEsUwyduAp6v
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

cgroup_util.h already has MB() and GB() for size
literals. Add KB() in the same style so tests can
spell kilobyte values without in-code shifts.

Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 tools/testing/selftests/cgroup/lib/include/cgroup_util.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
index 5307f3bf32a0..455e52a516da 100644
--- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
@@ -6,6 +6,7 @@
 #define BUF_SIZE 4096
 #endif
 
+#define KB(x) (x << 10)
 #define MB(x) (x << 20)
 #define GB(x) ((unsigned long long)(x) << 30)
 

-- 
2.55.0

