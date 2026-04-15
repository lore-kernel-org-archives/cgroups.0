Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA04C3DE452;
	Wed, 15 Apr 2026 16:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776270267; cv=none; b=mW0yI+dE3HrbBCebWFVFvw57yZxojQOtqLD8Nhnz2/8QMB3IEJThvMYXRLxIaKBZ+cRAegAY61AtkxsN8OIc6Bzzd/EoVazZTTKnMS0XkiGNq/yiLqeiQQBvOUMiv6JbELvBTkV+fpR/Bse3CjevBikLvNCb4WTLPLcZtMGtMAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776270267; c=relaxed/simple;
	bh=HdXaMBoPumudnhWuNY9dZA0vjUGf3iaSkeWTqwiWisU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cWeH8s/yKVgWLOFp6rKPL8Xsfy567+CRqpoOKuV+6fuPfOd8s22hYDYD5yJ05d/xxhOKVOZgNbgKlEtuaB4VbYMlpuU4NbYceRIuXhJFSB7hc34JJma7aSX2tUDJyyQWsJeCzbYu4/MmY1uZqMq9O74vb+Z76yWMMnoI4tjNwPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=I6NToXSy; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="I6NToXSy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:Content-Type:
	MIME-Version; bh=F8DGeYEPDbd6uTkQWGQlOL5JIA2NkbZr/DhyV0YRVO0=;
	b=I6NToXSyUkbGvDwVEBuWToyVpgMro9rCAORifBvQTlucqupmisnv6lbW0e1ryl
	Lvk30r+FMavfCG9luAG0fMam2Kcj8LE/LY/HDEqnq6YcjMWSByGiwaApB4xAl1wZ
	Oeq4MLo90NMcFZZEcCV+n1oQCtXmFlO6krFN6jM6zXITU=
Received: from 229.199.16.172.in-addr.arpa (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wB3WoNeu99pgeDOEw--.35537S2;
	Thu, 16 Apr 2026 00:23:01 +0800 (CST)
From: create0818@163.com
To: Vlastimil Babka (SUSE) <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Liam R. Howlett <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+1a3353a77896e73a8f53@syzkaller.appspotmail.com
Subject:
 Re: [PATCH] mm/memcontrol: restore irq wrapper for lruvec_stat_mod_folio()
Date: Thu, 16 Apr 2026 00:22:53 +0800
Message-ID: <177627017370.51713.13753959033860067852@163.com>
In-Reply-To: <ef2d8f65-b3b4-4a9c-a77f-78ad1cadff28@kernel.org>
References: <20260413064833.964-1-create0818@163.com>
 <ad0clnEYxf1H4_S1@linux.dev>
 <ef2d8f65-b3b4-4a9c-a77f-78ad1cadff28@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-CM-TRANSID:_____wB3WoNeu99pgeDOEw--.35537S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Gr1rtr4rZr1UuFW8tFyrJFb_yoWDCFcEvF
	y0krW5Ww4xAr42qa10yF1qyr9aq3WfCr1DAa4jgw4Sv3s2qFn0gaykur12qFn3Ka18tFnx
	Gr47uw17K3yY9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUgo2UUUUUU==
X-CM-SenderInfo: pfuht3jhqyimi6rwjhhfrp/xtbC6AVak2nfu2XCbAAA3i

Hi,

Sorry for the noise and for sending an insufficiently validated conclusion ea=
rlier. I rechecked this more carefully, and my earlier conclusion was not wel=
l founded.

I can no longer justify

  memcg_validate_race: fixed start/end mismatch (1 -> 0)

as evidence for this patch.

I rebuilt an apples-to-apples baseline/fixed pair from the same source base a=
nd reran the QEMU validation. The result is:

- baseline and fixed both reproduce the warning under the original remount-ba=
sed harness
- baseline and fixed both stop reproducing it under a no-remount harness
- the validation workers still start in the no-remount case

So this warning does not distinguish the wrapper patch from baseline behavior=
. At this point it appears to be induced by the remount/rebind test harness i=
tself, not evidence of a wrapper-specific regression.

I do not have a reproducer that distinguishes baseline from the patched kerne=
l, so I am dropping this patch from this line of argument.

Assisted-by: OpenAI Codex: GPT-5.4 [shell] [qemu]

