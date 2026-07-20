Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C6C3B38B8
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 20:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784577921; cv=none; b=FjykRBLjdCed/iiaKvqNehIBuh9NKRkYwp+onpNMQ7CxMKg2E3nDkysgYvmYarFMpZBWvW4DHpx0pcz6My07JVDuOcA4SWne7IUKzik7aBw9Bbu13Nai5YKpf1GlnZ4WgVYfswxfPBvbkgG//A8GEKlLYrPWeN1hI4dhysHlV3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784577921; c=relaxed/simple;
	bh=1rjpSQ8mu+YON7kDziz+Eqqp4mTUxp3NIFQjmqIoKtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=njgjQ7g2kFgre1obVL4tyzxtKqc4p0xgRswqmDLZlIzmykv9KIAn16OpQIp0J8BH/VZJmB6AnIueDAMTG1IqnVZ0juN3f7pfdGaASnuzS2KOk0BMcdYiPCcD7/YOpCeHxs45sxT30pMilr7bEZAuK0czeCNNx0IdJqGtMkFPfNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com; spf=none smtp.mailfrom=osandov.com; dkim=pass (2048-bit key) header.d=osandov-com.20251104.gappssmtp.com header.i=@osandov-com.20251104.gappssmtp.com header.b=y/hmaDAe; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=osandov.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20251104.gappssmtp.com header.i=@osandov-com.20251104.gappssmtp.com header.b="y/hmaDAe"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3860f32307bso1713884a91.0
        for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 13:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20251104.gappssmtp.com; s=20251104; t=1784577918; x=1785182718; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KYywQuRzpuUyQQKl8IkB8b6aSBOL9lUxtR3YJXQirrU=;
        b=y/hmaDAeo287ZSi2Hqtq0WnQlgMBAQhgOSVj+s3tc5ZjxqOOmicqwGB/dQt6EHM5tQ
         u7WAFhqYOlMp6rArKN5et8mnjJhXta00Thb+RuO0hxIvP2+qTQCX94HyvX837wId/plx
         bzHEUZxECCuVw16WaF4Wtdh6K2bfhLh1AzQRD+gzdn+/yg4FTY1LiZgW+XzP/OBVgRTb
         4KwUHjela//meQQoOXljO+vosO9C43OGpcuYKbh6cxKjPfs8eNDoIsV1f99Kob5GxIdB
         Py2XPwHoriXf+T5FxY1dQEn3IhmKtV03rPiKVSDCTcCX42bx7Ymjj0dA9Ex9IxaDvpZe
         cSTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784577918; x=1785182718;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KYywQuRzpuUyQQKl8IkB8b6aSBOL9lUxtR3YJXQirrU=;
        b=jLM8G0RjliiZ0hPt7wAEKlzxW7uhd5bX1zD7WmF3sXsVwelzLdbQ59c4ClAil91Qyg
         qj42KSfAqRyWmj0aoq2x8dLXvqLRe64cr1/dVYXvmPspHdAex71BaQmBaJ9EEzDh99F8
         PzoKW8OpQBEJ/7LmuzrNUUOYm96tShs+I7i/eeOZy3HmMt0LFGoWiuFD+91GEZo8INfC
         EB6qsajsoltPfcK/u+NYYO4asPZNi0R1agKIf0u5IB/ivjoqh4b3UXi7qDAM8OmiF+jm
         JDhwnTBKg5JKU8pZN8ZaYESuMPQDGvNQnmEGptdrBeC5s6C5k2HPix8Qw0rm8SUDF20Q
         0zGg==
X-Forwarded-Encrypted: i=1; AHgh+RojF0y3F2BmMzNnO7breEL4tCt0M1bElePZa32l5iAq5/yEo4aHUSDvbLe3cy84W6Zek7jakWJl@vger.kernel.org
X-Gm-Message-State: AOJu0Yywv/eP+2wRG+1fsfck4fHyaKcIwMMF5JlpwIaQKaPO2i02kDDO
	cnI5VE4eEladMp7mWhmdjqByupGP+Bkb7nVuPGMNQpIaN8RL1PuYEO59YjORhdkijF0=
X-Gm-Gg: AR+sD10LxzizcqyqI6JUqNiQ4EVn9afj3j04vrza9qnny0Y89ADUTTTzjpZbicqKQ4w
	DhRS81tjMiANpRlE1XCi1XHsZ6v3tWyxbtRvDZYxmtqyenoKUlzuCulTtvkipje+XyrUGh3sTV5
	SCW9aZ5f280H9QFbKxLUbgAYu505LSvb97phq3RpdjcKcsbtEQb/79JYx0Zdcx6Fh0lXo1jI+ia
	3B0BagmZtr25VjKhLFVMaNOL+b+q1CNSuvrnNq1ma4QKkOwrl6zh6A+3RzxBPbk5nc6/r5nwZhX
	zR5TcjwAsYDw6jM0kEfXBYVI0KBbZjk37hz1hpAbRMxJCXeILllmwV7GRAoey/gxEQptAb7cshA
	hFjoiNqRlocMnHePJ4RFNWoSWURZ3KEHOTvIa9mWK/QZ2J5KFHdqN7kzwzofLPg9Rzd0Int3xTJ
	BzY3SYWtFQN+Sun4ZD
X-Received: by 2002:a17:90b:58c5:b0:37f:eda5:516f with SMTP id 98e67ed59e1d1-38e9283cd0bmr318608a91.0.1784577917883;
        Mon, 20 Jul 2026 13:05:17 -0700 (PDT)
Received: from telecaster ([2620:10d:c090:500::5ee8])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13ce29e13a8sm33372118c88.4.2026.07.20.13.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 13:05:17 -0700 (PDT)
Date: Mon, 20 Jul 2026 13:05:11 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, arun.george@samsung.com,
	balbirs@nvidia.com, brendan.jackman@linux.dev, yuzenghui@huawei.com,
	apopple@nvidia.com, alucerop@amd.com, matthew.brost@intel.com,
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, corbet@lwn.net,
	skhan@linuxfoundation.org, gregkh@linuxfoundation.org,
	rafael@kernel.org, dakr@kernel.org, djbw@kernel.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com,
	alison.schofield@intel.com, jannh@google.com, pfalcato@suse.de,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	pbonzini@redhat.com, osalvador@suse.de, joshua.hahnjy@gmail.com,
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk,
	longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org,
	mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com,
	peterx@redhat.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev,
	usama.arif@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
	roman.gushchin@linux.dev, muchun.song@linux.dev,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org,
	cgroups@vger.kernel.org, damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v5 21/36] proc/kcore: include private-node RAM in the
 kcore RAM map
Message-ID: <al5_d2XCbaRBhqdJ@telecaster>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-22-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720193431.3841992-22-gourry@gourry.net>

On Mon, Jul 20, 2026 at 03:34:15PM -0400, Gregory Price wrote:
> The kcore_ram_list bounds its scan at the highest pfn in N_MEMORY.
> 
> As a result, private nodes placed above the last N_MEMORY node, which is
> the common case for device/CXL memory - is truncated out of /proc/kcore.
> 
> Include N_MEMORY_PRIVATE nodes in the scan boundary.  /proc/kcore is
> root-only (CAP_SYS_RAWIO), so this exposes nothing new - it just lets
> a debugger read private-node memory like any other RAM.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  fs/proc/kcore.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
> index 390547b992acd..f67194dc2a9b8 100644
> --- a/fs/proc/kcore.c
> +++ b/fs/proc/kcore.c
> @@ -251,11 +251,14 @@ static int kcore_ram_list(struct list_head *list)
>  {
>  	int nid, ret;
>  	unsigned long end_pfn;
> +	nodemask_t mem;
>  
>  	/* Not initialized....update now */
>  	/* find out "max pfn" */
>  	end_pfn = 0;
> -	for_each_node_state(nid, N_MEMORY) {
> +	/* Include private node memory in the scan */
> +	nodes_or(mem, node_states[N_MEMORY], node_states[N_MEMORY_PRIVATE]);
> +	for_each_node_mask(nid, mem) {
>  		unsigned long node_end;
>  		node_end = node_end_pfn(nid);
>  		if (end_pfn < node_end)
> -- 
> 2.53.0-Meta
> 

I'm sure this is the least of your concern with this series, but FWIW:

Acked-by: Omar Sandoval <osandov@osandov.com>

If everything goes well, kcore.c is quiet enough that this can probably
just be merged through whatever tree takes the rest of this work.
