Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50082285072;
	Fri, 17 Jul 2026 22:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784325776; cv=none; b=QQGHBbUEmd8gp7qEmZL6Az406rvM3T0BzXUto/xRcB3cQef9EEgC3RzZt6sfmhyam7mn21VaaoQ0D0IxgE8eqKBtrvnsdb9/jVYfAgihd7wCUz1sAXKeb5DUGex9sFDuLRFnLu9bnRhWYZ4Ngs0AW4TNAiyzb1avX1p6ryPv8Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784325776; c=relaxed/simple;
	bh=Cu+RcB2fgXh/agyqls+b5EC6fkWq2zM9igEXiB+56i4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ujcG0Udbui8rXZdjjzMdeCL9JECO69ziLpGnmRyhpZg5kj3Aus3fxhd6/xSPg1wK5eni+/nOH5ti3Rxa08RQMCBvyx4UqSNagFkxjkcla9r8KieE3b2ndyGiczhKuMWWs5NSkp8N7f9++VB9d1kKfSX+rrELaYHS7QWh8Xt8EPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZlQ6ylS+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZlQ6ylS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B563B1F000E9;
	Fri, 17 Jul 2026 22:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784325774;
	bh=vK0V6XdCn3VZKyqGqo603HO8YlBOB9rJrE2Ye6IoQho=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZlQ6ylS+qxrpG6MP60Ak8CeNHceJEr9xO9SMOpxRvMGFW4sF3apaOdzJliGRruGc+
	 uAA5I9+NtP33i6/eHULXIDlTL2cLk3X+FHzRpi9KlGLq2wavYN2oPWaLDo428h0RC8
	 ro+YhgGhNaFM5IuFDMRWGg8eBrnmLmPd1D11HyIdG8HkterFOeqpCktX3+XQ0Q1zOF
	 dlVDTWhRoqW44KpeTXQmbvfnAKKahYgbsuRC9XAwrBfHzOnOlNG7lb2m6WBhkTjLLH
	 eiU/d7h2FDFPBv3mlTdDtW0pPM5KY5AFi7X0znL9g+vJHmDXDW7RPgvo1a3pL9s2WB
	 Fok1KpRSmevgg==
Date: Fri, 17 Jul 2026 12:02:53 -1000
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Jackman <jackmanb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v3 2/4] cgroup/cpuset: update some comments about the
 page allocator
Message-ID: <alqmjd3pKWewxtWZ@slm.duckdns.org>
References: <20260715-spin-trylock-followup-v3-0-fc4d246f705d@google.com>
 <20260715-spin-trylock-followup-v3-2-fc4d246f705d@google.com>
 <7f4e784ee2bbbc23b4b97913e144c0d9@kernel.org>
 <alplxFeazzK_Ziie@slm.duckdns.org>
 <20260717115348.9ff2498eafb8ea256a0cb504@linux-foundation.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717115348.9ff2498eafb8ea256a0cb504@linux-foundation.org>

On Fri, Jul 17, 2026 at 11:53:48AM -0700, Andrew Morton wrote:
> On Fri, 17 Jul 2026 07:26:28 -1000 Tejun Heo <tj@kernel.org> wrote:
> 
> > On Fri, Jul 17, 2026 at 07:23:58AM -1000, Tejun Heo wrote:
> > > Hello,
> > > 
> > > Applied this one to cgroup/for-7.3 with Vlastimil's reviewed-by and
> > > Waiman's ack added. Please drop it from the mm series.
> > 
> > Never mind. I'll drop it from mine. Sorry about the noise.
> 
> Thanks.  Plucking one patch from a 4-patch series is awkward.  Better to
> retain this in mm.git with your ack(?).

Yes, that was a tooling problem. Shouldn't happen again.

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
