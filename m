Received: from mta1.migadu.com (out-200.mta1.migadu.com [95.215.58.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728464AB1AB
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 07:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790061611; cv=none; b=eYK4EyY2BBSg5NW0YjmqZwleUODSDDQMhk8PByCCoPE1O2D7jbq15uVBjrlfUrRXeU50ZVRFZCxvITvNDYlWbizii7DWD0z7Ld0tg9W+egp3ZckzTnCuBFxoJBLLl37wB95LBtOC//60Smmow/veJ5TMBMJ0n38cXZwi1Jko+/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790061611; c=relaxed/simple;
	bh=EZ/YCaSPuiIHq9yuX+NfV7x2DltaVEKpXi2O9ZD9ZuQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GCqUJn+WPbmbgKkWHOiLyMl9PC87QVX0ulhgMwJpwAMqfuBfL2AXJ4dt0lFPOvLnwB9MMGxB5s3JUZ5+BJSnvufIjBXtXHaBEao6RxGrq9PILechMHXX6Sp2QOQNxsQ9nHSFh/f9C0gs7wVoTvFJLGOzEB0h/N5e+BDW/LL4Q0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kIRggEQD; arc=none smtp.client-ip=95.215.58.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kIRggEQD"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=EZ/YCaSPuiIHq9yuX+NfV7x2DltaVEKpXi2O9ZD9ZuQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790061599; v=1; x=1790666399;
 b=kIRggEQDcs1UC/Cst/jynYBg/HQMkeKOgE0EOwKHH6ZUUcFyaflCKjkGRCstO5kArabqfFF2
 RTL5cCH1iwL/pWn/sWuFMwVo2CcWYd6yJWw/qRhEFvWU5yCAn77kd+C8QNSA2bZ+khnQSTpI2LS
 4iabQyLuUpPa0ZZxpDxeeRYk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3a52787b001092ab;
	Tue, 22 Sep 2026 07:19:59 +0000
X-Mizu-Trace-ID: 3a52787b001092ab
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Tejun Heo <tj@kernel.org>,
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
Subject: [PATCH v2 2/2] selftests/cgroup: Make the object directory an order-only prerequisite
Date: Tue, 22 Sep 2026 08:19:45 +0100
Message-Id: <20260922071945.693714-3-fuad.tabba@linux.dev>
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

libcgroup.mk names $(LIBCGROUP_O_DIRS) as a regular prerequisite of
cgroup_util.o. The directory's mtime moves whenever an object is
created or replaced in it, so an incremental KVM selftests build that
rebuilt anything in lib/ recompiles cgroup_util.o and relinks every
test on the following run. Make the directory order-only, as
libvfio.mk does.

Fixes: 2c754a84ff16a ("cgroup: selftests: Move cgroup_util into its own library")
Assisted-by: LLM
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
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
-- 
2.39.5

