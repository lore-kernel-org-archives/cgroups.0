Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB623DE450
	for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 18:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787338696; cv=none; b=aJhaw6Y17loefRHvmL97FZOHE/Uz1zm69av8Qap5JN427lREQLtBGjI79osIV4KxJ7QiGQyRY3pTBWO4WO+NPloymggnVzth9Lj7SOZHdG2a9MWpvzAV8hdx7zLA/CQiT7rljEBKxm0EsSOQCGvuhgpZcoAgy7s1YisUAoomMGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787338696; c=relaxed/simple;
	bh=Rj1uN9sO0+0eAEpjdehT8sKOBNe7Ctc1s/qVw1u0B/A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SNBEkk9k9iVAFCWOl+pwwiIACvyZx8h82c+M5JJ3RakiwWevWY/hl7IeT4MTP7nFpTjIWIRQd1y/qdd+4KsS5GJ0XZdnfcNYXXs/SXG8mcDI5ngrnZGNwwS+dZcLJO9McqGAx/EFG2XPjuOxxdIJMD1MHmDerry8/ZUxzSA4MX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hrDpbLyV; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=bYEWsG2h; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hrDpbLyV";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="bYEWsG2h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787338693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jb8nkZgnYdLG8ktPFayByOUpa/ch44LcnfTYgPP/10M=;
	b=hrDpbLyV3Gt8Cq58qJdk8tmzaO6BQGzJUthltqLx1JHMg/hDZB7+GC7MQGKpBsb++QXhGQ
	DLYumPEMmXLo+5sMurn2nvtHY0Ex5WdnfaG8jcxdDNiMd/se4MyljaRmHgW8lmqVRcc8DP
	597m0Ue8yGjqwMPQh8mGxVzf5COhxAQ=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-462-jbiwt_BSNhmzZY90XQGuiw-1; Fri, 21 Aug 2026 14:58:11 -0400
X-MC-Unique: jbiwt_BSNhmzZY90XQGuiw-1
X-Mimecast-MFC-AGG-ID: jbiwt_BSNhmzZY90XQGuiw_1787338691
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-92e5e38fbc5so154247785a.2
        for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 11:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787338691; x=1787943491; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jb8nkZgnYdLG8ktPFayByOUpa/ch44LcnfTYgPP/10M=;
        b=bYEWsG2hyD9HXNWQRM4S5snQALdv+ujihPmW2eua23zChwkJEYezZzat2wdXsRijIP
         huSLwnm8fzL2/BAN1ZO7OGZh7kio8aHiJQFt7SjQqW+gT/NALPP65j2uPT+VeFJ0yYAM
         jHejqIc6DjCr784XwZAlMXQcDAqBqh0A28uBEBJamc8ezERclRSCtwZnl6ypJsPesLV7
         q9Ef21Z1ccNU725UdtKEqMb3ku1kRAUmX948/QEBOUdAj6P7rrOwKnjX4PuqAqO+zril
         M4P5fgD0VbkKV2O581EGWXB1vbLyp9KnlGnRiR9Gr6yAuVwqwU93z3+/9+AlWTGCBymg
         cNbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787338691; x=1787943491;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jb8nkZgnYdLG8ktPFayByOUpa/ch44LcnfTYgPP/10M=;
        b=iEhv2mo6wEX0dNVl7FmEQ7fTEoHC1mOPKHk9hjpaTNRhF1Qf/uG3o9EdoqYtaDAZ22
         inM86ooEf3RX50PMbgEXNcP6wFYxTbB3BXyCiUZr5c+2R9+5qb6bzf8Kur5ybMrb0m7V
         yr8MUeasmMaoGGMGAEkMoLmmXzTHrYPopp7fRkDza7qSltJOptBBRd1ZK4Qz7Gqw5+we
         9LmHjnBAMJIIEAADurIcy+fjsl/2arcN+SRajeZrcd6H5JbJuQ9UbdaMG22K8mCyI2ey
         q+akEKsmFiO8nostyQ4xYldAKQ9ji3whMTPREhg9O/vCmk+wcWeuIdCYcCP9iRq2UXM0
         70rQ==
X-Forwarded-Encrypted: i=1; AHgh+Rro+Q4uu/sdb5rFLY31BLBaVfNPX9+TqZWrrYfHnVd1fviuTKR1rLsFuVpN6oTIV6SC8hijjCJa@vger.kernel.org
X-Gm-Message-State: AFuF++mBwiVlOA2fvvK/jnEI2SmNBtQPc9Zlu+yvih/Z4Gx5g/d1Wa0X
	lwt5tpM1rJbSd35dntBwOzxwNXZ8RJF82LF2Dh5ejja+nAPeH2Ry+C8wWlaBE5ovcQeZ2EUDsvu
	yX9fsG7dvMbKyXnvyklP6c2pb60v8SCWoJtGIsbj0ySJNY5/Kiqd63HDC8Ag=
X-Gm-Gg: AR+sD12+M5riFkFzNIKpreKr6MMTsKxG7EMSnvjwD6Qdn3ozijn9p+28pKDGgJFNKKh
	/hH9XRb+VycTTauxo2icY8YeFOhRM6TYC2XvfwREt22iVWZ7mnlDDgznjz+jyPAKXB2O61tTQbD
	rUDdAL22pVS8/yzO66JEdw+8ploJdGt5gNwZTH+OcPYLhJe+qhflpCqRQ2wqS/c/HMGt3peaFUs
	bnfBfGFy9b1rvedyakKYQxRXq9yAMyS0IYLEHq4cgsCm7p1RoQNmg7SVRbqi5/idMsB/WAIh6Pq
	shuVPct9qBj/OEEliF/TFo/dxorh+1Fz05vkMzDl4B8L4IdXDDsxfMjeMbQPlhbFv0kYNDvGN0R
	yMG41FFj5WrxeiDmyW3XZcr34uQKFoovq+D7wjDfN5IK5
X-Received: by 2002:a05:620a:6192:b0:915:9e84:85d1 with SMTP id af79cd13be357-9373952c7a5mr808447185a.23.1787338691127;
        Fri, 21 Aug 2026 11:58:11 -0700 (PDT)
X-Received: by 2002:a05:620a:6192:b0:915:9e84:85d1 with SMTP id af79cd13be357-9373952c7a5mr808442485a.23.1787338690612;
        Fri, 21 Aug 2026 11:58:10 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-937204b7b6bsm663030085a.20.2026.08.21.11.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 11:58:09 -0700 (PDT)
From: Eric Chanudet <echanude@redhat.com>
Date: Fri, 21 Aug 2026 14:57:01 -0400
Subject: [PATCH 09/11] selftests: cgroup: add a vmtest script for memcg
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-cma-memcg-regions-v1-9-d21b165b8440@redhat.com>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
In-Reply-To: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>, 
 Albert Esteve <aesteve@redhat.com>, Eric Chanudet <echanude@redhat.com>
X-Mailer: b4 0.14.3

Following dmem's example[1], add a vmtest-memcg.sh to provide a
repeatable VM workflow using virtme-ng for memcg tests.

Boot a VM using virtme-ng with cma=64M in its kargs and enable
memory_cma_accounting on cgroupfs, then run the cgroup tests inside the
guest.

Provide -b to build the kernel first, -q to use a different qemu binary,
-s to start a shell in the VM, and -v for verbose boot.

[1] https://lore.kernel.org/all/20260706-kunit_cgroups-v5-3-6c42c8753468@redhat.com/

Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
 tools/testing/selftests/cgroup/vmtest-memcg.sh | 196 +++++++++++++++++++++++++
 1 file changed, 196 insertions(+)

diff --git a/tools/testing/selftests/cgroup/vmtest-memcg.sh b/tools/testing/selftests/cgroup/vmtest-memcg.sh
new file mode 100755
index 000000000000..b19b96731784
--- /dev/null
+++ b/tools/testing/selftests/cgroup/vmtest-memcg.sh
@@ -0,0 +1,196 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (c) 2026 Red Hat, Inc.
+#
+# Run cgroup memory controller selftests inside a virtme-ng VM
+# Dependencies:
+#		* virtme-ng
+#		* busybox-static (used by virtme-ng)
+#		* qemu	(used by virtme-ng)
+
+set -euo pipefail
+
+readonly SCRIPT_DIR="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
+readonly KERNEL_CHECKOUT="$(realpath "${SCRIPT_DIR}"/../../../../)"
+
+source "${SCRIPT_DIR}"/../kselftest/ktap_helpers.sh
+
+readonly SSH_GUEST_PORT="${SSH_GUEST_PORT:-22}"
+readonly WAIT_PERIOD=3
+readonly WAIT_PERIOD_MAX=80
+readonly WAIT_TOTAL=$((WAIT_PERIOD * WAIT_PERIOD_MAX))
+readonly QEMU_PIDFILE="$(mktemp /tmp/qemu_memcg_vmtest_XXXX.pid)"
+readonly QEMU_OPTS=" --pidfile ${QEMU_PIDFILE} "
+
+BUILD=0
+QEMU="qemu-system-$(uname -m)"
+VERBOSE=0
+SHELL_MODE=0
+GUEST_TREE="${GUEST_TREE:-$KERNEL_CHECKOUT}"
+
+usage() {
+	cat <<EOF
+$0 [OPTIONS]
+    -b        Build kernel from source tree before booting
+    -q <qemu> QEMU binary/path (default: $QEMU)
+    -s        Start interactive shell in VM
+    -v        Verbose output (vng boot logs on stdout)
+EOF
+	exit 1
+}
+
+die() {
+	echo "$*" >&2
+	exit "${KSFT_FAIL}"
+}
+
+cleanup() {
+	if [[ -s "$QEMU_PIDFILE" ]]; then
+		pkill -SIGTERM -F "$QEMU_PIDFILE" >/dev/null 2>&1 || true
+	fi
+
+	if [[ -e "$QEMU_PIDFILE" ]]; then
+		rm -f "$QEMU_PIDFILE"
+	fi
+}
+
+vm_ssh() {
+	stdbuf -oL ssh -q \
+		-F "$HOME/.cache/virtme-ng/.ssh/virtme-ng-ssh.conf" \
+		-l root "virtme-ng%$SSH_GUEST_PORT" \
+		"$@"
+}
+
+check_deps() {
+	for dep in vng "$QEMU" busybox pkill ssh; do
+		if ! command -v "$dep" >/dev/null 2>&1; then
+			echo "skip: dependency $dep not found"
+			exit "$KSFT_SKIP"
+		fi
+	done
+}
+
+handle_build() {
+	if [[ ! "$BUILD" -eq 1 ]]; then
+		return
+	fi
+
+	if [[ ! -d "$KERNEL_CHECKOUT" ]]; then
+		echo "-b requires $0 to be called from the kernel source tree" >&2
+		exit 1
+	fi
+
+	pushd "$KERNEL_CHECKOUT" &>/dev/null
+
+	if ! vng --kconfig --config "$SCRIPT_DIR"/config; then
+		die "failed to generate .config for kernel source tree ($KERNEL_CHECKOUT)"
+	fi
+
+	if ! make -j"$(nproc)"; then
+		die "failed to build kernel from source tree ($KERNEL_CHECKOUT)"
+	fi
+
+	popd &>/dev/null
+}
+
+vm_start() {
+	local logfile=/dev/null
+	local verbose_opt=""
+	local kernel_opt=""
+
+	if [[ "$VERBOSE" -eq 1 ]]; then
+		verbose_opt="--verbose"
+		logfile=/dev/stdout
+	fi
+
+	if [[ "$BUILD" -eq 1 ]]; then
+		kernel_opt="${KERNEL_CHECKOUT}"
+	fi
+
+	vng \
+		--run \
+		${kernel_opt} \
+		${verbose_opt} \
+		--qemu-opts="$QEMU_OPTS" \
+		--qemu="$(command -v "$QEMU")" \
+		--user root \
+		--ssh "$SSH_GUEST_PORT" \
+		--append "cma=64M" \
+		--rw &>"$logfile" &
+
+	local vng_pid=$!
+	local elapsed=0
+
+	while [[ ! -s "$QEMU_PIDFILE" ]]; do
+		kill -0 "$vng_pid" 2>/dev/null || \
+			die "vng exited early; failed to boot VM"
+		[[ "$elapsed" -ge "$WAIT_TOTAL" ]] && \
+			die "timed out waiting for VM boot"
+		sleep 1
+		elapsed=$((elapsed + 1))
+	done
+}
+
+vm_wait_for_ssh() {
+	local i=0
+	while true; do
+		vm_ssh -- true && break
+		i=$((i + 1))
+		[[ "${i}" -gt "$WAIT_PERIOD_MAX" ]] && \
+			die "timed out waiting for guest ssh"
+		sleep "$WAIT_PERIOD"
+	done
+}
+
+check_guest_requirements() {
+	vm_ssh -- "grep -q memory /sys/fs/cgroup/cgroup.controllers" \
+		|| die "memory controller not available (CONFIG_MEMCG?)"
+	vm_ssh -- "[[ -e /dev/dma_heap/default_cma_region ]]" \
+		|| die "CMA heap not available (CONFIG_DMABUF_HEAPS_CMA? cma= cmdline?)"
+}
+
+setup_guest_cma_accounting() {
+	vm_ssh -- "mount -o remount,memory_cma_accounting /sys/fs/cgroup" \
+		|| die "failed to enable memory_cma_accounting"
+	vm_ssh -- "echo +memory > /sys/fs/cgroup/cgroup.subtree_control" \
+		|| die "failed to enable memory controller"
+}
+
+run_test() {
+	vm_ssh -- "cd '$GUEST_TREE' && make -C tools/testing/selftests TARGETS=cgroup"
+	vm_ssh -- "cd '$GUEST_TREE' && make -C tools/testing/selftests TARGETS=cgroup run_tests"
+}
+
+while getopts ":hvq:sb" opt; do
+	case "$opt" in
+	v) VERBOSE=1 ;;
+	q) QEMU="${OPTARG}" ;;
+	b) BUILD=1 ;;
+	s) SHELL_MODE=1 ;;
+	h|*) usage ;;
+	esac
+done
+
+trap cleanup EXIT
+
+check_deps
+handle_build
+echo "Booting virtme-ng VM..."
+vm_start
+vm_wait_for_ssh
+echo "VM is reachable via SSH."
+
+if [[ "$SHELL_MODE" -eq 1 ]]; then
+	echo "Starting interactive shell in VM. Exit to stop VM."
+	vm_ssh -t -- "cd '$GUEST_TREE' && exec bash --noprofile --norc"
+	exit "$KSFT_PASS"
+fi
+
+check_guest_requirements
+setup_guest_cma_accounting
+
+echo "Running cgroup selftests in VM..."
+run_test
+echo "PASS: cgroup selftests completed"
+exit "$KSFT_PASS"

-- 
2.53.0

