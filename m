Received: from mta0.migadu.com (out-219.mta0.migadu.com [91.218.175.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF194A8A36
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 18:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790275843; cv=none; b=I5Rk9Si2tBpEAqvpJAhihbMyWULUZrnNxCFbwBMZF4tt6DcvhnGWnWzYHr7H793NF2hyk9YYF9eSzwUpIadLHQP82e+PMFza9o+oe/i6MCd/DQAQVQqg2lLkM1bRCWzk27lm20FA1jvyJN0Tl6F0xpEQnTZteoNIeA7Div0yB70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790275843; c=relaxed/simple;
	bh=wwO3fY8wiWeLu70HfX7+HYNTDjHJ8k0nCAXKE84dEZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OyDE+00rcNtl+p8O5A5PrcseWCj3caVgG/cAw4wlMtGOfJ8tHULdGATzyJzntitqwcWyyitNl7LfyoXgpNLCCZJQeBRXS6K0vDlYXQOpo/fGu0fMExbsE8ILnTjwajQtDMOs9QRedouUONfL7X4Mn3jW+50DV2k7j4Pn8PSkOUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lJCCyO2F; arc=none smtp.client-ip=91.218.175.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lJCCyO2F"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=wwO3fY8wiWeLu70HfX7+HYNTDjHJ8k0nCAXKE84dEZ0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790275836; v=1; x=1790880636;
 b=lJCCyO2FaalPN0PkwolHPxvv44Q23fPFcLTIU9qjZgx167d5q03NDdOhI4+AlMfbZTYA83MO
 o9VpV4tbAkI/FLHYkxrb0rn57gnLrGOGESVHUytz8Dy2RzOBhYwbLoE13NCWGx441jEkeeqZW/g
 +gqrkRzlFeNfGMHoFKaHmV40=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2b345eaae1d9b58d;
	Thu, 24 Sep 2026 18:50:35 +0000
X-Mizu-Trace-ID: 2b345eaae1d9b58d
X-Migadu-Flow: FLOW_OUT
Date: Thu, 24 Sep 2026 11:50:34 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Peter Zijlstra <peterz@infradead.org>
Cc: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Suren Baghdasaryan <surenb@google.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	David Dai <david.dai@linux.dev>, JP Kobryn <jp.kobryn@linux.dev>, 
	Frederic Weisbecker <frederic@kernel.org>, Aaron Lu <ziqianlu@bytedance.com>, 
	Daniel Jordan <daniel.m.jordan@oracle.com>, Hao Lee <haolee.swjtu@gmail.com>, cgroups@vger.kernel.org, 
	bpf@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] cgroup: charge kernel work to the cgroup it is
 done for
Message-ID: <arVwmhAg1CSQAoX1@linux.dev>
References: <20260924184529.879516-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924184529.879516-1-shakeel.butt@linux.dev>

Somehow the git send-email got killed in between. Please ignore this.

The full RFC is at
https://lore.kernel.org/20260924184714.912181-1-shakeel.butt@linux.dev

