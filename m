Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795433999;
	b=wZWhPZIYDgnRTkvX4gDMDZy+XXYjwmMc8WT7tZuQBQCUNP0Csz0wQj3YSNzxcMVJGCQH
	 AkAYqnxKI4sDbQ9gQ5i2xMpNkRFAyrfHFvj+QMOBRMt/j0UZtVkLqWoleQ+klSzglR58H
	 NKUFerIkIE0q10DkYCkBEt4xggmso/krL/BtXC99WyumQxkD0oO4Eh+2YSOkJVcnha357
	 rw49RXAtq68V5ZNxnl8FUDIrjRMgE8evikSaiD4gKzxFwr5t70c5nUwiNGG71gWgxP98r
	 Is9YvsZyHseaaykZrpbgwGfjhCLRfUrhRdhDI2gkaQvifeOD52kZOULY0PoFu087Vbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795433999;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dzG3GXZhvfXV1CjH4z9JC/RUQc8XXCYXZlNff5428CY=;
	b=ATSyOaO+us4ISqRJoark6m/tq47xIwTENjBdCQidrDqL0Znl2xxi6TAikSVFOE4DBUSZ
	 fU7uJezIx6Ji5lCkuHd9Gr6fki7uVIF1jfPpJjFfaYGH8Ozz5awQXuJiXYassoPqJm1YQ
	 yLTgIn1M9oKzf4DDOR5PUNYmrp4d9LCCjSTVyC+jw+WaL/2iEGvgrFCGYHiWQfXGaIpEC
	 U80c0Q2aZQd9BAv3DmDNEY1NzEDz8j9I2Fj1bogV+INIO+F3Rh+xEyg3y6kg4GV7McnEG
	 IrpF3hnY9FtiowjxtrSe6uDY3aZWJcHmqijESvMuysoC3MvDJX6K9THIez+wTwqRHjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=A2dH5veA;
	arc=none smtp.remote-ip=209.85.214.170
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13AA6606A321
	for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 11:39:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13AA6606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=A2dH5veA
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2f04f61282dso11118325ad.1
        for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 03:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795433998; x=1796038798; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dzG3GXZhvfXV1CjH4z9JC/RUQc8XXCYXZlNff5428CY=;
        b=A2dH5veAYU9uoMnrxmCkRpQeZ0A/ZwDFNnDLQM4oCIdIkraVq13RcbOIFo5ogYHW34
         yQEXCsWBQBd5Oi03QRr/O7Ge9qpd4RlbrSFDsGIEDcagzszpXiPvKQC/9tioZWqMapSx
         CnZjg/qRD3DcZv0suqf0F6vnaXAyYJi2sv2CmvnHSziWmyD1ctOCJX9NM/wYuV8ZcFOD
         u0QHblU1m6MXTIUlqb2N02flLxsbt1XVqP4Xa3q7GL21gplmPtn2NcmRpbggGx5lpZ2y
         xkXavM2K+bb/WDFqfj2y+9AN4RRXWZHaaVUSq4ibjQBlOFIxzl/qBmAUY2V9lzOhBrZd
         fFjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795433998; x=1796038798;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dzG3GXZhvfXV1CjH4z9JC/RUQc8XXCYXZlNff5428CY=;
        b=EBYOY/c42OxZ0yQeuo3KhVJZhmL/Y3EREdgBjoVSDwjo5E30nA4jaAqOBC2EAmVqEc
         kZFjSgrJ0zbZWGcFyeB1R7hpUprydx1G2pMayKz+VFKJndXrc0z/SJSBYuIgD+uDb0Js
         EubW+O+tQDxyqeQ1i4hldRAuB+qNStAexiBwUA/UBmUILNrSCtyp0wKQdp7v9cyoyjJ8
         6xFizE14tby/4QT2YE8FDqnUGmx+xbO/6BNu3PrtG9nRlt9VRCMqebYuyeigj49Og/ga
         KqQ5WdOtDjOwWZQeyDiX49a/jdft2BTDWTY5OFyCvkMTeNbBNJ2S5kCo3bD4CtQ6hkYM
         +o0g==
X-Forwarded-Encrypted: i=1; AL+hErH3mGEhrbLQbFAzS14E0y1jmv4+Ymjj1ybuFKAujxJsIla4vSk8MFCXcTXCbq7A79Y+J9iS3Bim@vger.kernel.org
X-Gm-Message-State: APuU4Z+4RvcBPtUGiQhKIYgqUHB5yi7Tk5ZnfVRS6PpsKTgjbmANz2WO
	MJ6GwRDu8wk2GZP/aj30ftqFVqlhdTOaTvZ9qnPwV4fuhfyv3E772koR
X-Gm-Gg: AZFdTZeP3nSNGCVWhCkuI+/BpL8VdagCx7+A/n8e8+rFH7dod6Iob7VOugs/Hs1ahkX
	iPuQCuIb07aesHiBKPI78GNK59v41gbkS2Azy4U4pUrHHwSseN8QCr39pDYldILla6sItqZ2W64
	6zy38fl1ij5W4F5Da3dENnUtfcZwi7PcQzo6vfYham3bxFC1/tvM508V9mfVrczeh07/oyPiOfE
	254erDwMksYI9kLGDrJNnsmE7xOGg3o6FeMrJGZYB9zjEIMFYGtuf+FURjrpry8tyEo5uK6mmwC
	TjNpNAyhg4YhOq4Ng48yuqTG7S0gxkK02QBPo1fcxn5YAZprMI88mTboE9bLzCyBvr4S+SpYIIM
	TsEC30oQAZTMoNgYM51/pJdeGBo9p+tnpxuUEqBZE+kwg86knxHqTH7N3NOAKaT0WoITZYFn0oC
	HprZTgdo5BXHur6xb4VfpCI+ve2yUKklB32tMEzA9I2s8iIfRVS8gA7KzPJieGyD/bHk3PnVuUF
	Ywpqtd2JyI0X6h6I42+6y5DDESNJ+FNmP92ns+YFmZ4FteqjazaIqDCqkzR5nf7XoBdNIXPssQE
	LSe2kccdWldfzOKDV/kY3zM15gNnQNh85ef61tF9nhmzCA==
X-Received: by 2002:a17:902:ebd2:b0:2e9:970c:2c9 with SMTP id d9443c01a7336-2f03f1c75bdmr133283195ad.42.1795433998310;
        Mon, 23 Nov 2026 03:39:58 -0800 (PST)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0c1f42sm51601475ad.25.2026.11.23.03.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 03:39:57 -0800 (PST)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: tj@kernel.org,
	mhocko@suse.com
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	penguin-kernel@i-love.sakura.ne.jp,
	mkoutny@suse.com,
	chris@chrisdown.name,
	cui.tao@linux.dev,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: Re: [PATCH v3] mm: memcontrol: don't miss processes whose leader has exited in OOM scans
Date: Mon, 23 Nov 2026 19:39:51 +0800
Message-ID: <20261123113951.1771223-1-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <305c5803b904a57c188b505d6ed9e1e4@kernel.org>
References: <305c5803b904a57c188b505d6ed9e1e4@kernel.org>
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

Hi Tejun,

On Mon, Nov 23, 2026 at 01:13:25AM -1000, Tejun Heo wrote:
> Maybe the leader can pretend to be in the new cgroup instead.

Thanks, I'll implement that and send it to cgroups.  The memcg scan can
then stay on CSS_TASK_ITER_PROCS, so this patch is not needed.

Thanks,
Zhan Xusheng
