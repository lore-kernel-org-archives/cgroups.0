Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794582482;
	b=ipbiX7Fg5WxaxdPkOoX4z8hsPAIkD4w9LWaAR2SGhB0SJSodT9uADPf1Dob6q5PSkGSD
	 bwvPxcGHIACLD07eDDM3bbTkTJ0kI9PqEc624rc37Jx3kK+E9030fAalD2BsW44aaPgxd
	 EthFqKXsX1vMmFYb3ySJlT0wk4fnHIS3Kjdi3lV+LBTPWjMIjxr2bqre7QMoFuVXGFeTw
	 NBkVE0vthg9ZCaBOp3SSJiEBSw7beVXxZ0lxnactPzNFoOPKV2xYfYADSLFkHhbVyBYmK
	 u3Cny/vquTJMznSGitgdifU4SmhNl/xhfUx7v2f8pMqZmmvIcfsh7U9x16VEF8QyIFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794582482;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=aOrKfpbFYffgtTODqXNpk01o8WFHQPGbS4apVzTT7bQ=;
	b=r3vvjjaCFM5bZOKTTLBlND+bZ41aJOr3WYmZNlvzCKbCeTnUoQDpEPP3mi3cslLfy8QT
	 mTQ5CXI74SSLHBKdvdbUvMgEmyVB0YdrHC+PN0ahfwCiy/EvO2RSIomBsFQyi2aIrGuuy
	 7jtqEDghsgEJxNadWTOd6xLZ9nJmBWyR0RR0zOiVdn4wbwGyZs842a4ID4PUlh/1teld3
	 M/uLxUoJLZ67VvinshfgVV3r0XnV9yu6yPjNfOl7mOHfOV7OL/dWoFAdqgK+jtydqiL4b
	 C/2ADe9qXw4NnL9lOEY58LyvdfUxXfZgQN0br9DhHYoe6kga1Ci2L6kvEKcHZxh3Pnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ipm2ljuh;
	arc=none smtp.remote-ip=95.215.58.69
Received: from mta1.migadu.com (out-69.mta1.migadu.com [95.215.58.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0304F606A332
	for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 15:08:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0304F606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ipm2ljuh
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=5JN5ghI8dNw9QS0mTyFnJuNnXSuxG5Od9sIgQTg8Rss=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794582479; v=1; x=1795187279;
 b=ipm2ljuh89p+MZIQXU33RzY4MuB1Vxg9XvIjcS7OMHudXFJJv24l/QkflnkA2mYduWsRza54
 QmR+IomLiLmC2VEgoHNbMl462ECO4XVGeb4W17dznlZujBECOqka9t5myQtyK3ILw+HZCcqm6dL
 YsN62VGocIqqUWtdBFtKNOMY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 190fc832efd7b1c5;
	Fri, 13 Nov 2026 15:07:58 +0000
X-Mizu-Trace-ID: 190fc832efd7b1c5
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Shuah Khan <shuah@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Oliver Upton <oupton@kernel.org>,
	James Houghton <jthoughton@google.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] selftests/cgroup: Make the object directory an order-only prerequisite
Date: Fri, 13 Nov 2026 15:07:57 +0000
Message-ID: <20261113150757.646085-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The cgroup_util.o rule in libcgroup.mk lists the object directory as a
normal prerequisite. The KVM selftests include libcgroup.mk, so for
them that directory is their own $(OUTPUT)/lib. After any incremental
KVM build that rebuilds an object there, the directory is newer than
cgroup_util.o, and the next build recompiles cgroup_util.o and relinks
every test.

Make the directory an order-only prerequisite, as libvfio.mk does.

Acked-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---

Notes:
    This was patch 2/2 of v2 [1]. Sean took patch 1 through kvm-x86 and
    asked for this one to go through the cgroup tree [2].
    
    Changes since v2:
    - Collected Michal's Acked-by.
    - Rebased on cgroup/for-7.5.
    - Dropped the Fixes: tag, as the patch only saves a rebuild.
    
    [1] https://lore.kernel.org/all/20260922071945.693714-1-fuad.tabba@linux.dev/
    [2] https://lore.kernel.org/all/avJqZzKX1ZVAMGr-@seanjc-mac.roam.internal/

 tools/testing/selftests/cgroup/lib/libcgroup.mk | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/lib/libcgroup.mk b/tools/testing/selftests/cgroup/lib/libcgroup.mk
index 7a73007204c39..bcf6fe2516223 100644
--- a/tools/testing/selftests/cgroup/lib/libcgroup.mk
+++ b/tools/testing/selftests/cgroup/lib/libcgroup.mk
@@ -13,7 +13,7 @@ EXTRA_HDRS := $(selfdir)/clone3/clone3_selftests.h
 $(LIBCGROUP_O_DIRS):
 	mkdir -p $@
 
-$(LIBCGROUP_O): $(OUTPUT)/%.o : $(CGROUP_DIR)/%.c $(EXTRA_HDRS) $(LIBCGROUP_O_DIRS)
+$(LIBCGROUP_O): $(OUTPUT)/%.o : $(CGROUP_DIR)/%.c $(EXTRA_HDRS) | $(LIBCGROUP_O_DIRS)
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
 EXTRA_CLEAN += $(LIBCGROUP_O)

base-commit: 80bf33fd523ee1df2d265d34970df670a44a2ccd
-- 
2.47.3

