Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF64432BD9
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 15:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784559753; cv=none; b=n/hWgsYa0MOS4Wk2OQpe8Lti2hO1GuULiED36W9EVovcr5gluSPdx7isr/99qsScV7OYhBRqPJ+2c3zmqaDHNdcpFRadeCjtFogiZWfr80kvQGbCsWOezWU8t6LJx1jhcIn5KfaDSFGDSMU9c2x2t9HkB0XmRwfTItThrJmL0ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784559753; c=relaxed/simple;
	bh=Tq16sg4xa8nWWXzuYioMyhtg6n7YUHfctiTiYuI6iLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQxTJMTQSNpN08RPGyOmOIR4ADJ7vYnvgi4qnnjtcVlCrbubAYLp5IEb9xlW+U5UPW264GedJwtg1pUXIPGYPzi/DB/z6UH8SaP0rWJDEjn2u5l2CB7dmfIKTBHADRAydmWFbQb/6Q5DI4JB0VLnjwWoGeErECIJrGk8oQKXhGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D4RJMZHk; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D4RJMZHk"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-4a2fdbb7be0so4176722b6e.3
        for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 08:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784559751; x=1785164551; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JcXGf7/frUgo9pt1iwmRdB5om1Q2CFstWLKuaK2u478=;
        b=D4RJMZHkb4Jki1BTHSmtXiNe/WboPqgSUui63YhsMNSzkLRgg/BO8VNOfXX99bekWO
         kj7INzv0eOx6kldy7x7DJ7VDp4h+N09oJd9KovEXi5T1Yke0v4lIH3urQHzUFcbmk8LD
         XDAOkQXTFHz2Nm9zG9K0TkG1w33VnDmVQyxthVXTVcORhWjxNSLuKNXiLqIew+uWlJEZ
         ITY9Cfl33uhOmo2bSN3QBG6KLnBZFqphMiZS/JzcZQawTVVXhmVahFy05KY6YAJE3sxx
         IyKmy2dR86BNJUHkH7bJKY4zo1tVedqaZNGWAgAVBCzV5ZkcSl75p5667A4Ytt5YDDR9
         QcEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784559751; x=1785164551;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JcXGf7/frUgo9pt1iwmRdB5om1Q2CFstWLKuaK2u478=;
        b=pLux5HjPswrgULAHwXqmpFxrajNHBhAZHgugqP4TXlx33U3k8KkiPu4gDTNA5xVHFe
         n2As2rNpytoDSsryJHLl1Wl567tX8jlIsN3Rf+WdjEpWli/SyyQctkaEsJ2YkGG4AOCo
         /6DxCW/DYDhCqIckW0gS3nPhwJkUDhHG7TzMWxnG1n2ZMNJ6Zk4gq038GzC6lEl0fUnf
         T3DFD10CjvJJHyHgWEeAcDK3XkTCcjJ3T+VjoiMYSQTqE81VsT8703Xj3KSWlIzhSqep
         EPwLyaAzLLSvnv8cqpjATpYotf3Sc8vxvxP4qo27gz30fcnULVhLlIltuHrDlwv/GklM
         iKKA==
X-Gm-Message-State: AOJu0Ywtg1DwmKHvGFPxZ+PmpcYRmp1yMiMVn8oTKlpjRYkOZCaKwC4A
	Pi+NWHfb6aAi0tSBdffqkRSrBH7VMv5ulNDMPdOIH803pVSPvIEOemjK
X-Gm-Gg: AfdE7clJ7wsLaHziVfoieaUXNhUnSU9KfoMd47bp5JHeBdoN25A0/U3y/PS6FAWSrs5
	OOZwp7IjSKKtpNmuupdx0AejwoFA+6hkJlslNgg2f33yxvyaGiM3alYveXJnLMlIzqVfsiWvF2K
	afnazG0mEbWWRm0pQokHy9mOBtS69BRPlreIZ8ivyAyU+Ja7RIboYyFcNSBsgqAP6lAXI5YBX79
	l0NR09EN8oh1IAe9cxKu2p3AU+K0GBO4BJm/8quDomtSL5f7j3cFffCGOd9b9oZLYff2TNnD9Pc
	+JKtHba7P3n7ZUviHUH8okZpM+seuTnfCO9kKvA2iwgV2x7PxkCfBmUH+Iw4jAWngZV3PPX7sOF
	yt5YBGhkOPfcC5/ABS/Eo40WaAr3t30rzxl4VXlNN5h4qwA+Wh7+gXAnhG9fYwC2gSYFf7hUGUG
	mXrmMJFfZRbJwTYiZivKy/5n8ogReukRz+
X-Received: by 2002:a05:6808:2227:b0:495:db8f:ded8 with SMTP id 5614622812f47-4a4d0346c90mr9145232b6e.9.1784559750787;
        Mon, 20 Jul 2026 08:02:30 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:46::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4a4d3aa81b4sm7518774b6e.5.2026.07.20.08.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 08:02:28 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Tao Cui <cui.tao@linux.dev>
Cc: cgroups@vger.kernel.org,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cuitao@kylinos.cn
Subject: Re: [PATCH] cgroup/cpu: document cpu.stat nice_usec and core_sched.force_idle_usec
Date: Mon, 20 Jul 2026 08:02:26 -0700
Message-ID: <20260720150226.926730-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260718080100.2334415-1-cui.tao@linux.dev>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> From: Tao Cui <cuitao@kylinos.cn>
> 
> cgroup_base_stat_cputime_show() unconditionally prints a fourth base
> stat, nice_usec, in addition to usage_usec/user_usec/system_usec, and
> also prints core_sched.force_idle_usec when CONFIG_SCHED_CORE is enabled.
> Neither field is currently described in the cpu.stat section of
> cgroup-v2.rst, which still states it "always reports the following three
> stats".
> 
> nice_usec was added by commit aefa398d93d5 ("cgroup/rstat: Tracking
> cgroup-level niced CPU time") and core_sched.force_idle_usec by commit
> 1fcf54deb767 ("sched/core: add forced idle accounting for cgroups"); the
> documentation was not updated in either case.
> 
> Update the cpu.stat description to list both fields and fix the count.
> 
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>

Hello Tao, thank you for the patch! I should have updated this when
I added the nice stats. Thank you for finding this and updating it.

> ---
>  Documentation/admin-guide/cgroup-v2.rst | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 0df15a672cf3..778b759dd892 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1144,12 +1144,18 @@ will be referred to. All time durations are in microseconds.
>  	A read-only flat-keyed file.
>  	This file exists whether the controller is enabled or not.
>  
> -	It always reports the following three stats, which account for all the
> +	It always reports the following four stats, which account for all the
>  	processes in the cgroup (including those in descendant cgroups):

I have to ask, which tree is this based on? I can't seem to find a single
tree that contains the "(including those in descendant cgroups)" section
anywhere. 

>  	- usage_usec
>  	- user_usec
>  	- system_usec
> +	- nice_usec
> +
> +	When core scheduling (CONFIG_SCHED_CORE) is enabled, an additional
> +	stat is reported:
> +
> +	- core_sched.force_idle_usec
>  
>  	and the following five when the controller is enabled, which account for
>  	only the processes under the fair-class scheduler:
> -- 
> 2.43.0

Otherwise, the change looks good. I just wanted to know what it was based
on, in case I'm missing something. Thanks, have a great day!
Joshua
