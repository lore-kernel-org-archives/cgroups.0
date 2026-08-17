Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3378D274FD0;
	Mon, 17 Aug 2026 03:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786937269; cv=none; b=AMKhimWtlfcr3z/fQCRSNDMBuREh//DpuagxwLuO9iZwNKj1z56q+WW407utE9dPMv8ePc29nytVGa8eJU3DGCGYY3JhCg5BCe6I+QGMSFc5PlBo5YXTGvgvorsym23oVUepDAiGpL9K5+GljDKzHLgRYK6Zk+Z7uZJhT1PeUeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786937269; c=relaxed/simple;
	bh=VVolysXLoWy18qGySXXaNw29/bQB5p1TiMd7mDZT48o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOHLXqo/WQW0Eo2XBB/NtVYTtZe9qMd240QysCB9wV3bnx3Q7e2TSN4ocU/okXla9GUWmULUgz9uOXHC9c3nOkSfzY76Um9XsfeA4r5AdjGA1uFl2/S0K+ykCloQXpJ61K27UwLvUeKnQ4b2u64V5AD0uk80fyR+WoM+dPhSUwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=o1ClP4Mq; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="o1ClP4Mq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=jm
	UlmtGTb4gVi/IDEHbLDTYOtz1T8CJBO+NBBDn380E=; b=o1ClP4Mqj77ZrliAXF
	c2FViRDOp+8kKI798/qcsVA14TvC84/8WHzQQnLrU57h0hnDvQk1wse53UQhRog5
	KsNisreYI3HQQjaezj7RHNReUb6iSMfnadjymBsEvbmjJsSibNGcPtml4IWUqJJx
	gYqYStlMHodZs6YloIAbAfk6w=
Received: from localhost (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgD3mfBef4JqlrSwLg--.26496S3;
	Mon, 17 Aug 2026 11:26:23 +0800 (CST)
From: mambaxin@163.com
To: shakeel.butt@linux.dev
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	cgroups@vger.kernel.org,
	chenxinxin@xiaomi.com,
	david@kernel.org,
	david@redhat.com,
	gregkh@linuxfoundation.org,
	hannes@cmpxchg.org,
	hughd@google.com,
	jose.fernandez@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mambaxin@163.com,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	ryncsn@gmail.com,
	sashal@kernel.org,
	shakeelb@google.com,
	stable@vger.kernel.org,
	syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com,
	v-songbaohua@oppo.com
Subject: Re: [PATCH] mm: swap_cgroup: fix NULL deref in lookup_swap_cgroup_id on swapless host
Date: Mon, 17 Aug 2026 11:26:22 +0800
Message-ID: <20260817032622.1135640-1-mambaxin@163.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <an-yt4a6td75VvHw@linux.dev>
References: <an-yt4a6td75VvHw@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-CM-TRANSID:PSgvCgD3mfBef4JqlrSwLg--.26496S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7urW5ZFy8ZFyxCr4UCr4fuFg_yoW8CrWxpF
	yrWas3tF4rJryxtr4I9w1rta4F9a1fW3y5trn5Kry5Zan0vryaqr1xuFyj9F9F9ws3GrW2
	vFnFy34xWr1jvFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piN6pfUUUUU=
X-CM-SenderInfo: xpdputx0lqqiywtou0bp/xtbCwR8yPGqCf186cQAA3T

> On Fri, Aug 14, 2026 at 07:23:41PM +0800, Barry Song wrote:=0D
> > On Fri, Aug 14, 2026 at 3:48=E2=80=AFPM <mambaxin@163.com> wrote:=0D
> > >=0D
> > > From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>=0D
> > >=0D
> > > [ Upstream commit 63b02a9409cb5180398491b093e48bcb5315f5fb ]=0D
> > >=0D
> > > lookup_swap_cgroup_id() passes swap_cgroup_ctrl[type].map to=0D
> > > __swap_cgroup_id_lookup() without checking that the type was ever=0D
> > > registered via swap_cgroup_swapon().  On a swapless host every ctrl->=
map=0D
> > > is NULL, so __swap_cgroup_id_lookup() dereferences NULL + a scaled=0D
> > > swp_offset().=0D
> > >=0D
> > > Since commit bea67dcc5eea ("mm: attempt to batch free swap entries fo=
r=0D
> > > zap_pte_range()"), zap_pte_range() -> swap_pte_batch() calls=0D
> > > lookup_swap_cgroup_id() on any non-present, non-none PTE that decodes=
 as a=0D
> > > real swap entry, without first validating it against swap_info[].  A=
=0D
> > > single PTE corrupted into a type-0 swap entry takes the host down at=
=0D
> > > process exit.=0D
> > =0D
> > Thanks for the patch. However, we have a strict check to ensure that=0D
> > this is only done for valid swap entries:=0D
> =0D
> This patch is already in the upstream linus tree.=0D
> =0D
> Mambaxin, what do you want to do with this patch? Are you requesting to b=
ackport=0D
> this to stable tree? Which one? It already had stable CCed, so I would ex=
pect=0D
> the stable tree maintainers would pick this up automatically.=0D
=0D
Hi Shakeel,Yes, we would like to backport this patch to the 6.6.y stable tr=
ee. =0D
We have encountered the same issue on a product running the Android GKI 6.6=
 kernel. =0D
We are still investigating the underlying PTE corruption using various debu=
gging approaches, =0D
but the reproduction rate is low. Given the constraints of our product rele=
ase schedule, =0D
we would like to first bring in this fix from upstream so that we can subse=
quently pull it into the Android GKI kernel.=0D

