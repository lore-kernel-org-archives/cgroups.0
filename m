Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC66737A496
	for <cgroups@vger.kernel.org>; Sat,  3 Oct 2026 20:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791060357; cv=none; b=Ow6atghaKB/JN4LxYS7Jk44wgb133F8Sf06huZIW+LEsYlY/l0Cw6prkifaZbgwS7lc211lG26t3MHYBJU5dTWGuT+7CLH1sjGGn8OcBZD1c8vDi4mGdGgz8EenUiDcXLPS/uddP1NF1zHSDXltF2ePPnO9SJRnEkQT0qD+VxCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791060357; c=relaxed/simple;
	bh=FRp4Cct50HXCeTViDVPkOvyv0qHQZnD+X0WubEU1Bpg=;
	h=Content-Type:Date:Message-Id:From:To:Cc:Subject:In-Reply-To:
	 References:MIME-Version; b=KmIbL+4gp3DX44ZPqzR2tuK8j3c9JpI1ywK8/56t+XshDPcCvlPfXiAM15/i+HK04J5eGBX3CEY+wORQw8H0JoFQjfVhuGjG6qmQUp4t4ERnWbiUpqFt/CcOnBNO+1mcpeM78X4hGfmd54fvM4MTqT4ZVa60xXEubV9l3FrTtm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n8Zkw1si; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n8Zkw1si"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d90ba1d807so4245675ad.3
        for <cgroups@vger.kernel.org>; Sat, 03 Oct 2026 13:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791060355; x=1791665155; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :subject:cc:to:from:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FRp4Cct50HXCeTViDVPkOvyv0qHQZnD+X0WubEU1Bpg=;
        b=n8Zkw1sihXcl4/Pod6zhjI9skgCU8j8F1VKkIOWyX5CldojzAfWimmAks5nfi9OI3O
         LbN7M7jT2pSdPqOjAibpwHGhCfkmKEeJa16o1lM2yFRjyEhm4MeQNUwLEe02xZF4vbj4
         NeZadT6r48WSu8JRikuJCVsKoEhQMgAxyyGz7+cPMHDGRx2a07APhzA/cXMI5ZAkknsi
         +8Qoz0NWe0WKvKeW4oFLFGxdiBrgDzayaQPcO0bTL6xSS8av6YHG6ltu0YR4yjKo1gb2
         gbzTkclD39paWI8LoyivQfZbiFf+84u6SYhDpdYnX/ohVVesjMuxLL5xG1Uye/24m7/6
         Ta2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791060355; x=1791665155;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :subject:cc:to:from:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FRp4Cct50HXCeTViDVPkOvyv0qHQZnD+X0WubEU1Bpg=;
        b=RW5d8e7Q8WwWcjokZnSADNG9ObgcTqtzeU+hhLVL0B7iudmyRvDJHlPj44QUtV83V7
         Wv+vpyicAgD9mWwDzDnxc8Kp1Gd9HT16/DE/08tMEY/w7veJu1U6sexschfrCRBDSd48
         KkjtP2IRzPHGYPJaEXYS4ORzZg+AV1xbOfDpAWRgbAtLJJZBYCJNgCl2hPEeAPIPPw4b
         X8s6+P/o9NdxTp72pP4gAURW93y3M6o9XZoVFE2lnDjxuVY0t/mn/q1nTgu1wtQiz59T
         g42uMV6gnze7ZO4l7//QLupVjrx80oVY2kWmgg9RrsOsO9wxjnQcG5R1I4q47iNLi8ci
         isww==
X-Gm-Message-State: AFq9FYKghYYkjI9gSpL2MdZQywRxxTGv37RpP2WqwFTJyFnGvNCMPlAQ
	05fEG4T5k8fcU5rhc4sors6cKNwZQOrTgZ/O4zIL5aXpT7fJ7Vde4rAQ
X-Gm-Gg: AYBFou2m42m6BmcLArtQwWPISDwAWjCQIpy5IGaiueOZIMOoQItpicJcW4y/Lxlr4Rb
	x41bTwskTSYsp5HjHgNGj0zETmnJoLk/o6XiE2oYF6g2ij6q3Q8Em+fUv3aNm50Yb4GQPs37pqg
	DQ6UmAJFEmG1kEFa9UdMhhBfsPTR3QvvSSGOWsMDDoi0XXqMBZGWy/USvHP2RuC5VUPyEFEmBgP
	YOniXOK/rMvqHOnbUVohw4htMcM6HWihoEJCJeF2NrZZYUJKheesPx7v1N2SCLosMvewptOEW/o
	axUK886wJhF9OXMk46vSwC2jWizBNa2uWDUbW3qjETljaNe8JE40Ft4Ug7sfQqQcKi2RIdWNOil
	maM9V820XGTK5hvaVcm6F+3STnbsBFMTH1VF+3V9VHwwnHvXNou4r6qtQhqtRQRHC2vRhqoowx6
	UdMi7gJBh5WY/xm15pWOTkRYLNpKuG9HkqgxLpF4Guv94Bi1FjdTYbSAUtYVH0RYhd3+072Zrou
	0aoCIbn4GlshPcmhgdqjsL2DuTDAGcK4MGyLUzhnI7Q+VZnxtTx1lful5vtCOG1Ue4dE+rrkRuq
	uYKJfKab2jBfgg==
X-Received: by 2002:a17:902:da91:b0:2df:83ce:724f with SMTP id d9443c01a7336-2e49b615cf2mr61626695ad.30.1791060355061;
        Sat, 03 Oct 2026 13:45:55 -0700 (PDT)
Received: from localhost ([153.61.198.243])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e533e8397bsm7343265ad.78.2026.10.03.13.45.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2026 13:45:54 -0700 (PDT)
Content-Type: text/plain; charset=UTF-8
Date: Sat, 03 Oct 2026 20:45:53 +0000
Message-Id: <DLVHWNL0AVKU.NV007WEHWST8@gmail.com>
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Tao Cui" <cui.tao@linux.dev>, <tj@kernel.org>, <josef@toxicopanda.com>,
 <axboe@kernel.dk>
Cc: <cgroups@vger.kernel.org>, <linux-block@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>, <andrii@kernel.org>,
 <eddyz87@gmail.com>, <daniel@iogearbox.net>,
 <linux-kselftest@vger.kernel.org>, <cuitao@kylinos.cn>,
 <ameryhung@gmail.com>
Subject: Re: [RFC PATCH v10 1/4] blk-iocost: add BPF struct_ops cost model
 support
In-Reply-To: <20261003124045.1289305-2-cui.tao@linux.dev>
References: <20261003124045.1289305-1-cui.tao@linux.dev> <20261003124045.1289305-2-cui.tao@linux.dev>
X-Mailer: mkdraft (claude review draft; edit before sending)
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sat, Oct 03, 2026 at 08:40 PM Tao Cui <cui.tao@linux.dev> wrote:

v10 was sent 11 hours after v9.
Patch 1 grew from 712 to 789 lines and device removal is still
not tested.
Pls slow down. Wait for Tejun before sending v11.

pw-bot: cr
