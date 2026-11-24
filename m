Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.109
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795486788;
	b=J800HmQM8Hh9vK4CDfVumCcsVp3mNtqaKK1b/zetFsTA0Gr4Qt/lS0Y3TOWXFMl0K6No
	 7RPXid7721DTcOzZwRiaPi0zzR4WMGne7MyEAXzPIWMLLuvl+yu3jMogkUj0yDf3z+833
	 18DCZ+DaS+2kj5ueKL/0eHHp+YxLF3flvvwSeSJPiwFwM8uwEb2blo0Wz/uY8TS6sH9iU
	 grdQ5Oa5VHoJ8wTAVJC8z71A/FD+lU0IooZ1eGD4zg0YxM58osZvkuMli4btmEK1l1u7m
	 GPoCDU6J1zS6YM1sb1hrzSAsjwUmPH7Jedq3BLQ4lm3i8NojaAvz3I9fE4QmTH6dpJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795486788;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Content-Type:Mime-Version:Subject:From:
	 In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:
	 To:X-Mailer;
	bh=DBx0Oc8DjrG47WqcvxRyI0jpjHXnJ50q9VSIVqYcYcc=;
	b=fQ6Gy+W4JgM+woy6oZhBLP0ntsoxPnseM273ZljtXygzp/B6ZPiebAQn6FsIUQOdew/P
	 KIB36d8POeZDmE2xiVZNlEU0UtA2r4O0sj/Vs/tQLEhdSy18xofSQzOGAKTFL2yI+QMUH
	 HXUKGGv0DD35MeM91GkVaegwkwx7iMfChK/gbpT+v1NQeBn4YoBiw3Wg9bB3zRccJJhjq
	 uzpAED03tSE5RDIN/U1dpgvL4HGmoOSKSwQbTkaU1OrGsLcaAFIvjc0DMqLuwSncE5eVV
	 hZCgKUfOFnC01yo2lTBtyXDcsVyZwvbvEcC7PDkgekW479Z5G6sz9VprFLSKkE9to6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tfdPqlaX;
	arc=none smtp.remote-ip=91.218.175.109
Received: from mta0.migadu.com (out-109.mta0.migadu.com [91.218.175.109])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB00606A335
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 02:19:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AFB00606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tfdPqlaX
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=NKu5Xiz7C3AzZvOFUD8J7Uu+4Usuf9/OFAgGNS+u1B8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795486785; v=1; x=1796091585;
 b=tfdPqlaXx7ouiMzM9VnpBDU12hviUPVADC8rjidEa2X0YIuG58aVuGQeLgwnEXzJE2iLK9us
 wlfRVIxp4giQM6RdsEXpLBPUE82ObXd1ixtHb599E5onMs4jRop46ltQgsHq0AM920I5NtrXc/s
 5DqtfTfoVTqJhutPgv9uniro=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id db7b533f27c72b2d;
	Tue, 24 Nov 2026 02:19:45 +0000
X-Mizu-Trace-ID: db7b533f27c72b2d
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH] memcg: warn when memory cgroup IDs run out
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261124020800.2313930-1-shakeel.butt@linux.dev>
Date: Tue, 24 Nov 2026 10:19:26 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Koutny <mkoutny@suse.com>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Meta kernel team <kernel-team@meta.com>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <5BB43F38-F97D-413F-B1E6-0EEB6302FE6F@linux.dev>
References: <20261124020800.2313930-1-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)



> On Nov 24, 2026, at 10:08, Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> Every memory cgroup gets a 16-bit private ID, so a host can have at most
> 65,535 of them at a time, counting dead ones. A dead memcg keeps its ID
> as long as any swap slot still records it. On Meta hosts that create
> many short-lived cgroups, dead cgroups held this way filled the whole ID
> space. After that, every mkdir of a cgroup with the memory controller
> failed with -EBUSY: systemd could not start units, and container setup
> failed.
> 
> This was hard to see:
> 
> - Nothing is logged when the ID allocation fails. The only sign is
>  -EBUSY from mkdir.
> - Since commit 8290f45995f5 ("memcg: move memcg private ID refcount to
>  objcg"), a dead memcg is freed even while swap still holds its ID. So
>  nr_dying_subsys_memory in cgroup.stat can be 0 while the IDs run out.
> 
> Print a rate limited warning when the ID allocation fails because all
> IDs are in use.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Reviewed-by: Muchun Song (ByteDance) <muchun.song@linux.dev>

Thanks.

