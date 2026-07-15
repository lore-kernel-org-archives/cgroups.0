Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E247648C8DC
	for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 17:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784138172; cv=pass; b=O6Kd855ywtq4uQRiZ0XA74FyWdC5meoxkTfQ9TXtowxj+GVvVi+/TuckNV9DhZmf63rMQ0TBjmZxIzpZ2IAclCu9DHnZbQ/xgTCls9GkPZR3XmCoAUHEqwbizu9t2ckztYHcrSNXVdWHJW4O5FwkXwJFdzGAyA6qbEL6X8y/Qbg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784138172; c=relaxed/simple;
	bh=u+3FAslbVlj96800WiAMAGOylgc0ssLAYc5uCqETipo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qO0L1rm+mUnWSsEguGQMnT6pw7KtmOOTCFm0OohacC36ZTtSctI12KdnW/l8Yx4DqskfL3vma0yXKUKfBDeDY4pSh2m2zj8Wr7ivpj3hBJevOEvrYP71MlrMvTSSmBbjc2YOQyx4mN3y7W3TvSH4+tgU+LFtd3LBaqd073kcjRg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A4hgAjv+; arc=pass smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A4hgAjv+"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-493c556ada3so5575e9.0
        for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 10:56:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784138169; cv=none;
        d=google.com; s=arc-20260327;
        b=X0vBPO8x2zsoRyD2DQ4mbL5S1O5gcqfz5xsr6XYh1gHPks+Zi/7k4Sh9zFEgDWa5tr
         sWAEpSngbQST/MMM9N6kMY3FXj6UGos9vVPETLinO7eNKdWifDQJk6Uw+zgAO0dimmGY
         AOCJ9ZIAie3JJqkvn8Csaswraqgw7e0moqDXo7clNHeDuzCv0m10BMM/UJH18iPXnINs
         j5AeotQMK2V/XL/BqVrEUlimfcD/cBULyQv6fBcS7D/l+L5V+gRHGtY1/zBhh9koXJja
         deBrP4HIMw0MNmGCAa8ZlOAotjlo8hyRvld/0Xp8jOziBGJpyb8ib/+Cl7UWN3feZQUc
         09jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RuBIyMRxxSG5xOKfBj9RRTURzzjnDkJEBKCLyFmN4sQ=;
        fh=fGWGTr1VAaEoUpYsI3N0P8a1Mwm5o5Q/qaDFDSytGso=;
        b=YKtvST14ELr1y+FnB7dwsAsTSR8X6t/ELYNwjTit/MiKHD5z5lPqA6cRdRidbqDoZO
         R7OR4QHcsTzvu6tlDllYANqtK5ldyESuyiL+HxrK9/FK8diKaRVS+jQB6aiFQPCfbYTV
         sfU+EzzHz+JGgbAFOADrNAJ/tVvnAY4bAjlnz27iaBxBd1582PSd8i4ftEuSf+LR253R
         pB1ceNuJ6iDUzbeKo0W/WUVotEivKF88TYrvXAI0EcxsRUQ/ttbbQE+a1KsXez96uJQX
         tCma4C47cHNASFf2937Ji1ciuLPUJYr8xEhIDQGpnQyKyOb0AYCGHkwRMUwErNCbngV5
         nBWw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784138169; x=1784742969; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RuBIyMRxxSG5xOKfBj9RRTURzzjnDkJEBKCLyFmN4sQ=;
        b=A4hgAjv+cRMPs1OEpvkfeZIySozAnIHRuQUe/3yE/Xk5dftlFG3toVQSh54TcUDa9L
         Oj0tQ4KRMpYlTiRTcOCT7kjC2lsuBSGe12L7u2aNzp2l0BsfcVZclyE1ZOOv+MCEYUvI
         4aj/+ak8C0mEO3owGJyjU85qe7UnvTkmPhjvsshpylZx50InZMHYIH2Daw3+HuGw0pcc
         8tjLT7N8Mgi/eRumssERQwz90Jt/6COlHuFMjYMXZ7SxF+bGjKzKsoD9beSROq7sewYT
         0SerjmRzmjo4kDWOp+NF15rkocmlO3w64W6v0wpzjkSA211XUGNffeuqujyrT9U14XNt
         hfzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784138169; x=1784742969;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RuBIyMRxxSG5xOKfBj9RRTURzzjnDkJEBKCLyFmN4sQ=;
        b=Wr/uwdQ4SylDa1vMSEFQ126xb6BaajSCrB8FDRJ9jdLoxpx3FExYlefBkZte5aeJ1k
         +aAQfYodmkHDSA6SFEhXL8MdFxviBOIjqpsFg/D/CvZmnPM9Kqo0f/AY3cB2jttjeqFa
         iT5Spvoqjkl2H5vXD29Z2l3pQtxRVTfsS4o6aAizIwp47IEgJ4YH6Lcg470shlpVMfv6
         I5ZJyAoq+n3DnMQaJubWKknNl6LzU65HUYZoqpD1GJJxWBpdvCmASL4jvgLfwRWAOGEt
         KYgIeKur2g0vxGnEHViEN5fSXKfTR6cMg1ZoVRxkZziIbitXaO/dpTwxzjCWZGyviJo8
         1pfw==
X-Forwarded-Encrypted: i=1; AHgh+Rq9s4kbwmwyOtf5ij4XATY/5yh8PWX8TpDDhW6NLW/pcylvylvl5QW0gF9uIjAr3I+K5fzx4uxS@vger.kernel.org
X-Gm-Message-State: AOJu0YzI1A/D5UnlrjspQdzsj3U50y3M3NKzFWQ4YQe8tjMy5eECHaV+
	UyL5DvOyipVh1b05nNXXFSExe3iGlrumCqZ8vr6upx9Yhl3wVifvIbnEElREQtg+4rx8GAiDB1g
	tJw1JILfG9611DlMv3sYwZWZgyq8Hlbg1sdJ7lY/9
X-Gm-Gg: AfdE7ckObWJCteX42IAQNyqhWUj9p4olaGdLmypfroDw1snw3Sq+pNuN68Qm7NZWLjS
	ZYCNAXpXwXxK96VtyXvXyBNgo6nr8KndUnQxV4gbrzrn2vIf4EhjCEfc2Wlx3FDlJ9K8Q4kCytB
	ZgBa7v0AOWgKGaX156APxrVwNFpeZU5ykHB5bKZsKCv/puE7HeCwTT4HrzoLeGgEJiqEzvVCYd3
	k2n9SU4788wIAzIu5NDbEY2s2NZlqr0/Yo4TxLor8WzeOAMB+L1MhGIuwbiQdrmCyJJD6JOJQrx
	rTgmzBvoYuTT1sZJrYPVaiK8Woe1riny0b+P9UcBJRAqEMFrrv0vlKaxBoGNDB/d6rLGqA==
X-Received: by 2002:a05:600c:4ec6:b0:495:4069:b0de with SMTP id
 5b1f17b1804b1-495414230f0mr128295e9.9.1784138168394; Wed, 15 Jul 2026
 10:56:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260714121529.2237261-1-wangzicheng@honor.com>
In-Reply-To: <20260714121529.2237261-1-wangzicheng@honor.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Wed, 15 Jul 2026 10:55:56 -0700
X-Gm-Features: AUfX_mzAYIm26JZUendtoZyWaKS-eWpz07CFW-u1bis9rmp-d5YT8fcNAcUgKUM
Message-ID: <CABdmKX3y841t4Oqg3RRHTGXWP-LMMSi_exDuxAc4jR9v9ChD2g@mail.gmail.com>
Subject: Re: [RFC v2 0/3] mm/mglru: proactive aging via memory.aging
To: Zicheng Wang <wangzicheng@honor.com>
Cc: akpm@linux-foundation.org, yuanchu@google.com, tj@kernel.org, 
	hannes@cmpxchg.org, mkoutny@suse.com, corbet@lwn.net, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, weixugc@google.com, david@kernel.org, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, willy@infradead.org, 
	denghaojie@honor.com, baoquan.he@linux.dev, kaleshsingh@google.com, 
	tao.wangtao@honor.com, zhangji1@honor.com, wangzhen5@honor.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 14, 2026 at 5:15=E2=80=AFAM Zicheng Wang <wangzicheng@honor.com=
> wrote:
> The benefit is workload-dependent: file-cache-bound servers gain from
> aging, anon-bound servers do not, so no kernel default is correct for
> all.  The kernel also cannot know when to age: on Android the right
> moment is the foreground-to-background transition, when the app's pages
> are cold but their PTE accessed bits are still accurate from foreground
> execution, a framework concept.

When an app transitions and becomes cached, we attempt to reclaim its
entire workingset. We basically cat memory.current > memory.reclaim
and freeze the cgroup.
https://cs.android.com/android/platform/superproject/+/android-latest-relea=
se:system/core/libprocessgroup/task_profiles.cpp;drc=3D65bd7ab941a709bf0498=
71406981022b988e1721;l=3D706

File / anon balance vs hotness and generational placement doesn't
matter in that scenario because we want to get rid of all of it. So I
don't really understand how you'd want to use an aging knob.
