Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793387240;
	b=jx/BwaTutcrD8lNFQKrAKCqp9gJl7lW1tp+cBiO/2Uk+rUKlEaHsEDkHuEkCjmKwA/0s
	 oke4cvCeGY5bW0eLQhcitzFmf7x+KYZcPZ/4/uDRd8oFI7OiZPbJFrXO5RX7GnggHkjZ4
	 cTkglXUjPDpEcjDznoy/p8c/Loo9QB18LEwRuhcdwAgoHKWJiR4NcWE1LNUCVjQt2bDkM
	 WcGkWDzy3Pt9LtAKoW56+Qo9vhqEyjSHHT3EzaO3E9z4Tm4sLTjqyChPM9qMeTh+B1Cmy
	 LxkY+TJGnvPTVySnpDzaJ13ux1sc1GVW/yfEapb482NzIG5X7nkiiggwu6vWuOfVWkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793387240;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Transfer-Encoding:X-Scanned-By;
	bh=ftx4ZruOAfDMI6PKXwAIqfionkRjY4/wPyB89rMsDyg=;
	b=VwJg1ory2s1ART3YpgQ2/fM6R3nqeqXk5JHoqoUOjHjJaTjEHAlw2Uk9NWDzK/cAv6y5
	 ppniPVt0IoWMhcaFgENbyWttsOCKK2T4yGLkDHKNmCrNfnpQUnNpDekN4NUuYWBB0WIXu
	 /valAuM5QsqL9tytuPCeFuIOICA7DB3f/bNk16qUEF0LGcsbq9Ee3Iuvwe5hGn63kNMeL
	 42ebIhjaFWQQStvC6bFCnntKRrq5MZ1bJB6sQVqsy7E05c3ZAv6PPFy+oGcMsVwJgAHsU
	 wIK6/PhCQblN38/U3TWWtcuGQgytFizeDHJGoEELfJM9XsTIA6fPL9jnFRP3XKAq/8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XIL7lM93;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621F4606A31F
	for <cgroups@vger.kernel.org>; Fri, 30 Oct 2026 19:07:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 621F4606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XIL7lM93
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793387239;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ftx4ZruOAfDMI6PKXwAIqfionkRjY4/wPyB89rMsDyg=;
	b=XIL7lM9359LjrhhzEJFFtWY8NAls0Hfa82MmBc0lF6Bd41TvuYnjrAbhDP9FcPkllWeWbq
	lf/MJSdLb5NvKupukYkmcrs84LQPTapS5GFlZFBeR5iPuOg0XUSp+B1jKwKDV6B8vreKK7
	7h8+z2dHaEkHvE5HDqG6wKtHXryAkG8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-262-vDJHJn7yMKi0-velmpQ4uQ-1; Fri,
 30 Oct 2026 15:07:14 -0400
X-MC-Unique: vDJHJn7yMKi0-velmpQ4uQ-1
X-Mimecast-MFC-AGG-ID: vDJHJn7yMKi0-velmpQ4uQ_1793387233
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 84AB2180058C;
	Fri, 30 Oct 2026 19:07:12 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.rmtusnh.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8D1281956088;
	Fri, 30 Oct 2026 19:07:10 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH v2 0/3] cgroup/cpuset: Fix some more bugs in cpuset partition code
Date: Fri, 30 Oct 2026 15:06:58 -0400
Message-ID: <20261030190701.78308-1-longman@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

 v2:
  - Add two fix patches for problems reported by sashiko and Guopeng.

This is another series of 3 fix patches for bugs in cpuset partition
code.

Waiman Long (3):
  cgroup/cpuset: Fix incorrect CPU accounting with parent's
    effective_xcpus expansion
  cgroup/cpuset: Recompute effective cpumask in update_cpumasks_hier()
    after calling update_parent_effective_cpumask()
  cgroup/cpuset: Do housekeeping check when isolated child with root
    parent may get more xcpus

 kernel/cgroup/cpuset.c                        | 32 ++++++++++++++++---
 .../selftests/cgroup/test_cpuset_prs.sh       | 25 +++++++++++++--
 2 files changed, 51 insertions(+), 6 deletions(-)

-- 
2.56.0

