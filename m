Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D047439CCF3
	for <cgroups@vger.kernel.org>; Tue, 28 Jul 2026 19:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785266627; cv=none; b=rZxPFlHsrmioS0JHFBJIE9Dr3pCpARp9u7vqAqTz/rkmb0BrYSAHUBnNiWGAhZTNGGbzNEM+VajnOXr+45wxwPid4bqZSt0FnLzLvuU3FXHGWflLx0PIvq7M/DaFE1Eg7SvkBI/9Z9RFV8q2wbMqdXwbrgV1HXSLPuOuvAaJjnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785266627; c=relaxed/simple;
	bh=pBhHjY4lmyfN+zGiDNSUsLHi2xqfgYzXS+aNGMlJq9k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eJSMrzp9iKAF4bzCeKnCRrdvRZbdj1UnBOhBLNAdUb4FzlN4iztQdcHWk6DwGzxGU2R107mT95Q+ihoa9+XuCh4bYb7TZ/m1G3g6b5NgGtXHYrp4bK8DQSgpuC3QZUJOjpylG4MdJsidZR1C/s0wBlRzGUOfPHkc0B99SSIZn4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IK6oJ86Z; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IK6oJ86Z"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-471eeac43bfso197207f8f.3
        for <cgroups@vger.kernel.org>; Tue, 28 Jul 2026 12:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785266623; x=1785871423; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=K8qZfjaxhGbSgiZnpnKGN1HzCLFjiwC8FeQ/0VidGnU=;
        b=IK6oJ86ZF9qx1GtzaORjQ2Iuhjxr1H3CHcXzxrFiKtMDuRaDwyUVvb6fb28VXLSn84
         RpjgUc93e1t3Y3vEJjCKB9wWolGMT1hPuEoUBF7p0FH2OTAoOwH21b4+YLAu7kpOGx6H
         9Jy1EDVImq+CwJTeciiv5G6JOCiFATmWPPDQ7/WL8LwdDMaL4w57+dgIJ/YIylCR0Fsi
         wzo4Ul/PrOkybMB7WfI31f9hOliD/3OPbBo49dyjswbnyGaStmrqcP7ogC5bsEOBEr1e
         i71CrGZH1oXxUQfweZCu2xC4xAH8s5AT6N7DcZf9DXo4RR8/e/DIXTBtx5EsGqKqqxJ4
         090g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785266623; x=1785871423;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K8qZfjaxhGbSgiZnpnKGN1HzCLFjiwC8FeQ/0VidGnU=;
        b=WYjk+R8uTPBtnAckLvzsWkejH3xwc88fEoh33Mw/z6IWHNqJtYjvWfakMGXj2iP5Ul
         H5PZuQOkj/2i5v8PVryXuAyzQda+q8iFS7UQRpF9dDeEuMdKLnIfwgzm3TStNKfbbfF8
         CJ1vRscB2JF8EMZmyLKkiXcC0Qs3CtmUNTovhkHWv/YP6hiI3TN9Hb+KQ/EmIeYpYH/h
         hpuxv/GtNWMbvfqfuj0pyExbRNinKkZWxQDWb+jULs2hd+mDpXgOqCE79kOyvcm0T/mt
         knfGz8wOt3u8RMQ4PqcnEvG8MrNUBQZdb0XRdpcXnJ3JDvw5vwRZwryKN1kzwjf3w0t4
         AzwQ==
X-Forwarded-Encrypted: i=1; AHgh+RrwchcKDE5ea/f54iYZAkAycX/mLs7AamCIA5SMlNLtCUbs9x8IaXj5w2/jW42xh/abtsnjqvYe@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7IlpOCXtw/yn9DzJaZ/U0Qtd+ZTb+dsFNspWIkmGi7JcLVxCJ
	i+GOYXWC12EUHFALt7daaYJ8CKgw7BGqDu6T49zbN9/6n9/CXcWv4tEqeyhPoPQ0tBU=
X-Gm-Gg: AR+sD11j57y+ny7cm2JWI1ATT3PSdV00XLiOY25vJ7zqrcykKfZTAzXJ4uSW3Jxjlqv
	sD6dnAKnbKqo1ZLrDwbRTuzGSclksD7gbJM8NZ8bwAjwPy+YxXRhukIvU9p6K6lBpsgelaIyvhN
	qcKizTRTXG2hU7FI+KbxlcUiHB8TY8dPD/n7rYnIgj+5t5VWpy2qqDXEC4dWaD/qGAdOc2LeVg1
	/koomxyrr0chOztOcKQPJCXw3AE0EZ/iL+NiGC7QM86WXJslPWrreEo42kzDjQ9gZdkz+twarIg
	6ByP/bB3IrhmKHb7lzpkvyDSmKM000hr2qp2gk83fiUDNBkBcSuoqyS5/j3ceROr1TqLooyXYkk
	34R6Mlyy7A2w3WRKQBfVTCp0J+fBvZLex5sdwxojYCwaS6u46eUTsPIeL0OGVuv6J8bmXSUejHv
	EmojNhgQFWSzs61XuzY9U+knD6G35xyOto9HtMfY3dMBvOwcU7ssoOkFx3d+JcQD3QvIgd
X-Received: by 2002:a5d:5849:0:b0:47f:8f8f:e494 with SMTP id ffacd0b85a97d-47fb1ec88d4mr4116620f8f.2.1785266622998;
        Tue, 28 Jul 2026 12:23:42 -0700 (PDT)
Received: from localhost (109-81-83-7.rct.o2.cz. [109.81.83.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6b189fbsm1268107f8f.25.2026.07.28.12.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 12:23:42 -0700 (PDT)
Date: Tue, 28 Jul 2026 21:23:41 +0200
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
Message-ID: <amkBvRSJm5rgiV5Q@tiehlicka>
References: <20260723001908.4046643-1-shakeel.butt@linux.dev>
 <amds50dIVOiQNz0k@tiehlicka>
 <amd6N4DVzZkl90cs@linux.dev>
 <ame7Q-0eVRrtt34j@linux.dev>
 <amhZ645Nhj856JfO@tiehlicka>
 <amjeUV3dAn7KPQgK@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amjeUV3dAn7KPQgK@linux.dev>

On Tue 28-07-26 09:55:21, Shakeel Butt wrote:
> On Tue, Jul 28, 2026 at 09:27:39AM +0200, Michal Hocko wrote:
> > On Mon 27-07-26 13:48:58, Shakeel Butt wrote:
> > > On Mon, Jul 27, 2026 at 08:38:37AM -0700, Shakeel Butt wrote:
> > > > On Mon, Jul 27, 2026 at 04:36:23PM +0200, Michal Hocko wrote:
> > > > > On Wed 22-07-26 17:19:07, Shakeel Butt wrote:
> > > 
> > > [...]
> > > 
> > > > > 
> > > > > TBH I am not entirely happy about this approach. It effectivelly reverts
> > > > > a75ffa26122b ("memcg, oom: do not bypass oom killer for dying tasks").
> > > > > It just makes it lockless. Assumption that a dying task will do so
> > > > > quickly and with bounded resources has turned wrong on several
> > > > > occasions.
> > > > 
> > > > That's why I kept it as RFC :)
> > > > 
> > > > > 
> > > > > On the other hand I do undestand the contention issues and I can imagine
> > > > > that the existing solution doesn't really work well for huge thread
> > > > > groups that all end up lining up on the oom_lock just to learn there is
> > > > > nothing really killable anymore because they are the oom victim...
> > > > > 
> > > > > Would it be just safer to bail out only for oom victim threads. This
> > > > > would narrow down potential runaways for oom victims which should be
> > > > > more limited than any killed/exiting task. It would also give the oom
> > > > > killer/reaper chance to work. WDYT?
> > > > 
> > > > I will give the following patch a try with the reproducer I have. I am still
> > > > improving the reproducer as I am still not able to recreate multi hour slowdown
> > > > yet. I will report back once I have some results. 
> > > > 
> > > 
> > > I have some results with the reproducer I (AI) wrote.
> > > 
> > > Setup: 20k threads, each with its robust_list head on its own page in a
> > > large anon region pushed into a zswap pool (writeback off, so it's
> > > unreclaimable and pins the memcg at the limit). On the OOM-group-kill
> > > every thread faults that page in futex_cleanup() -> do_swap_page() ->
> > > swapin charge -> memcg OOM. A separate thread holds mmap_lock for write
> > > in a loop so the oom_reaper can't reap the pool -- matching the host,
> > > where the reaper was blocked and the memcg never fell below the limit.
> > > 
> > > I tested on next-20260726 as baseline and then tested your suggestion over it.
> > > For baseline ~48k no-victim OOM invocations serialized on oom_lock; ~40s to
> > > drain the 20k threads in a VM (hours on the host, where each invocation
> > > was a dump_header over netconsole). With the patch the dying tasks stop
> > > entering out_of_memory and the storm is gone.
> > > 
> > > With the following suggestion, the threads of dying tasks stop entering
> > > out_of_memory but the exit time doubled as each thread has to decompress the
> > > page from zswap.
> > > 
> > > 	if (tsk_is_oom_victim(current))
> > > 		goto force;
> > > 
> > > I also tested by replacing goto force with goto nomem and the exit time halved
> > > i.e. ~20 seconds. Looking deeper it seems like each thread is still going
> > > through the reclaim loops.
> > > 
> > > Just for testing purpose I moved this check along with goto nomem just before
> > > the reclaim fuction i.e. try_to_free_mem_cgroup_pages() and the exit time falls
> > > below 1 second. I think what we need is to detect early that the cgroup is
> > > unreclaimable and the threads of exiting/reaped process should just return with
> > > enomem.
> > 
> > Do you mean, something like this?
> > --- 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 6dc4888a90f3..66f1eebf8c22 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2648,6 +2648,18 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >  	if (!gfpflags_allow_blocking(gfp_mask))
> >  		goto nomem;
> >  
> > +	/*
> > +	 * OOM victim still needs to charge memory to exit. OOM reaper should
> > +	 * help but it might fail on mmap_lock contention. If the victim is a
> > +	 * large thread group then all exiting threads might compete on oom_lock
> > +	 * just to learn that there is nothing really killable anymore. Bail
> > +	 * out early and fail the charge to expedite their exit. They are
> > +	 * considered fully reclaimed by the oom reaper and they shouldn't contribute
> > +	 * further charges.
> > +	 */
> > +	if (tsk_is_oom_victim(current) && mm_flags_test(current->signal->oom_mm))
> 
> I simply had tsk_is_oom_victim(current) check here. 

I was hoping for a more specific treatment. 

> I assume you want
> MMF_OOM_REAP_QUEUED in the mm_flags_test() above. Do you want me to test with
> this additional mm_flags_test() as well?

Sorry I meant MMF_OOM_SKIP there.

-- 
Michal Hocko
SUSE Labs
