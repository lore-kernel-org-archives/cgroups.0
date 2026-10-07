Received: from mta0.migadu.com (out-21.mta0.migadu.com [91.218.175.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A935411F9F
	for <cgroups@vger.kernel.org>; Wed,  7 Oct 2026 07:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791358858; cv=none; b=hzkeB53+MU43mXa9v6Au/ybzjpW05kLGwck75ZRGHzcod2rZ0+tUSJQ5o26KwOpegFsapY8+ozZUMHB3QM+70zq1/o0pph1vNJf3sWhuUW5PPC2W1VKkVndkxzY9lmKUHltiQ8tcgiP/lpzjyQmn7RfIl5Ka+Gop6stBSvdlHkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791358858; c=relaxed/simple;
	bh=zpeDri79jDSPiCNzLVYdDR1QwvFynzb8SDt007S+BUU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l3k21wDKGI9J+xfe6JCqp+KOjazHkvVCgtzOliz4gsCf9P5sWLDeUTTv0S1Bar2gOpOwrleLEx0IsIgfg9WK67gExH6+OAgI/iDUzgBDzvLMLqlLDccETvjVK93OeP9hF7MI7/JSbDpJUaT8Lm2Ox0FTTExzuvxMyYbdGve4wTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kk1okmSf; arc=none smtp.client-ip=91.218.175.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kk1okmSf"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=zpeDri79jDSPiCNzLVYdDR1QwvFynzb8SDt007S+BUU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791358853; v=1; x=1791963653;
 b=kk1okmSf9+7vs0SgS0oQS3aBrhyw7ly6rEkOLhaXqAEHsrNMUUC0hgsnVYzqXyP2xezo300j
 Tn3vHRXVwS9JrUH8WVeOQzroTg6ZYzRpoeNkHeuPLYY41TNBJWRyGvlEuHydbTmmzalu3NtNCz8
 tAsjQHy4ubCuMfaj6gxVVhGY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2885e374f357218a;
	Wed, 07 Oct 2026 07:40:43 +0000
X-Mizu-Trace-ID: 2885e374f357218a
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	James Houghton <jthoughton@google.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] KVM: selftests: Fix incremental build dependencies
Date: Wed,  7 Oct 2026 08:40:37 +0100
Message-Id: <20261007074037.316564-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260922071945.693714-1-fuad.tabba@linux.dev>
References: <20260922071945.693714-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Sean, Paolo,

Gentle ping on this series.

Cheers,
/fuad
