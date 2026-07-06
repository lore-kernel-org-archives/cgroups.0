Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D0E3A9605
	for <cgroups@vger.kernel.org>; Mon,  6 Jul 2026 02:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.139.111.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783305783; cv=none; b=ajqmlJjGP48p6TqJTJBk0rQRy5gcZI/dukNGGVvuYUu6nTnDmzKiMBodG9a0hrUol/ijq7ZEl5vzD9Yv3kIdDKJr4zM+jTk9NXdR2fUVrYcJXE/FTkLvUxr/mfkfvB8tISu7C4RKjH8CjEKMVStvWixICa+Tkjy1ESkPwZp48KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783305783; c=relaxed/simple;
	bh=Ov6PdTjuk8SAVI4sc7+h/iyRA1ls2mem+qq8xCEfT9A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=aqw6MUqrdRrWZxxUHefnYxtlNzrmWsggMHbaPV4Q+i64BrknGWSIKwHobkMB8JWQA+EGGQQISscuT/duRqVMjFYFxKVSHt77g0TThjX+duOQ0NPaQKaYWsom9JYvUcl7js82u10rzWTz3GUYC3W545Xl8lCQ0v2xdnTa/wwqSh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=fail smtp.mailfrom=gmail.com; arc=none smtp.client-ip=205.139.111.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=gmail.com
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-448-qAdnzgQbO3KdSj3kfVunCA-1; Sun,
 05 Jul 2026 22:41:38 -0400
X-MC-Unique: qAdnzgQbO3KdSj3kfVunCA-1
X-Mimecast-MFC-AGG-ID: qAdnzgQbO3KdSj3kfVunCA_1783305696
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D5ED21801378;
	Mon,  6 Jul 2026 02:41:35 +0000 (UTC)
Received: from dreadlord.redhat.com (unknown [10.67.32.13])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5AEB83000B4C;
	Mon,  6 Jul 2026 02:41:27 +0000 (UTC)
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
Subject: drm/ttm/memcg/lru: enable memcg tracking for ttm, xe and amdgpu driver (part 2).
Date: Mon,  6 Jul 2026 12:36:09 +1000
Message-ID: <20260706024122.853329-1-airlied@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3mv9vG7FohDzKquh9f83kyXYftwCD8t3X-htix_EHzc_1783305696
X-Mimecast-Originator: gmail.com
Content-Transfer-Encoding: quoted-printable
content-type: text/plain; charset=WINDOWS-1252; x-default=true

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

