Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794912671;
	b=zXOtBea9ca08rRu417wbqjPA+rNqrZJ2sS9o+/j1/nEC9qPCt6Zr5gIatalv+V4S3qNo
	 H6oC3JJm7+t7nz6Ahi+BKWmb4Kqs8T+MIrnHj/dy7fJAF1OLBYHeMnq1GoR2qSZsbOuvS
	 bYuL+t65WJl6pfK9z7HDvtp7PySuH98DzwnpbhCg2llfDz6fBkvNO3hkNALWQ4Xj4yYDo
	 KqH53iPBnkvNfgJB9KSGwm8g2ir1uJHemHpsVBk6r5BJfqjSrnh83hQJhwu1s3yDisS+A
	 orLiH2DSgshGgkWsJQhuss6QvWW4J/Mnw4vmJxlZ5pOdOFrgia4QOzELtrazxYAurPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794912671;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=yGGt8NV4WYvP8D8jXjkN3E6BeLc6Z0ULYHtYvxxLSCI=;
	b=JJri9r4jIvhodg7kttQNUIgqX/USz09AXd4wkjXMmF7mrUU8Z/K7FlBbK22jrxu2yeQU
	 N/PnpbnQqDsne+w3M7jq9YrVdBxHrnlxfk7dNlC4oY3nOubLK6Ipyg0wrYYYR5UkroAE/
	 sDgMovUaj1NYL9i4LO1RMi4rteZMzGu/d6rJ24YwzppsC1Qi7q83osjDvjDGo1v7j2CGw
	 /wiedyQ/ZT0Zu1IKOfiQYmFQK75OFTpDsFyAL6fpJ3gCIJ3IRJ5Hc4XkUfRvXIaSit5iy
	 z2eN7Pq4WlzeDDRY4N7tRm1SU4GBSzUxcJQhoTz7YbgMPC5BiI3iEJuMz4YVKbVonLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=oi+gFa2F;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02855606A33E;
	Tue, 17 Nov 2026 10:51:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02855606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=oi+gFa2F
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 03EE21476;
	Tue, 17 Nov 2026 02:51:07 -0800 (PST)
Received: from [10.0.130.226] (e127648.arm.com [10.0.130.226])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2B5E03F763;
	Tue, 17 Nov 2026 02:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794912669; bh=E3QjzpjlG575ONB94R6gDkhYslcgcTo7SORhb5xOQys=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oi+gFa2FfTAC6l/84DGUSZsQY6RHBH0v9Ores4fAfSbDkbDg5UYRlJSmJc3LTeQ6K
	 pbvGuib+72+pNST0Df1t6ShiyLgM4A/o6mya//XN5w1NU2OeG+L7L82f07PNs0dOl+
	 oFbchjMGudkpeuizxFGrtldqVeiBdnQbjCTnD3yc=
Message-ID: <c6918c4e-060a-4968-a43a-1b1cbdafd27b@arm.com>
Date: Tue, 17 Nov 2026 10:51:04 +0000
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH AUTOSEL 6.12 486/486] kernfs: Use RCU to access
 kernfs_node::parent.
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Tejun Heo <tj@kernel.org>, Yonghong Song <yonghong.song@linux.dev>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, reinette.chatre@intel.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, rafael@kernel.org,
 dakr@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, ast@kernel.org,
 daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com,
 shuah@kernel.org, jolsa@kernel.org, alan.maguire@oracle.com,
 cgroups@vger.kernel.org, bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20250505223922.2682012-1-sashal@kernel.org>
 <20250505223922.2682012-486-sashal@kernel.org>
 <e274493b-0774-423e-a7e0-bd2c59333d93@arm.com>
 <draft-0011-reloehlekernfs612@kernel.org>
From: Christian Loehle <christian.loehle@arm.com>
Content-Language: en-US
In-Reply-To: <draft-0011-reloehlekernfs612@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/13/26 19:10, Sasha Levin wrote:
> On 5/5/25 23:39, Sasha Levin wrote:
>> Subject: [PATCH AUTOSEL 6.12 486/486] kernfs: Use RCU to access kernfs_node::parent.
> 
> On Fri, Nov 13, 2026, Christian Loehle wrote:
>> I just stumbled over this issue on a 6.12 stable kernel,
>> any reason this patch wasn't applied back then?
>> Can we apply the backport now?
> 
> 633488947ef6 ("kernfs: Use RCU to access kernfs_node::parent.") is a
> preparatory refactor with no Fixes: or Cc: stable. It is part of a series whose
> other patches are not in 6.12 either, and it has fixups upstream, so it is not
> a clean backport.
> 
> What failure are you seeing on 6.12 (oops, lockdep splat, trace)? If you can
> send it, we can look for the fix that addresses it directly.
> 

Sorry, my bad, this should've been to ::name, later in the series.
Here's a lockdep:

[    7.291918] [ BUG: Invalid wait context ]
[    7.292932] 6.12.117-kernfs-intree #3 Not tainted
[    7.293486] -----------------------------
[    7.293808] repro/92 is trying to lock:
[    7.294275] ffffffff81effa18 (kernfs_rename_lock){....}-{3:3}, at: kernfs_path_from_node+0x26/0x60
[    7.297072] other info that might help us debug this:
[    7.298307] context-{5:5}
[    7.298739] 5 locks held by repro/92:
[    7.299157]  #0: ff11000000d90b20 (&vma->vm_lock->lock){++++}-{4:4}, at: lock_vma_under_rcu+0x91/0x410
[    7.300199]  #1: ffffffff81eb2900 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0x26/0x1a0
[    7.300931]  #2: ff1100003ea2c218 (&rq->__lock){-.-.}-{2:2}, at: __schedule+0xb4/0x8f0
[    7.301590]  #3: ffffffff81eb2900 (rcu_read_lock){....}-{1:3}, at: bpf_trace_run2+0x7b/0x1e0
[    7.302469]  #4: ff11000000f0b0f8 (&mm->mmap_lock){++++}-{4:4}, at: stack_map_get_build_id_offset+0xbd/0x300
[    7.303319] stack backtrace:
[    7.303979] CPU: 0 UID: 0 PID: 92 Comm: repro Not tainted 6.12.117-kernfs-intree #3
[    7.304499] Call Trace:
[    7.304737]  <TASK>
[    7.304970]  ? dump_stack_lvl+0x64/0x90
[    7.305089]  ? __lock_acquire+0xb05/0x25d0
[    7.305130]  ? __lock_acquire+0x404/0x25d0
[    7.305171]  ? lock_acquire+0xb3/0x290
[    7.305194]  ? kernfs_path_from_node+0x26/0x60
[    7.305222]  ? find_held_lock+0x2b/0x80
[    7.305252]  ? _raw_read_lock_irqsave+0x72/0x90
[    7.305277]  ? kernfs_path_from_node+0x26/0x60
[    7.305297]  ? kernfs_path_from_node+0x26/0x60
[    7.305321]  ? get_mm_memcg_path.part.0.constprop.0+0x36/0x150
[    7.305350]  ? __mmap_lock_do_trace_acquire_returned+0x54/0xe0
[    7.305394]  ? lock_acquire+0xb3/0x290
[    7.305432]  ? stack_map_get_build_id_offset+0xbd/0x300
[    7.305465]  ? lock_is_held_type+0x97/0x110
[    7.305511]  ? down_read_trylock+0xa9/0x130
[    7.305551]  ? stack_map_get_build_id_offset+0x2d1/0x300
[    7.305616]  ? __bpf_get_stack+0x3a9/0x400
[    7.305674]  ? bpf_get_stack_raw_tp+0x7a/0xa0
[    7.305713]  ? bpf_prog_ec3b2eefa702d8d3+0x3b/0x3f
[    7.306445]  ? bpf_trace_run2+0xc4/0x1e0
[    7.306478]  ? set_next_entity+0x97/0x130
[    7.306512]  ? switch_mm_irqs_off+0x4a6/0x570
[    7.306546]  ? __schedule+0x2f3/0x8f0
[    7.306585]  ? preempt_schedule+0x33/0x50
[    7.306608]  ? preempt_schedule_thunk+0x16/0x30
[    7.306646]  ? _raw_spin_unlock+0x2f/0x40
[    7.306672]  ? wp_page_copy+0x2f9/0x8b0
[    7.306711]  ? __handle_mm_fault+0xa3d/0x19e0
[    7.306757]  ? handle_mm_fault+0xb0/0x360
[    7.306784]  ? exc_page_fault+0x240/0x8c0
[    7.306824]  ? asm_exc_page_fault+0x22/0x30
[    7.306949]  </TASK>
