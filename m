Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64718352013
	for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 14:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784729101; cv=none; b=IqSxLQshHSTuxPn6MRta6K64GwJgggw9hBimo0iwjvY4fMkmX43Eubk0qTMxEdMZnJJy2vXwITZ1dCenPlf+V/1LmtX7IelYpHRhXnGJ++0E5nlvQ3KCfbEMaQsOd2Cu1J+rW1mFsb9zYTW/pVEKA2+n1hb+DV6SFJ2Z3/pd3RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784729101; c=relaxed/simple;
	bh=BiKsszl+35xq/ewMPZzGz30tgw5kvnsmDpEO+3lG0vE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HXG8Dx0JMqfl6mqlqnBBOIsArK2pYQ5W90C0bqG1PGDBJerjJdymLdpOT68mb61nNCf8/S68S93+PHGD+TYGsMttwEnLOE+lCaGB3tPUyjyPzUEFHy1KZmRHjTlmtEQe77IGphXwJmLmZbRjp1Iz+PFnpp6nHjYRhxkw9DQ0Gi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=mrvhPX8T; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="mrvhPX8T"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-9305a2121a1so927086985a.2
        for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 07:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784729097; x=1785333897; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wzTopji7Zl+MAyFivVnXiZLO5KABEpd5UV02S/KHUTw=;
        b=mrvhPX8TYaW6OdLHwE1oVXsMQJLltg7gssKp5utqf/LuYMMymUzUMHKiHysM64pTuL
         L8ZJEzSGtBUdGHqeoUS/ZfnQohfr5G/UrhC/wRUH3KEFfdFHNSA50wlsbw2D2YHpykae
         ihCSsUC5m6IS7Fmjzsof4Ps0QyK2W/EjkS+7y09grIz4VVqpiGjn7sXKLdzKT/vQfG/B
         FoUnOSa9uvT9rWH0HIZMJpxdrLvtqqPMzscmxRRoeGPXyeBHamY6dRkeIHPPOFi2zbom
         3sQoKh5VsE/T35TkORWJZ7BdBRwCVaEy85AwnwuwDRQCD5ybGnugX0rapf/PmeW7sZkw
         vl+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784729097; x=1785333897;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wzTopji7Zl+MAyFivVnXiZLO5KABEpd5UV02S/KHUTw=;
        b=JiOb/rLwhFRUvn1xGY85JIeFsg1gx0bCYA4FhMlkyt7gI4J6K3yK30iFYPQN/AZG7x
         GpKF/cL58bkZu/Pe/3tBu0zhhxenMkhu9aEn3rzTXBXTmUJTWHHh+aHs8Tm3QGKGibvp
         kaUafhvZDFpwzqwJ+PMB1aC09NjAQpLc4WPe9rkrEkQ646OarN+YVMzewREIqsyuYFNi
         f+G7NO67OFoKN4/LqAJHStQvONbJ8WsFubGdx3D35rLMUiAjB6MmJWOpzY3wjU+1qgf/
         GR4GJxYbltTwBr8KA4v/+f0l8EiUHOoxyHcbF4If9QcF7Lpy86Wx3lEIktZKctkLroef
         hkaA==
X-Forwarded-Encrypted: i=1; AHgh+RqKvYdVj9TgYu29krkRTSoWD0oVsGTkFoLJ9oxCEn/45ovkHvRVKSuc7nMbVBSqnqWXuXL627M8@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7/MvTcuRdHthDUVyrsYiMKXx6f6CwwSpu98LvmX3hgqEWiD3r
	GXvXCUCKVV0g9+bsCNMur96LnH3Md2mlYSnhPqvM7/ReKn9PsvH2XjRobwHxCnSqtts=
X-Gm-Gg: AR+sD13CD4I4kMISewAOvH1Bz3fJgZlDSAQzZ1AGcAPAhjHja7ExON4J0FYntZutsuN
	14Sr8Xtrh0SztQHsrYmHQoGdbxvcgAElOR2Znno0iyNYDTOmyG+DLx/Pd8Y7b57BkwHla7r1MU3
	3tlOjdWc8cuiU+3GYxrhBRVpfX/PW0yAygoCn2bWesKgtjvmboqc9HXHK0W/ffNZSE+irCcGvn7
	skrXWKHDUbu3Hbd1OKei0gjD+SdNKLyrBza03+I38coc+DWDq6NzsT3u4QTwmPRkUvVz25HK6Vs
	zUjE1oaVJOofzJCbJSepXxU5wZc9kdQXNHuhhuMt2VFnodVqbGvCiTw49sym8mVztRlnTkkYuvg
	P6lqYWMhCzzTzcKm6sikH0Ec/jhsmxG2AlfXy9pxayLIz2/2ddQmaRXE7C27Pgx3lZLUALx5hkt
	3FXJ+iU9K5qWQbsgrzFDd80rStdh/N/JEtLvEz5LJsWX+MU95b3MXOPSsL0g==
X-Received: by 2002:a05:620a:1992:b0:930:f7ee:2cf5 with SMTP id af79cd13be357-930f7ee3792mr215753585a.66.1784729095553;
        Wed, 22 Jul 2026 07:04:55 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930f68d5d6dsm171863585a.20.2026.07.22.07.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 07:04:55 -0700 (PDT)
Date: Wed, 22 Jul 2026 10:04:49 -0400
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com, arun.george@samsung.com, balbirs@nvidia.com, 
	brendan.jackman@linux.dev, yuzenghui@huawei.com, apopple@nvidia.com, alucerop@amd.com, 
	matthew.brost@intel.com, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, djbw@kernel.org, 
	vishal.l.verma@intel.com, dave.jiang@intel.com, alison.schofield@intel.com, 
	osandov@osandov.com, jannh@google.com, pfalcato@suse.de, jackmanb@google.com, 
	hannes@cmpxchg.org, ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com, 
	linux@rasmusvillemoes.dk, longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org, 
	mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com, 
	peterx@redhat.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, usama.arif@linux.dev, 
	xu.xin16@zte.com.cn, chengming.zhou@linux.dev, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v5 28/36] mm: add NODE_PRIVATE_CAP_HOTUNPLUG for opted-in
 private nodes
Message-ID: <amDNMmbdE_ZhUgl1@gourry-fedora-PF4VCD3F>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-29-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720193431.3841992-29-gourry@gourry.net>

On Mon, Jul 20, 2026 at 03:34:22PM -0400, Gregory Price wrote:
> Add CAP_HOTUNPLUG, which allows memory_hotplug to migrate a private
> node's folios for the purpose of hotunplugging memory.
> 
> Without this, hotunplug fails if any folio on the node is allocated.
> 
> Add node_allows_hotunplug() - which returns true for any normal node
> and private nodes with CAP_HOTUNPLUG.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>

after this question:
https://lore.kernel.org/linux-mm/al-pkvmgIxGu3LzM@gourry-fedora-PF4VCD3F/T/#m5b8166212a276fece2380f2dd03d6864375a576b

and some off-list feedback about limiting initial cap bits to active
use cases, I realized that this CAP bit can be entirely eliminated.

hotplug notifier callbacks already allow a driver to prevent memory
block state transitions - so that control already exists.

v6 will remove both the filtering here and the cap bit.

~Gregory
