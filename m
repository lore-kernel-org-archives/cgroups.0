Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1A0429CDD
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 13:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784208260; cv=none; b=Z5epOlDTG7obGwryORxW+CW0HcLPs5Zyn1N6Ab9iy5zEjiaFV1yh3kRAL2GlTpSq69lxOEVYCF1PpQbvu79+vvu0xsiW5eESzf/5kTQSKODwYVX6bK3pc01moKYrZRQRjAWVYdteDdFLdQijcd2RvKdN3u8A3hP+FAhUu/oq2xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784208260; c=relaxed/simple;
	bh=twRURTDJ/5mjryqyEE5G8bGbsMrfIX8bKO9DFB7ZQbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jzh2S/7f8YxNiOiPSQvhIkx0KY/5d56KFih5d3hj9peiWPeM3XCoApq4hj1yuZZSaaVzC7mcGtD52NweIy309tLvKD7PuZJ2fhwvWIqkTq41etqVJ4Snx9wVCNKHR742mTjREKwl/vA0k+v6KdPPM4P5zTP2cpoW2m4n7NJBQu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=W06YgJh9; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="W06YgJh9"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-47ddf7b09aaso4504927f8f.3
        for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 06:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1784208257; x=1784813057; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SkIgdZHasNjIyn1ZP3a3yKWYiQkNI/IXycTrMI5IrYQ=;
        b=W06YgJh9LPK68BH88YFbEQ9W1tbSKeqCdNjxwLILVgCOgeYhwi4PMos943yBhzkj7U
         EA0gQiHpqldUNWDlRcnCynmQszLE+yBrjEfjR29XKTTljtgtpky/FmYjq8DzlH8XFbyd
         E2E4psGmWkHslsQdILLgbVNTJAaAlscLU+XakBN8JiieTR62ajHEcYanfGvvZHOV97Dq
         UTD9lYsoXmrlm/SqsonHwdIw6cIJBk1udm2BEWT5ApF9YKnptBhONw4QddCZF+RlpryP
         Vd022sa4nZbYnfo0NHaCxO6coIC+LsdSsISTLcKhYSj8janxTjvuw3m5f/xrxEJqLV1p
         OqDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784208257; x=1784813057;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SkIgdZHasNjIyn1ZP3a3yKWYiQkNI/IXycTrMI5IrYQ=;
        b=QTZKIL9D6qLISHDxDSq+5DxZggMaGU2yLVzZ7D1JXPmvQMWlrgXlyjxq0ejnKgqn3i
         V41v/+oYag6rCvQeSWyJJtr9HaLgrgFRsUNyP4ggxIs8heLxcC86A3Rsa6XXLuEBEZFA
         c7fSyUDXBdzFaBdmeXUGlH9wRTZ37esiN5ACSNvLDMljCKQ0Yro0EsUaJ1Knk676ozK+
         9x8ZzGDRI/DnzGsWA93bEcuD2z0r7e+/7FE12N8S1Gu/OudVMvq/nslrgxa0YRpMpeXI
         M4WwDQl//JzNkCDi+kYzgQjwElkv4Ry6LAHAoYKHDt1ZhVB6MObJo+oU+ZA+BTQUQxhy
         H4tg==
X-Gm-Message-State: AOJu0YyaEMxjBMbaT+sAokaa+iFwu7C28hsa18MUSL+DoPmJQ38S4wYP
	ltWJPr9Ze/1GYBOQRQrW3OZkAkH4zHAmm6SoQ/yZgzgoKELyQ4ObFKB7acjJxozy+cE=
X-Gm-Gg: AfdE7clNibl1A0EWZvU8IhU+2d5Hskmv3HJqWVNapV8GcWhCHdTGQHGG2iKXmlXnW4V
	YrZNybblGkrgQGcfIHqXnfD1ZoZMcr7KJERaJCuDBZwPKWg0E7U89lbivxQWsguIBsprTrQPyEq
	St1IDneIaFhgeupi+o5ayzQB1VW3s+JbIGZyhyD2fNQk/A2baw0MAvKbSXcY4kQEVC4z5KmiS2t
	lUjL9KfumhemZC9j6VvZDKuKYdggAmAQ3YQPNQyKMmR0NKNkMsLiMJezb6Ui3zGJpyHw0dAEPgB
	m1mi+ZdAj6e5vLUIUIRSO3gJQ8ZMHfUhcp6zl+Ky7OpY275KmNYFNYlGtjMI2IPkjzEjHLtrfHV
	+VySR221mMLHDzkYB8h3yqt6alafSLWSLdhoO9CXGAbh3apxzzPCvIv1atUmbP9UKwrygYH1MYm
	jq/+gxRckECUo=
X-Received: by 2002:a05:6000:2c10:b0:47d:ed40:a94e with SMTP id ffacd0b85a97d-47f463409e5mr17099014f8f.22.1784208256780;
        Thu, 16 Jul 2026 06:24:16 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f464b7f09sm24849479f8f.26.2026.07.16.06.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 06:24:16 -0700 (PDT)
From: Jiri Pirko <jiri@resnulli.us>
To: linux-rdma@vger.kernel.org
Cc: cgroups@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	parav@nvidia.com,
	mbloch@nvidia.com,
	cmeiohas@nvidia.com,
	roman.gushchin@linux.dev,
	bvanassche@acm.org,
	zyjzyj2000@gmail.com,
	shuah@kernel.org,
	tj@kernel.org,
	mkoutny@suse.com,
	hannes@cmpxchg.org,
	alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	wenjia@linux.ibm.com,
	yanjun.zhu@linux.dev,
	cui.tao@linux.dev
Subject: [PATCH rdma-next v3 14/14] RDMA/selftests: Add rxe_netns_names test
Date: Thu, 16 Jul 2026 15:23:15 +0200
Message-ID: <20260716132316.1495242-15-jiri@resnulli.us>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260716132316.1495242-1-jiri@resnulli.us>
References: <20260716132316.1495242-1-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jiri Pirko <jiri@nvidia.com>

Add a kselftest script that exercises per-netns RDMA device naming
with RXE. Cover duplicate names across namespaces, move conflict
handling, move-with-rename, and same-namespace rename requests.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v2->v3:
- added wait for rdma devices are removed
- added retry for old rdma netns mode restore
v1->v2:
- fixed ktap_set_plan
- s/RXE_A/RXE_SAME/ in dup rename
---
 tools/testing/selftests/rdma/Makefile         |   3 +-
 tools/testing/selftests/rdma/config           |   2 +
 .../testing/selftests/rdma/rxe_netns_names.sh | 334 ++++++++++++++++++
 3 files changed, 338 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/rdma/rxe_netns_names.sh

diff --git a/tools/testing/selftests/rdma/Makefile b/tools/testing/selftests/rdma/Makefile
index 07af7f15c1bf..a91c14c45006 100644
--- a/tools/testing/selftests/rdma/Makefile
+++ b/tools/testing/selftests/rdma/Makefile
@@ -3,6 +3,7 @@ TEST_PROGS := rxe_rping_between_netns.sh \
 		rxe_ipv6.sh \
 		rxe_socket_with_netns.sh \
 		rxe_test_NETDEV_UNREGISTER.sh \
-		rxe_sent_rcvd_bytes.sh
+		rxe_sent_rcvd_bytes.sh \
+		rxe_netns_names.sh
 
 include ../lib.mk
diff --git a/tools/testing/selftests/rdma/config b/tools/testing/selftests/rdma/config
index 4ffb814e253b..e1ff54ec0f57 100644
--- a/tools/testing/selftests/rdma/config
+++ b/tools/testing/selftests/rdma/config
@@ -1,3 +1,5 @@
 CONFIG_TUN
 CONFIG_VETH
+CONFIG_DUMMY
+CONFIG_NET_NS
 CONFIG_RDMA_RXE
diff --git a/tools/testing/selftests/rdma/rxe_netns_names.sh b/tools/testing/selftests/rdma/rxe_netns_names.sh
new file mode 100755
index 000000000000..f40118407f4c
--- /dev/null
+++ b/tools/testing/selftests/rdma/rxe_netns_names.sh
@@ -0,0 +1,334 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Exercise RDMA device name handling across network namespaces.
+
+source "$(dirname "$0")/../kselftest/ktap_helpers.sh"
+
+NAME_PREFIX="rxe_netns_names_$$"
+NETDEV_PREFIX="rxn$$"
+NS1="${NAME_PREFIX}ns1"
+NS2="${NAME_PREFIX}ns2"
+RXE_A="${NAME_PREFIX}rxe_a"
+RXE_B="${NAME_PREFIX}rxe_b"
+RXE_SAME="${NAME_PREFIX}rxe_same"
+RXE_NEW="${NAME_PREFIX}rxe_new"
+DUMMY_A="${NETDEV_PREFIX}a"
+DUMMY_B="${NETDEV_PREFIX}b"
+OLD_MODE=""
+MODE_CHANGED=0
+MODS=("dummy" "rdma_rxe")
+TEST_SAME_NAMES="same RDMA device name can exist in two net namespaces"
+TEST_MOVE_CONFLICT="move without rename fails on destination name conflict"
+TEST_MOVE_RENAME="move then rename succeeds"
+TEST_COMBINED_MOVE_RENAME="move with requested destination name succeeds"
+TEST_SAME_NETNS_DUP_RENAME="same-netns rename rejects duplicate name"
+TEST_TEARDOWN_RETURN="netns delete returns device to init_net and renames on conflict"
+
+ksft_skip()
+{
+	ktap_skip_all "$*"
+	exit "$KSFT_SKIP"
+}
+
+fail()
+{
+	ktap_exit_fail_msg "$*"
+}
+
+need_cmd()
+{
+	command -v "$1" >/dev/null 2>&1 || ksft_skip "missing command: $1"
+}
+
+rdma_ns()
+{
+	local ns=$1
+
+	shift
+	ip netns exec "$ns" rdma "$@"
+}
+
+rdma_dev_exists()
+{
+	local ns=$1
+	local dev=$2
+
+	if [ -n "$ns" ]; then
+		rdma_ns "$ns" dev show "$dev" >/dev/null 2>&1
+	else
+		rdma dev show "$dev" >/dev/null 2>&1
+	fi
+}
+
+add_dummy()
+{
+	local netdev=$1
+
+	ip link add "$netdev" type dummy || return 1
+	ip link set "$netdev" up || return 1
+}
+
+add_rxe()
+{
+	local dev=$1
+	local netdev=$2
+
+	rdma link add "$dev" type rxe netdev "$netdev"
+}
+
+rdma_dev_on_netdev()
+{
+	local netdev=$1
+
+	rdma link show 2>/dev/null | awk -v want="$netdev" '
+		{
+			for (i = 1; i < NF; i++)
+				if ($i == "netdev" && $(i + 1) == want) {
+					dev = $2
+					sub(/\/.*/, "", dev)
+					print dev
+					exit
+				}
+		}'
+}
+
+wait_rdma_dev_on_netdev()
+{
+	local netdev=$1
+	local dev
+	local i
+
+	for i in $(seq 1 50); do
+		dev=$(rdma_dev_on_netdev "$netdev")
+		if [ -n "$dev" ]; then
+			echo "$dev"
+			return 0
+		fi
+		sleep 0.1
+	done
+
+	return 1
+}
+
+# ip link del returns after NETDEV_UNREGISTER, but rxe tears the RDMA device
+# down asynchronously via ib_unregister_device_queued(). Wait until our names
+# are gone.
+wait_rdma_devs_gone()
+{
+	local i name ns
+	local names=("$RXE_A" "$RXE_B" "$RXE_SAME" "$RXE_NEW")
+
+	for i in $(seq 1 50); do
+		local found=0
+
+		for name in "${names[@]}"; do
+			if rdma_dev_exists "" "$name"; then
+				found=1
+				break
+			fi
+			for ns in "$NS1" "$NS2"; do
+				ip netns exec "$ns" true 2>/dev/null || continue
+				if rdma_dev_exists "$ns" "$name"; then
+					found=1
+					break 2
+				fi
+			done
+		done
+
+		[ "$found" -eq 0 ] && return 0
+		sleep 0.1
+	done
+
+	return 1
+}
+
+setup_devs()
+{
+	cleanup_devs || return 1
+
+	add_dummy "$DUMMY_A" || return 1
+	add_dummy "$DUMMY_B" || return 1
+
+	add_rxe "$RXE_A" "$DUMMY_A" || return 1
+	add_rxe "$RXE_B" "$DUMMY_B" || return 1
+}
+
+cleanup_devs()
+{
+	ip link del "$DUMMY_A" 2>/dev/null
+	ip link del "$DUMMY_B" 2>/dev/null
+	wait_rdma_devs_gone
+}
+
+setup()
+{
+	OLD_MODE=$(rdma system show 2>/dev/null |
+		   sed -n 's/.*netns \([^ ]*\).*/\1/p')
+	[ -n "$OLD_MODE" ] || ksft_skip "failed to read RDMA netns mode"
+
+	rdma system set netns exclusive >/dev/null 2>&1 ||
+		ksft_skip "rdma netns exclusive mode is not supported"
+	MODE_CHANGED=1
+
+	ip netns add "$NS1" || return 1
+	ip netns add "$NS2" || return 1
+}
+
+# ip netns del returns before rdma_dev_exit_net() removes the net from
+# rdma_nets. rdma_compatdev_set() returns -EBUSY until that completes, so
+# retry the mode restore instead of leaving the system in exclusive mode.
+restore_netns_mode()
+{
+	local i
+
+	[ "$MODE_CHANGED" -eq 1 ] || return 0
+
+	for i in $(seq 1 50); do
+		if rdma system set netns "$OLD_MODE" >/dev/null 2>&1; then
+			MODE_CHANGED=0
+			return 0
+		fi
+		sleep 0.1
+	done
+
+	echo "warning: failed to restore RDMA netns mode to $OLD_MODE" >&2
+	return 1
+}
+
+cleanup()
+{
+	cleanup_devs
+
+	ip netns del "$NS1" 2>/dev/null
+	ip netns del "$NS2" 2>/dev/null
+
+	restore_netns_mode
+
+	for m in "${MODS[@]}"; do
+		modprobe -r "$m" 2>/dev/null
+	done
+}
+
+rdma_supports_combined_move_rename()
+{
+	rdma dev help 2>&1 | grep -Eq 'netns .*name|name .*netns'
+}
+
+[ "$(id -u)" -eq 0 ] || ksft_skip "must be run as root"
+need_cmd ip
+need_cmd rdma
+need_cmd modprobe
+
+trap cleanup EXIT
+
+for m in "${MODS[@]}"; do
+	modinfo "$m" >/dev/null 2>&1 || ksft_skip "module $m not found"
+	modprobe "$m" || fail "failed to load $m"
+done
+
+setup || fail "failed to create net namespaces"
+
+ktap_print_header
+ktap_set_plan 6
+
+if setup_devs &&
+   rdma dev set "$RXE_A" netns "$NS1" &&
+   rdma_ns "$NS1" dev set "$RXE_A" name "$RXE_SAME" &&
+   rdma dev set "$RXE_B" netns "$NS2" &&
+   rdma_ns "$NS2" dev set "$RXE_B" name "$RXE_SAME" &&
+   rdma_dev_exists "$NS1" "$RXE_SAME" &&
+   rdma_dev_exists "$NS2" "$RXE_SAME"; then
+	ktap_test_pass "$TEST_SAME_NAMES"
+else
+	ktap_test_fail "$TEST_SAME_NAMES"
+fi
+cleanup_devs
+
+if ! setup_devs ||
+   ! rdma dev set "$RXE_A" netns "$NS1" ||
+   ! rdma_ns "$NS1" dev set "$RXE_A" name "$RXE_SAME" ||
+   ! rdma dev set "$RXE_B" netns "$NS2" ||
+   ! rdma_ns "$NS2" dev set "$RXE_B" name "$RXE_SAME"; then
+	ktap_test_fail "$TEST_MOVE_CONFLICT"
+elif rdma_ns "$NS1" dev set "$RXE_SAME" netns "$NS2" >/dev/null 2>&1; then
+	ktap_test_fail "$TEST_MOVE_CONFLICT"
+elif rdma_dev_exists "$NS1" "$RXE_SAME" &&
+     rdma_dev_exists "$NS2" "$RXE_SAME"; then
+	ktap_test_pass "$TEST_MOVE_CONFLICT"
+else
+	ktap_test_fail "$TEST_MOVE_CONFLICT"
+fi
+cleanup_devs
+
+if ! setup_devs; then
+	ktap_test_fail "$TEST_MOVE_RENAME"
+elif rdma dev set "$RXE_A" netns "$NS2" &&
+     rdma_ns "$NS2" dev set "$RXE_A" name "$RXE_NEW"; then
+	if rdma_dev_exists "$NS2" "$RXE_NEW" &&
+	   ! rdma_dev_exists "" "$RXE_A"; then
+		ktap_test_pass "$TEST_MOVE_RENAME"
+	else
+		ktap_test_fail "$TEST_MOVE_RENAME"
+	fi
+else
+	ktap_test_fail "$TEST_MOVE_RENAME"
+fi
+cleanup_devs
+
+if ! rdma_supports_combined_move_rename; then
+	ktap_test_skip "$TEST_COMBINED_MOVE_RENAME"
+elif ! setup_devs; then
+	ktap_test_fail "$TEST_COMBINED_MOVE_RENAME"
+elif rdma dev set "$RXE_A" netns "$NS2" name "$RXE_NEW"; then
+	if rdma_dev_exists "$NS2" "$RXE_NEW" &&
+	   ! rdma_dev_exists "" "$RXE_A"; then
+		ktap_test_pass "$TEST_COMBINED_MOVE_RENAME"
+	else
+		ktap_test_fail "$TEST_COMBINED_MOVE_RENAME"
+	fi
+else
+	ktap_test_fail "$TEST_COMBINED_MOVE_RENAME"
+fi
+cleanup_devs
+
+if ! setup_devs; then
+	ktap_test_fail "$TEST_SAME_NETNS_DUP_RENAME"
+elif rdma dev set "$RXE_A" name "$RXE_SAME" &&
+     rdma dev set "$RXE_B" name "$RXE_NEW"; then
+	if rdma dev set "$RXE_SAME" name "$RXE_NEW" >/dev/null 2>&1; then
+		ktap_test_fail "$TEST_SAME_NETNS_DUP_RENAME"
+	elif rdma_dev_exists "" "$RXE_SAME" &&
+	     rdma_dev_exists "" "$RXE_NEW"; then
+		ktap_test_pass "$TEST_SAME_NETNS_DUP_RENAME"
+	else
+		ktap_test_fail "$TEST_SAME_NETNS_DUP_RENAME"
+	fi
+else
+	ktap_test_fail "$TEST_SAME_NETNS_DUP_RENAME"
+fi
+cleanup_devs
+
+if ! setup_devs; then
+	ktap_test_fail "$TEST_TEARDOWN_RETURN"
+elif ! rdma dev set "$RXE_A" name "$RXE_SAME" ||
+     ! rdma dev set "$RXE_B" netns "$NS2" ||
+     ! rdma_ns "$NS2" dev set "$RXE_B" name "$RXE_SAME" ||
+     ! rdma_dev_exists "$NS2" "$RXE_SAME"; then
+	ktap_test_fail "$TEST_TEARDOWN_RETURN"
+else
+	ip netns del "$NS2"
+	returned=$(wait_rdma_dev_on_netdev "$DUMMY_B")
+	ktap_print_msg "device returned to init_net as '${returned:-<missing>}'"
+	if rdma_dev_exists "" "$RXE_SAME" &&
+	   [ -n "$returned" ] &&
+	   [ "$returned" != "$RXE_SAME" ] &&
+	   [ "${returned#ibdev}" != "$returned" ]; then
+		ktap_test_pass "$TEST_TEARDOWN_RETURN"
+	else
+		ktap_test_fail "$TEST_TEARDOWN_RETURN"
+	fi
+fi
+cleanup_devs
+
+ktap_finished
-- 
2.54.0

