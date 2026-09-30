Received: from mail-pj2-f39.google.com (mail-pj2-f39.google.com [74.125.227.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116CE344DB7
	for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 06:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790748221; cv=none; b=KvQhEWc34Setop3qOO0NkPbsneYuIglnBfysZy/kjk3IlsDrEH78JwxPnMPvvQgL4q6p3KGtiUE5iXIPjjyXlz9hyRyUjwBP8a+IFtKdl4wFnK5WxgafWQh63VIao4bVgZqdiH3EybOGnHlAryx2iH1Q73Oz0gJKBarCjBbF1AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790748221; c=relaxed/simple;
	bh=UARglUKAvqBq0oxbnGvbQklaKOcZCNUwsD/ukl9WrKs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SGp8NORfpCti3hH0OfyVcqOZGkSmk1oBym/kewlE0nNngjLZDdNQBch/tgh1BIYmP3pOipznksRRexDXwXIQ644Fb5DIQl3uxJy0xAdC+nOqNqpMPf8MpYnnGjoUrUvXTNM7Yy/ew+9dwLn/PY8RBaixoh9/TcKA16rMoQGg3CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UL08RL5J; arc=none smtp.client-ip=74.125.227.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UL08RL5J"
Received: by mail-pj2-f39.google.com with SMTP id d9443c01a7336-2e2d42b972bso7312515ad.3
        for <cgroups@vger.kernel.org>; Tue, 29 Sep 2026 23:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790748219; x=1791353019; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rnB9FKIKFzNu1Po5I3Gn7uovAY3H37YHyKqyanOeRws=;
        b=UL08RL5Jh3DrD968l86xLqCF+DqjZAj0uqyWfUYyBjs9yXitkSB4FL6Wtg9ZuERqVB
         FcIKjar3y7l/ZEbt/asvO2M6xiE5kihLoTFLqQJjY/ix7WJI58pQ26d9L2an3Pwzl/ft
         y1FarPqEn+Xwd1kJjqlo5m/vS2A+30tZO2APCFV3Wp3yyOD2gmvCPkJmniMUuDOCVIlB
         6KLfuNQTkz+dYzWFjJPZas5EaU2Uq4/CRWzBV0lJombzf5MKA/oq3EtapUiAqEusUvqb
         NSQ3naEp9ldMyPiMAr5M6KO4cLs4/ZKUHuPtLmNVpILEtKDztXwxM1KjYBkzyVtCtiN7
         oWVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790748219; x=1791353019;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rnB9FKIKFzNu1Po5I3Gn7uovAY3H37YHyKqyanOeRws=;
        b=iNNOD1I6niyZw6HpsPyR1+6SCXU0w56c0HIViCwRNhoHw7qgKIvnjd8AxfWcukdy/j
         JenQ5FCrMXb/Q/xqON27opaKG05SkVqco7D2UtXlQtk6a+Fr0ajCRuotyGLIcwkyd+A7
         3P8hQb/pVq8vH50O8rTAwxPqIo5T8UqOSK4VPiVCaJKPeqFJdzQ2uq0/RKtuuX+aB4LL
         uczfPmB9bxG5aDkYViOmcdW6yunLGX7XbTQ2Lyc8G/AL/JqVXfd8biCEpYSJrcydmA5Y
         m3re48+UxwHG+Qj0uWojvwFAojHGbtrauJnZbWCnXSMFZjjn3XURfSJmov32JitnJz7E
         B+Yg==
X-Forwarded-Encrypted: i=1; AKwUvBzplme4IPINu1loqKufgRabHveCyQ1IyjtsqLOuDj+NKhZNSYWfoNbzIS3AewydJvWBwCfP0g7v@vger.kernel.org
X-Gm-Message-State: AFq9FYK0rsjFjUQM5aKh2u3JaU3NjQtc51bFJREHzEhdmFdUqKn9qLt8
	wa/BJLsoqIyZAowThjYwbaQpZq9qGs9kmtzuKGuUARNGdn3kr5EG4L0x
X-Gm-Gg: AYBFou2DGY2qWZyYSiDy/qbfFHgV649hdLUliDb/uOmR3HmoQ2NwPZoyijDXBV4WLVg
	HzzPwPuEgsB448J6ls8kYEe0pfQMCNW4a5imCUrZ8wxmBKd8EIJHi/ntnCr+xqUa0AV3BCJp/ya
	JE5aSwR9mpXN4IIrh6KM1Rf0j290w5Nm1TlSjDNEgUviiSC55U4kWxn/Bcj3ZwSk2pewce+o3z2
	Q66TVXBqbgNROYPIjfORpb2HUIpFlZmbVlt3uJ6Q+IneTq5HmeKqXche0136KNv3E7yAZsIpscL
	PfbInMqaEel0vqUhVKHfDTQdqmWQP6WpwRa2Rk4LVpkAz5yqicQWEAg3aVFwOI4Iz8fILD+XmLl
	V171OkhtPe0syPJq06PacYtDDUCKQD4q7Z8c/5tFmbXxTR/4wCvDQLapGpoTcLnvYIlAxjWgNZp
	mjG1H2V08K1UNXlFJ6UGDLWHsMvB2kbHvxfpYQnKVrB+1EGp8nGthZaFNVrDOxtIQASa+ltNsEw
	WY=
X-Received: by 2002:a17:903:b4b:b0:2d6:ff5f:eeda with SMTP id d9443c01a7336-2e2e49179ebmr3989585ad.6.1790748219186;
        Tue, 29 Sep 2026 23:03:39 -0700 (PDT)
Received: from omarchy ([2404:7a81:bb40:2400:e077:4928:9847:63b3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e2e5b89c89sm1509225ad.15.2026.09.29.23.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 23:03:38 -0700 (PDT)
From: Ren Tamura <ren.tamura.oss@gmail.com>
To: tj@kernel.org
Cc: hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests: cgroup: preserve command arguments in with_stress.sh
Date: Wed, 30 Sep 2026 15:03:34 +0900
Message-ID: <179074810121.139422.1170111592692928081@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

with_stress.sh invokes the requested command through unquoted $*. This
subjects the arguments to word splitting and pathname expansion:
arguments containing whitespace are split, empty arguments disappear,
and literal wildcard characters can expand to filenames.

Invoke the command through "$@" so that the command name and each
argument are passed as supplied by the caller.

Fixes: 1a99fcc035fb ("selftests: cgroup: Run test_core under interfering stress")
Assisted-by: LLM
Signed-off-by: Ren Tamura <ren.tamura.oss@gmail.com>
---
Validation (2026-09-24, mainline 62f4c998b297): ran both versions of the
actual wrapper under Bash on Linux with a fixture mount listing and no
stress workers. The argument boundaries, empty argument and literal
wildcard are preserved after the change:

    Input:  ["two words", "", "*.txt"]
    Before: ["two", "words", "match.txt"]
    After:  ["two words", "", "*.txt"]

Ordinary arguments and the child command's nonzero exit status are
unchanged.

LLM assistance: finding small cgroup fixes, drafting code and commit
messages, and preparing validation.

 tools/testing/selftests/cgroup/with_stress.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/with_stress.sh b/tools/testing/selftests/cgroup/with_stress.sh
index e28c35008f5b7a0f66654b10d8fccf4678120f6e..a95fb387464460ba24775a3e947a91875b743bc9 100755
--- a/tools/testing/selftests/cgroup/with_stress.sh
+++ b/tools/testing/selftests/cgroup/with_stress.sh
@@ -87,7 +87,7 @@ time=0
 start=$(date +%s)
 
 while [ $time -lt $duration ] ; do
-	$*
+	"$@"
 	rc=$?
 	[ $rc -eq 0 ] || break
 	time=$(($(date +%s) - $start))

base-commit: 551c722f40809618230001baccf219193e22fc5a
