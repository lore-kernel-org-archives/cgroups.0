Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E980E1DD0EF;
	Wed, 26 Aug 2026 00:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787704023; cv=none; b=IgOPMrE1uFQDS6UWoWzTrlS134U9/WH4ii0RaIn9IVNph19P1qdBmP60TFR0MWn1+eYMqxZP/cYr4qvVQ5gHfMALKVlRfod1VVTvDtt1eJfIV245xS6PtLoXtXsId/AjX8KlRaWUGmuG8T2TnbfCd9hqR2mrtKZwbDDDVO3xsgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787704023; c=relaxed/simple;
	bh=Sjs0Z15da9BQWJI0NwHJhrHiNkwgfTBqUOuCCqKnuX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SoXaQUFKJv3LyVaiQ9NFrwZznPDG3yfunymW5Te+8uMg2WPh1RRtZsm1wclYec1GDLFXcbIac6mcSjbfpXMK0un80+u0mwyCrP5hiIQsW7qgAhz7micLtredl7MIxVq5/KZEfcFG//AIR40s+9w46pRuiEBslbgzpLfg6+lDu/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iLnrmaqP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iLnrmaqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2935B1F000E9;
	Wed, 26 Aug 2026 00:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787704021;
	bh=4h+AxUzp2+TOGJRdtBIJ00M+Vd7ZziIXgCInJnTM0Zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iLnrmaqPaMVaX1hKJ9rKgIeV1a5LuC3WUfy15gV6bSJa2uP3q/SWYDUn5kP2YIDg1
	 SfJCZaXBmpU93AQ0rpKOcTO/83CO41Ug2UnbE0GR+evgElw4WOjp1fEjshTMmdKGAF
	 4286/ruaV8xRheVOlRsFkPvSj0QPaiJPAY3Fza8roKJwOAloMlcmeggeaOL5nY8v5a
	 QZ0XWoms9DXeGHmyUshhCTwo4LEXKhVeMbICb6LJrNl+Imk+rfVTWV8+Xaqu2n0hZp
	 50kIgU5fuhesy7atB8CPkyAF00BQjkon7+Ew+eRE9O/CncWpycE2+KoXG8fANh4SHz
	 KkKE8LVXE+ucw==
From: SJ Park <sj@kernel.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] mm/memcontrol: remove unused memcg parameter in calculate_high_delay()
Date: Tue, 25 Aug 2026 17:26:48 -0700
Message-ID: <20260826002649.64994-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260825120153.1405-1-hongfu.li@linux.dev>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 25 Aug 2026 20:01:53 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:

> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> The memcg argument of calculate_high_delay() is never referenced in
> its function body. The delay calculation only depends on nr_pages
> and max_overage, and both callers have already obtained max_overage
> from the same memcg.
> 
> Drop this unused parameter and update the two call sites inside
> __mem_cgroup_handle_over_high().

Looks good cleanup to me.

> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]
