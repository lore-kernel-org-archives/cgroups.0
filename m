Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B452D3733
	for <cgroups@vger.kernel.org>; Wed,  9 Sep 2026 05:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788931081; cv=pass; b=mgJjb3vIN8fXckaRvOm0SFtykL0sUteA6+JS7xuYyyVkmJT3rHk9KYtgycEzC3dzQNyloi27aIKxff/FpQ3PrWp5qT2y4+4dKsly9wua8N1OW5+9fc3j3bHPUnFLgz7XGdwbTS/eb/mwZwFJjbGHKqn0pJulof6IKsZmzDx2JZ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788931081; c=relaxed/simple;
	bh=lTUeH7uBg1apEPj4h8nGLSJDSLS3Xk4Z953/h7Ad4fE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HZ6pKgXVVVCCnAZYSGRhtBMryX/jJ0I9mcG7Dp/5uEXZWaitCBHMZUdkt6XA5NbNb9CMyi8GAlG/Lw5j8MEu1Z3MUFN21hxCHImCMsFBmwEkWb81DppmRTtBVLGLLppsgRa7IMyS67gKykFsinG2OXlmLLRDk7SifouF8p+lLUs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lO+67OJ3; arc=pass smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lO+67OJ3"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4998b5a63e2so63765575e9.1
        for <cgroups@vger.kernel.org>; Tue, 08 Sep 2026 22:17:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788931078; cv=none;
        d=google.com; s=arc-20260327;
        b=PafLw6PfjnvYD+MRmxgZpi71seQwbuy0QXBrM+g+W0sLQc/b8jjGQIVaWSfzramvQq
         GT1tVmGdUXTpeVJz2qljq1k1Fn88WJ1ALD2zRL2r2hC7VIORNeyojQxicXZaexjLD8Yy
         RFifGK/mPVg5gJNU84vjy/fAmLcDoU9ClWefWJ0cNOE2Kk9d4WN7vPZlBJFzwiQcDD50
         cGxg/ZFcVtrp9pKziCgACvd64HTxYtIC0ThU4HP2EzkBVv4/ZYCuLFkpAElv7D8AQ/ee
         WWls+NSUYagN4C81+lNZBWK4c3lNhKAHcL70xaxa30aqtxYOjdkel+zy+GQu2oLFjePb
         tdLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tpwg2VYWUV11d9na6aGEr4WCfSoveOTRZKFpwBK71as=;
        fh=JwI6ltbppv95JEZ3K9M7wOVGZqQtTc4x3/pk5KxZzqc=;
        b=KKQst5RFQEtvlzpX8CKxk7UPrk3ZyRPz2F1SHaSMPOGOxyAdIeWqYRn/IhrcfytF+H
         VnKPdqRQQFk5FG3u+rxruF2YWL6W78VavGAahivTEMJnDK08xiP+tXUf/W1rDgoFo5tv
         nByqlD74J1HNYflvH1vRrNpiu3S9wjvbMzVE3WrKPJxC9YC2Xi+1XD8daSse3nfN8NDB
         2wlqnj67QGO7mgw39H0G9Y5OnHWFKdMbBbDh4NOkQYCtRb5voLwvMAoQ0SvYlbVZ0cdf
         Jr1Mjf4XNMI1c6IHnLoSVyytDZ8AUF+mSF5oywzALN1n955rUPdhR9B/Fy8n4T1Watm1
         51nA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788931078; x=1789535878; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tpwg2VYWUV11d9na6aGEr4WCfSoveOTRZKFpwBK71as=;
        b=lO+67OJ3IGhqll8vXeLvTOahZth0zjaiU3enZNvJ6P4MLNb4rTgDLlPsgs/xCvIr9e
         Euq/kbR6klL9Anfms2ejYXqd7EmMdXSAtvvk1znTAEyMR5WP2tKzJ96dADwwORfIMRMb
         oSYSqGMDQQaq5OOW96FoHXvXi3TXdvq39aaoNry/CdJsmeLHea0QlgymNH5CpQSIuj3P
         gaDl2lwRupsJ1L4/JcRAr4CDlEWtDWYaia+8LZw6sgl/rdnDoeGNLnbget4FP6tJP+J+
         7nmEqOEvXKtW6isp8j7nF1zcYlEqxIP2iHMXRPasjsX3odleCS6BKTOKkh9NGdmpcnBw
         z6NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788931078; x=1789535878;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tpwg2VYWUV11d9na6aGEr4WCfSoveOTRZKFpwBK71as=;
        b=deYh97H5hHY3o+hRHU+R6wkJHqWw9O1XGnrQSY4ndsNcYSdMm82yTRxzeQFXajDEg8
         mzHwXCzfFns5ylIAy5vA/GdnccUun4PvKL/JNSdhJRu6QmX8uDMSRm9H04oAfbRdJMcY
         l3PvfEFGqkDIwlEq39MJnKg4MqMwafKF3ItzlQhDPuTvX3n04VaSckLx3K7vBNFt/UM5
         BJbN1+Pf2z3EeK8ld8BsEGJ3nFTHhYzkXLRoNFDjiN7zoJg7NbJok+A+7eyW2Om1XS1c
         wt4pHXGAPekGTw1mHBjeZTfaEo02wqkPiFV31MYDsg/a712fs1N59cMsnfT/8p5GMatu
         wpTg==
X-Forwarded-Encrypted: i=1; AKwUvBy05xJPycX/64z/gAOgYtuEDhH/KSadBGV5Ayz4lHswDmJnDqukHBzLU4b1aQhDNqfBc+N5tQpu@vger.kernel.org
X-Gm-Message-State: AFuF++ltwxoUkXIyD2IRGtgDImzLG2vMRSNDvYWm9soGFM6yIALGKwHS
	5grTFiEor+mXu/2TTuBigo5YUK19qcQ7IJfwxSFANxdl1HSp4Nu55JQXxVu9ttvRo/ZUfFpIek8
	W6yMSwlFsFYyrMIbmpSl2dCByRLwUflm0exfAyVY=
X-Gm-Gg: AYBFou1Qr56MyxuS2++L8JisFM+TwyTjbzFObCO4Rm9/6fZ2LhY9PXl0SbGRJDwrhhq
	oupWSTqtVBOWHCQQ+eUh50mbtwq3wmTfXA+NvnyddQlt8aiWaidTUdMeAwc3Cx1XMRNtQHmB7eo
	5fifo4ny4CB4J9/aptlh98NFHhnlZWHkhmkmBXbIm6GymQZ1dC8IzhwXJ+wSdSoLjLe9/vFckiW
	7HQJoHLbHZlDLvuBtHZDpyz4Wyptau5yVbPK/9ee26qrAvtzWP+7j/WMmd2AR6PjEg/Mm1Snmw0
	EzHfrQe5Zra+q8NAgAsHJOYegZ6VWpu39hAVmAKbSBejzkIjPqtXyFcPRNKZmJivoHpsDvMeJA8
	Xj25cypAT91sZjKSTBXXl0FsEnnJyR0PMIEiretNDDKY3Ow09g3O0EE+LnuJCF0eBVW4YRbL+EX
	KiduQ/DOk=
X-Received: by 2002:a05:600c:3f19:b0:49c:fc6c:be13 with SMTP id
 5b1f17b1804b1-49cfc6cc0f4mr295286715e9.25.1788931077754; Tue, 08 Sep 2026
 22:17:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260904034707.268416-1-sh_def@163.com> <appnKwylGK3QUIJ3@slm.duckdns.org>
In-Reply-To: <appnKwylGK3QUIJ3@slm.duckdns.org>
From: John Stultz <jstultz@google.com>
Date: Tue, 8 Sep 2026 22:17:45 -0700
X-Gm-Features: AcwNN1XZTxQTZZ7aSCZe1KjWtvEMHTatn6Zj5p6jHaQ6JF4P0FCajzYWel3JKFI
Message-ID: <CANDhNCq5iPq87=iKSJv-XzYzTYJ8Hp+bPJ6SoVfWB3pRa=HypQ@mail.gmail.com>
Subject: Re: [PATCH v2] sched: Account cgroup CPU time to the execution context
To: Tejun Heo <tj@kernel.org>
Cc: Hui Su <sh_def@163.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Koutny <mkoutny@suse.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 3, 2026 at 11:37=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
>
> On Fri, Sep 04, 2026 at 11:47:07AM +0800, Hui Su wrote:
> > Proxy execution separates the scheduling context from the execution
> > context. Commit aa4f74dfd42b ("sched: Fix runtime accounting w/ split
> > exec & sched contexts") made per-task and thread-group runtime
> > accounting follow the task that actually executes, while cgroup CPU
> > usage is charged to the donor.
> >
> > When the donor and execution task belong to different cgroups, this
> > makes a task's execution time count against a different cgroup from the
> > one the task belongs to.
> >
> > Cgroup CPU usage should follow the execution context, matching the
> > per-task, thread-group, and cgroup user/system accounting. Keep
> > scheduling state associated with the donor, but charge cgroup CPU
> > usage to rq->curr.
> >
> > A reproducer with the donor and execution task in separate cgroups
> > showed the execution task accumulating runtime while cgroup CPU usage
> > was charged to the donor's cgroup. With this change, the execution
> > task's cgroup accumulates the CPU usage instead. The same behavior was
> > verified with an RT donor and with legacy cpuacct accounting.
> >
> > Fixes: aa4f74dfd42b ("sched: Fix runtime accounting w/ split exec & sch=
ed contexts")
> > Suggested-by: Tejun Heo <tj@kernel.org>
> > Signed-off-by: Hui Su <sh_def@163.com>
>
> Provided John is okay with going this way:
>
> Acked-by: Tejun Heo <tj@kernel.org>

I believe I'm ok with this if you are. Commit aa4f74dfd42b ("sched:
Fix runtime accounting w/ split exec & sched contexts") was trying to
allow the owner's cputime to make sense in top, but we still want the
donor to be "donating" their time, so I thought the compromise of
charging the donor's cgroup would make more sense.   I'm imagining
something like the cpu bandwidth controllers, where it seemed like the
donor's cgroup is who we'd want to charge, and eventually throttle,
even though it is donating time to the lock owner to run (since even
if the lock owner's cgroup was throttled, proxying will let the donor
"bust" through the limit and run the lock owner using the donor's
bandwidth - up until the donor's bandwidth was exceeded).

But if it is causing trouble for the accounting, and you think it
makes more sense the other way, I'll trust your judgement.
Tentatively:
   Acked-by: John Stultz <jstultz@google.com>

Eventually I think we'll want to track per-task "donated" and "gifted"
time so folks can more finely distinguish the accounting.

thanks
-john
