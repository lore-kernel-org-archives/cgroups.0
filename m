Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991DE37187E;
	Tue,  4 Aug 2026 19:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785871579; cv=none; b=s/xQYCmx9paFyYjplYdAmrIikX4NjwV3kc8EwDqzET5WsO9+H/r7CaFy5zWg8AY5Win1/muM1qjZXxtxGP85byq8ei1a0fNKInnsUEGO3Zcm0TfBivG8lit9FXlZXQLWJboRu3bnNo/uUfCcy6oPVzMIKS1pxDZeBC/KmRKJT94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785871579; c=relaxed/simple;
	bh=bK48B78t1JWDrv6S/X8mhLp4MBW4pi69KlFw5vQ/iqM=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=FzF53fjpDgJt3Cm02GZXB7V1KCJgTaKPBcM4pgGQkxNlSMt+pFYhxEABQoV2c/eh/wR/CpUe5rRy27han/3W/VDf5IaV+EQ3F8JWpG8SdTdJWtobxQVB79bWIYc/UZylBvoVXU7yfWfy+gVZK7rfZknjGwOtBjiCmh90sjIxlfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gryoVr3u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gryoVr3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346101F000E9;
	Tue,  4 Aug 2026 19:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785871577;
	bh=VdJmti4wVkf/3TGhFwMCUFJImTJ1GZ8o71ayzmFONv4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=gryoVr3uqUvPBfWyH1Iv27KhOQyNxNNN4NCtw5V0qWGkoSNqe7m15N2vC6lm82AOk
	 LAItVjjQIG+cQGKiBSvhfyBgfGrNOhR+m3zlJgkABqJHuE9ZnYjzK4KfQqvFVNyvEh
	 LyR5BdvlhJg1a0CZNb9VNWK6RcVaV0+jaSrdDFng=
Date: Tue, 4 Aug 2026 12:26:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, kasong@tencent.com,
 qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, chrisl@kernel.org,
 nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com,
 hannes@cmpxchg.org, roman.gushchin@linux.dev, muchun.song@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 rientjes@google.com, kernel-team@meta.com
Subject: Re: [PATCH v5 0/3] mm/vmscan: reduce lru_lock contention via
 vmstat-derived scan-balance cost
Message-Id: <20260804122616.46369067579b2bf7d678c03f@linux-foundation.org>
In-Reply-To: <20260727162550.2032-1-usama.arif@linux.dev>
References: <20260727162550.2032-1-usama.arif@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 27 Jul 2026 09:23:22 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> The actual code between v4 and v5 is the same. The last patch is
> now split into 2 commits and the commit messages are shorter and
> cleaner.

Yup.  A comment was altered.

Thanks, I updated mm.git's mm-unstable branch to this version.

> v4 -> v5: https://lore.kernel.org/all/20260720164207.450685-1-usama.arif@linux.dev/
> - Cleaner and shorter commit message (Johannes and Shakeel)
> - Split PGROTATE_{ANON,FILE} definitions and producer accounting into
>   a standalone patch, and document their public diagnostic value (Shakeel)

Here's how 5 altered mm.git:

 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~b
+++ a/mm/memcontrol.c
@@ -526,9 +526,9 @@ unsigned long lruvec_page_state(struct l
  * Do NOT use for non-monotonic page-count reads where a transient negative
  * reading from per-CPU delta skew must present as zero.
  *
- * XXX: This helper (and its node/global peers) exists because we place
- * monotonically-incremented event counters (NR_VMSCAN_WRITE and PGROTATE_*)
- * into enum node_stat_item.
+ * XXX: This helper (and its node/global peers) exists because some
+ * monotonically-incremented event counters are stored in
+ * enum node_stat_item.
  */
 unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
 					  enum node_stat_item idx)
_

