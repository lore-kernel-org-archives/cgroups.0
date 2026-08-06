Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3461141B8F4
	for <cgroups@vger.kernel.org>; Thu,  6 Aug 2026 21:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786050762; cv=pass; b=VUWOUCuMzEkZrXMv55Aa19X2AwZieLyBdcmy/8LcQ8o6HBvbuYhO547OBv1riWQmEZ79cYVOoB0GKu1XjKvFqGGlI2+379xeGbhcVsedgbPwmu0+z6plrhb7X5yD0/btrVpVQ6CTcMxBkwWSUgdqLDhPdSuSthQ7r5vdpUDbgLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786050762; c=relaxed/simple;
	bh=O2nXCqD4o4f5F4Q2WJbaQxzYFvLIe2CbH7K3L5QM6zE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YA2nAIX0Rt1FgtfTGD6l+vPV9dxXl8zHP5EJjS7EhfNK/QSDD8Lcib/SiozQoQ8ZrcZ0VEmTcEu2PcljyM6gjSzSskkONEAYmVQhV/fvQylJ4myWj5YWYFUnm2Yrc/tCjP2fMxopqbS7TEDadJDNtNjD+rDYv5zQ4ie1O4OV8Bk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MWSiDaEj; arc=pass smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MWSiDaEj"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-476a130c138so2324636f8f.0
        for <cgroups@vger.kernel.org>; Thu, 06 Aug 2026 14:12:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786050759; cv=none;
        d=google.com; s=arc-20260327;
        b=MbM7NBWNWYs91qwPLPf6zDa/Pb1LmfhLtxhKizyHcJ5PzyR9L2oeC+CGZ8I0ov7ODw
         91xOud7GSz7u5UCLQKQiz4qa1hUpbov4KAuwbKQEmFsmwjdzYPKxannzKislIjo7vAsm
         XJf74nFnzTJjqHU/qSffOU2K8IMUdcyCActcPwOQ5ZRKneSrELnzTGa2DM2sN2vfzswP
         ghEU/YMuvyy8/rjGVORAiufTfNwMcp8grg/7qStS95C+8TLgL5OSLJ/rn+7DBcXfziRg
         4Pi1cWSN5XL5BDxc5P7e/7bDlHcwRqWTBjVB8nSAMCOBw0si2XzxFmWZvPmSZ1xjkeOK
         sWgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=O2nXCqD4o4f5F4Q2WJbaQxzYFvLIe2CbH7K3L5QM6zE=;
        fh=azKKLigNiSR2ts+BhTnUdM2pUpNckg7TI57TAqSjGVk=;
        b=mvUAZA50Rmx14LeiKeg6FQqmO1BLjzANU659Ky/GMz/yiVdddMiSYER+mcewZqayr1
         0oTs/Vd1c+XFvHG3Xuo0RZyCQMylLy0ovrXJzyFxFg8JqYpZVQZPk3GgHo/1WQFoet6r
         HBsuiXTS6u2Wbcd3HgdnunCyJnXRkUf6IP7ef69/+A91o+bpC2J1VzfStbdG2XqgyChJ
         p1dMiCInJvS25GMsqXC7sbApYVJ+afngjPjcZLXkVa9FhCOTYkpOcLYS/oYVrM3tq9ID
         D2lfpDLUih4je0b2ozuKd6GatEAZVQ5lQDjo7ra5T9po/zSxAAApP+e+yj19EOcTPpDX
         fuHQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786050759; x=1786655559; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=O2nXCqD4o4f5F4Q2WJbaQxzYFvLIe2CbH7K3L5QM6zE=;
        b=MWSiDaEje+zgNjbbgl8YXgfzKrlmEiybwk/ZCe57OjFU8PiEpLmNEq6ksPxCPWTK9s
         N34+Rn0TodRmWp9REy6zkVZMbElz98OR3en/0NKjR2zaxtPX3q9dAZiTdDtCJYY12jBp
         Ze80Y3gOVBVnldjPfcYJY5YRWTwoke+LdHsZmcIq5f781f+hEIDCEdtnJLZ0ao0OvuuX
         cG6Sl59VogNBeXnICtArSPAovXAageHGulOXz5AKK+3Brhn86XwZr3wxH4YXw9XnBRex
         AFYlT66/LGm1zlIAJC3o7P8P1Tj5YHKHytwXBsVlbB+3GYpyFnNgMOeucRIkeO6L8PXp
         ZvmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786050759; x=1786655559;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O2nXCqD4o4f5F4Q2WJbaQxzYFvLIe2CbH7K3L5QM6zE=;
        b=WpZ/vOTWVjN8Krz72xP8EPHydWCsyISnWmKL7OaP48MAdNXzPljI5X0uviV5SaVPGy
         AlWfNtWEqpXIJHFBH1aZu5KGE6DM+mhdfqRbarHCLBIoRHC1apZgFOlTudhjMB2GHmhF
         vSMGMAbBmBFJJA8OJFVvuTkpZRMQTf9R9pU0d6qvVQx0JbaSFxk4x+R8Sj46ggrS/32y
         +LG37R3s8Yo6YYwuyIKt5zpk+WFeY3Tbf73SLUbJBNpN83/UyX/fFp1TD0paWVB94ujy
         MScYuaIMrPT9aBRjPg0rdQfLRJgUQkrLt1MxrMF4PP91jx+uioiswDXWvdS+ObNlabYY
         e64w==
X-Forwarded-Encrypted: i=1; AHgh+Rq+g5qGCRjKoO66l6dsCnLktPOJtfq6HRpVdGmFVUNoPo0VFdc8d4gTmoMKziSzx+UGdYO1xMrd@vger.kernel.org
X-Gm-Message-State: AOJu0YxaxTPSvmmF5Ub+EXRdQWPRRmcKR0tLuZWoAzI4wsTF2cd9sZz0
	FbAXV6kbgsvQL159Pcdmx4Lw9+Qc9jRAe1B8mdhGTdxB20lI8Zn75ICVpYR2C9e13gQ7QOnigAh
	6Pffex7cA9+j2cIVpTtM121lYXzZm1jQ=
X-Gm-Gg: AR+sD12lomeqVYpMrV+xLiSMpJyQSKbJFPIrXjFTrDVFTed2/ofHKUNU4PMtLclsloi
	hjKsA6duDwh+oXyn5qp8OMXd5xPBvFWBXOsdy2RGGVi79zyUhvPFlovoE1A6H/WAZ+ocR3bQndM
	HnaGLtX9h1TkBRxztlXr5+d3G4jJrXz626wxwPzc/Vj4tfp04xS+WOItk4K/7+9mfC+XDf+DTo0
	fQgh8Zr6jgDmDHJImuIqZGH7mGtolgt7nXVD0v7RefRl0zvmOFYeEBLgj8GKTONnn/Q8OojpJkw
	343TVMOUFvoUdtv6KJGPj7anWa5UpgxKL/tFy8dKWaf2YuIJ/QfcGhVdPgvcPRGZ7ZzZYoTljkJ
	Bce7zZYQ0ARzGSIqK6EroVuv7
X-Received: by 2002:adf:e012:0:10b0:47f:762f:32a9 with SMTP id
 ffacd0b85a97d-47ffd2322d0mr5562298f8f.12.1786050759421; Thu, 06 Aug 2026
 14:12:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJnrk1bk66ZhRAS7mojSnD5RBfFS+0ChAPymE3ObRWr0C_udWg@mail.gmail.com>
In-Reply-To: <CAJnrk1bk66ZhRAS7mojSnD5RBfFS+0ChAPymE3ObRWr0C_udWg@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 6 Aug 2026 14:12:26 -0700
X-Gm-Features: AUfX_myi8qSsw8YaJ3oXvGriDbREJKOHPf6InLwZIwXLf_s2phZcmAT4WgkHKVs
Message-ID: <CAJnrk1YNZ-mW7VDXtbNYDUbim7g20gSsec1Gxpy8kWKrDEN5_Q@mail.gmail.com>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi strictlimiting")
To: Yosry Ahmed <yosry@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, 
	fuse-devel <fuse-devel@lists.linux.dev>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 6, 2026 at 2:04=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
>

Sorry, I think I messed up how things got linked when trying to update
the thread title in gmail. This is a continuation of the previous
discussion thread ("PATCH] fuse: disable default bdi strictlimiting")
which is at https://lore.kernel.org/linux-fsdevel/s4kv7qep3jlncs67q72xfhser=
pd66hpbwzkoppiddc5raufyjd@ksuvlfqcrbk2/T/#t.

Thanks,
Joanne
