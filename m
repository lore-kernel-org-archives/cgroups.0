Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE7A3DBD57
	for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 09:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783933360; cv=none; b=Kj29770fkXePaLaTVgWd8Opjo/ZW2SKqB7exZG5VZT8jRQyntufmryb0wORgbnsCyT+tg3mwTqObWxo1ncyNCyXfjF00fND3fDAYsMIXsXDZn17kZJhHsZviVYK+ADtEmy2REUV6DnH4ju8Ww40pLsHepfy7uk4TAJHvht7UTJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783933360; c=relaxed/simple;
	bh=ZMnTzIIYD3ryqWvmxnS7KPltVp7erW0leC7SgcT6FFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JiYLM/rBkBwpCw0s3ib+NQjmOUl0ci/4YsrZK/nJhokmHQek8B0rGPpKXjTAYR6oDfo8EhZ1fVKDZmeVXRwcO34pg8bgeYS8NlRFQalVCgR2wpt7HmF6+op/WPt9aI18kPQUzby7FUtXSw/Lymr1J0ksHrDxuSFe5uN5LMUGkrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=dEo1Mewv; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="dEo1Mewv"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5b0115b9e17so2792265e87.0
        for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 02:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1783933355; x=1784538155; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JmJBQdQ4elBFSV3TDptElk8IGzQWnD9GFf/e4lmq0eU=;
        b=dEo1MewvM6WVrTO3QDvtPCjC/VqjyYBM9skqvyFMwPKBtM8yq2R8Y25kbhDUJ6jWfs
         f0Cu3WR9L4UYqWpBjybNUr2F/8r/fmM4k1D8W6W1DVpV4YFkY7kU1sBF931YgUK7F3SR
         6YaueeH6f6hW19Tx6fRpdYnhpr5O7p5nOlJjFN7u+7HlQq0y9l7EBnZ42wSYRdz2u+NO
         g5EVs8CZU/hHeAOou6eVQWdBIx5DcD1vvtoN6MJ/RG6ZzL03vx1Pik6kmavbOErDpfNB
         AV4IPEl4nnJ1VNW3J+D2rpGnQQ+39GtKSTVUJxb6wlkGex8eB++k64IrQg49z7gf4wwu
         Fh6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783933355; x=1784538155;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JmJBQdQ4elBFSV3TDptElk8IGzQWnD9GFf/e4lmq0eU=;
        b=N6hxN64KXK5AIbHS958qNXi0+JWS3vaoG31yU9+LUSUKsrtqCaSuCJOhTO4msrar5F
         vqoF5fr1ibsWNJZ2bOvqS2eJsvVkiNtMizK6t7jlsRDVJAeah00P3yXHzi88vJXYhd/G
         kfaRTMdQfu0Git2c1SR/Id3JT8KCRYGWmzPR7qLkZJshVysBgmpTBCE1b4XzFOIRH/Zm
         KS1KDtxzR7Eqa7vVGpw5UgIOgSzDGGRrPn14GNJIBBNDttNh3KxByRYyaD/ZZPHu1r5y
         zpyblpPc8SVVYmPKWqDRJWPi/06aUShBSbfydNn+HLebWsLrI/yRcQo3twm1uFUh+sMX
         Atvw==
X-Forwarded-Encrypted: i=1; AHgh+RrLro2XjoRwPHDV47QoWUiXBUTEW9mdLAc4gZFrNrkzvbi5Cd876tPIO/GxDIB3k7cxgNv1MUYG@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3n25eliM/P1maY2qTm/JUIaz5/1W4PnbAfQ4ha/WcNyeyuPep
	66Us7LxAGZLKYm5iUlunnXyuiYH4dJYNmYOWtzjgbH45ZqqFv7ZY5u1f0wHiwMlgFQw=
X-Gm-Gg: AfdE7clSO1yw1tIm9S9jVRyTpxHexToNSlB3pau4EYjsUmi1mWKbZhTUXJ2d4znEAUn
	G5Us1K6bb9mqx19mioQmRp5ZnrfU14bzsRA7I/jkBwniITT4iW7vHZkY9nOrWMZGyrow+r7f5m3
	bwe6DzgrfbpVxkXorwI4lJPGOuH2Vt8bM+V+JjVtfFejBB6lY8IMgmqkQFZz58iZTv8u95XPGr3
	FPiydf/eY/6nEU1m1HslxBz1629iFfWSI+odk3v1H7a6+bJO+jgxAiJU7XwNzz6JTLAQ0eZtt/F
	KFWUHjHPZ+Evi1PG5/Rn6C829dVnF101vl+XhxIfZdMdHnpWru4rvdvOBTiAblIUj+voF/CRQN+
	ltH+E4ftgdLVZk6or/kLOPFYsd0KvQG1qEHABCHXOh12ikqoVL2Hcz5KEwPiwyisvMw5/c0cnNy
	GAMAZ9s+anlKZG1vB4v6VZeg==
X-Received: by 2002:a05:6512:23d2:b0:5b0:1ae2:8b7a with SMTP id 2adb3069b0e04-5b0236ab3e8mr1256753e87.45.1783933355519;
        Mon, 13 Jul 2026 02:02:35 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b01caa66b4sm2731890e87.64.2026.07.13.02.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 02:02:34 -0700 (PDT)
Date: Mon, 13 Jul 2026 11:02:30 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: "yanjun.zhu" <yanjun.zhu@linux.dev>
Cc: linux-rdma@vger.kernel.org, cgroups@vger.kernel.org, 
	netdev@vger.kernel.org, linux-s390@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	jgg@ziepe.ca, leon@kernel.org, parav@nvidia.com, mbloch@nvidia.com, 
	cmeiohas@nvidia.com, roman.gushchin@linux.dev, bvanassche@acm.org, 
	zyjzyj2000@gmail.com, shuah@kernel.org, tj@kernel.org, mkoutny@suse.com, 
	hannes@cmpxchg.org, alibuda@linux.alibaba.com, dust.li@linux.alibaba.com, 
	sidraya@linux.ibm.com, wenjia@linux.ibm.com
Subject: Re: [PATCH rdma-next 13/13] RDMA/selftests: Add rxe_netns_names test
Message-ID: <alSoztLdt2of_6rf@FV6GYCPJ69>
References: <20260709095532.855647-1-jiri@resnulli.us>
 <20260709095532.855647-14-jiri@resnulli.us>
 <2aec2d14-0000-4595-aa2a-73aa5ae41060@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2aec2d14-0000-4595-aa2a-73aa5ae41060@linux.dev>

Sat, Jul 11, 2026 at 01:51:45AM +0200, yanjun.zhu@linux.dev wrote:
>On 7/9/26 2:55 AM, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> Add a kselftest script that exercises per-netns RDMA device naming
>> with RXE. Cover duplicate names across namespaces, move conflict
>> handling, move-with-rename, and same-namespace rename requests.
>
># timeout set to 45
># selftests: rdma: rxe_netns_names.sh
># TAP version 13
># 1..6
># ok 1 same RDMA device name can exist in two net namespaces
># ok 2 move without rename fails on destination name conflict
># ok 3 move then rename succeeds
># ok 4 move with requested destination name succeeds # SKIP     < --- This
>testcase skip
>
># ok 5 same-netns rename rejects duplicate name
># # device returned to init_net as 'ibdev35'
># ok 6 netns delete returns device to init_net and renames on conflict
># # 1 skipped test(s) detected.  Consider enabling relevant config options to
>improve coverage.
># # Totals: pass:5 fail:0 xfail:0 xpass:0 skip:1 error:0
>ok 6 selftests: rdma: rxe_netns_names.sh
>
>The above are my test results. But one testcase is skipped.

Yep, you need patched iproute2:
https://github.com/jpirko/iproute2_mlxsw/commit/cfb61f715fb16fc2b6d007408e048786ef3ed3f6

Plan to send this one after this patchset is merged.


>
>Zhu Yanjun
>
>> 
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> ---
>>   tools/testing/selftests/rdma/Makefile         |   3 +-
>>   tools/testing/selftests/rdma/config           |   2 +
>>   .../testing/selftests/rdma/rxe_netns_names.sh | 282 ++++++++++++++++++
>>   3 files changed, 286 insertions(+), 1 deletion(-)
>>   create mode 100755 tools/testing/selftests/rdma/rxe_netns_names.sh
>> 
>> diff --git a/tools/testing/selftests/rdma/Makefile b/tools/testing/selftests/rdma/Makefile
>> index 07af7f15c1bf..a91c14c45006 100644
>> --- a/tools/testing/selftests/rdma/Makefile
>> +++ b/tools/testing/selftests/rdma/Makefile
>> @@ -3,6 +3,7 @@ TEST_PROGS := rxe_rping_between_netns.sh \
>>   		rxe_ipv6.sh \
>>   		rxe_socket_with_netns.sh \
>>   		rxe_test_NETDEV_UNREGISTER.sh \
>> -		rxe_sent_rcvd_bytes.sh
>> +		rxe_sent_rcvd_bytes.sh \
>> +		rxe_netns_names.sh
>>   include ../lib.mk
>> diff --git a/tools/testing/selftests/rdma/config b/tools/testing/selftests/rdma/config
>> index 4ffb814e253b..e1ff54ec0f57 100644
>> --- a/tools/testing/selftests/rdma/config
>> +++ b/tools/testing/selftests/rdma/config
>> @@ -1,3 +1,5 @@
>>   CONFIG_TUN
>>   CONFIG_VETH
>> +CONFIG_DUMMY
>> +CONFIG_NET_NS
>>   CONFIG_RDMA_RXE
>> diff --git a/tools/testing/selftests/rdma/rxe_netns_names.sh b/tools/testing/selftests/rdma/rxe_netns_names.sh
>> new file mode 100755
>> index 000000000000..a7e57706fdff
>> --- /dev/null
>> +++ b/tools/testing/selftests/rdma/rxe_netns_names.sh
>> @@ -0,0 +1,282 @@
>> +#!/bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +#
>> +# Exercise RDMA device name handling across network namespaces.
>> +
>> +source "$(dirname "$0")/../kselftest/ktap_helpers.sh"
>> +
>> +NAME_PREFIX="rxe_netns_names_$$"
>> +NETDEV_PREFIX="rxn$$"
>> +NS1="${NAME_PREFIX}ns1"
>> +NS2="${NAME_PREFIX}ns2"
>> +RXE_A="${NAME_PREFIX}rxe_a"
>> +RXE_B="${NAME_PREFIX}rxe_b"
>> +RXE_SAME="${NAME_PREFIX}rxe_same"
>> +RXE_NEW="${NAME_PREFIX}rxe_new"
>> +DUMMY_A="${NETDEV_PREFIX}a"
>> +DUMMY_B="${NETDEV_PREFIX}b"
>> +OLD_MODE=""
>> +MODE_CHANGED=0
>> +MODS=("dummy" "rdma_rxe")
>> +TEST_SAME_NAMES="same RDMA device name can exist in two net namespaces"
>> +TEST_MOVE_CONFLICT="move without rename fails on destination name conflict"
>> +TEST_MOVE_RENAME="move then rename succeeds"
>> +TEST_COMBINED_MOVE_RENAME="move with requested destination name succeeds"
>> +TEST_SAME_NETNS_DUP_RENAME="same-netns rename rejects duplicate name"
>> +TEST_TEARDOWN_RETURN="netns delete returns device to init_net and renames on conflict"
>> +
>> +ksft_skip()
>> +{
>> +	ktap_skip_all "$*"
>> +	exit "$KSFT_SKIP"
>> +}
>> +
>> +fail()
>> +{
>> +	ktap_exit_fail_msg "$*"
>> +}
>> +
>> +need_cmd()
>> +{
>> +	command -v "$1" >/dev/null 2>&1 || ksft_skip "missing command: $1"
>> +}
>> +
>> +rdma_ns()
>> +{
>> +	local ns=$1
>> +
>> +	shift
>> +	ip netns exec "$ns" rdma "$@"
>> +}
>> +
>> +rdma_dev_exists()
>> +{
>> +	local ns=$1
>> +	local dev=$2
>> +
>> +	if [ -n "$ns" ]; then
>> +		rdma_ns "$ns" dev show "$dev" >/dev/null 2>&1
>> +	else
>> +		rdma dev show "$dev" >/dev/null 2>&1
>> +	fi
>> +}
>> +
>> +add_dummy()
>> +{
>> +	local netdev=$1
>> +
>> +	ip link add "$netdev" type dummy || return 1
>> +	ip link set "$netdev" up || return 1
>> +}
>> +
>> +add_rxe()
>> +{
>> +	local dev=$1
>> +	local netdev=$2
>> +
>> +	rdma link add "$dev" type rxe netdev "$netdev"
>> +}
>> +
>> +rdma_dev_on_netdev()
>> +{
>> +	local netdev=$1
>> +
>> +	rdma link show 2>/dev/null | awk -v want="$netdev" '
>> +		{
>> +			for (i = 1; i < NF; i++)
>> +				if ($i == "netdev" && $(i + 1) == want) {
>> +					dev = $2
>> +					sub(/\/.*/, "", dev)
>> +					print dev
>> +					exit
>> +				}
>> +		}'
>> +}
>> +
>> +wait_rdma_dev_on_netdev()
>> +{
>> +	local netdev=$1
>> +	local dev
>> +	local i
>> +
>> +	for i in $(seq 1 50); do
>> +		dev=$(rdma_dev_on_netdev "$netdev")
>> +		if [ -n "$dev" ]; then
>> +			echo "$dev"
>> +			return 0
>> +		fi
>> +		sleep 0.1
>> +	done
>> +
>> +	return 1
>> +}
>> +
>> +setup_devs()
>> +{
>> +	cleanup_devs
>> +
>> +	add_dummy "$DUMMY_A" || return 1
>> +	add_dummy "$DUMMY_B" || return 1
>> +
>> +	add_rxe "$RXE_A" "$DUMMY_A" || return 1
>> +	add_rxe "$RXE_B" "$DUMMY_B" || return 1
>> +}
>> +
>> +cleanup_devs()
>> +{
>> +	ip link del "$DUMMY_A" 2>/dev/null
>> +	ip link del "$DUMMY_B" 2>/dev/null
>> +}
>> +
>> +setup()
>> +{
>> +	OLD_MODE=$(rdma system show 2>/dev/null |
>> +		   sed -n 's/.*netns \([^ ]*\).*/\1/p')
>> +	[ -n "$OLD_MODE" ] || ksft_skip "failed to read RDMA netns mode"
>> +
>> +	rdma system set netns exclusive >/dev/null 2>&1 ||
>> +		ksft_skip "rdma netns exclusive mode is not supported"
>> +	MODE_CHANGED=1
>> +
>> +	ip netns add "$NS1" || return 1
>> +	ip netns add "$NS2" || return 1
>> +}
>> +
>> +cleanup()
>> +{
>> +	cleanup_devs
>> +
>> +	ip netns del "$NS1" 2>/dev/null
>> +	ip netns del "$NS2" 2>/dev/null
>> +
>> +	if [ "$MODE_CHANGED" -eq 1 ]; then
>> +		rdma system set netns "$OLD_MODE" 2>/dev/null
>> +	fi
>> +
>> +	for m in "${MODS[@]}"; do
>> +		modprobe -r "$m" 2>/dev/null
>> +	done
>> +}
>> +
>> +rdma_supports_combined_move_rename()
>> +{
>> +	rdma dev help 2>&1 | grep -Eq 'netns .*name|name .*netns'
>> +}
>> +
>> +[ "$(id -u)" -eq 0 ] || ksft_skip "must be run as root"
>> +need_cmd ip
>> +need_cmd rdma
>> +need_cmd modprobe
>> +
>> +trap cleanup EXIT
>> +
>> +for m in "${MODS[@]}"; do
>> +	modinfo "$m" >/dev/null 2>&1 || ksft_skip "module $m not found"
>> +	modprobe "$m" || fail "failed to load $m"
>> +done
>> +
>> +setup || fail "failed to create net namespaces"
>> +
>> +ktap_print_header
>> +ktap_set_plan 7
>> +
>> +if setup_devs &&
>> +   rdma dev set "$RXE_A" netns "$NS1" &&
>> +   rdma_ns "$NS1" dev set "$RXE_A" name "$RXE_SAME" &&
>> +   rdma dev set "$RXE_B" netns "$NS2" &&
>> +   rdma_ns "$NS2" dev set "$RXE_B" name "$RXE_SAME" &&
>> +   rdma_dev_exists "$NS1" "$RXE_SAME" &&
>> +   rdma_dev_exists "$NS2" "$RXE_SAME"; then
>> +	ktap_test_pass "$TEST_SAME_NAMES"
>> +else
>> +	ktap_test_fail "$TEST_SAME_NAMES"
>> +fi
>> +cleanup_devs
>> +
>> +if ! setup_devs ||
>> +   ! rdma dev set "$RXE_A" netns "$NS1" ||
>> +   ! rdma_ns "$NS1" dev set "$RXE_A" name "$RXE_SAME" ||
>> +   ! rdma dev set "$RXE_B" netns "$NS2" ||
>> +   ! rdma_ns "$NS2" dev set "$RXE_B" name "$RXE_SAME"; then
>> +	ktap_test_fail "$TEST_MOVE_CONFLICT"
>> +elif rdma_ns "$NS1" dev set "$RXE_SAME" netns "$NS2" >/dev/null 2>&1; then
>> +	ktap_test_fail "$TEST_MOVE_CONFLICT"
>> +elif rdma_dev_exists "$NS1" "$RXE_SAME" &&
>> +     rdma_dev_exists "$NS2" "$RXE_SAME"; then
>> +	ktap_test_pass "$TEST_MOVE_CONFLICT"
>> +else
>> +	ktap_test_fail "$TEST_MOVE_CONFLICT"
>> +fi
>> +cleanup_devs
>> +
>> +if ! setup_devs; then
>> +	ktap_test_fail "$TEST_MOVE_RENAME"
>> +elif rdma dev set "$RXE_A" netns "$NS2" &&
>> +     rdma_ns "$NS2" dev set "$RXE_A" name "$RXE_NEW"; then
>> +	if rdma_dev_exists "$NS2" "$RXE_NEW" &&
>> +	   ! rdma_dev_exists "" "$RXE_A"; then
>> +		ktap_test_pass "$TEST_MOVE_RENAME"
>> +	else
>> +		ktap_test_fail "$TEST_MOVE_RENAME"
>> +	fi
>> +else
>> +	ktap_test_fail "$TEST_MOVE_RENAME"
>> +fi
>> +cleanup_devs
>> +
>> +if ! rdma_supports_combined_move_rename; then
>> +	ktap_test_skip "$TEST_COMBINED_MOVE_RENAME"
>> +elif ! setup_devs; then
>> +	ktap_test_fail "$TEST_COMBINED_MOVE_RENAME"
>> +elif rdma dev set "$RXE_A" netns "$NS2" name "$RXE_NEW"; then
>> +	if rdma_dev_exists "$NS2" "$RXE_NEW" &&
>> +	   ! rdma_dev_exists "" "$RXE_A"; then
>> +		ktap_test_pass "$TEST_COMBINED_MOVE_RENAME"
>> +	else
>> +		ktap_test_fail "$TEST_COMBINED_MOVE_RENAME"
>> +	fi
>> +else
>> +	ktap_test_fail "$TEST_COMBINED_MOVE_RENAME"
>> +fi
>> +cleanup_devs
>> +
>> +if ! setup_devs; then
>> +	ktap_test_fail "$TEST_SAME_NETNS_DUP_RENAME"
>> +elif rdma dev set "$RXE_A" name "$RXE_SAME" &&
>> +     rdma dev set "$RXE_B" name "$RXE_NEW"; then
>> +	if rdma dev set "$RXE_A" name "$RXE_NEW" >/dev/null 2>&1; then
>> +		ktap_test_fail "$TEST_SAME_NETNS_DUP_RENAME"
>> +	elif rdma_dev_exists "" "$RXE_SAME" &&
>> +	     rdma_dev_exists "" "$RXE_NEW"; then
>> +		ktap_test_pass "$TEST_SAME_NETNS_DUP_RENAME"
>> +	else
>> +		ktap_test_fail "$TEST_SAME_NETNS_DUP_RENAME"
>> +	fi
>> +else
>> +	ktap_test_fail "$TEST_SAME_NETNS_DUP_RENAME"
>> +fi
>> +cleanup_devs
>> +
>> +if ! setup_devs; then
>> +	ktap_test_fail "$TEST_TEARDOWN_RETURN"
>> +elif ! rdma dev set "$RXE_A" name "$RXE_SAME" ||
>> +     ! rdma dev set "$RXE_B" netns "$NS2" ||
>> +     ! rdma_ns "$NS2" dev set "$RXE_B" name "$RXE_SAME" ||
>> +     ! rdma_dev_exists "$NS2" "$RXE_SAME"; then
>> +	ktap_test_fail "$TEST_TEARDOWN_RETURN"
>> +else
>> +	ip netns del "$NS2"
>> +	returned=$(wait_rdma_dev_on_netdev "$DUMMY_B")
>> +	ktap_print_msg "device returned to init_net as '${returned:-<missing>}'"
>> +	if rdma_dev_exists "" "$RXE_SAME" &&
>> +	   [ -n "$returned" ] &&
>> +	   [ "$returned" != "$RXE_SAME" ] &&
>> +	   [ "${returned#ibdev}" != "$returned" ]; then
>> +		ktap_test_pass "$TEST_TEARDOWN_RETURN"
>> +	else
>> +		ktap_test_fail "$TEST_TEARDOWN_RETURN"
>> +	fi
>> +fi
>> +cleanup_devs
>> +
>> +ktap_finished
>
