Received: from mail-dl2-f40.google.com (mail-dl2-f40.google.com [74.125.229.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A4749B5B9
	for <cgroups@vger.kernel.org>; Fri,  2 Oct 2026 13:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.168
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790946734; cv=none; b=ihzDC+Vg5PtPMEJu7KBMAzIHTvKt1eh37dOCvcMzjivAEULj966OUbUa0vZyRqdNjgDqeJl5P3994lhBsA23vNyaq8OdLqDCC6BH56WT33RMfyekA3TeunXuDaLsXCsBMOywOiWLPsLFfanbNc7i1jd3lV0oLoHb6Cpo/Dgv0xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790946734; c=relaxed/simple;
	bh=sWv6Leq6SuqptJnNKUCmcETfko2DxDcu7sNcPsNTbs0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IsqxyWDCTU8PXZTiTM3/5t9jSRHXpVnqKHgRNfSLJEFNdduN2ZH4soDGFWi1YnVR9Nw7AD43KZfjaDzb/doc3LnYgEd3YGwuNBvbrYSWIPH4EQNKCLM+vktf9OwMGD/OALeH0A8ru4h4SK0np2pK8UorSNh0LLJxUzIIloacXoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sz09DrGS; arc=none smtp.client-ip=74.125.229.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sz09DrGS"
Received: by mail-dl2-f40.google.com with SMTP id a92af1059eb24-14f381f0424so541189c88.0
        for <cgroups@vger.kernel.org>; Fri, 02 Oct 2026 06:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790946731; x=1791551531; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+k9Mb/vAtNfAzviPhjr8Kitc87slYpO6UmJ9+Fe/NTM=;
        b=sz09DrGS89jq3g0CFwD+8ZZPtBPk98ZUhy933i0JoXPb0d7DlVmOQIPFbUIhhSmrKk
         mAkYwqdFLMJyIq9PU9vrEhRZouFMJO65/cJgBJC2wKkHAvzVlSeeerYfxebFb+84P4wO
         Wef4Q5F7k0QtwyBH7s7H26qTA0xY5nDNpvTmiUp1RVYLm/RxJUSB0K/Px7HjgtgOVHB/
         6o1Fv8N1qJoM3MEbuLlxZT3/3S0cnffew5THGlCSleYqKfaMzecT7ohcVJebLiBRgQG9
         OSUrURlq092tgFc6hHm0CR75QX/YOczgb0OMhRQ4PB0uxk/Ma/KcFlYG+ig73XnsrxAh
         9A5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790946731; x=1791551531;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+k9Mb/vAtNfAzviPhjr8Kitc87slYpO6UmJ9+Fe/NTM=;
        b=QkhXPkC/Pj0A/SiMnW+JgW1kGUng3Pkjb0VRrTQIFCy/DnQknWAbDqNlB7vUtGntVu
         4G9RuqYuXn8qqN7lii6/OoVdvPzSrr2ZSf1/blN5h+PK6EDEGk7UTPD0dVEbdR1b0tfv
         y3Mx4Q6g1ai0/uvqLI0oJxvWqIMiHtE9rSHOLrmqi9q+Zte42Ysv/xlRlL4YgL3WRRnG
         jDNDGdNx/I7t7zW+b8Sk5u2faQQajT3DplP9b2obLagZZnPhXk4K/VY1TkKJj2BW0Tco
         B/WhWkXiXKcTvyB2DvwLHTmpHRHpK5eABJiKL4VSxQQEf2W6qcbyZTEjSeQvcfxMd8mf
         AmTg==
X-Forwarded-Encrypted: i=1; AKwUvBzgOA3ClUIJLgJuJVqBk5KEwrg7/17gTCzqzEyqus1Xwh6vvLQoC/0F9HJBguqm9zKsEyH+lI4E@vger.kernel.org
X-Gm-Message-State: AFuF++kKQMdAFwyeaqTQx/hRTOlBztkDs6dBThnQTby93jHnx7KBf23/
	XG7ee8Al7j/NlTDjm3kLOM3qcGzdTWhcpYGUhUtaBXxkS5Aq9C2Byp20
X-Gm-Gg: AYBFou3NHMMjsalRatrlQtQACaUbu1Rr5xotFiSTqTCGV1i1iIexUVYBes7SBT0qY3r
	Om+q+xDvIShjPaimCJSOl+c9wG5HQ1XsAjcqnlVl+Hkn9RHpTBWj4DgXNAeBWusPfNU2wtceyOb
	kLZLwuG/Z+ApTFhJYO8krIo5t5GBS2u4/YAGFq3S/XUHKoeh7SfJLpU4eFTLDjTnW/rGFfP2Ybp
	LcprzwMpWqK2f5inZMlAAUedVKP9JE14MN4P4L4HWydOGJ2yRS2sIyiE7ePJ49LSF1p65fc1eCe
	0H8XwHKBC5H9YIUL8OesEhilZodHUpPa8qQljEcmyUqfTIksdb88lJAAMSsKIotAVwFvAWN0nYU
	abClQTG7/Bz1+JVlX5+bSVz2QGGuT9EkCBCqhFvQ4d6akLpb5jKLXhAoWD6YJG8JiEtINi3B1tq
	Pnq1gE1B4If4jkMPc9IfBch/6MtFry/UD2dtFI7ufBfOn7mln/KNJ1zAg1CHj7M8rAQ05DUxKTb
	2vU
X-Received: by 2002:a05:701b:2915:b0:14d:6b42:c8b0 with SMTP id a92af1059eb24-14f5bc0031amr2947764c88.7.1790946730324;
        Fri, 02 Oct 2026 06:12:10 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34f0672c739sm7309347eec.3.2026.10.02.06.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 06:12:09 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Fri, 02 Oct 2026 21:10:32 +0800
Subject: [PATCH v5 12/12] selftests/cgroup: Add kernel-noise isolation test
 to cpuset selftest
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261002-wujing-dhm-v5-12-78a6996d87ad@gmail.com>
References: <20261002-wujing-dhm-v5-0-78a6996d87ad@gmail.com>
In-Reply-To: <20261002-wujing-dhm-v5-0-78a6996d87ad@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, Tejun Heo <tj@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@kernel.org>
Cc: Waiman Long <longman@redhat.com>, linux-kernel@vger.kernel.org, 
 rcu@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0

Add test_hk_noise_isolated() to test_cpuset_prs.sh to verify that
creating and destroying an isolated partition updates the kernel-noise
housekeeping state, including the /sys/devices/system/cpu/nohz_full
attribute.  Add the cpu_in_cpulist() helper to correctly test membership
against a cpulist that may contain ranges.

Also detect and report whether the test is running in zero-boot-param
mode (no nohz_full= in /proc/cmdline).  When in zero-boot-param mode
the test confirms that nohz_full is activated by the DHM runtime path,
verifying that dhm_cycle_isolated_cpus() correctly enables tick
isolation without any boot-time setup.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 578 ++++++++++++++++++++++
 1 file changed, 578 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 7efd5e645767c..d4ae35dd71563 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -1281,10 +1281,588 @@ test_inotify()
 	echo "" > cpuset.cpus
 }
 
+#
+# cpu_in_cpulist <cpu> <cpulist>
+#
+# Return 0 if <cpu> appears in <cpulist> (a kernel cpumask list such as
+# "0-3,8-31"), non-zero otherwise.  The kernel cpulist format uses ranges
+# ("lo-hi") and comma-separated items; a simple grep cannot detect that a
+# number falls in the middle of a range, so walk each element explicitly.
+#
+cpu_in_cpulist()
+{
+	local cpu=$1 list=$2 range lo hi
+	for range in $(echo "$list" | tr ',' ' '); do
+		if [[ "$range" == *-* ]]; then
+			lo=${range%-*}
+			hi=${range#*-}
+			[[ $cpu -ge $lo && $cpu -le $hi ]] && return 0
+		else
+			[[ $cpu -eq $range ]] && return 0
+		fi
+	done
+	return 1
+}
+
+#
+# verify_nohz_exact <baseline> <active_cpus> <current>
+#
+# Verify that <current> nohz_full equals <baseline> ∪ <active_cpus>.
+# <active_cpus> may be a cpulist range ("4-7") or empty string ("").
+# Catches both missing CPUs and unexpected extra CPUs.
+#
+verify_nohz_exact()
+{
+	local baseline=$1 active=$2 current=$3 cpu exp got
+	for cpu in $(seq 0 $((NR_CPUS - 1))); do
+		exp=0; got=0
+		cpu_in_cpulist $cpu "$baseline" && exp=1
+		[[ -n "$active" ]] && cpu_in_cpulist $cpu "$active" && exp=1
+		cpu_in_cpulist $cpu "$current" && got=1
+		[[ $exp -eq $got ]] || {
+			if [[ $got -eq 0 ]]; then
+				echo "FAIL: cpu${cpu} expected in nohz_full but absent" \
+				     "(baseline='$baseline' active='$active'" \
+				     "current='$current')"
+			else
+				echo "FAIL: cpu${cpu} unexpectedly in nohz_full" \
+				     "(baseline='$baseline' active='$active'" \
+				     "current='$current')"
+			fi
+			return 1
+		}
+	done
+	return 0
+}
+
+#
+# Test that isolated partition creation/destruction drives kernel-noise
+# housekeeping mask updates and remains correct under pressure.
+#
+# Requires: >=8 CPUs, no isolcpus= boot conflict, root
+#
+
+#
+# hk_noise_check_nocb_affinity <cpulist> <expect_isolated>
+#
+# When expect_isolated=1: verify rcuop/N kthreads for CPUs in cpulist do NOT
+# include those CPUs in their scheduler affinity (RCU NOCB active — callbacks
+# for the isolated CPU are offloaded to a different CPU).
+# When expect_isolated=0: verify CPUs are back in affinity (NOCB restored).
+# Silently skips CPUs whose rcuop/N thread is absent (no NOCB support).
+#
+hk_noise_check_nocb_affinity()
+{
+	local cpulist=$1 expect_isolated=$2
+	local cpu lo hi range pid aff_hex rev_hex nibble_pos nibble_char
+	local nibble_val bit_in_nibble bit failed=0
+
+	command -v taskset > /dev/null 2>&1 || return 0
+
+	for range in $(echo "$cpulist" | tr ',' ' '); do
+		if [[ "$range" == *-* ]]; then
+			lo=${range%-*}; hi=${range#*-}
+		else
+			lo=$range; hi=$range
+		fi
+		for cpu in $(seq "$lo" "$hi"); do
+			pid=$(ps -eo pid,comm | awk -v c="rcuop/$cpu" '$2==c{print $1}')
+			[[ -n "$pid" ]] || continue
+			aff_hex=$(taskset -p "$pid" 2>/dev/null | awk '{print $NF}')
+			[[ -n "$aff_hex" ]] || continue
+
+			# Extract bit <cpu> from the hex affinity mask.
+			# Each hex digit covers 4 CPUs; reverse the string to
+			# work from the LSB side.
+			rev_hex=$(echo "$aff_hex" | rev)
+			nibble_pos=$((cpu / 4))
+			nibble_char=${rev_hex:$nibble_pos:1}
+			if [[ -z "$nibble_char" ]]; then
+				nibble_val=0
+			else
+				nibble_val=$((16#$nibble_char))
+			fi
+			bit_in_nibble=$((cpu % 4))
+			bit=$(( (nibble_val >> bit_in_nibble) & 1 ))
+
+			if [[ $expect_isolated -eq 1 && $bit -eq 1 ]]; then
+				echo "FAIL: rcuop/$cpu affinity still includes" \
+				     "CPU$cpu after isolation (mask=0x$aff_hex)"
+				failed=1
+			elif [[ $expect_isolated -eq 0 && $bit -eq 0 ]]; then
+				echo "FAIL: rcuop/$cpu affinity still excludes" \
+				     "CPU$cpu after de-isolation (mask=0x$aff_hex)"
+				failed=1
+			fi
+		done
+	done
+	return $failed
+}
+
+test_hk_noise_isolated()
+{
+	local ISOL_BEFORE TEST_CPUS i PART ISOL_AFTER ISOL_RESTORE
+	local NOHZ_FILE NOHZ_BEFORE NOHZ_AFTER NOHZ_RESTORE
+	local HK_NOHZ_CHECK=0
+	local LOOPS=100
+	local CMDLINE HAS_BOOT_NOHZ=0
+	local DMESG_LINES_START
+	DMESG_LINES_START=$(dmesg | wc -l)
+
+	[[ $NR_CPUS -ge 8 ]] || {
+		echo "HK-noise test skipped: need >=8 CPUs, have $NR_CPUS"
+		return 0
+	}
+
+	# Detect whether CONFIG_NO_HZ_FULL is active: the sysfs attribute
+	# /sys/devices/system/cpu/nohz_full exposes the current nohz_full
+	# cpumask and is only present when NO_HZ_FULL is enabled.
+	NOHZ_FILE=/sys/devices/system/cpu/nohz_full
+	[[ -r "$NOHZ_FILE" ]] && HK_NOHZ_CHECK=1
+
+	# Determine if running in zero-boot-param mode.  DHM activates tick
+	# and RCU-NOCB isolation at runtime; no nohz_full= or rcu_nocbs=
+	# kernel boot parameters are required.
+	{ read -r CMDLINE < /proc/cmdline; } 2>/dev/null || CMDLINE=""
+	[[ $CMDLINE = *nohz_full=* ]] && HAS_BOOT_NOHZ=1
+	if [[ $HAS_BOOT_NOHZ -eq 0 ]]; then
+		console_msg "HK-noise: zero-boot-param mode" \
+		            "(no nohz_full= in /proc/cmdline -- testing DHM runtime path)"
+	else
+		console_msg "HK-noise: boot-param mode (nohz_full= present at boot)"
+	fi
+
+	cd $CGROUP2/test
+	echo member > cpuset.cpus.partition 2>/dev/null
+	echo "" > cpuset.cpus 2>/dev/null
+
+	ISOL_BEFORE=$(cat $CGROUP2/cpuset.cpus.isolated)
+	[[ $HK_NOHZ_CHECK -eq 1 ]] && NOHZ_BEFORE=$(cat $NOHZ_FILE)
+	TEST_CPUS="4-7"
+	echo $TEST_CPUS > cpuset.cpus
+
+	#
+	# Basic create/destroy cycle — verify domain isolation and
+	# kernel-noise (nohz_full) changes together.
+	#
+	console_msg "HK-noise: basic create/destroy cycle"
+	echo isolated > cpuset.cpus.partition
+
+	ISOL_AFTER=$(cat $CGROUP2/cpuset.cpus.isolated)
+	[[ $ISOL_AFTER != "$ISOL_BEFORE" ]] || {
+		echo "FAIL: isolated set unchanged after partition create"
+		exit 1
+	}
+
+	if [[ $HK_NOHZ_CHECK -eq 1 ]]; then
+		NOHZ_AFTER=$(cat $NOHZ_FILE)
+		verify_nohz_exact "$NOHZ_BEFORE" "$TEST_CPUS" "$NOHZ_AFTER" || exit 1
+		console_msg "HK-noise: nohz_full after isolation: $NOHZ_AFTER"
+	fi
+
+	# Verify RCU NOCB: rcuop/N kthreads for isolated CPUs must have those
+	# CPUs removed from their scheduler affinity mask.
+	hk_noise_check_nocb_affinity "$TEST_CPUS" 1 || exit 1
+
+	echo member > cpuset.cpus.partition
+
+	ISOL_RESTORE=$(cat $CGROUP2/cpuset.cpus.isolated)
+	[[ $ISOL_RESTORE = "$ISOL_BEFORE" ]] || {
+		echo "FAIL: expected '$ISOL_BEFORE' after destroy, got '$ISOL_RESTORE'"
+		exit 1
+	}
+
+	if [[ $HK_NOHZ_CHECK -eq 1 ]]; then
+		NOHZ_RESTORE=$(cat $NOHZ_FILE)
+		verify_nohz_exact "$NOHZ_BEFORE" "" "$NOHZ_RESTORE" || exit 1
+	fi
+
+	# Verify RCU NOCB restored: isolated CPUs must reappear in rcuop/N affinity.
+	hk_noise_check_nocb_affinity "$TEST_CPUS" 0 || exit 1
+
+	#
+	# Reject all-CPU isolation (must leave at least one housekeeping CPU)
+	#
+	console_msg "HK-noise: reject all-CPU isolation"
+	echo 0-$((NR_CPUS - 1)) > cpuset.cpus
+	echo isolated > cpuset.cpus.partition
+	PART=$(cat cpuset.cpus.partition)
+	[[ $PART = *invalid* || $PART = member ]] || {
+		echo "FAIL: all-CPU isolation was not rejected, got '$PART'"
+		exit 1
+	}
+
+	#
+	# SMT safety: partial sibling isolation
+	#
+	console_msg "HK-noise: SMT sibling constraint"
+	echo $TEST_CPUS > cpuset.cpus
+	echo isolated > cpuset.cpus.partition
+	PART=$(cat cpuset.cpus.partition)
+	[[ $PART = isolated ]] || {
+		echo "FAIL: could not create isolated partition, got '$PART'"
+		exit 1
+	}
+	echo member > cpuset.cpus.partition
+
+	#
+	# Non-hotpluggable CPU: must be skipped with a kernel warning without
+	# rejecting the partition; hotpluggable peers must still be isolated.
+	#
+	# A CPU whose online file is absent (e.g. CPU 0 on x86-64) has hotplug
+	# disabled.  DHM emits pr_warn_once and keeps it in the tick/RCU-NOCB
+	# housekeeping set; it must not appear in nohz_full after isolation.
+	# The remaining hotpluggable CPUs in the partition must still be isolated.
+	#
+	local FIXED_CPU="" c NOHZ_NOW
+	for c in $(seq 0 $((NR_CPUS - 1))); do
+		[[ -f /sys/devices/system/cpu/cpu${c}/online ]] || {
+			FIXED_CPU=$c
+			break
+		}
+	done
+	if [[ -n "$FIXED_CPU" ]]; then
+		console_msg "HK-noise: non-hotpluggable CPU${FIXED_CPU} skip"
+		echo "${FIXED_CPU},${TEST_CPUS}" > cpuset.cpus
+		echo isolated > cpuset.cpus.partition
+		PART=$(cat cpuset.cpus.partition)
+		[[ $PART = isolated ]] || {
+			echo "FAIL: partition rejected when including non-hotpluggable" \
+			     "CPU${FIXED_CPU}: got '$PART'"
+			exit 1
+		}
+		if [[ $HK_NOHZ_CHECK -eq 1 ]]; then
+			NOHZ_NOW=$(cat $NOHZ_FILE)
+			if cpu_in_cpulist $FIXED_CPU "$NOHZ_NOW"; then
+				echo "FAIL: non-hotpluggable CPU${FIXED_CPU} appeared" \
+				     "in nohz_full (should be skipped)"
+				exit 1
+			fi
+			local lo hi
+			lo=${TEST_CPUS%%-*}
+			hi=${TEST_CPUS##*-}
+			for cpu in $(seq "$lo" "$hi"); do
+				if ! cpu_in_cpulist $cpu "$NOHZ_NOW"; then
+					echo "FAIL: hotpluggable cpu${cpu} missing from" \
+					     "nohz_full in mixed partition (got: '$NOHZ_NOW')"
+					exit 1
+				fi
+			done
+			console_msg "HK-noise: CPU${FIXED_CPU} absent, ${TEST_CPUS} present" \
+			            "in nohz_full: $NOHZ_NOW"
+		fi
+		echo member > cpuset.cpus.partition
+		echo $TEST_CPUS > cpuset.cpus
+	else
+		console_msg "HK-noise: all CPUs hotpluggable; skip non-hotpluggable subtest"
+	fi
+
+	#
+	# Delta isolation: modify cpuset.cpus while the partition is isolated.
+	# dhm_prev_isolated must track the delta and update nohz_full in step.
+	#
+	local lo hi mid lower_cpus upper_cpu
+	lo=${TEST_CPUS%%-*}
+	hi=${TEST_CPUS##*-}
+	mid=$(( lo + (hi - lo) / 2 ))
+	lower_cpus="${lo}-${mid}"
+	upper_cpu=$(( mid + 1 ))
+	console_msg "HK-noise: delta isolation (shrink ${TEST_CPUS} → ${lower_cpus})"
+	echo $TEST_CPUS > cpuset.cpus
+	echo isolated > cpuset.cpus.partition
+	PART=$(cat cpuset.cpus.partition)
+	[[ $PART = isolated ]] || {
+		echo "FAIL: delta test: initial isolation failed, got '$PART'"
+		exit 1
+	}
+	echo $lower_cpus > cpuset.cpus
+	PART=$(cat cpuset.cpus.partition)
+	if [[ $PART = isolated ]]; then
+		if [[ $HK_NOHZ_CHECK -eq 1 ]]; then
+			NOHZ_NOW=$(cat $NOHZ_FILE)
+			verify_nohz_exact "$NOHZ_BEFORE" "$lower_cpus" "$NOHZ_NOW" || exit 1
+		fi
+		# Expand back to full TEST_CPUS and re-verify
+		echo $TEST_CPUS > cpuset.cpus
+		if [[ $HK_NOHZ_CHECK -eq 1 ]]; then
+			NOHZ_NOW=$(cat $NOHZ_FILE)
+			verify_nohz_exact "$NOHZ_BEFORE" "$TEST_CPUS" "$NOHZ_NOW" || exit 1
+		fi
+		echo member > cpuset.cpus.partition
+		if [[ $HK_NOHZ_CHECK -eq 1 ]]; then
+			NOHZ_NOW=$(cat $NOHZ_FILE)
+			verify_nohz_exact "$NOHZ_BEFORE" "" "$NOHZ_NOW" || exit 1
+		fi
+	else
+		console_msg "HK-noise: delta test: partition invalidated on shrink" \
+		            "('$PART') -- cpuset constraint, not a DHM bug; skipping"
+		echo member > cpuset.cpus.partition 2>/dev/null || true
+	fi
+	echo $TEST_CPUS > cpuset.cpus
+
+	#
+	# Nested partition: parent root → child isolated
+	#
+	console_msg "HK-noise: nested partition inheritance"
+	echo $TEST_CPUS > cpuset.cpus
+	test_partition root
+	mkdir -p HK_SUB
+	cd HK_SUB
+	echo "${lo}-$((lo + 1))" > cpuset.cpus
+	echo isolated > cpuset.cpus.partition
+	ISOL_AFTER=$(cat $CGROUP2/cpuset.cpus.isolated)
+	[[ -n $ISOL_AFTER ]] || {
+		echo "FAIL: nested isolated partition not reflected in cpuset.cpus.isolated"
+		exit 1
+	}
+	echo member > cpuset.cpus.partition
+	cd $CGROUP2/test
+	echo member > cpuset.cpus.partition
+	rmdir HK_SUB 2>/dev/null
+
+	#
+	# Pressure test: 100 create/destroy cycles with nohz_full verified
+	# on every cycle to catch mid-run state corruption.
+	#
+	console_msg "HK-noise: pressure test ($LOOPS cycles)"
+	echo $TEST_CPUS > cpuset.cpus
+	for i in $(seq 1 $LOOPS); do
+		echo isolated > cpuset.cpus.partition
+		PART=$(cat cpuset.cpus.partition)
+		[[ $PART = isolated ]] || {
+			echo "FAIL: cycle $i create failed, got '$PART'"
+			exit 1
+		}
+		if [[ $HK_NOHZ_CHECK -eq 1 ]]; then
+			NOHZ_NOW=$(cat $NOHZ_FILE)
+			verify_nohz_exact "$NOHZ_BEFORE" "$TEST_CPUS" "$NOHZ_NOW" || {
+				echo "FAIL: nohz_full wrong at cycle $i (isolated)"
+				exit 1
+			}
+		fi
+		echo member > cpuset.cpus.partition
+		PART=$(cat cpuset.cpus.partition)
+		[[ $PART = member ]] || {
+			echo "FAIL: cycle $i destroy failed, got '$PART'"
+			exit 1
+		}
+		if [[ $HK_NOHZ_CHECK -eq 1 ]]; then
+			NOHZ_NOW=$(cat $NOHZ_FILE)
+			verify_nohz_exact "$NOHZ_BEFORE" "" "$NOHZ_NOW" || {
+				echo "FAIL: nohz_full wrong at cycle $i (member)"
+				exit 1
+			}
+		fi
+	done
+
+	#
+	# Stability: after pressure test, verify final state
+	#
+	console_msg "HK-noise: post-pressure cleanup"
+	echo isolated > cpuset.cpus.partition
+	ISOL_AFTER=$(cat $CGROUP2/cpuset.cpus.isolated)
+	[[ -n $ISOL_AFTER ]] || {
+		echo "FAIL: isolated set empty after pressure test"
+		exit 1
+	}
+	echo member > cpuset.cpus.partition
+	echo "" > cpuset.cpus
+	ISOL_RESTORE=$(cat $CGROUP2/cpuset.cpus.isolated)
+	[[ $ISOL_RESTORE = "$ISOL_BEFORE" ]] || {
+		echo "FAIL: final isolated '$ISOL_RESTORE' != '$ISOL_BEFORE'"
+		exit 1
+	}
+
+	if [[ $HK_NOHZ_CHECK -eq 1 ]]; then
+		NOHZ_RESTORE=$(cat $NOHZ_FILE)
+		[[ "$NOHZ_RESTORE" = "$NOHZ_BEFORE" ]] || {
+			echo "FAIL: nohz_full not restored after pressure test:" \
+			     "expected '$NOHZ_BEFORE', got '$NOHZ_RESTORE'"
+			exit 1
+		}
+	fi
+
+	#
+	# Pressure with resident task: create/destroy cycles while a sleeping
+	# task occupies the isolated partition.  Exercises the dhm_cycling_cpus
+	# suppression path that prevents false partition invalidation when a
+	# task is present during hotplug cycling steps.
+	#
+	console_msg "HK-noise: pressure with resident task ($LOOPS cycles)"
+	echo $TEST_CPUS > cpuset.cpus
+	sleep 600 &
+	local TASK_PID=$!
+	echo $TASK_PID > cgroup.procs
+	for i in $(seq 1 $LOOPS); do
+		echo isolated > cpuset.cpus.partition
+		PART=$(cat cpuset.cpus.partition)
+		[[ $PART = isolated ]] || {
+			echo "FAIL: task-occupied cycle $i create failed, got '$PART'"
+			kill $TASK_PID 2>/dev/null; wait $TASK_PID 2>/dev/null
+			exit 1
+		}
+		if [[ $HK_NOHZ_CHECK -eq 1 ]]; then
+			NOHZ_NOW=$(cat $NOHZ_FILE)
+			verify_nohz_exact "$NOHZ_BEFORE" "$TEST_CPUS" "$NOHZ_NOW" || {
+				kill $TASK_PID 2>/dev/null; wait $TASK_PID 2>/dev/null
+				exit 1
+			}
+		fi
+		echo member > cpuset.cpus.partition
+		PART=$(cat cpuset.cpus.partition)
+		[[ $PART = member ]] || {
+			echo "FAIL: task-occupied cycle $i destroy failed, got '$PART'"
+			kill $TASK_PID 2>/dev/null; wait $TASK_PID 2>/dev/null
+			exit 1
+		}
+	done
+	kill $TASK_PID 2>/dev/null
+	wait $TASK_PID 2>/dev/null
+	echo "" > cpuset.cpus
+
+	#
+	# Concurrent partitions: two sibling cgroups each holding half of
+	# TEST_CPUS simultaneously isolated.  Verifies independent isolation
+	# and correct union in cpuset.cpus.isolated / nohz_full.
+	#
+	local lo hi mid lower_half upper_half NOHZ_BOTH
+	lo=${TEST_CPUS%%-*}; hi=${TEST_CPUS##*-}
+	mid=$(( lo + (hi - lo) / 2 ))
+	lower_half="${lo}-${mid}"
+	upper_half="$((mid + 1))-${hi}"
+	console_msg "HK-noise: concurrent partitions ($lower_half and $upper_half)"
+	echo $TEST_CPUS > cpuset.cpus
+	echo root > cpuset.cpus.partition
+	mkdir -p HK_A HK_B
+	echo "$lower_half" > HK_A/cpuset.cpus
+	echo isolated > HK_A/cpuset.cpus.partition
+	echo "$upper_half" > HK_B/cpuset.cpus
+	echo isolated > HK_B/cpuset.cpus.partition
+	local PA PB
+	PA=$(cat HK_A/cpuset.cpus.partition)
+	PB=$(cat HK_B/cpuset.cpus.partition)
+	[[ $PA = isolated ]] || {
+		echo "FAIL: concurrent partition HK_A not isolated, got '$PA'"
+		echo member > HK_A/cpuset.cpus.partition 2>/dev/null
+		echo member > HK_B/cpuset.cpus.partition 2>/dev/null
+		rmdir HK_A HK_B 2>/dev/null
+		echo member > cpuset.cpus.partition 2>/dev/null
+		exit 1
+	}
+	[[ $PB = isolated ]] || {
+		echo "FAIL: concurrent partition HK_B not isolated, got '$PB'"
+		echo member > HK_A/cpuset.cpus.partition 2>/dev/null
+		echo member > HK_B/cpuset.cpus.partition 2>/dev/null
+		rmdir HK_A HK_B 2>/dev/null
+		echo member > cpuset.cpus.partition 2>/dev/null
+		exit 1
+	}
+	if [[ $HK_NOHZ_CHECK -eq 1 ]]; then
+		NOHZ_BOTH=$(cat $NOHZ_FILE)
+		verify_nohz_exact "$NOHZ_BEFORE" "$TEST_CPUS" "$NOHZ_BOTH" || {
+			echo member > HK_A/cpuset.cpus.partition 2>/dev/null
+			echo member > HK_B/cpuset.cpus.partition 2>/dev/null
+			rmdir HK_A HK_B 2>/dev/null
+			echo member > cpuset.cpus.partition 2>/dev/null
+			exit 1
+		}
+	fi
+	hk_noise_check_nocb_affinity "$TEST_CPUS" 1 || {
+		echo member > HK_A/cpuset.cpus.partition 2>/dev/null
+		echo member > HK_B/cpuset.cpus.partition 2>/dev/null
+		rmdir HK_A HK_B 2>/dev/null
+		echo member > cpuset.cpus.partition 2>/dev/null
+		exit 1
+	}
+	echo member > HK_A/cpuset.cpus.partition
+	echo member > HK_B/cpuset.cpus.partition
+	rmdir HK_A HK_B
+	echo member > cpuset.cpus.partition
+	if [[ $HK_NOHZ_CHECK -eq 1 ]]; then
+		NOHZ_NOW=$(cat $NOHZ_FILE)
+		verify_nohz_exact "$NOHZ_BEFORE" "" "$NOHZ_NOW" || exit 1
+	fi
+	hk_noise_check_nocb_affinity "$TEST_CPUS" 0 || exit 1
+	echo "" > cpuset.cpus
+
+	#
+	# Concurrent create/destroy: two background subshells race on the same
+	# partition simultaneously.  Verifies that concurrent cpuset writes
+	# do not corrupt kernel state or trigger warnings.
+	#
+	console_msg "HK-noise: concurrent create/destroy race"
+	echo $TEST_CPUS > cpuset.cpus
+	local RACE_LOOPS=30 RACE_PID1 RACE_PID2
+	(for i in $(seq 1 $RACE_LOOPS); do
+		echo isolated > cpuset.cpus.partition 2>/dev/null
+		echo member   > cpuset.cpus.partition 2>/dev/null
+	done) &
+	RACE_PID1=$!
+	(for i in $(seq 1 $RACE_LOOPS); do
+		echo member   > cpuset.cpus.partition 2>/dev/null
+		echo isolated > cpuset.cpus.partition 2>/dev/null
+	done) &
+	RACE_PID2=$!
+	wait $RACE_PID1 $RACE_PID2
+	# Drive to a known-good state regardless of who won the last write.
+	echo member > cpuset.cpus.partition 2>/dev/null || true
+	PART=$(cat cpuset.cpus.partition)
+	[[ $PART = member ]] || {
+		echo "FAIL: concurrent race left partition in bad state: '$PART'"
+		exit 1
+	}
+	if [[ $HK_NOHZ_CHECK -eq 1 ]]; then
+		NOHZ_NOW=$(cat $NOHZ_FILE)
+		verify_nohz_exact "$NOHZ_BEFORE" "" "$NOHZ_NOW" || exit 1
+	fi
+	echo "" > cpuset.cpus
+
+	#
+	# Kernel hard-error check: none of the above scenarios must have
+	# triggered a BUG, OOPS, panic, or RCU stall in the kernel log.
+	# Also catch WARNINGs that implicate our subsystems (cpuset / rcu /
+	# nohz / housekeeping / irq_affinity); ignore unrelated WARNINGs from
+	# other kernel subsystems or user-space processes.
+	#
+	console_msg "HK-noise: checking kernel log for errors"
+	local new_errors
+	new_errors=$(dmesg | tail -n "+$((DMESG_LINES_START + 1))" | \
+		grep -c -E \
+		  'kernel BUG at|OOPS|Kernel panic|RCU Stall|scheduling while atomic' \
+		|| true)
+	local new_subsys_warns
+	new_subsys_warns=$(dmesg | tail -n "+$((DMESG_LINES_START + 1))" | \
+		grep 'WARNING:' | \
+		grep -c -E 'cpuset|rcu|nohz|housekeeping|irq_affinity|dhm' \
+		|| true)
+	local total_errors=$(( new_errors + new_subsys_warns ))
+	[[ $total_errors -eq 0 ]] || {
+		echo "FAIL: $total_errors kernel error(s)/warning(s) during HK-noise test:"
+		dmesg | tail -n "+$((DMESG_LINES_START + 1))" | \
+			grep -E 'kernel BUG at|OOPS|Kernel panic|RCU Stall|scheduling while atomic' | head -10
+		dmesg | tail -n "+$((DMESG_LINES_START + 1))" | \
+			grep 'WARNING:' | grep -E 'cpuset|rcu|nohz|housekeeping|irq_affinity|dhm' | head -10
+		exit 1
+	}
+
+	cd $CGROUP2
+	if [[ $HK_NOHZ_CHECK -eq 1 ]]; then
+		if [[ $HAS_BOOT_NOHZ -eq 0 ]]; then
+			console_msg "HK-noise: PASSED" \
+			            "(zero-boot-param: nohz_full verified via DHM runtime path)"
+		else
+			console_msg "HK-noise: PASSED (with nohz_full verification)"
+		fi
+	else
+		console_msg "HK-noise: PASSED (nohz_full skipped: CONFIG_NO_HZ_FULL not active)"
+	fi
+}
+
 trap cleanup 0 2 3 6
 run_state_test TEST_MATRIX
 run_remote_state_test REMOTE_TEST_MATRIX
 test_isolated
 test_boot_isolated
 test_inotify
+test_hk_noise_isolated
 echo "All tests PASSED."

-- 
2.43.0

