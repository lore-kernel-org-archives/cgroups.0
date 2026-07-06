Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E330529BD8C
	for <cgroups@vger.kernel.org>; Mon,  6 Jul 2026 05:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.139.111.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783315432; cv=none; b=twIjxTs9MTfVlGhEZm8ZEaSfl47GKB/oiwKPye/PmjaAojZvr6pc6P1dkNLO4P2ayqamncyLHDktckUtBLw512C2orJeTtPohFcFv0BAuEIW/Z4eJeXR+Xw0FfaAeBMoSP3g0z7ijQsdgffdGJlkkedzRYU3DJHKkmwkx4a7Zo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783315432; c=relaxed/simple;
	bh=SCwnODb+Os/HuwW45iZK/uX86zqakjFs1jo/Z9VxSI0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=MgXv85arqwJxSTYcBAZXIf7fXAY/X2H23aZZw1jZqsO+6+dDBaP17oOYZbSR0Cpcby+u0Fb3hCPr3pb02hbFKRwP7DG13+vU0skRnT4W89ORvUBuX+90y1yHI5ipoljZnWlfyKiAWAB/zQ4nRou9BZHt6/ZUuzdnRmzRl7dLK/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=fail smtp.mailfrom=gmail.com; arc=none smtp.client-ip=205.139.111.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=gmail.com
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-26-odXm0R1VPzCEJ_HSJO9U-w-1; Mon,
 06 Jul 2026 01:23:46 -0400
X-MC-Unique: odXm0R1VPzCEJ_HSJO9U-w-1
X-Mimecast-MFC-AGG-ID: odXm0R1VPzCEJ_HSJO9U-w_1783315424
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E5D151800640;
	Mon,  6 Jul 2026 05:23:43 +0000 (UTC)
Received: from dreadlord.redhat.com (unknown [10.67.32.13])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 75A161956096;
	Mon,  6 Jul 2026 05:23:34 +0000 (UTC)
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
Subject: drm/ttm/memcg/lru: enable memcg tracking for ttm, xe and amdgpu driver (part 2) (v2).
Date: Mon,  6 Jul 2026 15:22:29 +1000
Message-ID: <20260706052330.1110909-1-airlied@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bsNP7sqvqq6s1XAQFP0zpbqGzNcd4MqMcg3skOAvXqg_1783315424
X-Mimecast-Originator: gmail.com
Content-Transfer-Encoding: quoted-printable
content-type: text/plain; charset=WINDOWS-1252; x-default=true

This is just a repost with a number of sashiko identified problems that I f=
ixed.

I committed the vmstat counters and list lru changes, and they are now in t=
ree.

This is the remainder of this series. Intel have expressed interest in gett=
ing
this landed for xe, we can drop the amdgpu changes for now if they can't ge=
t
across the line.

I've dropped all previous acks/reviews.

This series adds the memcg counters for GPU active and GPU reclaim to align
with the two global vmstats. It adds an accounting flag to TTM alloc/popula=
te,
and enables memcg tracking and shrinker support in TTM.

Then it adds amdgpu and xe support.

I think for this to land, Christian holds the main objection which I still =
fail
to fully understand beyond it doesn't solve all the problems we ever have h=
ad
with cgroups and drm, so we shouldn't even bother, and maybe we could do it=
 at
the object level, and integrated with dmem, and android cross process accou=
nting,
but I still feel this is a good baseline.

I think this is the right layer to hook this into TTM, where we allocate me=
mory
and I think accounting for this memory in a proper way should be done.

Intel folks (Thomas/Maarten) please review and express concerns as well.

Regards,
Dave.

