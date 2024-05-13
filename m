Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FB41CF8B;
	Mon, 13 May 2024 17:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715619669; cv=none; b=lBLwMaY16A+RgRR+byMtrpBB1OPCsRTnvOkpg9qPDbYKEMtXRqvD884NSWvfHY869j6Dr98jG0kNi0JsRDGer7K2dLG67BHck4JHa1l9Dkribz9COV61z11DTjSPldmqI3vbDo0iscCC7vOe/c3T0EfBodcujvGZRldjvGTjRFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715619669; c=relaxed/simple;
	bh=z4tPhX+s7QYkqBxhFqtjNDO8qlvAQd0ektMTJgJI2Fk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sOso+Ss4t40MqszqDVFNZV+O0kZh/bECiu592EWrCT+eLWY3DnqoTR2KTJBxb4/hxTcbqeNdMQKfQALO4+ohaWPMxwYt5Jr81gipQ4XBC2Ki1HeVtsjDBzCw8WitHZ/Vhw2Chdl+t91E7jH41tiSKaNgT2maZaE22B6Juwy6mrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ytm5Iiil; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ytm5Iiil"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6f4302187c0so3834987b3a.1;
        Mon, 13 May 2024 10:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715619667; x=1716224467; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zjyrbOMAEeAhSgORyPVPJODgsoTk91oJWHq0SRUfKJw=;
        b=Ytm5IiilJN5XCxh4dQiqK7NnUl9VTnEYgVRoHNhwJF+ewSiGGLhKrWKM+cV0mxx7ru
         daACmw8Lh6dIE802gb7YlaCiDTpBVKDjWHnYxqcNL979au9DCAd0XFFqZK7XwLTbyHSg
         6BndxUfP0Io+JlhLt/Xt1xWWGpsHSy9z0l+92ahfTSsUImvSnZaQzaTvZOMUT8DUFskj
         sFKW5WUyHb0rxXCnB4sntdYYIYrk+hE+0IVwBTROSV0DgrbtTflpraL1ZWSvC30ZWzYT
         JwhaUO5P1yZ+r1vHhUlNwAr26IaAVJvVTvOISaOi+vzAoVTQKHxcKqwtfuDsJUHWjaEz
         PLNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715619667; x=1716224467;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zjyrbOMAEeAhSgORyPVPJODgsoTk91oJWHq0SRUfKJw=;
        b=OV2o65GvWLLaWqTjAs8AEskBSeQNt2gxjwgF17BSX38YOSsHaYYvk3w8VRb1ITHfut
         GRIjJmV8ZJvHjm7vcGoByUWF9dAn3JVQaGl2ay5HTbstTSdJQW2tM2L5uq8PUQ9/OcSs
         zU7o3UxQdbDGsO4ND1UxGHZo/GvCkLHDppVmLkJOto32r7AO7YpZ8Ma2OglQzVcfEUSF
         7Gvbh9mpfqNJU9b8mONTueWSU8HPBVX2INHTKh7V6uQMOmyl/u+HWto5oP+1qaj/4YKV
         LiZUXjWknpUrxuLQWX4tYUtNhv9dm5/MTszArBQTiALfa4g9pvNJ/pBpK5l9ezcjQpjp
         c6aA==
X-Forwarded-Encrypted: i=1; AJvYcCUItM+Shwb62ukm1SzZ1OoQTxXJm/8ubxTJragiazgrWZynuJOZxtUF89JdOu9W8/XX+7g5dqGTGPdOMclsFnKYnisfem/Mz6y+AT21VqyVGg1xI3E/bmw/vde4zhmC4BZDQITp7sPATMPH4OId60oWNOYfprwoH5asmschcJ596Y+M+WZNi2vLbEsunrsirvDj2hWJKiH0ZXtOejVm7bqf0w==
X-Gm-Message-State: AOJu0YySFrcoNEWqs9CjSa8jq55nHf+jBBNAvfcLGWHnmyxlgxWGtJza
	ebmD/1iYHVXv2rOUTYYHgK8RsGp7VDWgC7MuhasM05pwciDkN++T
X-Google-Smtp-Source: AGHT+IF+HKRteWFX1nu/JhxanTGlUgwXpxwtCzZP1u4kEXer1USTBTds1a7jqu3AuSmZCNS1jjqFzA==
X-Received: by 2002:a05:6a21:627:b0:1ad:7f1e:eac9 with SMTP id adf61e73a8af0-1afd1482da7mr15746264637.30.1715619666695;
        Mon, 13 May 2024 10:01:06 -0700 (PDT)
Received: from localhost (dhcp-141-239-159-203.hawaiiantel.net. [141.239.159.203])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-63411346d96sm6942717a12.81.2024.05.13.10.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 May 2024 10:01:06 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date: Mon, 13 May 2024 07:01:04 -1000
From: Tejun Heo <tj@kernel.org>
To: Illia Ostapyshyn <illia@yshyn.com>
Cc: Zefan Li <lizefan.x@bytedance.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] docs: cgroup-v1: Update page cache removal functions
Message-ID: <ZkJHUNILS4VLL_PK@slm.duckdns.org>
References: <20240507103426.544488-1-illia@yshyn.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240507103426.544488-1-illia@yshyn.com>

On Tue, May 07, 2024 at 12:34:27PM +0200, Illia Ostapyshyn wrote:
> Commit 452e9e6992fe ("filemap: Add filemap_remove_folio and
> __filemap_remove_folio") reimplemented __delete_from_page_cache() as
> __filemap_remove_folio() and delete_from_page_cache() as
> filemap_remove_folio().  The compatibility wrappers were finally removed
> in ece62684dcfb ("hugetlbfs: convert hugetlb_delete_from_page_cache() to
> use folios") and 6ffcd825e7d0 ("mm: Remove __delete_from_page_cache()").
> 
> Update the remaining references to dead functions in the memcg
> implementation memo.
> 
> Signed-off-by: Illia Ostapyshyn <illia@yshyn.com>

Applied to cgroup/for-6.10.

Thanks.

-- 
tejun
