Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43EA3EA967
	for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 11:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783942852; cv=none; b=gn6bJe23qrknRTCse8L3eSaKT/86tRfPZc8DCSLxJgSMg2pV7xTK6acQMgbw2wlCOu7orH3s3uZl24D9iE+77bLhEFaYNxzzKYVYfncpHBRTua//L4CTz/Me6dAaLdM6MmuOU0Ny/oSzW51lk0qCQUvCAmPAsmh76W/q7ysIkN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783942852; c=relaxed/simple;
	bh=LH9/W3OUGmfaGWsLqGOAOP482KnrL6lFuz03qhNnSeo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p4QBZdf67cfrGtGdJSOA9zXPDHfVPwm5TQXjbRYMp3//SJ6B5iuEmRPOZy5MSbNukGaJgdxnMO0n8bDyqa2tdd/eDAJS41/nigGc0o/OqOs0FCuxCG0dR2m+9JIGSZCfYAoyo6XTGLcEKDrvviSvloOt4UijVDRgP/9ajNjLQrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=U2ap9TQh; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="U2ap9TQh"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-475cb71a4ebso2978187f8f.0
        for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 04:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1783942849; x=1784547649; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=O/6B9YNSHoy7N6JoeH5/zIRc86w/yJtKIFK0rWk3xNc=;
        b=U2ap9TQhd3O6thh5S3K6swMDz03JfvLB15O7ghbvxDZ6/UPNd/avXPneNj4WBSg1eF
         wAk6CYK9xfuWrReTZafJlgQyqWmcnJ3xXv8EO13QXjnmdv65in0N19EbIHQbX+FbAi6v
         +Qcsk73qHZEuUg23kTudUqF/S8sPwkllKc9NfsfniPfDs0reD3Boau2kbW9qoh+Crny9
         SrArCDCj5y2hxC7ZJmVP+voMANQTqt6aEasI8M1//jjVfxyLBpeZMi8qKMBOnC1EfwrA
         0U2xgXlfFFuaSYrjq5qE/H/1Uz+4Oe+Lmzs6u/gOJ7lwZnodPf3ABSeBm40F7zSghiua
         SNgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783942849; x=1784547649;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O/6B9YNSHoy7N6JoeH5/zIRc86w/yJtKIFK0rWk3xNc=;
        b=EgBDzicTADmJv0QzkBtqiBIQzUWFRG0iQdtrdiZ9GE8idEPkZfjBhw+Vqz8Hfo1oZt
         2EdFNjmZzsdVKi9TbEdEXvCcaYd9xOKHZ21m6x56WEBsA4cc5060QIcdLcbbe9tKTjqb
         hURIHnnkjHBO4U1ZhHXl4ymqNzOpSa/evX09Gi6Vy8AB0gCUmPXGvcIulY+OZ/f8GfKL
         5OuyZrXX318r5kgFCKVwFltMAA5H/9fx1972xbCHRe2iynDLXkneffA+RcvY98a8JS4n
         k+xp783Zd9idGLes/GRw7BArwhaxmW6KMYKfj6VeEAvLLOeSxSzJ+Bb2MCtJfqk5ipOd
         c0Aw==
X-Forwarded-Encrypted: i=1; AHgh+Rpg2UzfwlNyY3ihKUco537PEz1bSyeTRLZ+Zt6VZRGbGUJ3KalArqoDOezyzyeiAqJfjcbw51qo@vger.kernel.org
X-Gm-Message-State: AOJu0YwXnkN0WhxvyzgLrYo2wuAoM4RQHA4aKaOSIP3gB8s/GkFEN/Vu
	6MxdcautaD6xPKnwmK8W+qrm3/ujQkdpxO95bOkMhOiVq8XSoUTc7sukRmG4VH9PUGw=
X-Gm-Gg: AfdE7cnL4M46xGHrvjixxj373hmNY+0/T/E/5KrF/zoRzLE0GsjKYpxOSfZGfeuPZeo
	3adyAw88BcQetFWDJ7gnQmUxsZaF5KsPOdzduIrWnqSPqM+lWPaDc0YbJSAZjQRkrKEV4B3Ee5B
	Wy1ClSKFZNM/hnn6cAbuY92z7ZSdXdPND58j0/IwKkG2zqkahrcYsC5avBV0bvGuurtu7xlbj77
	xATSSI8+uibQNJqJC0zlwxA84aCa5OJGvKXriNsA7psdiqnXaFrppseeok+voZjKDYua6Lq3Qqd
	aLxrK6j7u4iyz31pfqSDUWLKkevSUnU0UAVPAXZ33OpE9tfKFj4arnF5KCg2zPGwUdKicxE+S5m
	oNK7VclNuE6hf7M6GwNk+pb+PRSJUJOnwlzTzn9XW3kvBeCeyr6wrb3B8D95ZCQwhY5Y/UUKpQv
	IbnhSWPlul629judO+stun
X-Received: by 2002:a5d:59c9:0:b0:472:edc7:b4c9 with SMTP id ffacd0b85a97d-47f2dce91aemr9957535f8f.38.1783942849218;
        Mon, 13 Jul 2026 04:40:49 -0700 (PDT)
Received: from localhost ([2a02:8071:6401:180:d892:bf43:a0b4:83b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9e4d6da9sm85394652f8f.12.2026.07.13.04.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 04:40:48 -0700 (PDT)
Date: Mon, 13 Jul 2026 07:40:47 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcontrol: drop unused cpu argument from
 flush_nmi_stats
Message-ID: <20260713114047.GJ276793@cmpxchg.org>
References: <20260713090010.2991906-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713090010.2991906-1-guopeng.zhang@linux.dev>

On Mon, Jul 13, 2026 at 05:00:10PM +0800, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> flush_nmi_stats() does not use its cpu argument. Remove it from the
> function and its !CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC stub. The
> caller still uses cpu for the subsequent per-CPU rstat flush.
> 
> No functional change.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
