Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7261D431E68
	for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 13:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788182742; cv=none; b=QQZKPTVGR5RUOWCL99OcC9fq/CmP7Be4ezBrYaI1xiw9oFkoS09rquRVuGjVmieIt5pFDmu+YyLv7NluNFN+jzEGNIRLI02AhwvKZ3fm+qki0D6e+TNjFylVwJDlFhiRGERYuVKpBtODHtu3XanDWwkAXjrZ/RGWzFundhltXN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788182742; c=relaxed/simple;
	bh=aVEc4CBnAuDpcrLanwlbnMxjvede+STFifs83Q+K67I=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=mBPgz/1mrichRvdUPe6/+m9kMMLTVMMjAnxUl4IhofibnAMpjwvUrgVazjsHObWYycr29uki2SSWX1UAmdcSTgFXnT3J62Mjvyw1au7Grpyplxye/+I7RYbMmBN0C1hWbeVgm+2sqIJnETAtWl2v/xPJR4Umu3yZ/XDIxuQcC7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aA/l0Om8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aA/l0Om8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788182739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=aL+7sHvd56d9JgdTBw3xWSS4186zcTT+zr6gMk9HLxo=;
	b=aA/l0Om838dvq9TCJLQrCVXl6oX9oHQFA3FEERClKwd8FqynA8Wz5DNnf31KCQPZUyRjHT
	2m6AxuI71B83SXchDva67ZfvwsgGBtSVB1YdgXhOdKkZSoUQybcRp73J0PewQ1A1w2ppEP
	02+lSCYMiEroU+GShSG+tBDB1itmdpw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-155-ZL00BXHvME6RseQsOwOqrg-1; Mon,
 31 Aug 2026 09:25:33 -0400
X-MC-Unique: ZL00BXHvME6RseQsOwOqrg-1
X-Mimecast-MFC-AGG-ID: ZL00BXHvME6RseQsOwOqrg_1788182732
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DE40E18AB304;
	Mon, 31 Aug 2026 13:25:17 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D69DE426;
	Mon, 31 Aug 2026 13:25:15 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Subject: [PATCH v6 0/3] cgroup: dmem: add selftest helper and coverage
Date: Mon, 31 Aug 2026 15:25:10 +0200
Message-Id: <20260831-kunit_cgroups-v6-0-63b6c7695287@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/2XM3WrDIBjG8VspHs/hx+ur9mj3McqIRhsZS4qmo
 aPk3mfLIJs5fB74/e+khJxCIcfDneSwpJKmsQ58ORA/dOM50NTXTQQTyCQ39PM6pvnDn/N0vRS
 qo2POBgTGNanmkkNMt2fv/VT3kMo85e9nfuGP97ckdFNaOGXUau6k19J2jL3l0A/d/OqnL/JIL
 WLjIHjLReXOIWrVGwHW77jcuGLQclk5hM5b5jRGy3cc/nBuWw6VR/QigjWxC7DjauOaYctV5eh
 BeKOVBDT/+LquPx/fCPWnAQAA
X-Change-ID: 20260318-kunit_cgroups-7fb0b9e64017
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Albert Esteve <aesteve@redhat.com>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788182715; l=4119;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=aVEc4CBnAuDpcrLanwlbnMxjvede+STFifs83Q+K67I=;
 b=sKXF7OcPYNbbZoZnAbF9Ox00btU61ZyJz+dImt+BzymQWN0lblFu4j7DwDtqVKC78RS15MCwK
 xYhF0XkYBjHA13SA5LcVzEKl+p6ezP7WSXV89Y6sLws0F4x1vJ/QNDa
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Hi all,

This small series adds practical test coverage for the dmem
cgroup controller.

The motivation came from following the recent dmem API discussion in
thread [1]. That discussion considered changing the dmem API and
adding a new knob. Currently there are no dedicated tests covering
dmem behaviour, which makes such changes riskier.

Adding selftests has an additional challenge: dmem charging paths
are driver-driven today, so regression testing is harder unless a
suitable driver is present in the test environment.

This series addresses that by adding:
- an out-of-tree dmem_selftest helper with alloc/free module parameters,
- KB() definition next to existing MB()/GB() helpers
- test_dmem for dmem.max enforcement and byte-accurate dmem.current

The goal is to make dmem behavior easier to validate when evolving the API
and implementation, while keeping tests deterministic and driver-independent.

Thanks.

[1] - https://lore.kernel.org/all/aZoHfloupKvF2oSu@fedora/

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
Changes in v6:
- Drop virtme-ng wrappers
- Build the helper out of tree, drop CONFIG_DMEM_SELFTEST
- Rename charge/uncharge to alloc/free
- Add KB() in cgroup_util.h
- Use cg_read_key_long(), ARRAY_SIZE(), and KB()/MB() size literals
- Drop test_dmem_min/low
- Check dmem.current for exact equality
- stat() the helper once in main() instead of per-subtest
- Link to v5: https://lore.kernel.org/r/20260706-kunit_cgroups-v5-0-6c42c8753468@redhat.com

Changes in v5:
- Change parse_first_region() by find_selftest_region to scan
  dmem.capacity lines
- Use exact equality for limit readback, not values_close()
- Write VM tempfile to $SCRIPT_DIR
- Fix KTAP by dropping outer framing in test_dmem
- Use array for optional vng args to handle paths with spaces
- Respect O=/KBUILD_OUTPUT= when building, per bpf/vmtest.sh convention
- Link to v4: https://lore.kernel.org/r/20260519-kunit_cgroups-v4-0-f6c2f498fae4@redhat.com

Changes in v4:
- Fix charged_pool leak in dmem_selftest_init()
- Replace ssh-based VM approach in vmtest-dmem.sh with vng --exec
- Add main() wrapper to vmtest-dmem.sh
- Other small fixes suggested by Sashiko
- Link to v3: https://lore.kernel.org/r/20260504-kunit_cgroups-v3-0-4eac90b76f91@redhat.com

Changes in v3:
- Set charged flag on unexpected over-limit charge success.
- Add CONFIG_DMEM_SELFTEST=m to selftest config.
- Simplify -v to a boolean; single -v was a no-op.
- Unquote kernel_opt to avoid empty-string arg to vng.
- Document -b in usage() output.
- Link to v2: https://lore.kernel.org/r/20260421-kunit_cgroups-v2-0-bb6675d8249c@redhat.com

Changes in v2:
- Fix debugfs_create_dir() error check
- Fix module teardown race: call dmem_selftest_remove() before
  uncharging so debugfs files are torn down
- Use IS_ERR_OR_NULL() in selftest() sanity check
- Add CONFIG_CGROUP_DMEM=y to the cgroup selftest config
- Replace config-file parsing in check_guest_requirements() with
  a direct check of /sys/fs/cgroup/cgroup.controllers
- Add new patch 4 (from Eric Chanudet): vmtest-dmem.sh -b flag
  to configure and build a local kernel tree
- Link to v1: https://lore.kernel.org/r/20260327-kunit_cgroups-v1-0-971b3c739a00@redhat.com

---
Albert Esteve (3):
      selftests: cgroup: Add dmem_selftest helper module
      selftests: cgroup: Add KB() helper
      selftests: cgroup: Add dmem selftest coverage

 tools/testing/selftests/cgroup/.gitignore          |   1 +
 tools/testing/selftests/cgroup/Makefile            |   3 +
 tools/testing/selftests/cgroup/config              |   1 +
 .../selftests/cgroup/lib/include/cgroup_util.h     |   1 +
 tools/testing/selftests/cgroup/test_dmem.c         | 314 +++++++++++++++++++++
 .../testing/selftests/cgroup/test_modules/Makefile |  17 ++
 .../selftests/cgroup/test_modules/dmem_selftest.c  | 146 ++++++++++
 7 files changed, 483 insertions(+)
---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260318-kunit_cgroups-7fb0b9e64017

Best regards,
-- 
Albert Esteve <aesteve@redhat.com>

