Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795671682;
	b=pNVSfRraZz0JpTLiAuT6AQS3d4SP0YTfAb8x7GkABDG4Opx0O/Ei5982Td7VaIAAaXJK
	 nj7FeLPt29B52FUrv7fCbT7P50lsaj6ulJjVAAvk87TMFUKhz7yXZctxID14mb9vH64kX
	 m+9S+7aKrCzNnh6PucClQyLAAPDJZTZkJ5Z/fazDsI0fQx7J9pMY2nPYyTXg2JuYkh4fa
	 iHEyxSplW4fFe14igqKpOsr8UQS+aIna39EpIpDEefmSQkgALQNe7QA49sEHQZtAcJocr
	 aU+y1CaVotUCGtlY1fTEW4aTf8r4nBoEM6BOdGTQu4f95QqA3e6f/NZ8HT7gtCDGVNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795671682;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:Message-ID:
	 In-Reply-To:References:From:Subject:To:Cc:MIME-Version:Content-Type:
	 Content-Disposition:User-Agent;
	bh=aXkURdkuBYQdWWdqWRepiJVQhkxYqOLTa2nNf0PXwjc=;
	b=cxtxgmqjfiLCToNq0ePDEwwEUiwENvn4k6r09skFodPSZoennm8SVWDc4ngdBejj8m2t
	 CajxNThzOAHIdVw5HkXzpJDH2G/k5pEqTxPLm3BVMJl9FU/NaoCnHfEjy+VEuNjvbj/o7
	 TAhcBUtPIOiuNdbMRVUBhohJeohptPGF3FATaeu3JrPAiwQ8XWcWcplMIPryTyOUGELNn
	 gF0CpgcXqjmstSWAoheu51+kLTgXRReBFPFit/8Li7p+N5I3l0nM6R9VBg5Vmqj2WyPjj
	 GGmnuHfmQU5Gh26mEA3bK7F93mmAmkjxvgtmSQH/kB/3bj9F/w6LpaYyYp9vp5gcIkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=S2EbV8Cj;
	arc=none smtp.remote-ip=209.85.128.180
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14763606A332
	for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 05:41:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14763606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=S2EbV8Cj
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-8b4eab91bcaso36273407b3.2
        for <cgroups@vger.kernel.org>; Wed, 25 Nov 2026 21:41:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1795671681; x=1796276481; darn=vger.kernel.org;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:references:in-reply-to:message-id:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=aXkURdkuBYQdWWdqWRepiJVQhkxYqOLTa2nNf0PXwjc=;
        b=S2EbV8Cjlbyw9JbXy2mD1LeCrIf1F5GFpCfgRh9I3HWQzDnGKDT0ldYUT8UNEtOvVe
         VK20hs/Qd6g8hf1AasqCC9MLdMqzXjn3Pg5sCdd0Ylo2bp//1RxAq9DzZXZEgqO49pcd
         dKnA2CQqn0HX0X+AqmfHFdqAYawtTEexYPBBw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795671681; x=1796276481;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:references:in-reply-to:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aXkURdkuBYQdWWdqWRepiJVQhkxYqOLTa2nNf0PXwjc=;
        b=LQ52XWn66fR+ocVQJa451kQdag9NLUXPNvBp5zXpbQc/TW36nAYl5JouwRNqXrCnYG
         mgQkV6K8BuGbbHHyISv+4cNJlpun8bSsDoYeMutS5G7y8g/YQiBtMrlTboz7SnHUzfry
         eTYyxR02c4E0i1Q2oepLITdLUhIlWak5b3Ogik82gTW1cUfhYzwjLbF+QPy2cdUH/cLv
         4H3+6RG2AKLMbBunsdPexUWj8C8sXZauJzIzM7NeRjQ3rLBIdskq0OAhAkLFU4sM/qHJ
         V5/AgKr/FBSfI0ztdn84XhP63jc7LRGt9qTGDLhPhqX5Yw2t7Ic2yVilYJc6BJIb/7VJ
         t9pQ==
X-Gm-Message-State: APuU4Z9Y+CpvFORZnHBxll+uYf721e6W9PNb1uzrdtXIcVgeSG29PyP9
	gUr7QIdBerWAAb0I6/gISV1lD7pI8OEBcOo1uuT9T4V/rF9Y+cr27kOuofT7fEbnXVE=
X-Gm-Gg: AZFdTZcD6UcgX5sxZ+k57+G83XzNwWEi7MAusOmr3K6Bprz5jW9E9qI+PngkVmwakp+
	1MIJXjIy9/29mlINnwgyLuTAuAd3jXYHBv7rDQYz+nYvynn9ep1E+QiICi8ctt/mYOecMCSKLzc
	QfNYQTrejTGZPgmwEM0H1ODg8oZofYYbEqUic5shX7Ps1gK92yM/y/lorNi3GzEIoM8wTsIM0q2
	jDEfmac0sYbAIUUJJwgXzX28GoUQ2UwQascmh1o/Lh0Yw4BeTZiHfOywo/T7dxRJxI2gZgMhVVy
	NVttvEbRVJjQCprfAJLdFV+zsaFOKaYOm8a6p7EWB8oEadruCmQMTEaprncJi5EiFbuVHWK9PUx
	STmuE5sctovLPXRFeOqAT8NIawrBVJymS9e+q6El+n2yuwoaur5K2+XVJWYSjlvsxUPSWfYZcty
	AY81P+J8esrkzKqNemUdxg/gySb649qGfMqBvQjc4YcREFJB38LxhnwWyp94Pj4OvjlRYMvb9CP
	4NCD47v8Kbc0qa5uvKDJdNTHcFF5Pp/xZa16wdlIKsGatYlKqTYuAUQxsJTKdCHQp1KPoeeK4K0
	LZPlNfedGvm9hMJzE67y4Z8TWuTJZnntcoPUhJtCWQpTag25Q4CB2Zayp0foE+4hnZ/LlFnwC27
	t8AR2CMoRh5MjUzrjSG5aFLGtS0UaykuJi79SoJL8ZRzqjoGTvXbIZIRdeOvOoUe4Pg9w/q9KUf
	cntCeBn5puX7sehC3xdYCse87x0hF7geg2Bqsf1v1LMB1UeV00i+Bmy7HB14p8bJ+oEDBDpcTbo
	juICtFjhRIdWoIyfWzzSQs=
X-Received: by 2002:a05:690c:799:b0:8b4:d584:6165 with SMTP id 00721157ae682-8b52043ff55mr84924517b3.21.1795671681052;
        Wed, 25 Nov 2026 21:41:21 -0800 (PST)
Received: from [172.20.0.2] (c-73-207-185-9.hsd1.ga.comcast.net. [73.207.185.9])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b52030ff10sm79663677b3.33.2026.11.25.21.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 21:41:20 -0800 (PST)
Date: Wed, 25 Nov 2026 21:41:18 -0800
Message-ID: <dbdeffef59486589a893e2724546724b58443757.1795671629.git.chris@chrisdown.name>
In-Reply-To: <cover.1795671629.git.chris@chrisdown.name>
References: <cover.1795671629.git.chris@chrisdown.name>
From: Chris Down <chris@chrisdown.name>
Subject: [PATCH v3 2/2] selftests/cgroup: Test parsing of long fractions in
 cpu.uclamp.min
To: tj@kernel.org,
    hannes@cmpxchg.org,
    mkoutny@suse.com,
    shakeel.butt@linux.dev
Cc: cgroups@vger.kernel.org,
    linux-kernel@vger.kernel.org
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Add a test to test_cpu that writes values to cpu.uclamp.min and reads
them back, checking that they are rounded to two decimal places and
that malformed or out of range values are rejected.

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 tools/testing/selftests/cgroup/config     |  4 ++
 tools/testing/selftests/cgroup/test_cpu.c | 71 +++++++++++++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/tools/testing/selftests/cgroup/config b/tools/testing/selftests/cgroup/config
index 39f979690dd3..c8b2c95a186e 100644
--- a/tools/testing/selftests/cgroup/config
+++ b/tools/testing/selftests/cgroup/config
@@ -2,5 +2,9 @@ CONFIG_CGROUPS=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_SCHED=y
+CONFIG_CPU_FREQ=y
+CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y
 CONFIG_MEMCG=y
 CONFIG_PAGE_COUNTER=y
+CONFIG_UCLAMP_TASK=y
+CONFIG_UCLAMP_TASK_GROUP=y
diff --git a/tools/testing/selftests/cgroup/test_cpu.c b/tools/testing/selftests/cgroup/test_cpu.c
index 3456e3e988c6..369d4930c1f4 100644
--- a/tools/testing/selftests/cgroup/test_cpu.c
+++ b/tools/testing/selftests/cgroup/test_cpu.c
@@ -809,6 +809,76 @@ cleanup:
 	return ret;
 }
 
+static int test_cpucg_uclamp_parse(const char *root)
+{
+	static const struct {
+		char *input;
+		char *expected;	/* NULL if the write must fail */
+	} cases[] = {
+		{ "12.34", "12.34\n" },
+		{ "50", "50.00\n" },
+		{ "0.125", "0.13\n" },
+		{ "0.999", "1.00\n" },
+		{ "100.01", NULL },
+		{ "abc", NULL },
+		{ "0.5000000000000", "0.50\n" },
+		{ "0.123456789012", "0.12\n" },
+		{ "0.99999999999999999999", "1.00\n" },
+		{ "0.0000000000000000000000000000000000", "0.00\n" },
+	};
+	int ret = KSFT_FAIL;
+	char buf[64];
+	char *cpucg;
+	int i, err;
+
+	cpucg = cg_name(root, "cpucg_test");
+	if (!cpucg)
+		goto cleanup;
+
+	if (cg_create(cpucg))
+		goto cleanup;
+
+	if (cg_read(cpucg, "cpu.uclamp.min", buf, sizeof(buf))) {
+		ret = KSFT_SKIP;
+		goto cleanup;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(cases); i++) {
+		err = cg_write(cpucg, "cpu.uclamp.min", cases[i].input);
+
+		if (!cases[i].expected) {
+			if (!err) {
+				ksft_print_msg("%s was accepted\n", cases[i].input);
+				goto cleanup;
+			}
+			continue;
+		}
+
+		if (err) {
+			ksft_print_msg("%s was rejected: %s\n", cases[i].input,
+				       strerror(-err));
+			goto cleanup;
+		}
+
+		if (cg_read(cpucg, "cpu.uclamp.min", buf, sizeof(buf)))
+			goto cleanup;
+
+		if (strcmp(buf, cases[i].expected)) {
+			ksft_print_msg("%s reads back as %s", cases[i].input,
+				       buf);
+			goto cleanup;
+		}
+	}
+
+	ret = KSFT_PASS;
+
+cleanup:
+	cg_destroy(cpucg);
+	free(cpucg);
+
+	return ret;
+}
+
 #define T(x) { x, #x }
 struct cpucg_test {
 	int (*fn)(const char *root);
@@ -823,6 +893,7 @@ struct cpucg_test {
 	T(test_cpucg_nested_weight_underprovisioned),
 	T(test_cpucg_max),
 	T(test_cpucg_max_nested),
+	T(test_cpucg_uclamp_parse),
 };
 #undef T
 
-- 
2.56.1

