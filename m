Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795374696;
	b=pTpPLmBmUXhAvpJnFH81Zhepfe8uf9vsVK+PlHmU0NquZKbMLgRCh4o4/D7yOV6BF7Td
	 Dw2cckY2Gep32nwLQ1M7xMLip2eYHSJ59zTuYsjhZaWv2JARqpRqtXOwIvzsgysl5iDH9
	 299Zy5pHEFtWDNMmxzu4LyQLf/XXYxBfWUSXcK8yJ6rZXGPqf6RRCfrH3zf9Kl+9r6WIv
	 giqeQEM99LVp79SCgCKXyOH52gQ81t3pEvqbuleV8+9wDKK8hqikeSpfLJx5xaKf5dcxj
	 Ow9+IlxMhOmvSQqvpn6EcTUcyyBpbzfOvi4J7xe5X5JnkBofl668WyEC3BBT8aRIhug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795374696;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=oGsMa7wmHQHTRJX2QekmD3Y6Ja6uGmq6iEm7evLlQd4=;
	b=soOwVhpPXfDCjWOJHFDLf/bHJuurp6e6qPBkGB2r6iqWu06MKp56HRf43pz/P4u/Qk5u
	 r+jlcoeWLiE0/PttOvjqrl1IwHTRut9qx+HwYAZ/hfej9Gn6nR3V3slxpTYKWyuOZ4GaS
	 aHvgDUVK0rChtFvVkNwo6wcA1cXyoNVKiBG93Fjp9Qtv3iMrgTTvaEHs4YXqja2ojsqRL
	 p+kpXV+BKxHWUvJiVyCdDttLEFqzqgxKT8klvgidmDxOwlevurfR2JWYKilJBOR9T8zUH
	 zUNssuELttwAwfv6Uxek6knB/jxiadO85jtibCh4sRLe9mZZvZVjvC649wwr8AIRgoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=TPI3MTe1;
	arc=none smtp.remote-ip=209.85.222.175
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1D7606A339
	for <cgroups@vger.kernel.org>; Sun, 22 Nov 2026 19:11:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA1D7606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=TPI3MTe1
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-949680e6d82so320848085a.2
        for <cgroups@vger.kernel.org>; Sun, 22 Nov 2026 11:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795374695; x=1795979495; darn=vger.kernel.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=oGsMa7wmHQHTRJX2QekmD3Y6Ja6uGmq6iEm7evLlQd4=;
        b=TPI3MTe1RlG4SmZzzoCpRdy2QVmmqnbO/w6aR5KNMokJV/Ej+uAFQG7yAYqk56hfkq
         LZC9wKLhxk3NMVRMaR1VvWVuCxA6GsIEcwsr6le7u6bdoCGonrAZjK3eTkxOT3nRTyMs
         kLr2KYSGk0Kdl3U1jn7zVe/GjwSTB8XynoaJu+1hSecxlfaiVnqBhg9qfE6UcOdBFpU7
         K6+K542N8Cf/GVSasbtS0zq1zF4T0u1FTMwtPGg2hgdtwvyFLiHHyHTH+dkRxgJO3IEQ
         VpIReU6i3uKk4uALa/TFB/P/g7vgcldffZQ51PdHza/mx09Vr+vtrjEp2lxRt4rjm1dE
         cSLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795374695; x=1795979495;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oGsMa7wmHQHTRJX2QekmD3Y6Ja6uGmq6iEm7evLlQd4=;
        b=0r4J/68X5/ReGil46XuIGLHF5TNlZ5/0hZv0oznoOG97Ji2zN8aNjejbWredtuz7yS
         ViPPK9+0xrKNIjCdy+5+dWEP5k5PXvItzirIftlffVfIBDSSHIifG2hg5SRFnVxOL1kO
         iCNN9vpy3VIQ6c14Gfplk1UVhROLE8dd858iznfAdYdVYCnvay5InVIGQ5vz6ZXurwBR
         DaJDuxFyHj8PozI0G6tQir6HNH/+xK8HWsfzssfKoIYKn7x04d80HzoNJtAiD+2cDFp0
         +jmEwraPJNoOtyB7SodNz6d3kZ7eyTyZ2xuXqq99T6yprjFE5oXgBQxpukBOy2YhTZza
         B2Gg==
X-Forwarded-Encrypted: i=1; AL+hErENK9CbgEVfPk3uWMDFNKBsVkIx4EvwOkzaWa5o1lxMAOLVy/U0s2Y6Rn2IJv6cEmoJXGc9fK/Y@vger.kernel.org
X-Gm-Message-State: APuU4Z+fWSZSpNE65S2dOApTzge3c2lHrsEXn885hG2SUbUwdAUEXSYi
	l5A6QKqkSY2mP/TwX2mTshg63jtA0yJvRp97wfdfB4Ik9uWQByO154+JpDToT4Qp9ieiWA+XTiC
	NVy6+
X-Gm-Gg: AZFdTZcAzCkkyqZxv67eDgR34Nb8jJoCe/vUm8wq21QVyY6jmGGCdJDI6DrIg7Ghmfx
	PUF8lNRGIaPr88liMxN+p1HOFRpBGU5UEiuxDg1TRswArLYgN5p8qE/x8F8uIUIfYGVXWgQ4RRY
	9zlST/MejBCkVKn1baR2LI1BEfME8Qy5fj20CW+mz3PNCYOPuPhT2Lt14hj37dQNbnTHOi1D0VO
	FpU+3ydHX+YFI9GcwYrz8V6yWVIg6oBN+0c27JE3bwgldWv+ep9w6/9qXR/MN7hg8XRBC0M2Uvz
	gs1du7sxnO/I3SJBg8ch4U4KVZOqxKwaUJzjCsxfHYUCuEyayg6e6B+tW/dwdbiIt8JQ+7Zn7e9
	7s37cyTPvbo9Ux8S5VEWVpGMtplaPMAIW5/tzUhJo0n1mEEmHlqC1THqUOY1HN+N/0GcUTDP3RF
	BqI/XsJ8wM3YhZfegOkhSUpJXY9J2h7SOKqoEjkQ0nzah8TmM0OZOEReRmfH0or4oM9k9lmeg76
	u6Ec3e9chH6bZwo+lwn583BKbBlZ60Pt5OlUi3W0EZgao9UFoH7MpdXce+KMtHCvEB9vS/5z7vY
	OvOu8lanJdYrPkiUPMdLr211wVpjzlvjnrWuult/9Dai1cAZ6S2HILpps2iaoHW64IwwF933EMx
	JMf422Yg=
X-Received: by 2002:a05:620a:4727:b0:949:326f:bd2b with SMTP id af79cd13be357-949ba9aa37amr1639379885a.43.1795374694656;
        Sun, 22 Nov 2026 11:11:34 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb38c903sm651828485a.19.2026.11.22.11.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 11:11:34 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 00/60] Private NUMA nodes
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Yury Norov <ynorov@nvidia.com>
Cc: gourry@gourry.net, Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org
In-Reply-To: <awMdeK8O-5mffg2m@yury>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <awMdeK8O-5mffg2m@yury>
Date: Sun, 22 Nov 2026 14:11:31 -0500
Message-Id: <179537469194.412063.13456998694958645706.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-11-22 11:51 -0500, Yury Norov wrote:
> On Fri, Nov 20, 2026 at 01:08:51PM -0500, Gregory Price via B4 Relay wrote:
> > This is v6 of the Private NUMA node series. The series falls into four
> > parts, each building on the one before:
> > 
> >    1-18  mm: introduce N_MEMORY_COMMON
> 
> I walked through this part, mostly. It looks like you can substantially
> decrease the patch count if you keep N_MEMORY meaning unchanged, and
> add another type, like N_MEMORY_NOALLOC.
> 

I don't see how this would reduce the patch count substatially, you
still need to convert existing N_MEMORY users and need to differentiate
between general purpose memory nodes and private memory nodes.

And N_MEMORY_NOALLOC is not a good name.

-- 
~Gregory

