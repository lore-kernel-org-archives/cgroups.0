Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5501F78E6
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 20:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792009852; cv=none; b=blSfQnnjvWa/90gef1g+aiT2mjJFCICog8zWSfTCpfIBb+XGCc6EcRG06Zu4J2zTU/YUJ20ddgO7Ho9pIUmhlgtTaVg+RSISnEu0ncThX2QJzsnD521LqCLmu3DEZNBEtK7xZb7p9YsxqrMlccJx82Jli8ZvfHPLTsR/xRU2XR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792009852; c=relaxed/simple;
	bh=PfBGSGCbAABd/YEy9xw7R6Q+FzWP354c+IfDeJO7RrI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UE1+PVwD6Lji71O2+mrvnnUCHJW9sMiIG/kJr9MriDD3aV80OE3CTC3FfHFUqux17GFs7//8syHyyCDl7OZ6hgSvQdBiI/v7Oh979ej99ewmsljY5VSv9eT2eVRD+eEPupMZ9ptZMygcURSbKzrzpIyTd7kkJXOQ7P21rDK5uUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=Wo8uuQSD; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="Wo8uuQSD"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-533972e0cccso51979051cf.0
        for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 13:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1792009849; x=1792614649; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jJ6C0cQbZi7DUkbDV+JTTS7gIU7UG7fhtx07+1Sej4c=;
        b=Wo8uuQSDT9UkIVXZvm0claCuQw/jn2PweLAbQ3ICbYk8FMg7FrUKWDNUmQldWSloWi
         2dhaB6YHPuE7BVMHg/VAiHoIymxU4jGKLkbigmX9AfCkbbS0L4LOXaIhygCxh1Iwe168
         gFljg9m+o90vFCtkXyguwpwxe7FL6MVbV5dID0Hwd2QMdmeHCgCH0SBgYNAXevOEwzNv
         mmvZIg/Bwga4ohk00tF0dNBdI0EWIFzkrcFeIcgwnHPdOVpNcvMxsTE455N59BbGsNDR
         7DIku87qJi3hDSQQRzv8jzzXW8I6lrKdM06A2bukM5nwH1XybMbSl4pl049I8LOOWZ1s
         SWzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792009849; x=1792614649;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jJ6C0cQbZi7DUkbDV+JTTS7gIU7UG7fhtx07+1Sej4c=;
        b=w96+uEQK+sbpvowFgouCfgKrMQniuR8PiSAW8bssu0dENVgiWcj0y7HVQ7dXCOeazv
         f6bTCENwrxjWoY00HD8mENhB/2WBoVbMhJMsSr8b5l3Agkn1QNx3KROphOVjlDMsDaCS
         BGR9PHDIruwgQzFVxquHRcV/xidBoIVpj4dMFPLMrPLTshg7ua9JbHSTw2AZNbnIFJXQ
         O/SLWlUzyN8wqQC14+YqUPaFQ3Ziusn8L4Fa2u6tuij+iUvRH7FUCl/UmriQYEyUR8az
         lH58XyxJ1OkRN9LtlKnGLExVZNetaeQhhWDCN/rJPhyu7lGiAflY05HoLvXmCs3F82Is
         uxAg==
X-Forwarded-Encrypted: i=1; AKwUvBy+Si2qplJ1bZ8W4Y7vgobG9oHWNStPhbvhREiXgcf17L7+tJ+0Qu9Uur6XgLampzJsptDIKt9c@vger.kernel.org
X-Gm-Message-State: AFq9FYLlLLNIJLbqJVy6XWse6G+nWHr4wf6VkGlztkJSUrW9q80i71Ww
	QANv6ojSM/U1SeAo/FqxGrOZK4uS0GJa6nAKOPBtKtAmijWOG0UL/l1S5zO+de/ZzDs=
X-Gm-Gg: AYBFou3l+2cn40mhND6B+bA6nBKhAto68dAvY4m5FsIG2Yqx6T+xZeE8N9lBa/xvO2k
	FPFhIgUJzMFyvVMBXi3IKkKFXimNAYW1dvitBQrOJlriwcDBzAGx8qZtXV7qao0UQ8ptJrzlw4B
	egOLXVT1Bnaq8qygswX6PVfG40gnE4qYb7pJMwSvEv7vCOVGA8H6rbPWgGP7eNVtDjR1IrTWTTG
	h/SD71t6+FDXm3YE6oXkhxUnjIyB3wDHN5fJYenZGHtMY/6XF0S9PkC3psaTPUl4ZRb95O7mJ/r
	KzQS8Mlz7zZluypU2Rwv9FFHf8ET3qDXerm454Mdo52wkeehlYEc25mqaYlJksKuZV5qZ0YdPxf
	Boaur7tdcdm9A+XTSAxZgklotDGL8vlOcdyHqaPpAZxAQJikEV8bbfe2SjdDE1vpTEvJTg0eGID
	QuztTDNTDqcxtv+A1bRNzjXcDx5Ipdz+nnW/zTYmY7FXkILNjyZGxy3T7EqX4dLBsZF8CQ
X-Received: by 2002:ac8:610b:0:b0:535:1b18:20f with SMTP id d75a77b69052e-5359fb287e9mr250799621cf.29.1792009849141;
        Wed, 14 Oct 2026 13:30:49 -0700 (PDT)
Received: from localhost ([2603:7001:f100:5081:9526:3c0:45cc:5ac6])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97bce2c5sm61949726d6.36.2026.10.14.13.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 13:30:48 -0700 (PDT)
Date: Wed, 14 Oct 2026 22:30:47 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: memcontrol: remove page_memcg_check()
Message-ID: <20261014203047.GE371161@cmpxchg.org>
References: <20261014-memcg-unused-page-helpers-v1-0-240b37c53831@columbia.edu>
 <20261014-memcg-unused-page-helpers-v1-2-240b37c53831@columbia.edu>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014-memcg-unused-page-helpers-v1-2-240b37c53831@columbia.edu>

On Wed, Oct 14, 2026 at 01:08:21PM -0400, Tal Zussman wrote:
> The last caller was removed in commit 90f095b816e2 ("mm/page_owner: use
> memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()").
> Remove it.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
