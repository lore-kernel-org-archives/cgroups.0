Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.219
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793685258;
	b=WBm8RmvavLvTJ2Cjy4zetuh3zYmLmW39E5qUpMMWmZc+sTydOtp8nOX/IMgF4hqyc/Y0
	 XKmc+TdyJQAfaDTzOseivW9b0EPpCgvP4M/eXuKQkGYOw9buLLblzlZulkCm8TkzW5edg
	 vZ32g966gGEbmA+L6cO+/UAf7Zh065G9vigOP7+Dar7r6DDH6VZGlO9Knrit04FlNRxgy
	 IPjWkoW5LP4YSceGKAn/vWf/5Q+a9rpmC1lxbdmr18f4Y8b06YfydCptWDn4xVrVGdV01
	 XeeSIHuY40y7ftinbygZoL81lNUjt96y25+uhtI3/cDovcAf9dkpLFA6mu84ih2ph/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793685258;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=f6tohwCPgHiuZF8eRH66ZKcFUC+TlKOu4ZWfBkxIU9w=;
	b=mUYmgB3pyXs3Qh3lK20RJxtPytvQh6U/QwWDELx0ZMcAbX5K1YodxeDOCExzbBm6q5v9
	 TJZbngtvHFJ/TdmrrImyhCS1pWhfQaP6nB+fXgSehCxd2+kRVghHYWgvuXRELAVDJ4b3F
	 41PZoQ6QTdHLmyRl3MLMT12BbZl2dhgEsqR6SjhCLrnPIm90qdUoPUNmKt9WTayrUcQxV
	 xTujpE6ZfqWsVvNK4zV8SLRKJnhSPixEHjy8+tp5bI0HbJ0hwm366AxPFIcjGcMzOh70W
	 puK+zjDiLvtfDzpsGYwNLY24NcKMYNHoQWt5QwLVFMHvUM9gKn15rbHyvn6QhJhDmPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="PU6M/JuI";
	arc=none smtp.remote-ip=95.215.58.219
Received: from mta1.migadu.com (out-219.mta1.migadu.com [95.215.58.219])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88270606A32C
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 05:54:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88270606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=PU6M/JuI
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=0iTU/obU9AJ9W0pesgfQNaEftQkREMOsnsvVS/OmldY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793685254; v=1; x=1794290054;
 b=PU6M/JuIkSLzUXuS6JZKKUvE//74A4tu1nNGmYcFb/OMTL0YL2iWlmVRngQpvLppWY+UhK4L
 kOzLqJsPN0sy3ZFQ/p/WeBzIG0EjJn/+UE88cigpF9T1Kfjp+xeur+8O/wE60EIjkouagxq2puf
 25tElufqBKwzf+kZFylFCdkE=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 4e3eec371c58ba17;
	Tue, 03 Nov 2026 05:54:14 +0000
X-Mizu-Trace-ID: 4e3eec371c58ba17
X-Migadu-Flow: FLOW_OUT
Date: Tue, 3 Nov 2026 13:54:07 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v6 6/7] mm/mglru: add lruvec_gen_size() helper
Message-ID: <aul2_8m90FuzSnqv@fedora>
References: <20261103025610.3738894-1-ridong.chen@linux.dev>
 <20261103025610.3738894-7-ridong.chen@linux.dev>
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
In-Reply-To: <20261103025610.3738894-7-ridong.chen@linux.dev>

On 11/03/26 at 10:56am, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> The number of pages of a given type in a generation is computed by
> summing lrugen->nr_pages[gen][type][] over all zones and clamping each
> per-zone counter to >= 0, since the counters are updated locklessly and
> can transiently go negative. This loop is open-coded in
> lruvec_evictable_size() and in the debugfs lru_gen output.
> 
> Add lruvec_gen_size() to compute it from a seq, and convert both users.
> Put it in mm/vmscan.h so that the vmscan tracepoints, which include that
> header, can use it as well.
> An upcoming tracepoint and the MGLRU swappiness rework will also use it.
> 
> No functional change.
> 
> Suggested-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  mm/vmscan.c | 18 ++++++------------
>  mm/vmscan.h | 16 ++++++++++++++++
>  2 files changed, 22 insertions(+), 12 deletions(-)

LGTM,

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 3054175717ab..1581b73aec56 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4207,18 +4207,15 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
>  
>  static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness)
>  {
> -	int gen, type, zone;
> +	int type;
>  	unsigned long seq, total = 0;
>  	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>  	DEFINE_MAX_SEQ(lruvec);
>  	DEFINE_MIN_SEQ(lruvec);
>  
>  	for_each_evictable_type(type, swappiness) {
> -		for (seq = min_seq[type]; seq <= max_seq; seq++) {
> -			gen = lru_gen_from_seq(seq);
> -			for (zone = 0; zone < MAX_NR_ZONES; zone++)
> -				total += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
> -		}
> +		for (seq = min_seq[type]; seq <= max_seq; seq++)
> +			total += lruvec_gen_size(lrugen, type, seq);
>  	}
>  
>  	return total;
> @@ -5723,20 +5720,17 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
>  		seq = 0;
>  
>  	for (; seq <= max_seq; seq++) {
> -		int type, zone;
> +		int type;
>  		int gen = lru_gen_from_seq(seq);
>  		unsigned long birth = READ_ONCE(lruvec->lrugen.timestamps[gen]);
>  
>  		seq_printf(m, " %10lu %10u", seq, jiffies_to_msecs(jiffies - birth));
>  
>  		for (type = 0; type < ANON_AND_FILE; type++) {
> -			unsigned long size = 0;
>  			char mark = full && seq < min_seq[type] ? 'x' : ' ';
>  
> -			for (zone = 0; zone < MAX_NR_ZONES; zone++)
> -				size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
> -
> -			seq_printf(m, " %10lu%c", size, mark);
> +			seq_printf(m, " %10lu%c",
> +				   lruvec_gen_size(lrugen, type, seq), mark);
>  		}
>  
>  		seq_putc(m, '\n');
> diff --git a/mm/vmscan.h b/mm/vmscan.h
> index adb22e80d760..c6b583fc7493 100644
> --- a/mm/vmscan.h
> +++ b/mm/vmscan.h
> @@ -3,6 +3,7 @@
>  #define _MM_VMSCAN_H
>  
>  #include <linux/gfp_types.h>
> +#include <linux/mm_inline.h>
>  #include <linux/nodemask.h>
>  #include <linux/swap.h>
>  #include <linux/types.h>
> @@ -115,4 +116,19 @@ struct scan_control {
>  	struct reclaim_state reclaim_state;
>  };
>  
> +#ifdef CONFIG_LRU_GEN
> +/* The number of pages of @type in the generation @seq, summed over all zones */
> +static inline unsigned long lruvec_gen_size(struct lru_gen_folio *lrugen,
> +					    int type, unsigned long seq)
> +{
> +	int gen = lru_gen_from_seq(seq);
> +	unsigned long size = 0;
> +
> +	for (int zone = 0; zone < MAX_NR_ZONES; zone++)
> +		size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
> +
> +	return size;
> +}
> +#endif /* CONFIG_LRU_GEN */
> +
>  #endif /* _MM_VMSCAN_H */
> -- 
> 2.34.1
> 
