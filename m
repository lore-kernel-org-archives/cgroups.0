Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7F73587AD;
	Thu, 22 Jan 2026 01:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769045459; cv=none; b=ukmEYxZzMqQ1RW0Eg3WS+TnI7l2eD/43c1SSynGmbTC94C1na1gaCI2baGUBwVPcKUekUkGmtnbqi0nTVW24tR5o80bjbBgLV4x8dfSOO4VNfY1gx9soPvwrqHbpQD+0KQ6aNe5iER4rF3EjjGuDx5FHPor1PUt1B/lAstyRKFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769045459; c=relaxed/simple;
	bh=SLEk1HlG2KbrZjOE6/l1NmcIEfJFonjsbxNe/cDOH/Y=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=ZZ304FGGyLcyPMYWw1JcCUeD5DldZw5idRlACVgU0IEvbOmsuoBN9DZnli/rygmKPyYEpHChWhJgcAG+YUk32Aljol9rfidHS0cNPepwfnQ+PaKjhDoqw0vPv2orboPX/LenF5abB09CN7KVtz0dTr7ymi/1WmsonEb1MYUQVdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FvS2215S; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FvS2215S"
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769045445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tKl8Jno7lJhkwOUwcQTSrgeBn0gJ6jgSqCy+B19d98w=;
	b=FvS2215SGQI3qb3MxlQhDug5Iwy0pKGdkZjE8IYX1wUcCvvUTVLSs6JXqKXQVILcdBQVcT
	CHcTDiv58zSvLIoyTtyxj+VMlPducNqMBBXfjtMF2n/AlZ3mINeUXahO0xRMukNo3I33Rn
	IdBPVprLxk0CZvf9fsB7j5FiweWlJXo=
Date: Thu, 22 Jan 2026 01:30:42 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Message-ID: <bac18fc5600a0e8a2f0f5d1e46191ef1e6b64962@linux.dev>
TLS-Required: No
Subject: Re: [RFC PATCH 0/3] mm/lru_gen: add memory.lru_gen interface for
 cgroup v2
To: "Shakeel Butt" <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, "Tejun Heo" <tj@kernel.org>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "=?utf-8?B?TWljaGFsIEtvdXRuw70=?="
 <mkoutny@suse.com>, "Jonathan Corbet" <corbet@lwn.net>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Axel Rasmussen" <axelrasmussen@google.com>,
 "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, "Vlastimil Babka" <vbabka@suse.cz>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, "Muchun Song" <muchun.song@linux.dev>, "Qi
 Zheng" <zhengqi.arch@bytedance.com>, cgroups@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <aXFPhnOn4oGllq_Q@linux.dev>
References: <20260121123955.84806-1-jiayuan.chen@linux.dev>
 <aXFPhnOn4oGllq_Q@linux.dev>
X-Migadu-Flow: FLOW_OUT

January 22, 2026 at 06:19, "Shakeel Butt" <shakeel.butt@linux.dev mailto:=
shakeel.butt@linux.dev?to=3D%22Shakeel%20Butt%22%20%3Cshakeel.butt%40linu=
x.dev%3E > wrote:


>=20
>=20On Wed, Jan 21, 2026 at 08:39:46PM +0800, Jiayuan Chen wrote:
>=20
>=20>=20
>=20> This patchset adds a memory.lru_gen interface to cgroup v2, allowin=
g users
> >  to interact with MGLRU directly on a specific cgroup without needing=
 to
> >  know the internal memcg_id.
> >=20
>=20Unfortunetely we don't want to expose reclaim implementation specific
> interface to a cgroup.=20
>=20
> >=20
>=20> Motivation
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >  Currently, the only way to perform aging or eviction on a specific m=
emcg
> >  is through the debugfs interface (/sys/kernel/debug/lru_gen), which
> >  requires the memcg_id. However, there's no straightforward way to ge=
t the
> >  memcg_id for a given cgroup path. This makes it difficult for users =
to
> >  leverage MGLRU's proactive reclaim capabilities on specific cgroups.
> >=20
>=20From the next kernel version, this memcg_id will be inode number of t=
he
> cgroup for this interface. So, a simple 'ls -id cgroup_path' would be
> sufficient for your use-case.
>=20
>=20The relevant series [1] is in mm-tree at the moment and if you want, =
you
> can backport it to your kernels.
>=20
>=20[1] https://lkml.kernel.org/r/20251225232116.294540-1-shakeel.butt@li=
nux.dev
>

Hi Shakeel,

Thanks for the review and the pointer to the inode-based memcg_id series.

I agree that using the cgroup inode number as memcg_id will simplify the
write operations (aging/eviction) through the debugfs interface.

However, I'd like to point out that the read operation (viewing lru_gen
info for a specific cgroup) is still not convenient. Currently, users
would need to parse the full debugfs output and grep for the specific
memcg_id, which can be cumbersome especially on systems with many cgroups=
.

Would it be acceptable to add a read-only command to /lru_gen that only d=
isplays
the lru_gen information for the specified cgroup?

Alternatively, if exposing any lru_gen info in cgroup is not desired, I
understand and will use the debugfs approach with scripting.

Thanks,
chenjiayuan
