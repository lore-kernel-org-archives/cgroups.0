Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB93435AC12
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 14:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787927147; cv=none; b=UpqBsTjjFbWKj6EoPVXVhXqOSWwp6/WOE+vl7lYOHamY+/LR7CyEJ82bxwXqm4RqhLSjx0Nw/JE0KZKFk/rRX3Gu3Xscp80ixu1LmlrdYnG+0ruEnyMxiLPH40FbqkdIewLVNuUHEl7ZVOFWvYeARjjuGeNNRcLwJp1L4IkFyx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787927147; c=relaxed/simple;
	bh=gF7RjPEJRFWajt/OLcEI/3tzHIgjMyeLim53Upe2oFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FHyhGwlFpC1dSvUK+4ewVPZ5DgdVqirHnz9q3kBlJRYiCOuyJrVGxqhYd4RNSHKZE9zcNtwgNW5SdCqb01JkpyYqSx2soZmLvqaEAmPZ1+GFNRQK7P0yyEpaa6pg3nw5hgjhNdmvxDc5XtVYjO642amPICe5jNnPWEzH54UM3ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eXnuON0z; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eXnuON0z"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-482dd6ee390so899087f8f.3
        for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 07:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787927144; x=1788531944; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BoxMq16+fYtVCLi36Xsb9nn9RavJ5HgJioRujA1lSB0=;
        b=eXnuON0z7SL4oznMBGst9qSBcOo3fOl/LXUzgaBWnOHkjqXCUiOSiSCofWmNzhHuFt
         C9xsrjVFAkWVcRXUi26Je2nO0TvJRYOAaewoLpq1ve3q6g2jZk8jh2rGROy/4aQSRHYW
         6ORnDst3cZZHfeFdJYvQqM8KJRef48cFX+G9wSS4GUWORN26q6PcvCDEPdVPjduqDrSO
         9vGlee0KGMyx+Rz+pfZl09rQERxM146WBE1qkQ4AbtGa1c7YMbrzTbyjtusCuT+t6sx/
         wXzZ4Jzs2EDS2Xsncu2VaGp0cy3O4sJ5uuq+Wj2Y9vtpma1BhqyAA09utlk4JNEbTIql
         uxSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787927144; x=1788531944;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BoxMq16+fYtVCLi36Xsb9nn9RavJ5HgJioRujA1lSB0=;
        b=hqvHt0VHwzcmVZPfZytOhLYu1ep6WYn63BBWhHn2HiqrZdQ5powoEHn3mvr0n+BotH
         tfQ28klS4/VBr4sGInQsuYMJyF3dLUlmZvht8wYrEswYrE0ya+nn+WSO7UO9jgbhAxcu
         jYdd1IbxqeTXt/zMVcVlhRGqso9VTaHErURvkcGCaxxhlkzh/RRjX/Ms0gCCv8fY/UuF
         AVzGpd6WJTnTuLN4wgdC4Yk7glAzGW5Pc6jlZb91p9V9FWTTKACYrXn7oFcaBGJdDoNC
         /tUMczCiY88JLy2bev800D4bc5wRwfETELY07enZMn7eZoklOC+WUv7ZnOx+OxnDO0Ji
         toPg==
X-Forwarded-Encrypted: i=1; AHgh+RrmyBuN2qYR8ZrpJ5mgS47cb3yaIBvvk0gzlG9daul0+T5dRz3V6hAbW0PNOXKXUlj2H1qxxyu+@vger.kernel.org
X-Gm-Message-State: AFuF++mGpxwcOBP1lTo9WVjU4c7oseSdCSTemPnNXQQk8bKg8U4FydGw
	1G+EmEP5b50eBIu7J0TSkiah7oNvuWi4yYEjMnbs+kP8o0cQQeNUER/kSTQzl0ccVN4=
X-Gm-Gg: AR+sD12WJRTy3njNgDWfLHx5y8IdZafzSZDWs85Wvw3HvzY3E3yu6zLV8eK96aeIlJ9
	fw0fRP0NFORBhR8BQsVrSvdvDX4kFM45ImDHFCXiUINV2x5LcvQKs9dDxjprD1eZ6CEZ9oBg3nJ
	zgZlRJeWVHHYUw0AojKgoyMddLHhKBv9A8sDavrlk3DBc2ItfG0h9IP4qMFtXxxLBLLVlSmsixZ
	ocJc6ZmquN20zEXBnA4y7IdI7hA1yNXazvqSi9HPsghvhTNMbwHdqfPRLVHcGFMEseQ8QCt/Z/v
	aUugB7sN88VBC09joX6sOQcu0ZOYloHILq7oQ1uaA2kXeBdHJameGQuY8ewilkhAJDB2upXZJts
	kYmm0gRp+qcxuin7TLg3GWN3N8DarS7NYzICKZq3aZmEcTLQywuWmErZ6Hjb0Vzg3w5IrKjddic
	MB5SnlarjiFU+O+h7o8bhe5W2jSOar92Ibp0lC83mrJToSshhk+x097oOeDs+FA4IU9YGTAg1b7
	A==
X-Received: by 2002:a05:600c:b85:b0:49c:c96a:d36b with SMTP id 5b1f17b1804b1-49cc96ad411mr23596595e9.12.1787927143838;
        Fri, 28 Aug 2026 07:25:43 -0700 (PDT)
Received: from localhost (109-81-85-229.rct.o2.cz. [109.81.85.229])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49c5a903eebsm17011155e9.4.2026.08.28.07.25.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 07:25:43 -0700 (PDT)
Date: Fri, 28 Aug 2026 16:25:41 +0200
From: Michal Hocko <mhocko@suse.com>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm/memcontrol: avoid stuck FLUSHING_CACHED_CHARGE bit on
 isolated cpus
Message-ID: <apGaZdxAPH68kkCc@tiehlicka>
References: <cover.1787890328.git.riel@surriel.com>
 <a611f2bc40d30f9c14a6f41b173185975c46a203.1787890328.git.riel@surriel.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a611f2bc40d30f9c14a6f41b173185975c46a203.1787890328.git.riel@surriel.com>

On Fri 28-08-26 09:46:21, Rik van Riel wrote:
> drain_all_stock() can leave FLUSHING_CACHED_CHARGE set after the
> work is dropped.  It sets the bit before checking isolation and
> schedule_drain_work() checks isolation and queues in a separate RCU
> critical section, so housekeeping_update()'s synchronize_rcu() can
> race the second check.
> 
> drain_local_stock() only clears the bit for work that ran, so the bit
> remains set and the stock is never drained again.
> 
> Reorganize the drain_all_stock() loop, reducing nesting, splitting
> out local vs remote cpu handling, and skipping everything on isolated
> cpus, which solves the stuck FLUSHING_CACHED_CHARGE flag.

Is there any reason why we cannot simply clear the flag if the work is
not scheduled?
---

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 69b37f63a307..907ac63e5067 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2261,8 +2261,10 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
 	return flush;
 }
 
-static void schedule_drain_work(int cpu, struct work_struct *work)
+static bool schedule_drain_work(int cpu, struct work_struct *work)
 {
+	int ret = false;
+
 	/*
 	 * Protect housekeeping cpumask read and work enqueue together
 	 * in the same RCU critical section so that later cpuset isolated
@@ -2270,8 +2272,12 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
 	 * pending work on newly isolated CPUs.
 	 */
 	guard(rcu)();
-	if (!cpu_is_isolated(cpu))
-		queue_work_on(cpu, memcg_wq, work);
+	if (!cpu_is_isolated(cpu)) {
+		queue_work_on(cpu, memcg_wq, &memcg_st->work);
+		ret = true;
+	}
+
+	return ret;
 }
 
 /*
@@ -2303,8 +2309,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 				      &memcg_st->flags)) {
 			if (cpu == curcpu)
 				drain_local_memcg_stock(&memcg_st->work);
-			else
-				schedule_drain_work(cpu, &memcg_st->work);
+			else if (!schedule_drain_work(cpu, &memcg_st->work))
+				clear_bit(FLUSHING_CACHED_CHARGE, &memcg_st->flags)
 		}
 
 		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
@@ -2313,8 +2319,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 				      &obj_st->flags)) {
 			if (cpu == curcpu)
 				drain_local_obj_stock(&obj_st->work);
-			else
-				schedule_drain_work(cpu, &obj_st->work);
+			else if (!schedule_drain_work(cpu, &obj_st->work))
+				clear_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags);
 		}
 	}
 	migrate_enable();
-- 
Michal Hocko
SUSE Labs
