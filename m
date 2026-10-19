Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792426904;
	b=BHbQBiH0FJwTz3MzWSSEV0FkmhIUHiPJB/orkwgacIgaTjhPhQh96VmIromCXWFIFrCI
	 itspsR6ZAtPPqaWChn1fhkEgxic2yu9C2egkxdhwKpjwYbKkPblNlnXOkFKt/406cgGMX
	 DiXek3NAnarFj7SdaeLvUnA0aN7PWli0rqxNLYdKsjvesAAjFddNnWKIIqXJrBn3gOIDw
	 ikZekyzgJnK2SSCyxrOMr6Vu8FCr/RfRiYOhot2aU0QxKyQNkB7DrlHnyxYnQk6MSBDma
	 CaDm0mnXkEOL1igo4ii9WAA+2W2Um4zinqJYYLdNi4CePGyCQ7G/JM/zVgsWL4vm29w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792426904;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=AXALzYiDlqNLgw2O3tAb14ubqs9EH5rpsxDv02Io52g=;
	b=Xo+Paq2oZFoDwQx6w75C33TxYW0i9wIsopLXhD2C1t0/wIepXTIlO9KDd6y0rjxjSzZH
	 y4zJFPECC8v2Bg2v3m+Snfcgn2b4BB6KD0vkkq4ZoWjjGYUnPD5tNgHqBWqUyqokTagxg
	 hX/ebQzWyu86yDDkSsChtEttEIMIUH7RLAtUmEkT0YpXa2P7d9iyETSQ2waDCUn4IF98b
	 d5FUdxIC7ItYNjNz2nomdPEOuMn8ZfI6/k1MrleqNIxLUiq0ej9cVAh3I4Pk5KEJfuu0R
	 8zfJgxmhoPwY/e5JzjZwTgBaTpih43WEeuYIU30Z3/ROQ3LRZ0QVjr5KS0Btqd3J/Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=H5phoMDY;
	arc=none smtp.remote-ip=209.85.222.172
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C0F606A31B
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 16:21:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3C0F606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=H5phoMDY
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-93ead211f14so257989385a.1
        for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 09:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792426903; x=1793031703; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AXALzYiDlqNLgw2O3tAb14ubqs9EH5rpsxDv02Io52g=;
        b=H5phoMDYTzRbKT2WQq6v53aaHIsZvm1oxzEgECPunKwtKkbsSkCE4MZxkn3xcEJxR0
         fiG9OVJ7vkjQVXNajJY0aqT84jQrovr8c6S0wljKhLKPpFPb0SyY0/vyWAGnU8G5moAx
         8fvA/aKfZSXKPjrxjGyt91Wl+Gu7f33xJtLuX2g/ZpAMYM0JxV5M0346QUsIK67D7i5K
         vnUOI7rghz/gEcqY2A0ZS8nVFU9w3I85sbau0/gmmL4PH4CTRs8XX/nc2A5uTm6Q8Ux7
         VNWBxxiDeYkDZjlZIt7Aap2r7budsQqPO9TLhv4BjSi/UeAk2pYZ/cSEMPZBa0r5V/Wd
         XsEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792426903; x=1793031703;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AXALzYiDlqNLgw2O3tAb14ubqs9EH5rpsxDv02Io52g=;
        b=KxLu8If7eCswRsLGozoJBYqrteWj6T1KdEF1aLl+/rlfjtKkSy9hzgynkWSbFfmaHj
         QZbgRGYK318aXzV+oy8k38+OdPVGgEH332RVMsFGXEHCuBzFez4liLERaOuKfcCxIa+4
         vqTel1lbEPy0L+1f9LNq2s+Aq/UumaRXe4tjCOpy+mLuR6IrnljucbnGbVV6S7yOPyat
         w8h8F0l6hB+r1kk6o2Lv0JsZuAm3QVNvkuC8wcSBKjMeRoLJEvs97H4bNlKGoYUU3xkb
         0TNyCGix5PWd5rAyiTH+IIFYJP91g5/kY0FKk2aiEN01YNCawl4mWOZfXP+QOVauL3e9
         hNjA==
X-Forwarded-Encrypted: i=1; AKwUvBxSWWuZBTzn4DdVRcIO0JWjGivYWr/Y/MS2GMRCkOPpfDBtAQYJnJFa4F8Qo9Cf/ueg4fBoAFTo@vger.kernel.org
X-Gm-Message-State: AFq9FYLjgwF63yBfQMAKCMvKS7KWyOKKEFsZ6hK2f4Ss6LK6rnYk1DY+
	BQwi/B4TjbVP4Az9WfEaZNIcl4d+MIoQj3/mmYZuPxMOpQ9GNVyt7Oro2amtXtlU/gc=
X-Gm-Gg: AYBFou2m8DmXwUklvQ4nxVu+LBGSBaO8yO71nNAqI48FJse6wtL+6bNScz/Z9lA+0Ep
	bPJmqj7VOfTldmtW+jNsknDZX69o6iLF+99ACZo59FYlaPkiEK6aETaIJvgoUTcGsxzFhKuXuHS
	xE3iTvzRxEZKhvaDpUGRQn/e3Z8h4sYWbMmVRFSL1X+DZjMkALciqtDdsx4H8OzOf4dXIHHoyZk
	ELVmztvPatd3PjacHbMz3bKbCyvMt35iVlU5A7RdX1FsVIMAwUgS1UznywjE4D/OwDKQFSL8SZx
	qvRI5PXQt7PysBM0FKAr7IIJQ6VU9COxykLbUj9tJ6pugMYdrQGJBeA2DUhLjQFT1MDMHGmV6Pj
	gM64FPCJFvG+z6EkrXSm21780lsO9El0qNr83EOglkAW3gocSgnk1XLSZ284yn9xU3l4Yr0Z04y
	PQNL2M/RJAmr1slaA+FahyC0zYTLCrZ+khzMV/aPHhc+ECsy4AFCTcir3AdzYo+TxvFDAnUgYaH
	TSAtH7On2IwQZ2xNLyCglZa7V/XQ2x+1Uvx76zjlUs2BrCD5MR+tP7FCQCIGtfrK2RAlxI=
X-Received: by 2002:a05:620a:6cc4:b0:93f:2b65:593b with SMTP id af79cd13be357-93f2b655ed6mr1165985985a.38.1792426902714;
        Mon, 19 Oct 2026 09:21:42 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91bcba4b9e1sm102394026d6.14.2026.10.19.09.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 09:21:42 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org,
	cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	mgorman@suse.de,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH v2] cgroup/cpuset: use mems_allowed_seq when checking a policy nodemask
Date: Mon, 19 Oct 2026 12:21:38 -0400
Message-ID: <20261019162138.3271947-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
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

A cpuset update changes the task's mems_allowed and rebinds its
mempolicy in separate steps under mems_allowed_seq, but the check
reads both without it.  This can cause a spurious numa placement
miss under some cpuset/mempolicy combinations.

A reader that loads one mask before the update and the other after
it can see a spurious empty intersection and drop the nodemask.

For example, a task with cpuset.mems={0} and MPOL_BIND={0}.  If the
cpuset moves to mems={1,2}, the policy is rebound to {1}.

The allocator can race and compare the old mems_allowed {0} against
the new policy {1} - which will result in a dropped nodemask and a
misplaced allocation on node 2.

Simply retry the intersection until mems_allowed_seq is stable.

This covers the task policy, which is rebound under mems_allowed_seq.
VMA policies are rebound afterwards by mpol_rebind_mm(), outside
mems_allowed_seq, and are not covered by this change.

Fixes: cc9a6c877661 ("cpuset: mm: reduce large amounts of memory barrier related damage v3")
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
v2: there is no real update here, i'm breaking it off of the page_alloc
    series so the page_alloc fixes backport collectively cleaner.

 kernel/cgroup/cpuset.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3f52717c19654..8ee239d5c6b48 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4354,10 +4354,21 @@ nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
  * @nodemask: the nodemask to be checked
  *
  * Are any of the nodes in the nodemask allowed in current->mems_allowed?
+ *
+ * A cpuset update rebinds the task's mempolicy and changes mems_allowed in
+ * separate steps, so retry if an update raced with the check.
  */
 int cpuset_nodemask_valid_mems_allowed(const nodemask_t *nodemask)
 {
-	return nodes_intersects(*nodemask, current->mems_allowed);
+	unsigned int seq;
+	int ret;
+
+	do {
+		seq = read_mems_allowed_begin();
+		ret = nodes_intersects(*nodemask, current->mems_allowed);
+	} while (read_mems_allowed_retry(seq));
+
+	return ret;
 }
 
 /*
-- 
2.53.0-Meta

