Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795087435;
	b=d8XOIgcHQZFPlVWo8baLbGZ292snPWH/2wJTWe0miAV18bfiasSDU0JSSp1JlQzziZTP
	 Z8mG/MvaG3U2PIQeH805QFlSTe2FDjTj1rS9tJ0flcO4hZJx+yqvkYPKNB6W6jbFKJ5fV
	 RZnnK9JUjlq3gvddqj2/9FaNTNE+A62uGZ7gyrd9ioPQjCPTK6mFLv1x9NByrEQxJmN9l
	 5o6g5p2zbNsGgz2tu2oDOJlA2b2uDcVA9vdmaO7fg5ikN5hVWP9Up8HlSIDMgfDNH12pi
	 uZoafmddoJomEKG7n+HHXQsaeM/D1eB34bRMVBO+ysuLHXmPpHnR5bR60Uc6wnUi+6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795087435;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=YVbpX2nx6ti/uUMeAlvhSd3o7fztClL1udOGBcOp1ew=;
	b=Kahfmgg1f9zccFhbjX3i6wjzSQP+a+d0fQgU3loqIVlQl18rHYeKdGBVlVXLZChW+zIM
	 xbMgit8bda7gouB/vwzdWUbt6EbrekeEId7d9vkP76aEkNGQ1/j8GAi2frg1FqMtyAxO0
	 +RpUCOsrLhNoTAWI4oCynnLyZooGAI5BOsoR6CmnUolkyqI8D0sGRvaoS4pgBlGABRVAa
	 DC+ZQmtC9HX0TKI45jbwIRgvEuP4U3ZgTgkYcvWG7H6dX7v9nU1c9hd4XURwWZviTnClD
	 +bOW5QE0WUIv1QCYCJu7EKVIeKxwL+Rmi+s/oAblhZKvyRKlIg8DhT9430BT7Qg+6SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=RmVPcQcB;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=DyV3HjXG;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A62606A325
	for <cgroups@vger.kernel.org>; Thu, 19 Nov 2026 11:23:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27A62606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=RmVPcQcB;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=DyV3HjXG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795087434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YVbpX2nx6ti/uUMeAlvhSd3o7fztClL1udOGBcOp1ew=;
	b=RmVPcQcB3dN7t/JdFICLX9M3TU5vdZk0L3zH/4iwta1j+eBNPt/C/yK2V6nLJrDUo6BKhl
	kN/+IL/c15NqIQRIENsVp3xUe5mvagN7rEM6yeAZ8tSw2B6+gwV8nnP0xvyl5k1yZrwKkp
	QMwSL2S0yQkC9nc1H/easadPXjO8Aqk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-300-vAm-KarEO5KMDBcRZQNm8Q-1; Thu, 19 Nov 2026 06:23:52 -0500
X-MC-Unique: vAm-KarEO5KMDBcRZQNm8Q-1
X-Mimecast-MFC-AGG-ID: vAm-KarEO5KMDBcRZQNm8Q_1795087431
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-49337a224a8so1432067f8f.3
        for <cgroups@vger.kernel.org>; Thu, 19 Nov 2026 03:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795087431; x=1795692231; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YVbpX2nx6ti/uUMeAlvhSd3o7fztClL1udOGBcOp1ew=;
        b=DyV3HjXG6hee94VpCu1VeW0GhRqirFRkFa1dHxd8r6gLNy6oz75bflSKoxX+6TsDMF
         nGEni52PmQhY5xCI5Y1hSucr2npu1g4fNpFglEk8EAEVImlTRGSbgql4qgdmU8fez5Dg
         L4+4a+lS5aJFH0WcOcF99L+lZU5YZiHkwboy4HsUagQIUJZY/q7IgmX0rpveUBksbe/K
         rFMJgd83F71MQdUO3AQ0lu8agGlJOXV1O1uHe+Cph5Cl6eiZeiJAhmFBgpoZUOY6POjW
         T14YES+QaNDuqbeGWnXQbqhizr1uHUCuvZMTEV4Kc/zvtlqhSgqpo0Ff+VVsdQsqHTip
         xtlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795087431; x=1795692231;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YVbpX2nx6ti/uUMeAlvhSd3o7fztClL1udOGBcOp1ew=;
        b=AB4UaG4JgbRycghVcfy+o51pyUwZdL7kq9G3rUdAUaf90zgyHUXZytJb/WMyY3KdCp
         MRSngO7YiHK83+6y1YNAQ1Xge1dawdvQABVGfTdWDQTY2CkX0o7aAsdDMovnq7oQaosR
         bRJG3wjURysuFwr2yVbtYH0d+Nt9gzbSAVeWfBmlo5OyNRfpExow4mQn2kLuGAvQzX/B
         n4tDlkWM1mUCE791GGrrLIf1y0x+Vp71P5ldQHzsYkS++8GDjqQbsepp1yXzj13bmkcX
         eMILzvTo/z6jYZOmdffxhChVdAkcKsiPP0mJ0JcIP0JNMaLMVbGFxDrq9YRF4ISZvULl
         mnNg==
X-Forwarded-Encrypted: i=1; AL+hErG38E3vOIImICH9Xaj6T9+SD+4QcIpRD6Oqte1ZKL622z4HMU+q2ZUSD5UHBZctHHDAgu7Vqnjx@vger.kernel.org
X-Gm-Message-State: APuU4Z+H39VIfRw7y8obrncaSw+dacyatsubcnk9Efc0F7AqiWP3zvqf
	2Sj5I2MQmVfd2W1i++NOduXMH7PaMkEi049zkmFV3Th6OdaQtzXlGBFHLgktVFLc4zmawEeVYQq
	tn+R8/Jr09ugxFgGamPhJdjTljSGi9JNFyY38RNjADWlUk2U1kcwqg0AmP4E=
X-Gm-Gg: AZFdTZdrzio+58jAGiLyWyUfmIY1SN1OfSn+vZ36Ekecl/bhwlVlRcVVUoouHFTsslS
	yJddUbAp/nfc/AhUPbokpSTPYQ0yi0JHI2OS3MwRwRpndxqwkrowlSRULt9U6Om+eCH0oT3xpc2
	VVpJuy99xdSkHrsiPV8hG5uKKdm6lXYfg5HQs1RCMjsZ0DDHGlYFnCccVbl6rXmNwEyB+QXak4W
	uXXCorrOK/fj4ux1aAqanA7+cVLAMnqGOobQvG9dqDcUPUAxH5aEWRDGLubf4lv+zsHsfbYb93b
	zcDQgcFZlLOLO6Za1QQpc7zv47uSBNlU67Vo6h8ZuHDWzpqpGUDmlUPCKqLtGh0/fdPWD2Ggpml
	722luSJqQeTStqKyPjMwsDGGFw4O0cAlWFa1dJPmDb3Jpb10jUKK9SUi1flFwN8NV+ozHZ/z108
	qQcoo=
X-Received: by 2002:a05:6000:4b1e:b0:498:7be6:8d69 with SMTP id ffacd0b85a97d-4a6346da850mr11645909f8f.6.1795087431415;
        Thu, 19 Nov 2026 03:23:51 -0800 (PST)
X-Received: by 2002:a05:6000:4b1e:b0:498:7be6:8d69 with SMTP id ffacd0b85a97d-4a6346da850mr11645865f8f.6.1795087430982;
        Thu, 19 Nov 2026 03:23:50 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a655db6d45sm9793923f8f.33.2026.11.19.03.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 03:23:50 -0800 (PST)
Date: Thu, 19 Nov 2026 12:23:48 +0100
From: Juri Lelli <juri.lelli@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Yuri Andriaccio <yurand2000@gmail.com>, bsegall@google.com,
	cgroups@vger.kernel.org, dietmar.eggemann@arm.com,
	hannes@cmpxchg.org, kprateek.nayak@amd.com,
	linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it,
	mgorman@suse.de, mingo@redhat.com, mkoutny@suse.com,
	peterz@infradead.org, rostedt@goodmis.org,
	vincent.guittot@linaro.org, vschneid@redhat.com,
	yuri.andriaccio@santannapisa.it
Subject: Re: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
Message-ID: <av7cRIyAMoiIR5k-@jlelli-thinkpadt14gen4.remote.csb>
References: <20261109163616.195264-1-yurand2000@gmail.com>
 <212c244d534ee1fdb0538a980789e16c@kernel.org>
 <20261111175657.250354-1-yurand2000@gmail.com>
 <58cb2cbaf82c0f671213eaca46465cd5@kernel.org>
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
In-Reply-To: <58cb2cbaf82c0f671213eaca46465cd5@kernel.org>

Hello,

On 17/11/26 22:07, Tejun Heo wrote:
> Hello, Yuri.
> 
> The summary sounds fine for the most part. Some comments below.

Sorry to interject again, but I had a thought that I would like to
share. Also, the very similar names probably don't help keeping track of
who said what, but anyway. :P

> On Wed, Nov 11, 2026 at 06:56:57PM +0100, Yuri Andriaccio wrote:
> > - `cpu.rt.max` only accepts per-CPU settings, so the global "default" is
> >   removed. Removing all overrides means the cgroup is a "max" cgroup, while
> >   just a single override means that the cgroup has its own budget.
> >   + This new interface disallows zero-runtime overrides, as a zero override
> >     is equal to an empty override when there is at least one non-zero override.
> >     As an example: [<CPU0 10ms 100ms>, <CPU1 0ms 100ms>] is equal to just
> >     having [<CPU0 10ms 100ms>]. This seems a bit odd, how to make this better?
> 
> It's odd because a missing entry means "max" when there are no entries
> and zero when there are some. Can a missing entry always mean "max",
> per CPU? On a CPU that a cgroup has no entry for, its tasks would be
> served by the nearest ancestor which has one. Zero then becomes a
> regular value which is shown on read, and the two configs in your
> example are different. The former can't run RT tasks on CPU1. The
> latter runs them on the ancestor's budget there.
> 
> This means that a cgroup can have its own budget on some CPUs and be
> "max" on the others. That is a fundamental part of the interface, so I
> think it's best to get it right from the get-go rather than starting
> with a restriction.
> 

Agree on making zero a regular value and on a missing entry always
meaning "max". There is one case where "the ancestor's budget" doesn't
exist though, and that is when the walk ends at the root.

The root doesn't have a server. Its cpu.rt.max is the pool of
SCHED_DEADLINE bandwidth that child servers are carved from, and
FIFO/RR tasks served by the root just run in the root runqueue, outside
HCBS (as with !RT_GROUP_SCHED). So take a top level group with

  0 runtime=10000 period=100000

no entry for CPU1, and a few while(1) FIFO tasks allowed on CPUs 0-1.
On CPU0 they are throttled by the group's server. Once they get to
CPU1 (wakeup placement, push/pull, affinity changes) they run in the
root runqueue and nothing throttles them, only DL tasks and the
fair/ext servers. The group reads as 10% of CPU0, root reads as
runtime=100000 everywhere, and the admin reasonably thinks the group is
contained. It isn't.

Making a missing entry mean zero at the top would bring back the
ambiguity you pointed out, so what about keeping your semantics and
adding a validity rule instead:

  A cgroup can be served by the root either on all of its CPUs or on
  none of them.

In practice, a cgroup whose parent is entirely root served (e.g. a
top level group) has entries for all possible CPUs or for none. A
write that would leave some CPUs served by a server (or zero) and
others by the root fails with -EINVAL, like the existing admission
checks. Further down, a missing entry is fine and means the parent's
context on that CPU, which is always a real server or an explicit
zero.

With that, per CPU:

  - no entry: served by the parent's context on that CPU
  - runtime=0: no RT on that CPU, shown on read
  - runtime=N period=P: own server on that CPU

A missing entry never changes meaning; the rule only rejects the
configurations where it would escape HCBS. For the example above, the
group must say "1 runtime=0 ..." (no RT on CPU1) or give CPU1 a
budget. The same config under a parent with servers on CPUs 0-1 is
accepted, and CPU1 runs on the parent's server.

What do you think?

> The root has no ancestor to fall back to, so a missing entry can't mean
> anything there. It has to always carry an entry for every possible CPU,
> which defaults to zero, and reject "max":
> 
>   0-127 runtime=0 period=1000000

Also, related to the above: on the root these numbers mean something
else (how much DL bandwidth cgroups may reserve, not a server for the
root's tasks), and showing them in the same file and format is part of
what makes the example misleading. Would you be OK with dropping
cpu.rt.max on the root and exposing the parameters through a separately
named root-only file (or the existing sysctls)? That way, having no
entry all the way up consistently means unmanaged FIFO/RR, and nothing
on the root looks like a budget those tasks share.

Thanks!
Juri

