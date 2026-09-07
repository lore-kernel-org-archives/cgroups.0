Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346ED378D7D;
	Mon,  7 Sep 2026 14:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788790796; cv=none; b=DwgvpOpcxeuJ6lQuppFk9mDjmLSD3qYU61l1Rdy2TYthqFqHQQfE6EIfyvFGM9oyqyr8dUU4FgcBm+nSOwpFeRgxqtnlfXzxvhiCqAms/tAipAZx6+FzlQVKHRHU3wmDbMR3ThPtBKoQa6aRYHlcEv7B3A+lsjTNbCjsQnoF950=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788790796; c=relaxed/simple;
	bh=eN7CWY2gfmcryQVI/MSeKzYUfNkKxilglzsnqc8nIvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qaRggs9zcnFzLDHwcoZTuj0lRTZMprS6YCb7uyV3l7tFmEiiW3TF9qCD/EqJpGM/dYWzDT8YUvmZ84mMpNUwOxbPa6NSAJqHB0LtZ+SXx9x42+61P4Kge87P3H88e4r8S7/r78SZcCvRZyFgIrnzkB0YddZcDqPL5AqmPy90UQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=spasswolf@web.de header.b=j9ZEavmk; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=spasswolf@web.de header.b="j9ZEavmk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1788790786; x=1789395586; i=spasswolf@web.de;
	bh=GnMP+KCTCgbdas0U1IyYmNs2t5yhn7KLiMgPLuSCKsQ=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-ID:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=j9ZEavmkb+kbY4cT7GqB7tjmE6MNdIBXXD7QV4T5JL9gohgxaDOln9rJibryFcIe
	 LFhSbSpn8lCuC4B9VZet61nesABa//Inaim+QXAXaw8xTmGowptw+lZwElp28ndb9
	 xJkUK1dNvkig9NmHz8yfwS3OUW6WCASXG1P+c2ANKuf6kirI7Ut973zaB9WhXRHnI
	 jqlLv7k383jRwRTwxqRC7wMsFHIDTCN7MQk5u49DxtdAVdhSEbWE6nlaMZ6z8kCyq
	 8t3pr4sBAQWJotl893yPFcTvNnczHlyDqmVg8RtZHuxWetQJuOo+WbCIcZDE/tsUj
	 AEDAh8kDLwSmElEFmQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MgiXO-1wMZFn1Y0S-00cL9v; Mon, 07
 Sep 2026 16:14:11 +0200
From: Bert Karwatzki <spasswolf@web.de>
To: linux-kernel@vger.kernel.org
Cc: Bert Karwatzki <spasswolf@web.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-next@vger.kernel.org
Subject: [PATCH] mm: memcontrol: fix compilation
Date: Mon,  7 Sep 2026 16:14:07 +0200
Message-ID: <20260907141409.215031-1-spasswolf@web.de>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:G2vb6+5FFlvznn/JhEyhzyxR3dV+ribanwtr5FETGq1US3wHy9a
 Cp4Epu3nkl5eJh9BkXNyP7WDCvmxo15b2Z4JRU9GrXnDpskX8A0cEJZLovEvhnHnQa3K4J5
 b3hkWmmo6PYURqKLTQ1jF6Ar2s3dylmlu2ykY/eJqgjp6lZkgTVHnyrhxT7n/h846kDFO9D
 pvFUaGhKiRRRz19R5XEYg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:0myuOc/617M=;rMjm9APOiDPPlN7GhWqter35nr8
 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
 c=

Signed-off-by: Bert Karwatzki <spasswolf@web.de>
=2D--
 mm/memcontrol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5b9e0ebd42ae..e50135df6e82 100644
=2D-- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -71,6 +71,7 @@
 #include "memcontrol-v1.h"
=20
 #include <linux/uaccess.h>
+#include <linux/irq_work.h>
=20
 #define CREATE_TRACE_POINTS
 #include <trace/events/memcg.h>
=2D-=20
2.55.0

In next-20260904 compilation fails with this error:

mm/memcontrol.c: In function =E2=80=98try_charge_memcg=E2=80=99:
mm/memcontrol.c:2859:41: error: implicit declaration of function =E2=80=98=
irq_work_queue=E2=80=99; did you mean =E2=80=98drain_workqueue=E2=80=99? [=
-Wimplicit-function-declaration]
 2859 |                                         irq_work_queue(&memcg->hig=
h_irq_work);
      |                                         ^~~~~~~~~~~~~~
      |                                         drain_workqueue
  CC [M]  drivers/usb/typec/ucsi/ucsi.o
  CC [M]  drivers/usb/typec/tipd/core.o
mm/memcontrol.c: In function =E2=80=98mem_cgroup_alloc=E2=80=99:
mm/memcontrol.c:4234:9: error: implicit declaration of function =E2=80=98i=
nit_irq_work=E2=80=99; did you mean =E2=80=98init_irq_proc=E2=80=99? [-Wim=
plicit-function-declaration]
 4234 |         init_irq_work(&memcg->high_irq_work, high_irq_work_func);
      |         ^~~~~~~~~~~~~
      |         init_irq_proc
  CC [M]  drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.o
mm/memcontrol.c: In function =E2=80=98mem_cgroup_css_free=E2=80=99:
mm/memcontrol.c:4443:9: error: implicit declaration of function =E2=80=98i=
rq_work_sync=E2=80=99 [-Wimplicit-function-declaration]
 4443 |         irq_work_sync(&memcg->high_irq_work);
      |         ^~~~~~~~~~~~~

explicitly including include/linux/irq_work.h fixes the issue.

Bert Karwatzki
