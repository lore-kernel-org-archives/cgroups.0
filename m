Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7CE4B3382
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 14:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788445046; cv=none; b=OGgU9DG6kmXsBmgjBQ4SoEp/WO5DeKxeXNd18sNkPJN5UHXtjQS78BrBBNmrWADDEJM5ViNwoN0IS/74/c2SF5ammxhCVc9XSrbrEKXs+plTUlgjWFTlKaTTDJr91hw0HbGydfiJ021MO1uNILDPrkpnVN7DWlnfWlKMalNW2TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788445046; c=relaxed/simple;
	bh=grbSD99wnbBQjbz5a/guFkZGFX6aK7WNXYkMNE/JzbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fIFpERRprHSiqRqcHtci4dbg2894v6Qas2fqFeSr8h0lIqQ9gcFGgfv8mR9nygFUCi2g0PN9cIttCCXFsiPE3P3yY3BDcTyV4L9tN1ErMI4wxCD6udBO6/NDzDKzERu804VBczDilH5oI9j9uqh+I/MIbunWm6Kx6yKkYo86+bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QOYurI94; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QOYurI94"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-6b1497f0453so1561272eaf.3
        for <cgroups@vger.kernel.org>; Thu, 03 Sep 2026 07:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788445037; x=1789049837; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zcCW6+/z3gty5vQ5bRmZgnTdisuOcsWk7AuFt/Gu6MM=;
        b=QOYurI94eBhCsm7GIovBe1qbVZIqPNiHvos/4RtFCcBOjOZ12nAzHNP14mwKrqYgnH
         pmAzOfjVcAFAesdrH0FgPpLqafI4FZc+Ex3bDHHM9VmKgpnGv69jftLgt4q2NSh3cvIp
         xV3v2UYGckSQrno+u6Lf7IS7UkP/LAEtmEMHUuJqBBNn0NEH1gS5f2FgkvQjRJ8DI/je
         g7fcDC5gniABI9l9Uo0RlCpvC/DeTE16o5QYQ8CVXsLWkbrk4S01gx/dZdS0u9NolutW
         bWZZQwW/dZIDmqMumyUWAW5xsskT77U6gDRnfhvc/MiVHoeqwF4r4eElOAgn8F9AL/IE
         g04w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788445037; x=1789049837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zcCW6+/z3gty5vQ5bRmZgnTdisuOcsWk7AuFt/Gu6MM=;
        b=sie0SUge7voX7AIvDYRBQ1gVrNkJSJR695kzOXmsZ3JsyjkkSl1/E3FMtLDlXkVA+X
         g03BsK3TwxlsTfaKjlYUCjGChCQZn378ThFgfOPWkfQVAGHOfIsixpFV2J6pSIbCdW0R
         2qw8U7M+9AGd4DcFjp2MK6lNOcIaF5FcabPqmZeFQowVRfqa1LdmNYd0K3IdwT2fnEpL
         amIxBAlfeWdnuu4WwzKsLPZRHsKwsi0bS4n3b/HW/i5YL4BwzOAdz5NxxUqHPNhp/POy
         8N8YH7ogLCw1oKsj3v6o3B4fgGar+ii6a9Ul4eHnwJojvP3rwX6WqkZc7lBjSEcktcQE
         LHoQ==
X-Forwarded-Encrypted: i=1; AKwUvBzamOXGgpKmQ3y0w8OxKQAc79BkoEfVL/HzO99N/e/IHsJ1Xn9G5hh5J+2rxgVMFlH6f4ZbQVz8@vger.kernel.org
X-Gm-Message-State: AFuF++mrEnVxDXflaMjqOBLSXn7u99tQiB1I/BYGBdzxc1S3SWXAeSEJ
	C2LTgvNOoaRSqlitJ1zGwQ1jf3rDHMm+REOTiWepd/qjOSVq7fNxzx8J
X-Gm-Gg: AYBFou3EFgzAp/fnNWMa0ie8Z7Xlzq8L/2vte1vsiyWYh2fPPbUFlgQPB9d10J/BMgG
	rsY32J2iy5cUW9SBBq1sUkDoFDTk8rSaOKsbPR0RZ1qpwZJANjxARZF6+k6fChzB8yDYtY+e335
	7cj4ZdqTmPaRoriXyH/14Eo+Ppc6rD3jsicsrUS/NtW6sA1XAVPzCI0K4r5v4a68sWcMXjVIJfp
	TGlnX1fr6lOkg7g8GBEXcskgTqOrC3UPzh55CKCkL8jx0baSoh94PrkYxhNuVSKvGXSQIXm5Ye8
	WqNJjEIhSVIYfy4CUkQQEFg+LwHcPAGryxUF+Fn43gA+jOV24yI/QRKsjr0vu523eYCVSxuZHeC
	511K9B4fqECc+mUDHh6cbVtXW+uooiL5rZjayp3ctK1ppcQ75HEUEtWmt009OTS2TIMt8l1iIyW
	9i76fsKBqX8WZthyyWaWcbg/Q3rUBKv9HDPpJSuxRt+fwfgvsOixcsFjdfa1soQ2chaj4hkiNce
	Y1ltfvtNUUGoU85zWk=
X-Received: by 2002:a05:6820:a0e:b0:6b1:4fe1:9464 with SMTP id 006d021491bc7-6b47dfac321mr10573094eaf.22.1788445036581;
        Thu, 03 Sep 2026 07:17:16 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:1b::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-46f3292c0b0sm7715350fac.12.2026.09.03.07.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 07:17:16 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Krush Chavan <krushchavan@outlook.com>,
	"Chengming Zhou" <chengming.zhou@linux.dev>,
	"Tejun Heo" <tj@kernel.org>,
	Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	"Shuah Khan" <shuah@kernel.org>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] selftests/cgroup: account for zswap shrinker writeback
Date: Thu,  3 Sep 2026 07:17:13 -0700
Message-ID: <20260903141714.595256-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260902180408.05b925ce05359cd4d7f96894@linux-foundation.org>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 2 Sep 2026 18:04:08 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed,  2 Sep 2026 12:45:20 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> 
> > The test_no_invasive_cgroup_shrink selftest checks that when a cgroup
> > has zswapped out more memory than memory.zswap.max, it does not
> > trigger writeback for other cgroups. To do this, it compares the
> > writeback count in a control cgroup and makes sure that it is 0,
> > and then checks the writeback count in an aggressor cgroup who does
> > expect to see writeback.
> > 
> > However, when the zswap shrinker is enabled, the victim cgroup can see
> > legitimate writebacks not triggered by the aggressor. In some Meta CI
> > tests, we have seen this failure mode happen.
> > 
> > Instead of checking that the victim cgroup has 0 writeback, compare the
> > writeback values before and after the aggressor runs and check that
> > the victim cgroup did not perform any additional writeback. Note that
> > this can still lead to probabilistic failures if writebacks take longer
> > than 5 seconds, but this should fix the systematic failure case.
> > 
> > Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")

Hello Andrew, I hope you're doing well!

> Thanks.
> 
> I do support backporting selftests fixes.  We want selftests to work
> well in the kernel with which they are shipped.  But, as ever, we
> should include a clear explanation of the userspace-visible runtime
> effects of the bug.
> 
> Seems the short answer is "false-positive test failures" but we can
> perhaps do a little better than that.  Quoting the failure messages
> would be a good way - very recognizable.

That sounds good to me. Unfortunately it seems like the selftests
aren't too expressive in terms of why it failed, so this is all that
I was able to pick up from the selftest logs:

ok 1 test_zswap_usage
ok 2 test_swapin_nozswap
ok 3 test_zswapin
ok 4 test_zswap_writeback_enabled
ok 5 test_zswap_writeback_disabled
ok 6 # SKIP test_no_kmem_bypass
not ok 7 test_no_invasive_cgroup_shrink
ok 8 test_zswap_incompressible
# 1 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
# Totals: pass:6 fail:1 xfail:0 xpass:0 skip:1 error:0

I'm not too sure how helpful this will be, but maybe it would be better
to amend the last line of the commit message to say:

...
than 5 seconds, but this should fix the systematic failure case
and make "not ok test_no_invasive_cgroup_shrink" less likely.

> > Reported-by: Krush Chavan <krushchavan@outlook.com>
> 
> Relatedly, is there a Link:/Closes:?

Unfortunately this was detected in our private CI workflow and raised
by Krush, so I'm not sure if there is anything we can share.

If there is anything else that I can add to make this clearer, please
let me know. I hope you have a great day Andrew!
Joshua
