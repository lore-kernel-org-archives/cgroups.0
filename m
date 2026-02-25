Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49245396B71
	for <cgroups@vger.kernel.org>; Wed, 25 Feb 2026 14:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772030614; cv=none; b=oMuQC+s9u8Os4JmSKj/xjv80RVf2NqGmtg8qtn4kv8w0gUbk3UKJO0UmGykTFFVT+BbGXe2elFpLKtD38gefeNxz7xkWcGPBDfXMcJ/AScCGU8vBM16Z8Ds+3gXDdhsqUn9sxWu9jNJXrojGg/vAh2DWFRfupgui+VJ7jV3VH1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772030614; c=relaxed/simple;
	bh=JHk303on0tH87FgVMmdu//2A2EJ68pOsAbk2jtfSs8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jJkKL6ZxTpeGmpXUieFBAC81YHJtBZp5Rg5TqmD1lR7QAqQ2znXsMqoBB7DZOxOItZwra0r2MSGe0jV+WJptIVI6S2gfjxue5MK8x2Z09PfyMM/6mPusN2Yx/BwsQFt0Sfsad6fvu+lLQgBEksfkzeQufjHeIUtbf3WJuqoQPIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=t1djVl/i; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="t1djVl/i"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-506a3400f30so8545001cf.1
        for <cgroups@vger.kernel.org>; Wed, 25 Feb 2026 06:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1772030612; x=1772635412; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=foY2Y5omQw20sTq6/J6XKrTrTufvDv+fOLstkti1G50=;
        b=t1djVl/iPQRVN8ydau/gloFLvPYLeBj3NAQsvuTSxKRsGcVR7pvgfrO2YsMihEAT48
         ey0ZOV9tfblTcVfcxp0ZYCZwczuWC6f1ARjG2e5AyNw6PZWaXTVN7Q78yd3iMQ9od4kv
         DgIyK/i454jAIPPyAJCu3CT6Q05qxMz076L2GDn8nMeTXUfheiAsDDgqbtT3OkUlgiRR
         LC/5UMLHmWCmJUHaCeepzNeRD0OD0JgA3BjeVCWDIBOBRShvs/agJyY1xZNeBrye+jih
         9lyJI6eJ0VW50faAzl5aepCMhFHMXWFW3uXie3yvGX9sO2d7CXrnE2lgfrwRa1XcaVP/
         HtLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772030612; x=1772635412;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=foY2Y5omQw20sTq6/J6XKrTrTufvDv+fOLstkti1G50=;
        b=bH6OZkBlxPVDVjE9QAqUd/x8iW2vZQsh6gS0VDcxgGLUreUoGk/QxxrF4+mHIXB96b
         5YAooDVxp3qb4E1kA68Z6PRIhxo9qEYLCdmcqE8X9nKa62uLgP4v7cKWSg8ER/CaRsOB
         bNgCzriW6Dl2lBXGtZbi+q/cSb0YO+QVhC398cNFnL9UXoaFkU3736oJbRaqcoXqbzzv
         1CVCv140GhEVvTFZ5eLT4gM1bEnA9dv+FEgaEc0UsnB9fWH8SNXwXolZcRAVDi5ISH73
         Gh6945/9BUs8aloN3Njk4kQuXGlikUBmoN57Jt4MI3G8Q9KLDlwOPV9bj6vEJsGjLWb2
         +d9A==
X-Forwarded-Encrypted: i=1; AJvYcCUzlwpek4g9uqjxy8LkwH7mol4Fc1/Memq9rz1PMvAM+xdUgmV3/LZV2rKJ/Dd54/9EvBz4kfx/@vger.kernel.org
X-Gm-Message-State: AOJu0YwN1iMsZU+jtXkVKoRABx8BlvxvgKXlYSvo9ynrUh1rd2ZmzBfF
	OX9Q5ptabJeUjb0KEvEmHROWbqn28PTrlohbzQ/VuBxr0SY/1QoFvoEOR73yAfOFh1U=
X-Gm-Gg: ATEYQzwwFt7JPgWkMHpznOsOFUuMVt3i+Ko5P/Vn8uC78WZAHGQ64E0kKBv3sMNyZKP
	u+gXpNOf8prUQhKviqWQT7UagV3u3+hOaY+ySWnG3fxHDRMj6t7hLRXfl5bkP8zdaixAZXk1xlX
	ymyZdmp6UMeUCAmIZWCRzxsQd/Spgv/wuoET3doBpVCQoSc8dgPA6vWVtGiM+Whn1oaZasxXzNT
	9osMyE5Qw4xw6HVcaJ3F11xCWgAs0g2YZFgwO7INrl0vv3jWIcqdYmwES6OE1mHrq350nnTOiZ7
	z/WsPXTu0vpVr1X8Mnfj1FgkTcmjGszBUzUxOPOMhSza9Re7pd+0geaEq1sfQDTx01B6iXuGM8j
	wUH6Eg/J790sJswECwr4ekzSVWNrUBJp7JEqHKVvSn1MlJxvKeWmjvAiAAk7P3sn5Qt0sc/d+c2
	m0k6xUWI/9cAPKalADRiQVzZUf5R0iG/00N5fUdLx+K+dzD5o7L3p591xdtvBtxnIivsJTW0/GX
	D7hUB9ju6hkKHxdb8lG
X-Received: by 2002:a05:622a:1453:b0:4f1:e79a:1e0 with SMTP id d75a77b69052e-5073659bc05mr41895291cf.20.1772030611934;
        Wed, 25 Feb 2026 06:43:31 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d510a7asm123124661cf.1.2026.02.25.06.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 06:43:31 -0800 (PST)
Date: Wed, 25 Feb 2026 09:43:27 -0500
From: Gregory Price <gourry@gourry.net>
To: Alejandro Lucero Palau <alucerop@amd.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev, kernel-team@meta.com,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, apopple@nvidia.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	yury.norov@gmail.com, linux@rasmusvillemoes.dk, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, jackmanb@google.com, sj@kernel.org,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, muchun.song@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, jannh@google.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, pfalcato@suse.de, rientjes@google.com,
	shakeel.butt@linux.dev, riel@surriel.com, harry.yoo@oracle.com,
	cl@gentwo.org, roman.gushchin@linux.dev, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, zhengqi.arch@bytedance.com, terry.bowman@amd.com
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
Message-ID: <aZ8KjxdPS077aFcq@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <b704b05e-3e65-4a73-84c0-21557b0cc38f@amd.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b704b05e-3e65-4a73-84c0-21557b0cc38f@amd.com>

On Wed, Feb 25, 2026 at 12:40:09PM +0000, Alejandro Lucero Palau wrote:
> 
> > /* This is my memory. There are many like it, but this one is mine. */
> > rc = add_private_memory_driver_managed(nid, start, size, name, flags,
> >                                         online_type, private_context);
> > 
> > page = alloc_pages_node(nid, __GFP_PRIVATE, 0);
> 
> 
> Hi Gregory,
> 
> 
> I can see the nid param is just a "preferred nid" with alloc pages. Using
> __GFP_PRIVATE will restrict the allocation to private nodes but I think the
> idea here is:
> 
> 
> 1) I own this node
> 
> 2) Do not give me memory from another private node but from mine.
> 
> 
> Should not this be ensure somehow?
> 

A right I set up GFP_PRIVATE for this

#define GFP_PRIVATE     (__GFP_PRIVATE | __GFP_THISNODE)

If your service hides the interface to get to this node behind something
it controls, and it doesn't enable things like reclaim/compaction etc,
then it's responsible for dealing with an out-of-memory situation.

__THISNODE was insufficient alone to allow isolation since it is used in
a variety of scenarios around the kernel.  v2 or v3 explored that.

~Gregory
