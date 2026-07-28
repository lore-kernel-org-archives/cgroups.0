Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647423BB665
	for <cgroups@vger.kernel.org>; Tue, 28 Jul 2026 07:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785223664; cv=none; b=FPtDBeZKDj7YvpkywUJHwukC7dWRnxlUfDfGYRYoxVS4Wegs02bJWhDCfsst2SJyC25v9mjE3gP0zym8WI/nqLnpapmUaq6eJgtQ5vPPY3vstdBGT3Qdy6c2/2+vNhO6PdKjUvtVtHZani0LrHI9oTe3wCXQp9cUOKx7srhdS8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785223664; c=relaxed/simple;
	bh=+VIdQB8Y6n1nzeewNmjmBI5PJhNouHzScrlj27XZY/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KrqUsm25593mDae0Wky1jBAFWrG7DJtQ5n5bqMFDCQSEfuYVU3P8lqQVT981SZY5LKCjMwwFx3u0xd7wU2Q5pQvWXqONDsrbawyaG7L4j8zGH6y7tesQEhpxnKV9EDkGusu31cCuqfRgjWr7GnR0zBdPjCQaaORZpO1RRCQrDgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LTRfefHb; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LTRfefHb"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4956869750eso26302615e9.2
        for <cgroups@vger.kernel.org>; Tue, 28 Jul 2026 00:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785223662; x=1785828462; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jftrX6lDinngHjdgigXRLobwfxyYWK7HW27rdPPfohU=;
        b=LTRfefHbRgLiWX2B9em5mJXIh9FWpuqJlQpjiFIWY2LvKc7GUz3kdpXGuXjiwDaGXy
         3E1UEaRnkA7EdaWH9p6I57jDZx+Kjl3qAZztcW/mssLVsXr9tqSjy6eYE7rClAZ/xREq
         gA7CZiqupAN1/Y7edl11X7S6rnHsyuJ/3GwlXxa0+TC2OMA+zNs1YYOlVk8QPCbR7Dpq
         LRAVBquL2zeYkEeG5+/3DLnf3MMj3jUoTN6xJDdLmlWfP4qiGHygvJVKPn8dzfsELR37
         VUH64f69aO7xX/AjTzvY3QMv+dKi7PcX1QQ5yycXwx4RAn/7XSdnAgqLCkxlJL94z70I
         qK0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785223662; x=1785828462;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jftrX6lDinngHjdgigXRLobwfxyYWK7HW27rdPPfohU=;
        b=UJM+nrYuRk7msqhxrKM2zbk6Vn3xvQzhVPOiMHDcdhmHiw3mZ9xKVr3QVb3I5Mt0Dr
         5ywncxoDYp/p/yy3B1oq67MWWRXqAsPytkTcYLiR7CqiQ0B7E8nf8EMZ+BVl6aU4foM7
         F7LZAB2lvCSEWugvalCndyQOrVZKuj4/DJ2K2kRKj2PPpEuo4eHWPowJ8fI5H/lSB4eT
         k90ujtI09rCzTxHAK4XzjvinbbD+mo87dj6zmZASGdR5NYb6KNXIeP2rvI6dUJbY2U3P
         CurSlygviYIueAzfILAr3R/DS/z0zl7VnmEUNeSdF/GurfrWxskG3yJQmkSoIlqd8qWR
         F5fw==
X-Forwarded-Encrypted: i=1; AHgh+Rp8eDhZLVYJMBru4iUZgXAfawPYricwW0DkYtRn3qr+2UAJIf8B8nRo+Cr4Tqn3w4zvKmPDgHAc@vger.kernel.org
X-Gm-Message-State: AOJu0YyXJf+hDOGMd/Y/x7M2v1+WLSY/i69A0xNHoQcuOAklN8K30Ece
	ArWG1MA2TU75iaKOM1IVC1So/A4egfvkZMCv8X/FjE8r1qre+6Q2/Ao9Bg6GpQGlPXY=
X-Gm-Gg: AR+sD10AcSzEXIv5QtNf+7j9QXSzRP6kTiXVyvAps5s//iOq/han/AD2oGyLvo9wWRq
	V+zFV1knno/xjTFrMi6OUrfUzBGJEuitvw6wP8KLe3/X7bLMqd34eLYCG4cMXqjIwOFeG/eWQ4s
	Pa6YlErRVkSZqm5UNrZu/X/Nz1nNdq9dLffIr+mUxO6DcLsGGhLY5P7Rmz0AIXai87jfwd8VViz
	iuQM1FpWVoU6l78WDmWcZFBk7bO1YZxn9htkErnq1flSqVMmcBKQQPkOHKZhnQYnunUQEv5njRH
	PhuhFYfBoRMiDVub4LkpJ7wakSZY+ikRSq+Hwfy4QzkRbAC5b57t/Ee+d9UGxd1oIiFOQtanDZc
	n/eOYhsRASShLLFkozgtQLMBsEiEs+oyNNq79dIcgfeqWuHnaSG5tF7jlNUUV9wtIyDx0H4cpu8
	EMcmWvBpejbg==
X-Received: by 2002:a05:600c:1c27:b0:493:e974:41ac with SMTP id 5b1f17b1804b1-496c643c6f9mr11555145e9.16.1785223661467;
        Tue, 28 Jul 2026 00:27:41 -0700 (PDT)
Received: from localhost (109-81-83-7.rct.o2.cz. [109.81.83.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496c4632263sm58920795e9.15.2026.07.28.00.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 00:27:41 -0700 (PDT)
Date: Tue, 28 Jul 2026 09:27:39 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Rientjes <rientjes@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Darren Hart <dvhart@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	=?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@igalia.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Yosry Ahmed <yosry@kernel.org>, Rik van Riel <riel@surriel.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Robust futex causing memcg OOM storm on exit
Message-ID: <amhZ645Nhj856JfO@tiehlicka>
References: <20260723001908.4046643-1-shakeel.butt@linux.dev>
 <amds50dIVOiQNz0k@tiehlicka>
 <amd6N4DVzZkl90cs@linux.dev>
 <ame7Q-0eVRrtt34j@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ame7Q-0eVRrtt34j@linux.dev>

On Mon 27-07-26 13:48:58, Shakeel Butt wrote:
> On Mon, Jul 27, 2026 at 08:38:37AM -0700, Shakeel Butt wrote:
> > On Mon, Jul 27, 2026 at 04:36:23PM +0200, Michal Hocko wrote:
> > > On Wed 22-07-26 17:19:07, Shakeel Butt wrote:
> 
> [...]
> 
> > > 
> > > TBH I am not entirely happy about this approach. It effectivelly reverts
> > > a75ffa26122b ("memcg, oom: do not bypass oom killer for dying tasks").
> > > It just makes it lockless. Assumption that a dying task will do so
> > > quickly and with bounded resources has turned wrong on several
> > > occasions.
> > 
> > That's why I kept it as RFC :)
> > 
> > > 
> > > On the other hand I do undestand the contention issues and I can imagine
> > > that the existing solution doesn't really work well for huge thread
> > > groups that all end up lining up on the oom_lock just to learn there is
> > > nothing really killable anymore because they are the oom victim...
> > > 
> > > Would it be just safer to bail out only for oom victim threads. This
> > > would narrow down potential runaways for oom victims which should be
> > > more limited than any killed/exiting task. It would also give the oom
> > > killer/reaper chance to work. WDYT?
> > 
> > I will give the following patch a try with the reproducer I have. I am still
> > improving the reproducer as I am still not able to recreate multi hour slowdown
> > yet. I will report back once I have some results. 
> > 
> 
> I have some results with the reproducer I (AI) wrote.
> 
> Setup: 20k threads, each with its robust_list head on its own page in a
> large anon region pushed into a zswap pool (writeback off, so it's
> unreclaimable and pins the memcg at the limit). On the OOM-group-kill
> every thread faults that page in futex_cleanup() -> do_swap_page() ->
> swapin charge -> memcg OOM. A separate thread holds mmap_lock for write
> in a loop so the oom_reaper can't reap the pool -- matching the host,
> where the reaper was blocked and the memcg never fell below the limit.
> 
> I tested on next-20260726 as baseline and then tested your suggestion over it.
> For baseline ~48k no-victim OOM invocations serialized on oom_lock; ~40s to
> drain the 20k threads in a VM (hours on the host, where each invocation
> was a dump_header over netconsole). With the patch the dying tasks stop
> entering out_of_memory and the storm is gone.
> 
> With the following suggestion, the threads of dying tasks stop entering
> out_of_memory but the exit time doubled as each thread has to decompress the
> page from zswap.
> 
> 	if (tsk_is_oom_victim(current))
> 		goto force;
> 
> I also tested by replacing goto force with goto nomem and the exit time halved
> i.e. ~20 seconds. Looking deeper it seems like each thread is still going
> through the reclaim loops.
> 
> Just for testing purpose I moved this check along with goto nomem just before
> the reclaim fuction i.e. try_to_free_mem_cgroup_pages() and the exit time falls
> below 1 second. I think what we need is to detect early that the cgroup is
> unreclaimable and the threads of exiting/reaped process should just return with
> enomem.

Do you mean, something like this?
--- 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dc4888a90f3..66f1eebf8c22 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2648,6 +2648,18 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (!gfpflags_allow_blocking(gfp_mask))
 		goto nomem;
 
+	/*
+	 * OOM victim still needs to charge memory to exit. OOM reaper should
+	 * help but it might fail on mmap_lock contention. If the victim is a
+	 * large thread group then all exiting threads might compete on oom_lock
+	 * just to learn that there is nothing really killable anymore. Bail
+	 * out early and fail the charge to expedite their exit. They are
+	 * considered fully reclaimed by the oom reaper and they shouldn't contribute
+	 * further charges.
+	 */
+	if (tsk_is_oom_victim(current) && mm_flags_test(current->signal->oom_mm))
+		goto nomem;
+
 	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
 	raised_max_event = true;
 

-- 
Michal Hocko
SUSE Labs
