Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F433428470;
	Mon, 21 Sep 2026 20:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790021981; cv=none; b=Uz0Kbvqz+tCs8zpvrA2as4XYBQL7BwFbDik8yc5pLbGQAJN6CGicpK6ymX41BwfE84/EZCgXBmgDyk6wfRWxjDg9RU98rUEhO0a+EZHLzMiqsYOuA56y0/zxXKJGdyaAje844S37EhFhh5fMlg4szgFdrL9SbvYN/hQW+6fWaLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790021981; c=relaxed/simple;
	bh=A4Ekyv+hXCNGc9kd4wCxvy4Somg21VCh2tlG35QERGs=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=Dly+X2YYbAixC3ylNqGMoOzWNDtHkqEW90uthJEZLOHBW2dQ1rKT1504Mu+zJtaLX3RZtYsAV+6p/KdNdWoBlnDWst0ICMEWPKM6/vdV65+VJ1OaIBGQfFG8O1suNGn1knrmL5TeyjxuKePzn04iZJ+NunmzMBe1xTNq4oLdTUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VwOwRcBI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VwOwRcBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898F01F000FF;
	Mon, 21 Sep 2026 20:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790021980;
	bh=oKuyFvdDafEvPgKBAQD55KsBuofHiKxwkbpxZQsO20o=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=VwOwRcBIq+8Ch8Vcnm8aDMg2Uws7MJBdBMOCi0S9vQbDC0NvXHjvTgRKnXc9e7yqa
	 UDSjDbDHGIQVDUHJLK6VgPIX2/mK5oLfKSsHw4QS1ICafyFBFiaYVHK20rZMDf1D5c
	 FJqu9BZ35FT4BpIBxvIZwFcnalRzhbQ5DpEcru3XAwT4lkJL4uKkaSbJRMI46kw4xb
	 0To4JfqVk+P8t/ngqFdXbnASTDw7tbRw2XdPVoFwIk0HHGNkKj1x7zrVxvLA8QuXI8
	 3GRWuvO4/sEo94YcjnoRnbbIo78tPxcvxEl1HTi9GGVmmo9rc3p+jqv1NckjvOWX7/
	 6aY91McPEWuuQ==
Content-Type: multipart/mixed; boundary="===============0035746704262275047=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <76e3a68c2ffd1644b1edc42507d25a1e4717beb9f9d420f04a4036b00e731d67@mail.kernel.org>
In-Reply-To: <20260921192559.2619635-2-shakeel.butt@linux.dev>
References: <20260921192559.2619635-2-shakeel.butt@linux.dev>
Subject: Re: [RFC PATCH 1/4] bpf, cgroup: fix cgroup struct_ops query for a second attach type
From: bot+bpf-ci@kernel.org
To: shakeel.butt@linux.dev,akpm@linux-foundation.org,ast@kernel.org
Cc: hannes@cmpxchg.org,mhocko@kernel.org,roman.gushchin@linux.dev,jp.kobryn@linux.dev,muchun.song@linux.dev,tj@kernel.org,mkoutny@suse.com,ameryhung@gmail.com,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,emil@etsalapatis.com,jolsa@kernel.org,ihor.solodrai@linux.dev,john.fastabend@gmail.com,jiayuan.chen@linux.dev,hui.zhu@linux.dev,donettom@linux.ibm.com,gthelen@google.com,kernel-team@meta.com,linux-mm@kvack.org,bpf@vger.kernel.org,cgroups@vger.kernel.org,linux-kernel@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Mon, 21 Sep 2026 20:19:36 +0000 (UTC)

--===============0035746704262275047==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> bpf, cgroup: fix cgroup struct_ops query for a second attach type
>
> Two things in __cgroup_bpf_query() work only because CGROUP_TCP_SOCK_OPS is
> the only one struct_ops attach type.
>
> It calls cgroup_bpf_enabled(atype) with an atype that
> find_atype_by_struct_ops_id() works out at runtime.  That macro is an asm
> goto and needs a constant.  Today the compiler can see there is only one
> value; add a second type and the build breaks with "impossible constraint in
> 'asm'".  Add cgroup_bpf_enabled_runtime(), which reads the key instead, and
> use it here.  This is a syscall path, so the cost does not matter.
>
> And find_atype_by_struct_ops_id() matches on type_id alone.  An attach type
> whose subsystem is not built keeps type_id 0, so a query for type 0 finds it
> and returns success with nothing instead of -ENOENT.  Skip such slots.
>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

This looks like a bug fix for the struct_ops attach infrastructure.
Should this include:

  Fixes: 369d9dcd8fb8 ("bpf: Add infrastructure to support attaching struct_ops to cgroups")


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/35646140734
--===============0035746704262275047==--
