Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795676414;
	b=pyki/Nljcy+xdUkPVfrCASEtN9B2lKUaa3AXLNHxP2qlwaBohdRf7krl6dqhfaEWe76r
	 ajures4fuAavKwcFKPCRpxQIdBCWRVeV5S9Kr4kKcIksrvnbQv/4chYX3nu9flSTeyoWS
	 ofdJ/pad76UFag20GJzIQLFNMot99OXJ4u98an+/E8l5A/T+1qavr7hF4sVyODutxT6tR
	 mWKxF3lGwFi7sNErhDUt1ukGPr4akELtZArA7ZAnvmc8Rqc6VBe6FK9lvMd2U1G0mxb3K
	 Y58tmzCdPYu6MtQw7l9y3npy2LbuosVuhL3PlVN7y1dx1731Tmh+T3E7bcpVg7+LOyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795676414;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=wy2ZfDuxZ+L0rGiTO2Hr2gxsNqdlmXKGnqLfSzRtbhg=;
	b=cMe5/vtV13QA9WMBT1gDf+Xzz5bL6TUc3M+IeuyrpY3pvy5BwphG6k340GpfgOLVtUbq
	 semvemXOv6P8A0IHCdT049jp7LXQkbT8YJQpmAADiNe2rTItUQx5p01MH2/sB2ynNXJOU
	 OVFH1jn1rU1wmrH2kJpYrs9Ao2W4qAPs/5XRCYZqwyP4gOQaOSCn930IvwP4h9dMgGnbc
	 6RYcDFn8I3BnXgBbLmP1nyeYQK+JbTxyZeApUZzLfiR4+k/Y1Y5JKzQK+Xm3VdFw0nAM8
	 nITPAvnddT9yND0ziZNlOhsiYjTR2NV8fref1ksXb5rI0hlqYH8gAfC317jjh0PoI1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eIqBQMhu;
	arc=none smtp.remote-ip=209.85.216.54
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25D4606A326
	for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 07:00:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C25D4606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eIqBQMhu
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3b41e627cadso4185981a91.1
        for <cgroups@vger.kernel.org>; Wed, 25 Nov 2026 23:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795676404; x=1796281204; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wy2ZfDuxZ+L0rGiTO2Hr2gxsNqdlmXKGnqLfSzRtbhg=;
        b=eIqBQMhupYMGiKV/6qlv4Cq7NXKn1OMb9eHtz72hxZv8xTGGeTQAZLp1YqYfVcvhlb
         GL1wxi88tFxuG/VdUhYm87woHu8EwSvU5wLvQTSezbb/Qzp9Hxb/YXGxdYQh4D159BzV
         AaCGZEwGJfzhz7Wx602e8f1lpTSRboxCYR+rwyogwv0JbuZVaHEqwhL73EkEUlqEVdU5
         iyXeDmfYWcDcdsIzUifNY0G46DEA2cYbmsa2Bvxd7MEN7q0G8KTWcHH0/c2mJtr0lCNV
         XHcNx2vRV9mL+f7UjHLAovSDZZx/UHcoVoBPvTEk93YdNSawrymTVWCKXQmvGoAzxqtt
         OwTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795676404; x=1796281204;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wy2ZfDuxZ+L0rGiTO2Hr2gxsNqdlmXKGnqLfSzRtbhg=;
        b=Idqyw8+nUL8WDgRAlxPqJlxrgsbHODfLaR5sXVGsG6BBx0DPdN0zXrhe702CvP4EWx
         XbLYGQg5LJej/tKtSgoyAWqiDW6TSEXD8dks8G/tiAGq5egbeNjtht7W3H2Lv13zk5qq
         /BE1wfCWlh4Kvvvu2AaKOXW/iVXqRrqtuvhgV4vgxEuM7nOnGXKcJ54hUs/cKeep2fjy
         kaGpPBw1wWxiXfvGJmPKoeIX2Mdl3N9RMUiv+OWSEWjhezMZVLQSLI/u3h6JcEtzt8N3
         z3KTMFwMWt8xqbJqoheLoO5wRObTL1SlGOKJHLA7r0lyp//fUIC1ouvI1iYjVWuFcknJ
         oDCw==
X-Gm-Message-State: APuU4Z/Gt6ViH0SoNy/3uBqLifVYUKJJP9ga2tNiwDZ0iXIPUbzuJ8CJ
	NuedDqzygLVp72mY8J5+CL8nD0LS6t6ZeDD3dKvmhY94LefzDLYgorSn
X-Gm-Gg: AZFdTZdRrSSIUXJpmwsOfNJEAhwsRgrxga1MeWpw2AysbaAD1UMsa9r837D3FkbNc9+
	jcSbDUIHU7+IBc6V7HceU1maoKhBdpn22m5gB9LjP3IwukVc0kp2IT5oHmchZ4YykT4UtHmyZQI
	fbk+bZAOl75kYiJv6qQR1CPJYzwT/BrGXkcA1o2vHvcncXZShr2+zSZjzDpL+ERb305dtmbgy7i
	ruXZZRmbEEif1e2urzImLtL/ZEZHby6wEw/zRB+BfOkgXENsXDawGrAw6ykNOA05FxNgDGqO3B7
	a0TM0plfx/AtWOIOVWH24ONQX43FV+7CNDFZhzvM+oVsWhW7kfpEV96oA5dH8hqrPdbyfN5fQCZ
	BF77ibKa74jNesuCEnE/YqSE2Fh02BZnVfQsuUcrWkBHxXpIWGh5KQyikZeC9FYNrdBGqvOKmAw
	kBECGFsCtYE9iACZGyBSFdZJyhUSzKF+Eyfl3WGA0Lg+XYdgyr3lIEzmzQHLv+OdeILoldh/T4b
	lOBKBojcEPH/XbBAYZRolAzcAfTcDKcFe7LaVEMXjJbAVjHYkZyWcxUvcZGhirGPjInyDOKMQgQ
	ntB6nIxW70MFwM08Bovahb1Vd4xK3R2qAg2NzgLvRQv7d3Z3Nubxmj16SxXoTHwgK0TGrEi1pk0
	Bc7cr3AFUpARqGWEIEMqb
X-Received: by 2002:a17:90b:4ec5:b0:3b3:adea:4b04 with SMTP id 98e67ed59e1d1-3b41c948521mr18210202a91.36.1795676403878;
        Wed, 25 Nov 2026 23:00:03 -0800 (PST)
Received: from LDYT9Q2G2M.pvgl.sap.corp ([2a09:bac5:cad0:1caa::2db:4c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405ecbd0bsm34150819a91.15.2026.11.25.23.00.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 25 Nov 2026 23:00:03 -0800 (PST)
From: Zhiqi Zhang <zhiqizhangg@gmail.com>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhiqi Zhang <zhiqizhangg@gmail.com>
Subject: [PATCH] cgroup: Preserve sign for fractional input
Date: Thu, 26 Nov 2026 14:59:58 +0800
Message-ID: <20261126065958.89207-1-zhiqizhangg@gmail.com>
X-Mailer: git-send-email 2.54.0
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

cgroup_parse_float() parses the whole and fractional parts separately with
sscanf(). The sign is only carried by the whole part, so inputs whose
whole part is zero, such as "-0.5", are composed as positive values.
Inputs such as "-1.5" are also composed as -0.5.

Callers such as cpu.uclamp.* and blk-iocost reject negative values
after parsing. With this behavior, negative fractional input can bypass
those checks and be accepted as a positive value.

Remember whether the input has a leading minus sign and subtract the
fractional part when composing a negative value.

Fixes: a5e112e6424a ("cgroup: add cgroup_parse_float()")
Signed-off-by: Zhiqi Zhang <zhiqizhangg@gmail.com>
---
AI contribution disclosure:
I found this bug. Codex modified the code, and I reviewed the change.

Validation:
- Built in a Linux container after applying the patch to a fresh shallow
  clone from https://github.com/torvalds/linux.git:
  make O=/tmp/kbuild ARCH=arm64 defconfig
  make O=/tmp/kbuild ARCH=arm64 W=1 kernel/cgroup/cgroup.o
- scripts/checkpatch.pl --strict: clean

Duplicate checks:
- Checked torvalds/linux commit, PR, and code search for cgroup_parse_float
  negative, -0.5, and sign-preservation fixes.
- Checked linux-next master and tj/cgroup master; both still compose the
  fractional part as positive.

 kernel/cgroup/cgroup.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index b3657e72db..bf7c3267db 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -7540,6 +7540,7 @@ static u64 power_of_ten(int power)
  */
 int cgroup_parse_float(const char *input, unsigned dec_shift, s64 *v)
 {
+	bool negative = *skip_spaces(input) == '-';
 	s64 whole, frac = 0;
 	int fstart = 0, fend = 0, flen;
 
@@ -7554,7 +7555,11 @@ int cgroup_parse_float(const char *input, unsigned dec_shift, s64 *v)
 	else
 		frac = DIV_ROUND_CLOSEST_ULL(frac, power_of_ten(flen - dec_shift));
 
-	*v = whole * power_of_ten(dec_shift) + frac;
+	if (whole < 0 || negative)
+		*v = whole * power_of_ten(dec_shift) - frac;
+	else
+		*v = whole * power_of_ten(dec_shift) + frac;
+
 	return 0;
 }
 
-- 
2.54.0 (Apple Git-157)

