Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795201148;
	b=G7eIFGDIo/yApR8bMizQM+G9zcxCez0Hgr0DGJIkerySFWG6DM/geovLEysK1BQl/2pI
	 BdhuNpe6qCi4SUDQHeBO0iPYOPynGAJR7SGIVlUiOhCVF71yJoEF0M7hIoTfpEqPkHGK1
	 rmZ3/T/IwzFYlb79PD36qmdm3yPgUSQak/P12ud9qxeberevGtCW3Prbs1XEEyxCZ5GLQ
	 gXH4sbvh8dhhN/7nrWB9AheMsZUjmPRrminICZZF8HcPsOUxLZYEsMtnf7QdjRmCiiaCd
	 4AUjmLnMkinVYFzH9OkPU5wDHRPxca5kxE8C68Gne00E94ItYSmWwH9MzpWl3W3+23w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795201148;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=QpjWV7nVPK4jNL88HvKbtHJ/44FkOvQPFo/KHrxl1Aw=;
	b=YQ7RsGVmlU07fsQ7JLWsy5N+6ANB7nyrl8RECokYb5ZSumZQGiTYnqy40MC06Km+pKrr
	 mGFaZAPdFipjKwGg7nrFgOwAgfA6WsspQ7t3sB3z0XZTBX6CTPR/z58ewV1rqdR3i0ZiS
	 ayONA4Y4GBDU928LNXJub/YwmZB3hyi+JBlT7RM3FU1U/vFisKs3e/k29lf2khXRywYVu
	 nLnbB6m0pcHLr85EjXCstCoKRWsK7daHp0jnONGEYnv5tfVtzPPf+gXcSoJz/3hu2wVhh
	 7BpzMQJuuzKOCfVzIu2OCAli8ekP6rqJ/UBYPvDCxCR1ASIoJJpn4vemaKoVXoilhpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Na8SXjJd;
	arc=none smtp.remote-ip=209.85.160.176
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAAB60A2618
	for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 18:59:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BFAAB60A2618
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Na8SXjJd
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-53644b28706so19849471cf.3
        for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 10:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795201145; x=1795805945; darn=vger.kernel.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QpjWV7nVPK4jNL88HvKbtHJ/44FkOvQPFo/KHrxl1Aw=;
        b=Na8SXjJdGUVWDeqxqwuMR3Udnc3JNjfyk3MTxe3QTRK6WZ76d7I+8tS90Y0CdUuXZA
         ozFtgrB8we5s3tBqJqZcDv80Ku/wbh/GB4PCsBMGwkvpKkzwa34jt1f6hdT26CVXC5UP
         CqXkNaWn5gwOSbAvxEed0NE1PQJozJiRIR7CWvSazN38YSX1t5MjQC7PqbHfNae4SLU2
         cRYRjbxZdeSI2Yb8n7W13IJok9pj2aMDEqWhp8T3dZvqoUOiu0H8ebtzuoxe8RQRnyoe
         2tmTqqK0Yz+5RXyD+Ed2jDx8IyB6oTTNJ8Tf0OYn05H7iul3Rs9K0jNoFETg+lTdYUmT
         Z6uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795201146; x=1795805946;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QpjWV7nVPK4jNL88HvKbtHJ/44FkOvQPFo/KHrxl1Aw=;
        b=Z91a0Fw0QKSOeJRrBlcULeHfJPz+mtKTGQ22gl+8BefGGXexc8D8DkfbSdwpGywPTJ
         W5wThe9NZ4QXaUXcwu0uvlWqyr/hXBbzFk8dSCc9HIHnbfBSzxtyHtC3+slQt/l1xHbC
         HVQrAOYtC0R8uR63BCERO+EUmIlYapJOpW5izM0aDgiqLkVBYPhgZikBcGiiQj/KHPem
         y8wGD+osgoSvtE3qbXo3nocQI1knnW4Sl9l4GRYOKF0mEKBhYjLeGNzO21OGfDSalYyF
         byOgUd9S+XEKGiEYCd3grR/FReNKYVl5OYO0gsMOaHqeQSmcvBAxe9EOhYnIgGJGHCKo
         0y6Q==
X-Forwarded-Encrypted: i=1; AL+hErHCQsnHAtGbT30xLqKuvJ4McG6g3GfAHHFcGpQuSlj5Ha73PTtLdhMpIbxjal4rbXnxobVAIHCE@vger.kernel.org
X-Gm-Message-State: APuU4Z9rMkUZRjZAOYa9SrUpBVhe3UhKg95YOhjXTbmqTuYm7k6MfRTm
	sFpXk192jUOdMxUDBSI6TrOQh2ZTTp8a3TlxTBfrQb+W494sGx53Kg4iC4h3iIPh5pA=
X-Gm-Gg: AYBFou1Ifn23oR5K02/40PHEf5uWR2P7kwTRglpC8TG2tHX6BX2S+7eieYZ9ctNczxs
	gx+BXWDweTQ7X/mqdrPkRoNjuY/LqXqTGwQWF22rrQ8QWyxtatnJiI9PTgAXLuazOPmZuyHD1Jl
	2Vus9fNDW92d3KgixCq+/m62HRMxGOCn1GTdgy/6vFjiuUL9rs3n7nORj5gw9+TfIzVf2nq2mLX
	uMKhc1oawGr2T8KyTfFl75OtQzumxlYr/infhEr4/JoyCNV1Hwrb7Q7ryOlrriVgyZhS5j/JZUT
	XQ4jgu4yzt6oVPQA1hHgxKYIdTdZ1AAI513pF/AaloGMw4viLobZJfYvst5y0gZwJwX02m2SR8x
	MiHmqVrWJickYA48Dl88STESXcX/1kPYOtDBNK/SybhCEnXmiFY3hfhfUXxIFXvTi9DaHoBFUOY
	wxxhgcm0SHORUUCEjRuW3KGmO4RJn/K7G5o9tPRZdgxGZ+QATXVIs1eNqmw5Qqr36tOVGSCeXI5
	wbkqukzL7dXtH753K0nPCsPkM/Tr4dShn4bGzhR30Y9GxHlTtxbXtp6dUEgBmM6ySHq5JSSLsDF
	044998OW4yvKQsQPKNNiJOdNokQnUX94bH9c0OX+BG4Pjt+/Qq9/TRxAX5FbFogtaFamDJWCVYj
	UNQ4eAX4=
X-Received: by 2002:a05:622a:1a89:b0:55d:2c9a:3776 with SMTP id d75a77b69052e-55d76a811c8mr74428711cf.65.1795201145651;
        Fri, 20 Nov 2026 10:59:05 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d7884d01csm30305771cf.21.2026.11.20.10.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 10:59:05 -0800 (PST)
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
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: Yury Norov <yury.norov@gmail.com>, 
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
In-Reply-To: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
Date: Fri, 20 Nov 2026 13:59:03 -0500
Message-Id: <179520114342.412063.6068641130948664600.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-11-20 13:08 -0500, Gregory Price (Meta) wrote:
> This is v6 of the Private NUMA node series. The series falls into four
> parts, each building on the one before:
> 
>    1-18  mm: introduce N_MEMORY_COMMON
>   19-26  restrict folio-walking MM services to common memory
>   27-44  N_MEMORY_PRIVATE, kept out of cpusets, mempolicy, accounting
>          and the page allocator's ordinary paths
>   45-61  private node features, memory hotplug of private memory,
>          dax/kmem private mode, selftests and documentation
> 
> Patches 1-26 change no behavior on any system and can be reviewed and
> merged on their own. Without private nodes, every path in patches 27-61
> behaves as before.
> 
> The full stack is also available at:
> https://github.com/gourryinverse/linux/tree/scratch/gourry/managed_nodes/private_nodes_v6
>

Apologies - my b4 prep dropped a commit from the stack because I made
the mistake of filtering on author (myself) and it stripped out this
commit:

https://lore.kernel.org/linux-mm/20260923211041.3127588-4-gourry@gourry.net/

The commit is one the branch listed above, and should be otherwise
indepedent of the series (can be pulled in ahead of everything else).

Sorry for the noise / compilation error, won't happen again.

-- 
~Gregory

