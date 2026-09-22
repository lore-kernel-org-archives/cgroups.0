Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020E12AD03
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 15:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790090453; cv=none; b=rmmzSXJQInGp86dBDbAqoqYaOYv0XGH7GELo2FDCWQj7QQO8NtpqiZ+YbOr343T+4l/hJ4WtR+p6PVXPwCfGaq+aTSDfB2OvDDCkMLuVUe9PTWzirBPxViXQYKNeWJjq1VDCOVpM75W4xRXUytrNdeyqTYNWkr/beHWfHlC/CAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790090453; c=relaxed/simple;
	bh=vOwCSITAZ4wT5Vmjl5c2eUZEHU4ha0KsU1gy9XxWQ5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dtXf49qqoxRwJOmwgyrWw0rhf2BCsQzhDv0TmlmTUPYnTAz0MtMtwzcHuH+db4mbaCWOOVfKLKMDcnGWQzmHhAjsK428ARnQ9S7r7k1Eeho0QtvGJPY/xP1DBC+Katcohhe39CNMqYtCUmw0FHpDp0ThlK36RRs/+IvN7Cz1n6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=kdYQvB+Q; arc=none smtp.client-ip=74.125.230.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="kdYQvB+Q"
Received: by mail-qk2-f43.google.com with SMTP id d75a77b69052e-52fb76ef19aso388651cf.2
        for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 08:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790090451; x=1790695251; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1GRx/g24FB4lP9hKxncW6XGKAeFROn+FyWjD+Llh4VI=;
        b=kdYQvB+QGHhWLiQzl586f/42jWC6ZmqItihk9aTPXP0fewn2OC6mO3hx+a96AWH2YF
         UpVANBki9wUUSus9JKurukP9JQVt1a9Jq7+CTG7fHmkKSRb6SKa51og3FJQfdFnQZU7c
         7QeL045HHnvFvwLje1eEw2C5SzOJ0OA0O3dU76yIUPBd3SQ3LViRiBclHs7gMt6EuBYU
         lpPN8k9Y0KV7RN6INHA05gGlLhvdAuyIKi8Yq+uaZPFjnFQbMTBqVPkPWcT2fxScHuw0
         oWSnLNzgS9DzPRifOHiE4OBbTrIGpbA4ty+RyNMBt6Cm+KW4gPF55djQ8nqrtZbB8a1+
         DlvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790090451; x=1790695251;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1GRx/g24FB4lP9hKxncW6XGKAeFROn+FyWjD+Llh4VI=;
        b=VuGhvn5fRebA3hycU8ZJD1SoMEUdK/JPwETljSJCh5Xf5+huz4hzOxy5Ct1zK4oq2W
         AdhYaS8U+rHRv+CYZ65VkP0QxupUt3JXXMN75C5fif5Bp/s5hORT2Z060lsnJ0uIbSuU
         t7+UZUndhjVYdhiPbwsxqf2k5UfgxBnn4xxQW7rOj0TDmPCl9gQB/7PfFc7Rypg/5mS5
         053Bpa3rvReUZA2tJaXi7+4M/3tMAjLSh4cR/gwJXQtoWvIriPnRdEj4lnpm2+Bp3GR7
         i3CbSh1xymJSwg4A4tBkZRLgNjmbSEFDT19EYuWEnMkyFgr6FLNTxHTB27dMdHIpQlK2
         lYiQ==
X-Forwarded-Encrypted: i=1; AKwUvBzujI9J2SG1vGJI9Xq6IPh+gm9L2XuT+ZLaZ8x67AwD/svGIa+ESeE/aalGKObkBDgeXL6shZ0j@vger.kernel.org
X-Gm-Message-State: AFuF++nYhuSmD7fMJeVUf7CtBURNrsKJlI0CrnkXy5LE4mqOKzuIEeTw
	s2D5WlrxtlHw11xU+lARL5hsHH/Hy0voT+HSIceOX+weWDvNM5VCf3IGr7ZJ+uMWCGI=
X-Gm-Gg: AYBFou1RfO5EZadxRzf5+by0riNsvpKtG/YFUzAPtfcO5U1QEiRwsvyxPRplU0h4rX2
	0HHbBTID7vK3y74RmmXGw9Ywlq3tsY+vB+DVrKi+ZP6hCrgo17rDkboGVa4E9ST4R+IQLfPS8A+
	3Ox/SOKeRNwdICf7FTl4B+RN9ecDzMKdDmfGh67HUd7+BUYJ675NlNoUWpyYxFM+hyX0o/1rikY
	1V6OUi9TCCcFFvc9dLMbV2BEH+mTdXMVki4o4juU7AmHjt73bekWc31/uqMFKsSPUQ195Pcp3e4
	U0lueVDLvYBNJ0gMaxFdn13QgTVI7/1vyGgj00lJi0X04g1oDUC4qNCVd+DsHKI5QFRfUJW+IG3
	DQFr5Jk81YXdhGoesgstIm/msOmy4CasqVAOeq9CjtNN8qJd4w2/X+H3I551dI7ljBbb5aOGTSI
	LI0aBtmKUq1fbTYLGkoAhyXSKKB8Yt2KaNfmD0GQJQ8nI3nafdIMb/KCWchhddt/M0qrBBbbzKa
	ROGb3YG9YR4xeAycncmLzRos5C10807xhuPu1YjOZAHo1QYUUYbU9o=
X-Received: by 2002:a05:620a:280f:b0:93b:e9d2:5ece with SMTP id af79cd13be357-93c15e412a9mr594708785a.39.1790090450524;
        Tue, 22 Sep 2026 08:20:50 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c1cf0dcd9sm181244085a.4.2026.09.22.08.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 08:20:49 -0700 (PDT)
Date: Tue, 22 Sep 2026 11:20:47 -0400
From: Gregory Price <gourry@gourry.net>
To: Chris Li <chrisl@kernel.org>
Cc: Rik van Riel <riel@surriel.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arKbXe1Qe-FDCTMM@gourry-fedora-PF4VCD3F>
References: <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F>
 <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>

On Tue, Sep 22, 2026 at 03:32:44AM -1000, Chris Li wrote:
> > Right now it has 64GB of memory.
> 
> That is exactly my point. You are running 1/8 = 12.5% system ram.
> 

Chris you are missing the point

Zswap:           8812236 kB
Zswapped:       24927876 kB

To support this, you'd need to know you were going to get a 3:1
compression ratio and allocate 24GB of storage (24GB of swap slots).

An hour from now he might run a workload that's 4:1 compressible and
there would be 32GB zswapped - but if he'd only allocated 24GB of swap
he'd be limited to 24GB arbitrarily.

On a 1.5 TB server, that number is oppressive.  It's 192GB of
potentially dead storage space.  At 1 million servers that up to 183
Petabytes of pointless provisioned flash if you know that most of the
memory is zswappable.

You're focused on the wrong problem.

~Gregory
