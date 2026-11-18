Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795012081;
	b=zoXGQb8HHRM5l457GiknU0NTvOJ/ZRXYCb7OMe/4XGGeFxqTV12tXbVz8ClhGdQVZOBI
	 ZD/cIeP43E+j6ozmnP7VRenD08JCSbYTPDKAIkge/UhUHs4X6a+Ty9othrXqGcmRZ89Mz
	 IAy1fi7aLWX2pnaLNjVSu9QkFqs00s3F5kO4UCr6dIxQejmswITvUf0mrA9O6KrUlfSIy
	 sTGlzw9xmprWWpQQOqHJExzo+cF2ZSCZi78Mvf0OgXHoKuAwR+E4bVWXLbdHR9s3qEO8f
	 43WXkUdFngAn5y6cFf6Krkj7+KOyZBo7/q9mRXPFlb6PqNlYWQDVfI6q8VvUe7t9u4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795012081;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=nZboGS9TzIUKYx8nlJm/8q9o+1lIrW0X9zgljbgU57g=;
	b=UTSEJUHDawb3zJWOEI3yp6G1E0W3eWAndNlg4BJp2uS/zjEHRY0rsLC10v9Ho1XdH15q
	 TvNyAxppYsBIZ0ZEQYMDjCg0bRM10hoR8hxmFcG/xGYkH+2EtOGBjRNiXvS5bhi1bZijz
	 gK7Ur5C3Rxm65jM9Pabyeu11brqXQ12CSNoAW6Unm57cpTRjB+u9uNdIVEgcsuwR3TkF9
	 b1E+oci2ThImpHWZww+K+Bypcyr9EkTwqL/Hu+Ta3XkPQiyt5oY63LXd3X7qNTg+wKe+n
	 2u+uZ5fGoW/B2VqWoLhs0kcM1cCzGomhfmfkROkOw+xwI4ruM3qbn8NKEflVvtdX5RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=QkYNVbFy;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=ovW6qsQm;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448F460A2600
	for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 14:27:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 448F460A2600
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=QkYNVbFy;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=ovW6qsQm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795012075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nZboGS9TzIUKYx8nlJm/8q9o+1lIrW0X9zgljbgU57g=;
	b=QkYNVbFysbtyTo4AxL9B0KwDuvSpfKKsbLodLqm+JE17yhpqM0Uc1uPV54vOxQ2dt2R8Mp
	DR5gWNMiUB1X7iZeh1X3GFSnqhRQITCHNkf1td9SMRIMjElUawN3/Z15TV4NKlFp/cpIEF
	H5TGVjuYC28MEq+4aildZ7y8A8b27uc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-vsD3bnMiMDGMyAdYH1jM2Q-1; Wed, 18 Nov 2026 09:27:54 -0500
X-MC-Unique: vsD3bnMiMDGMyAdYH1jM2Q-1
X-Mimecast-MFC-AGG-ID: vsD3bnMiMDGMyAdYH1jM2Q_1795012073
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-490d2ac331bso1103197f8f.0
        for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 06:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795012073; x=1795616873; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nZboGS9TzIUKYx8nlJm/8q9o+1lIrW0X9zgljbgU57g=;
        b=ovW6qsQmxXVAihs5E/C0Up2koWSJwl97J3RlT0gDjxNl/3ewPaKcGrXV6X/pbbBTw2
         xi9g//5llwdtKmaJLelowcrxl6y2x+sSq/SIaGXuPrGIx7XotPDQPhf3iy6TPJp63kL4
         z3BSDoag6uBYVTcj7pKhffpS/T6Nx38DFBhbvGqc6b472iaOq7TrkQ4AqGzbrwYncE6F
         24mDqAPo/P1px0V9gCwDqrbihj3uE9zsWEh4eM7S8K66PxOvWYx6UwR6BnOD5nLDovKG
         ZgBLNUOY7akxZNQFRg8u9y4rWNLBdBE+JiRdlM+VlZqGrz+8T5aX1b4vTxhG8aQYZkGP
         G7bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795012073; x=1795616873;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nZboGS9TzIUKYx8nlJm/8q9o+1lIrW0X9zgljbgU57g=;
        b=np/aI/zu4WQ/1J4Soos9X9uPMRNJNcIw1GIOwUtS4vZKJl6KCj9otFayI0Oa/zMGDc
         FHjcV1nv0ilQCyelBD7g0/PjhIgBcBstcu8KOtDzoXOuMH6YvJ+sYuTpGucn23WeG5sZ
         1BWmlAksL0rj5TYv5UXoEWMlqmKlZLmTdFdRKnG4DdsxcPza5qM+qJGMMqv+sFnJzb+8
         4gxgKq62gcb9TfbY1vINrgyvYImLQn9u2Q22g6peZx3AMgu3iJWoT2x6xkc/jjkvaC31
         t/VQXixcHkE9EKeDdJiMmGIFvF1Ecqarh3TS8aCvykWuo+bLexKepI2J4nH96ts5QThZ
         MvgQ==
X-Forwarded-Encrypted: i=1; AL+hErHE0bAC75fB2lcdGMlBB18bWHtiiOjNDA/DVPsRFeCtBsC35cZtbVEnrV87K/LP2lasIKokVWve@vger.kernel.org
X-Gm-Message-State: APuU4Z9I+NLoAJvKz2m4QZ2fwiLpKvtGzxHh082LGsrRyqStGNKseRvP
	CSzykmyTdzQHnWYUnZZFjxOl2TTK0ln2GKeW2fz+jAY33cJ8cssN6yXqZWCa+vXZBnK1ewYVzFB
	YDMvdzEZobubPTGXSQVDLbnuOuyjDIscg/vkk5Cl98xPL2nuDkTOUkwIro8I=
X-Gm-Gg: AZFdTZeQdAcUlOOhZ4XObsWONuz6eLKMsete2vwLg3KsC3whwrwOgF9sfF7hfFNObiK
	XawPg2OIys1ythKUo/rppP0CSftC4VSKiiEPpryoEBIWLKQaKpO2lcvYC0hVVhaMZiBLNyHnw3Z
	D0NDCmDi4Borb8bXc6OjOSJUHDIZy0XuMYsinWdiEtAfoB4bu8Fni7dJOkNJ/aPJ2fGQnvfC3ka
	li9veBlIMkGMAXN8I4+cFToOpzoUw/P4lKr8kS/aCb6O5uAoFeRyTS+fAGcrL1wE5VTlmyhrMcj
	jyVJQr3NxpSpC4UQjZctpVNNat8MzJdrd6fP2awmfu6bIVeE2JQXiioJBEwF9UsXeMhp5wLT7v2
	BprrUU35oxE+6RnFuo/7VHkZ6zScB04pNf1Nt53ZmoRX9Ak4BlWXrUl/OhDYOdlqqimHmFsjh/i
	3nl1c=
X-Received: by 2002:a5d:5888:0:b0:48d:ff71:dd87 with SMTP id ffacd0b85a97d-4a639475750mr5574843f8f.17.1795012072805;
        Wed, 18 Nov 2026 06:27:52 -0800 (PST)
X-Received: by 2002:a5d:5888:0:b0:48d:ff71:dd87 with SMTP id ffacd0b85a97d-4a639475750mr5574789f8f.17.1795012072412;
        Wed, 18 Nov 2026 06:27:52 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a656933961sm5275395f8f.46.2026.11.18.06.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 06:27:51 -0800 (PST)
Date: Wed, 18 Nov 2026 15:27:49 +0100
From: Juri Lelli <juri.lelli@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
	linux-kernel@vger.kernel.org, tglx@kernel.org, will@kernel.org,
	boqun@kernel.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
	kprateek.nayak@amd.com, luca.abeni@santannapisa.it,
	mathieu.poirier@linaro.org, longman@redhat.com,
	ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, shuah@kernel.org, bigeasy@linutronix.de,
	clrkwllms@kernel.org, parri.andrea@gmail.com,
	m.szyprowski@samsung.com, kayracizmeci@gmail.com,
	weihengqiuu@gmail.com, cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH v7 09/40] rtmutex: Continue the chain walk when a
 waiter's deadline donor changes
Message-ID: <av215SnBF5GShg0J@jlelli-thinkpadt14gen4.remote.csb>
References: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
 <c8b228501d8981454f63843b394019fefd4002f3.1794922146.git.mathieu.desnoyers@efficios.com>
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
In-Reply-To: <c8b228501d8981454f63843b394019fefd4002f3.1794922146.git.mathieu.desnoyers@efficios.com>

Hello,

On 17/11/26 09:10, Mathieu Desnoyers wrote:

...

> Fix this by recording the donor in the waiter with the sort keys, in
> waiter_update_prio(). rt_waiter_up_to_date() compares both. The walk and
> rt_mutex_adjust_pi() use it. A new donor then takes the walk on to the

...

>  kernel/locking/rtmutex.c        | 22 ++++++++++++++++++++--
>  kernel/locking/rtmutex_api.c    |  2 +-
>  kernel/locking/rtmutex_common.h |  3 +++
>  3 files changed, 24 insertions(+), 3 deletions(-)

Thanks for confirming the Sashiko finding and for the plan in your reply
[1]. As you note there, a window remains however the walk is changed,
because the donor pointer holds no reference on the donor. So I have to
wonder (and ask for Peter, Thomas, etc opinion) if we'd rather not keep
extending the chain walk for DEADLINE PI, which is known broken and
proxy execution is going to replace anyway, and leave rtmutex.c alone.

It looks like what we lack is memory safety, apart from accurate PI.
It's an hack after another, but how about having the owner pin its donor
instead: take a reference on the task behind dl.pi_se whenever it is set
to another task's entity, and drop it when pi_se changes
(rt_mutex_setprio() and __setscheduler_dl_pi() are the only writers).
The donor then stays allocated at most for the owner's critical section;
its parameters may be stale or cleared meanwhile, which
replenish_dl_entity() already copes with after patch 8; and the owner
may keep running on a stale donor, which is no worse than today's
DEADLINE PI. Thoughts?

Not against doing "the more right thing" of course. Just evaluating
alternatives.

Thanks,
Juri

[1] https://lore.kernel.org/all/f535fbbd-2247-4d0d-9771-a67116fda1a2@efficios.com/

