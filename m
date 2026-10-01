Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F01347D44B;
	Thu,  1 Oct 2026 18:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790880227; cv=none; b=I018iAeVHzV2LHp2N3FaD5AsJ7BcODxW9wk1UXrhtP8OfMuZoEA++WipJbsJGXjeRdAGXZeFd4SpIDCUAVAdiJLvCCNcT112bKHJZX98XJUt+sO3VZolMT+3xOk3bqa7oDBugGAF3jj88u7RYjMw5eV/E89RLrClqLhUrYeKbYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790880227; c=relaxed/simple;
	bh=IssYt/LOqNL4Aq5qn/f7wC5a3Ce0xfmWCSqcEaxumw4=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fOoRHxxThqf8GGyB0bZxh0AL/w4YgIcZ+8fmYoKtqyyyDiLdnrwEed2eBCv/XEkhKsKlXNLHpaW1eY9F/whF2zCHwjdRdgOo38xwPmT4gbbz1AyrNRJFw3IV+TVWiOsFxNFQwGTjgTkmfJveXxcK2fmIknza5GCJeF3Q/5/vTgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ei+G6BQ+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ei+G6BQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A981F00898;
	Thu,  1 Oct 2026 18:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790880222;
	bh=8IhyPraaZ+0Y4y5yNF3T0TZ5caa5fwXRSAMFytUHil0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ei+G6BQ+kQusBfSuAr9wTOsaqN5ckM7JLvO7hIUYeDcCqP43VlOvoItk5A4Mru+0z
	 TPGzdx7kMbtZcAzGelAhophnMIcY7WlH0Gh7kS/kGOy+hyokmWH6COBlDWGgXqD8Zq
	 jdkcItAqxwlM5WWGriLvIiLGGMm/Qdc5h7mh4hPUKxQwDn4F+panOEuPfGx1zYqqhp
	 HrUgRFiIZ8dijReXRACFrTPLlbuX/9xHzDxUfTUx2XiUUfZ8dmASp1p1+NvV1mFc86
	 ih7ApInwzZXkJa23LlvYks6M+jUJY0tT8Ae44TF261aLpujb/g/VDpdVRkzjZSTL0l
	 W2LMvjPwwmHpg==
Date: Thu, 01 Oct 2026 08:43:42 -1000
Message-ID: <ef728276c74f15e11f42301b4e6f011f@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ian@honeycomb.io
Subject: Re: [PATCH v4 2/2] writeback: switch a replaced cgwb's inodes to its
 successor
In-Reply-To: <20260930-wb-dying-cgwb-flush-v4-2-bde637803a96@honeycomb.io>
References: <20260930-wb-dying-cgwb-flush-v4-0-bde637803a96@honeycomb.io>
 <20260930-wb-dying-cgwb-flush-v4-2-bde637803a96@honeycomb.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello, Liz.

On Wed, Sep 30, 2026 at 07:35:37PM +0000, Liz Fong-Jones wrote:
> +	new_wb = wb_get_lookup(wb->bdi, wb->memcg_css);
> +	if (!new_wb)
> +		return false;

If the successor was already released, the slot is empty and the inodes
stay on a wb that foreign flushes can't find. Maybe fall back to
&wb->bdi->wb like cleanup_offline_cgwb() does?

> +	spin_lock(&wb->list_lock);
> +	restart = isw_prepare_wbs_switch(new_wb, isw, &wb->b_attached, &nr) ||
> +		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_dirty, &nr) ||
> +		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_io, &nr) ||
> +		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_more_io, &nr) ||
> +		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_dirty_time, &nr);
> +	spin_unlock(&wb->list_lock);

Switching a dirty inode away leaves WB_has_dirty_io set on the old wb.
inode_do_switch_wbs() moves it onto new_wb->b_dirty through
inode_io_list_move_locked(), which only updates new_wb, and nothing calls
wb_io_lists_depopulated() on old_wb. A live wb clears it on its next dirty
to clean transition, but a replaced wb never gets another inode, so it's
freed with its avg_write_bandwidth still in bdi->tot_write_bandwidth,
which wb_split_bdi_pages() and wb_min_max_ratio() divide by. Can you add a
prep patch which calls wb_io_lists_depopulated(old_wb) after the switch
loop in process_inode_switch_wbs(), while old_wb->list_lock is still held?

> +	while (switch_replaced_cgwb(wb))
> +		cond_resched();

cond_resched() is a no-op on PREEMPTION kernels, so a wb with a lot of
inodes keeps this worker from reporting a Tasks-RCU quiescent state. See
407a5d205179 ("writeback: report a Tasks-RCU quiescent state per cgwb
drain pass"). Can you use the same do { } while () shape with
cond_resched_tasks_rcu_qs() as cleanup_offline_cgwbs_workfn()?

Thanks.

--
tejun
