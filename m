Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794411015;
	b=MmkrbGVgD8XycYjUqgFloT8A4NQQEsBQqKRJ1cCFCNscmX+y+/JBjNjq+1unepjSGe8m
	 JnbsxQIuhXUIr8P+E81uqKQzu22/Ai0ceGMRr6WooIR6OzbG3C8vtja070DQukKgYBP4z
	 Oya2UAUyQVYhcXZjK4mFmPiq6VLTFybjuJ4qWZOCWX8Csj/qBz1m1WOEzw5OSa4FZ3UaQ
	 lyTOk1qwBS3T5jsIoQmQqHQtaml4I+Uz/YeCSVEBAhaHYD31hrMY4UX0sFEkpst6txHp5
	 8+GmsQCnSeXfSGUv2v4p8MxqGZ6ChgeRY1cx4nwG9pHPTUx1P1G2CVJ+GXnH5nP2V/A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794411015;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:MIME-Version:Received:From:Date:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=dX6hFmZdS7Gg8cUOEwScRtDpzCl55I9CPUiy1XCzenQ=;
	b=SuQAt+WQbXVjgAPyz78iL4qnXqM/oz9Y65hC6F4VRinCIOTg+PANhYDyXzg+lTqIO8ND
	 E+F/t7Ffl/bYS0aqEtVZtTMnm5A2vgktgcvanQnAK5XWdkup3YDXrsF6vJUZTYh2PxW8N
	 KtjRmG0lUhRtCGNQEmXdhnWo4W+B5ukndxsmRZAOiRS5HRxEXVIfbUxRl50n6A2wu60w1
	 HXcYU7KVtL1pd3+RbPNz8aLLokGbWD+O4FOwc7ImKQmUlzuKtB98Go1lbOeRomfRL+qtx
	 zEOOkzLeG+WNXGDovWbZvPKVX8ieVZwm+0BuJjhhnA7DEy5ZXk2ehd/DBibpYchN5/w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uPvURM2E;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.45
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33E3606A324
	for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 15:30:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C33E3606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uPvURM2E
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-4ad5b52f0a7so2073963fac.1
        for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 07:30:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794411013; cv=none;
        d=google.com; s=arc-20260327;
        b=ZNTzoom3HeyyGoc9EvHoqQ6q3EIhO8Jd0wfSChlbwP0LURuc9rfD/50mOB7HP+PvU5
         /L8+D+L8FR3DXMHZdpBipt//e+wWOOQ+HvqSNSXjsS0vkwkxOf/hb33pjokppU/waLNi
         p4Blu+YpZjnliDaIdG1kqu6we9WugMu9gh+l7vvTCBCYCSwppXoy/hNOkWf2kISHx8IX
         4cvL4rICmjqUdz8evtzv2Div9eUw8spaFGr277NEiDSBVklEuZT11tnj55Dj7PZ7Zdu5
         a2RufONa4ZElczne0FTBhSWzVqrZYhp+m2MJb/lWLYZ/rn+7l0ILH1l4P/hA5QSlJubJ
         Lv4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=dX6hFmZdS7Gg8cUOEwScRtDpzCl55I9CPUiy1XCzenQ=;
        fh=Lyu4fEww7ZOSS7aVdq3Bf1Shs4NC2RP6W+Rksnf0O14=;
        b=kE7WK8Kz8LEm3zkj5C5oekLsUuZUTOXtxjoGTlTs3onNhk41RZTmA5fS5n+UZzMRvD
         Syf11lz5unPJMZGkgFkI7lDCZO77VdiY8tzV9aGeFs2JiCV1Y6PIWd+jIs96G/smFPc0
         qxoS5qnSXDc5YsEJBsv2aVmpVKdX8IPsSDUzWmtPLe4TWHzB0iXId0YZ4cE5rNIPvqlq
         Q7vOouMNvE4MqcrO+sQOZRPuytJyKg3MN6wHynPjm9+yo5nVJhCJtjTWCw41kc9Hgubv
         DFhludvcK5Mrcu/Ap8ACeTXAcV0sBcIRaIltuHKe+LlrQ+TIEyI0koaqIpa/5o4Luhpc
         6E5g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794411013; x=1795015813; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dX6hFmZdS7Gg8cUOEwScRtDpzCl55I9CPUiy1XCzenQ=;
        b=uPvURM2EQFxOyq7hd1v1FGg3JL8ari51ttuca9gK060yWtnx9L3TA4MmDMiMSo3rZL
         WFD1G4lvnZVNa2HuDBUrZq6ik1T7dI675MvF2kIPB1AjR6o0pwQmedDHWg3g6F9g1Nol
         dRGdVeA0htRy/F1dI2UaxY15rtGq2ijkVikVT/YdY6PSa4/479UdwKOS7LmkZ4MHega3
         5aLRD/SwptUczegbPOjkbigMsTrzCLEifDGFYwYEslf48xjKM1dSlqpCziK2HWHO1jGM
         4Okcd4LKVRA2WaqFtRu9agY3VafW7MFh7Vj4ZW5tUkkucfzNCFpJbG3hrwMAEht90mgO
         udGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794411013; x=1795015813;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=dX6hFmZdS7Gg8cUOEwScRtDpzCl55I9CPUiy1XCzenQ=;
        b=p9voFxx30V9xgVjtBHxkxnz4Xf3mBIgjSj18+FVRDp+MGrue7kQ8kZQTZBlmTznGvJ
         nu8YC8W2WdplMaCWp+YO8qONUomVhn0tM3nb662wX4UIRjZGIDG64A8c93/f4Lw+my/n
         7xVolj/s3pEnv9Wle2Iq/8Ht9XsRcQcmlQFWunm64RijGKXuMhCEZ6xvLYLlw3eRY2eM
         Y0vGImDm4gJtuiIhCuO4TTCAHl3dRmeHDG62ikYmcO1/qxf2SFhG1QlLtTeHEqvJDpjM
         5pLoRODLVozKDXHJOv7PZLwLTLcVch1fo1k0BG8sbW02xUPscHgxOKTOgneMzw7Ufg1G
         i0/Q==
X-Forwarded-Encrypted: i=1; AL+hErEgYhgJNGyBXXfYC2LdIclIp5zbE+E9VpgK03Wm3oKymm8rUVjIsAnbrWpNCarl4fEl+fWNskPE@vger.kernel.org
X-Gm-Message-State: APuU4Z+2ZKx2mKY0h5wZi49e51lFlEe46g0ckE53mEy91Hvg9ubuYYBv
	eyrrx6BH22SAhIe/aWLyWIWP7enVDfP2ssiRFcHhhxAVKd4Faj8itdW1VMfwFsz74YnzxfDEhLw
	7fajBSdmDWXNvqlR3sna+9Werh08Ei98OIlQn
X-Gm-Gg: AYBFou3tpYUbaRBtoA1tvfiSDxpT7TIWyGgqjgJ6eDoFlXcm/LhQ4y+72z0XX9h26gR
	ODQRIMFsJzXkXLeqK/gEIncCV+ipTZpm8vbNqPZg7ZSaM3Yt1UoSU7LSf3crskq4WPchlFy5qGo
	k1wDWIflYrsG6iS6SBFDpli/XF06HzvoIuLliE7c72J/jLHdBxbjOkjM5eHRd1/TzcSB5BSrtum
	XS1C3ru4Go8BbygL+tOe3zqHhhWsA6iJ8ZN3b4+roIQeyb/vuHaOvG+Vcjqt3lx0ZCdhi0ZNb5R
	uVlf06ETQ32onzkrsmuglnAMLCogsI92bWgVdgUA/CRcTXfBRBQa6x3HUcObEIFho4nW3Dpq7Ey
	H0ytcpKlsbsVDIiy2zKYIIECQzxiojd4v8uI+VYVOQCf6fs/oQGICMB9oyE5ODRuxiEsbpzSper
	727lurAA0UmwnOfZPMpIXmZN0=
X-Received: by 2002:a05:6870:c112:b0:483:cb42:3979 with SMTP id
 586e51a60fabf-4ae46a42831mr2381441fac.17.1794411012764; Wed, 11 Nov 2026
 07:30:12 -0800 (PST)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 11 Nov 2026 10:30:12 -0500
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 11 Nov 2026 10:30:03 -0500
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Received: from 77377267392	named unknown	by gmailapi.google.com	with HTTPREST;
 Wed, 11 Nov 2026 07:29:09 -0800
From: Kanishk Singh <kanishk2607@gmail.com>
Date: Wed, 11 Nov 2026 10:30:12 -0500
X-Gm-Features: AclHuK8RPhVT8h4SoQ-sBKh-mRKS0ugcCHlJN_3RKGREeGlNi0WOGPnSLTYbW0U
Message-ID: <CAC=pywoHKV1157BrUsew_E4zriGMx3Gh8B2o_rR24c1yfZ1V0w@mail.gmail.com>
Subject: [PATCH] selftests/cgroup: Decode waitid results correctly in clone_reap
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

clone_reap() applies the waitpid() status macros to waitid()'s
si_status. Unlike waitpid()'s encoded status, si_status already holds
the exit code or signal number, and si_code identifies the event.

For example, a child exiting with status 128 is reported as successful,
while a child exiting with status 42 produces -1 rather than 42. Stop
and continuation events are also rejected. With WNOHANG, a live child
can be reported as having exited successfully because the zeroed
si_status passes WIFEXITED().

Check si_code for the requested event and return si_status directly
for exit and stop events. Accept CLD_TRAPPED along with CLD_STOPPED,
as both correspond to stopped children.

Fixes: 27eaaaf3b30e ("selftests/cgroup: add tests for cloning into cgroups")
Signed-off-by: Kanishk Singh <kanishk2607@gmail.com>
---
This patch was prepared with ChatGPT/Codex assistance for code inspection,
implementation, commit-message drafting, and local testing. The task was to
find and reproduce a cgroup selftest helper bug, make a focused fix, and
verify the result against the original helper.

Testing: the cgroup selftest programs build successfully. A standalone
reproducer linked against cgroup_util.c passes all 256 exit codes, SIGSTOP,
SIGCONT, SIGKILL, WNOHANG, ECHILD, and an interrupted wait after this change.
The original helper fails 255 of the 256 exit-code comparisons, the stop
and continuation checks, the WNOHANG check, and the interrupted-wait
exit-code check. No full cgroup runtime suite was run: the environment has
no cgroup mount. A ptrace stop check was skipped because PTRACE_TRACEME
was unavailable.

 tools/testing/selftests/cgroup/lib/cgroup_util.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/cgroup/lib/cgroup_util.c
b/tools/testing/selftests/cgroup/lib/cgroup_util.c
index 823b0312b..4915d80ed 100644
--- a/tools/testing/selftests/cgroup/lib/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/lib/cgroup_util.c
@@ -508,17 +508,17 @@ int clone_reap(pid_t pid, int options)
 	}

 	if (options & WEXITED) {
-		if (WIFEXITED(info.si_status))
-			return WEXITSTATUS(info.si_status);
+		if (info.si_code == CLD_EXITED)
+			return info.si_status;
 	}

 	if (options & WSTOPPED) {
-		if (WIFSTOPPED(info.si_status))
-			return WSTOPSIG(info.si_status);
+		if (info.si_code == CLD_STOPPED || info.si_code == CLD_TRAPPED)
+			return info.si_status;
 	}

 	if (options & WCONTINUED) {
-		if (WIFCONTINUED(info.si_status))
+		if (info.si_code == CLD_CONTINUED)
 			return 0;
 	}


base-commit: 067c5c24cef23d913b67eaaf71ae67e7169a6620
-- 
2.52.0
