Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795672342;
	b=jUlpX/J1b7Ttm+BGQRj2HdmrVtl0zZIRYDAA++keX8U97C3/UEjS47gaz+dWxYcvPcXc
	 stpcdv7ahO96Gdy/LlvFVI+EBO1Uay49igiWkKQqhXnwFSvopT2n26bRCVKAiUXioM4eZ
	 uLNpR1FOy8ZQRCRDuY/tsz63BoY3acIhOLjxqjNhZEVjiYq8tDNKkRxL8Irb7Xl9o+Xwh
	 MYLqxIVLjFZhuEd6klB+LJ5NlyNT1iL3NV0OJ5dITGdj9Uy+Nkx54Kdw1xMEFOO3mW0ns
	 3UkWcnxkz7/RY6fwtiuwnlBwfAtvPcAgXglc8+fSt2qDya61pkq8gJdNOaaFMuo533w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795672342;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=1mD25X2vM0tKSpsk0hOa7lL0V+yBHv3uETp5MwJ8n3g=;
	b=ZklOmb4DWnCQmjF8mXa6VNjJg85IUpvm9mhhWUzxZopXPhwp15rmIXVxNGVAbunnL8SJ
	 32aEaP93k5D1Rrtykiw4XpsIJEf4ZuFJhAsdaAKi1F429jvrmBIvDYT5rTqcCVUIuV7sS
	 z311onsqF9tDVSftN1cqKHQWqthLDQMm1FoJnmDmqx3cfCoL/cqBGUMb8kBN2Kq8AnRfS
	 TuX8EokEKBAfMHJgpV50yXHaklFSXkXErg3Jtv8nPCOrl6PTacKh8pZg/Tt2UmSAsyM5L
	 sA1+iQcD9MLrCEsgEUQOIA18wRiTLNAG/65QrGdPqRYnZM0Cj/lkwsWX3Pp1vxvocJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SR05x8JL;
	arc=none smtp.remote-ip=91.218.175.44
Received: from mta0.migadu.com (out-44.mta0.migadu.com [91.218.175.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0A7606A31C
	for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 05:52:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D0A7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SR05x8JL
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=DWd0xhelk2YFIhRVZofJlpgweZVvr/fdjF5GhP3nCXY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795672339; v=1; x=1796277139;
 b=SR05x8JLlMUYK7jnKWuLlxCA4kD34Om/t10MxvLDUxvbZnHEc89VTHBj+vWur2/+G1kw8KKY
 R1mKZKnGCfOX4xnCAybMFM3ODtCW42jYsD/rnOjgwDElYIvX74vx0gn7Xs4O0yrAs6kdyhsSoCt
 9Hoax+56vdtg/vTPtZcR9AQs=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 85f3c92f703aec8b;
	Thu, 26 Nov 2026 05:52:19 +0000
X-Mizu-Trace-ID: 85f3c92f703aec8b
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: longman@redhat.com,
	tj@kernel.org,
	corbet@lwn.net
Cc: ridong.chen@linux.dev,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH 0/2] docs: cgroup: Clarify cpuset CPU isolation
Date: Thu, 26 Nov 2026 13:52:04 +0800
Message-ID: <20261126055206.251724-1-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

The cpuset documentation has an incorrect description of boot-time
domain isolation and does not describe the housekeeping CPU requirement
for isolated partitions when full dynticks is enabled.

Patch 1 corrects the cgroup v1 description of isolcpus= and removes a
reference to the nonexistent cpuset.isolcpus file. Patch 2 documents
which CPUs must remain available for housekeeping in cgroup v2.

Guopeng Zhang (2):
  docs: cgroup-v1: Fix the isolcpus description
  docs: cgroup-v2: Document the housekeeping CPU requirement

 Documentation/admin-guide/cgroup-v1/cpusets.rst | 15 ++++++++-------
 Documentation/admin-guide/cgroup-v2.rst         |  7 +++++++
 2 files changed, 15 insertions(+), 7 deletions(-)

-- 
2.43.0

