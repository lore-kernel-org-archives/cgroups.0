Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717515;
	b=lX57L97H3QPThiPyDXfWP8OmSPS773wJ272S1IrStw+o7eOOtW0mbCGfyVrmnX3vfcgG
	 dAFMya6jh4EgMTGtrZkm6zC1vnkCAV+RMmA4rw1zcCqF3EbRh1rg7EdCkCCqf25zaRiqz
	 6WYQmhMWo8bxUfOfrYvghOLiFvvaASw3OsNjkrbeOUM2MrH8M4tuGPB0bGZ+m4C7Fx4DL
	 s9b92GZ/Tt+Kp45V6BSwQx06a6PGmuatW2A/oNS4BEG2ggytIThc1Q1FvzeCKEBi1W8vO
	 JttR2WnWV7JBNtLjgEFZeQVjPi5SO4WVnrtF2G4DN7PToBjQ3G4VDPh19bEa/6I6yRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717515;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=qj/jBK5uYX1lBOAh7CIGNjD5DbAGZcwkTAmQo8pBkzs=;
	b=Pyk1ioVu8FD2Nd4FSxFcJbSv6joq1aUrG2Ss4VS7P1VSZff0hS2B04s4QnDzoVOMtMI6
	 tD0CFsAjz6MdD70kB141knLxmUiJCfuopW+HB0rFbGeYKkbw3fPpFMi1DZfVw9sXpwFpE
	 9fkCG9gXWb2YYNQ3mvUBfO39PFBInqVMcA9GO0KARfDP3u6Rv9b71GH3FYuMC0UbmxoZ0
	 BayHal96DC/cD+nJdVZ/MZc/O0KlrZ5KpjUwiq2I5cJyiMUuAdncRUvZE5KdJdrizGV2a
	 akSELlRy7rv/x84Qk8VP9sX9rcefYSOxRMJJC0K6sbeTmOQMw0r4ru0GFdgq4HF6qzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B1yzwcN7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56AC606A7BA;
	Tue,  3 Nov 2026 14:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B1yzwcN7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06DAA1F000C1;
	Tue,  3 Nov 2026 14:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717514;
	bh=qj/jBK5uYX1lBOAh7CIGNjD5DbAGZcwkTAmQo8pBkzs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B1yzwcN7CWiyNWpcvubXRrCbxuNfue3EMWaxmI3o8yCwa1dApj+/hy+6VaZvzbFwj
	 gEiGdceIHEoatSvdxVZYydAj6jRnOYabrYDeBySkuosbTg1kwo0jFsSP59YwWge8Fh
	 vUK638xS1loXo8ZXokQ+5An9IkLHb3WpMcTzQ3KsL0J8WrjSZcRZhAoPTl6T2kttoz
	 rdkBGDeGBcS3zMVvm8FyuDJ2cPNbXIXbrVQhwpQZhqqSn2Json5EKJTKee4s6G1RTm
	 tpxiF8y58k6WRTbQocwVUIseU94DsGbwghXbH7zHPKxEd/jWAiuBKsm5tltGI3Ev+r
	 CvokGvV5slJGw==
Date: Tue, 3 Nov 2026 14:51:52 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Alexei Starovoitov <ast@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH RFC 4/4] mm/slab: serialize defer_free_barrier()
Message-ID: <aun0lgIta8LmcP1T@thinkstation>
References: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
 <20260624-kmalloc-nolock-fixes-v1-4-fdf4d17351dd@kernel.org>
 <feb3e339-f61d-4f99-9859-e1895d396561@kernel.org>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <feb3e339-f61d-4f99-9859-e1895d396561@kernel.org>

On Fri, Jun 26, 2026 at 05:00:51PM +0200, Vlastimil Babka (SUSE) wrote:
> On 6/24/26 15:11, Harry Yoo (Oracle) wrote:
> > irq_work_sync() uses rcuwait instead of busy waiting in two cases:
> > 
> >   1. The kernel is using PREEMPT_RT and the irq work does not run in a
> >      hardirq context.
> > 
> >   2. The architecture cannot send inter-processor interrupts to make
> >      busy waiting reasonably short.
> > 
> > However, rcuwait.h says:
> >> The caller is responsible for locking around rcuwait_wait_event(),
> >> and [prepare_to/finish]_rcuwait() such that writes to @task are
> >> properly serialized.
> > 
> > Since defer_free_barrier() calls irq_work_sync() without any locks,
> > it can potentially cause a hang as writes to @task are not serialized.
> > 
> > Fix this by calling defer_free_barrier() under slab_mutex and
> > cpus_read_lock() and add lockdep asserts.
> > 
> > Now that defer_free_barrier() is called inside cpus_read_lock(), iterate
> > over online cpus instead of possible cpus.
> > 
> > Reported-by: Sashiko <sashiko+bot@kernel.org>
> > Closes: https://sashiko.dev/#/patchset/20260615-kfree_rcu_nolock-v3-0-70a54f3775bb%40kernel.org?part=5
> > Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> 
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

It was dropped as it now introduces a mutex.

(codetag_unload_module() invokes kvfree_rcu_barrier() ->
deferred_work_barrier() but doesn't have access to slab_mutex
so we can't reuse it.)

-- 
Cheers,
Harry / Hyeonggon
