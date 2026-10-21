Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792595942;
	b=wRfGbia2/4cIrw5/GsxxjbWpAW/Hn34Hxi2dn1seXmKTA6ANJ+H2gauZH21+RVw/yQ9o
	 gsogBCd0IzBWbCnUXks8SXTxfzjyhijA4FL+lPTXDuyGRtjxvFgHH3eHEvABDS3XYWieI
	 VbRd0gnBWCYD8c1mwI3WreegNF/lN38DtDGWERqb+DfU1VbOxjUS9MmLNrTiVQW66ZglC
	 8Ds2KrBjWuEU4Icj7rdxSG6KQzrFFnKLKgU6yNNS6FUi3yGKlekUVKsBkLrBL9jtKiSXo
	 AsOygUTPD9SwUO82QFdyGRzMjKrwPKH9eCkI3+R1BZyMY2NjY0rJid0/ujlEkoTe9tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792595942;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=yp/iAPb62e75wupRmvyv0YjK3+amzNSWley0MVfbsjg=;
	b=VVr5D2A07oYRKy2yDWXk/6703/GBH4I3L9EhSN2rOW5y4KqcfFUpIqMwLSeLveWgQj8P
	 lN0JJLcuYnapMQ3v3MUSPh0j/BfOBSD8uIojHifxmhNkfdiL/SHF0sjFji750qDDF907c
	 bgyZBT0mKzFfJrzBYQL8w757GNC3GPZBjnabHLMlQgn3qfpUrXRFsQhRSNUw4srX+gk9c
	 Pg+THa4tsEfGGew77CA+ti4p9e8ir3j4kvur4Hjm34F5AgmsNpAvI4e2kG0u3bHAl8yWV
	 KfOi3ecPChXlsIfaMxYizh/bhAhJ43UOQrl0ku/elqaZqHRrMlFaUZ0+0JVnFIgkgzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=I5bAgT6I;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023BE606A31A
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 15:19:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 023BE606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=I5bAgT6I
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48b00aa033bso165749f8f.0
        for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 08:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792595940; x=1793200740; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yp/iAPb62e75wupRmvyv0YjK3+amzNSWley0MVfbsjg=;
        b=I5bAgT6I4ZHP/ULymcKjMOYkzka1gk0I2XhpIlEiYckvPuo4gw2OwfcZvoHmZHKOYi
         FvAreJ+mRh98hq2y1R/m7ovnyindM34dGXfUnGQOHHKA1wSpVpZykGIqC/3gkR+5mwph
         Sm/lUpHGWlNOSGPxUYkULcWs/7It+XeYu8Ku1iqo4TviNm1hoY546q9o+wRmmXxBr13U
         39iMYwFv2JaZ/dQbWem7q93JZcUIjlyLDejjkDlOnuuvOKQDhvNgsVm7mtEJwsenLcRC
         zU1QkZuksuB0U+gwizwE7ARc7w7ZD3mNzbIcejqe9s0wUHeq9exow09pErOrjiPbUtca
         iJpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792595940; x=1793200740;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yp/iAPb62e75wupRmvyv0YjK3+amzNSWley0MVfbsjg=;
        b=UROe8F3eXAh/HM/JHanaTomRgsJ2V5KDB9ejclwOgB/K5BPo5cCnuLioyEHafavVOh
         auzLraw0C6aMjYXxe7bV6oduUEPNX1kV1D7HtdEOYE7u/o14NTGTY06Qa/XlBBujjyxQ
         JC1MxAicBOaAodtI6aXe7OyMw2LSPo4Lb+zoQl8KsV3ZydfGKC0x22E/vjmt+F7qMk3Q
         L/37jXWX3Pukzq0yQHIhn1NtWWNesdGpFCQJhkwhLcm6+kr5N7/O0rc41Ec/McaD+Lk9
         MmKGrG8z0JQlJUXmDTTGxLFvtbjiSDoLyhBl6Pd06ICwrubtCy3ZT6oTbIo+DPk9+4/F
         voKQ==
X-Forwarded-Encrypted: i=1; AKwUvBwCuiC18u20tKzCbfnZxYo2X/u4aCED+HQBhjznPqMADd9Ki9EMEZNomZew8wTNUbHSiErsCM/J@vger.kernel.org
X-Gm-Message-State: AFq9FYLhzTX+EDAg5k3VmoBydqj/nUS1fQBvLqs9zx52Si7BGLIgGjPT
	VnA8xItFyrXZr7EI/aGGJTLCki7CX7J0Zj0Tw7EOJvh/OwZbsf6JmMNx
X-Gm-Gg: AYBFou12NIGuSmpwSNG89zGFo8Ku5K/xmnot9h+zEOeuRDy9dqVBDhkfumap4bQrt6a
	JdcR8oI/b3uhxPgl1JzkRRpYUo4GTnwD2TmRTzrj0PxkEoRAcEmkRt5i709ZSI0o24qhOzKu7N8
	1/oxsO7Q3PzFouGob7OPWpc2ARDZ7sHDaeEWcbX+LZThj8sBnkybVOlL6eDmiGm9HFGa6NtRtPk
	WNwrxm1cg9STMp1e2ZacMAK49Lwh515QHA+HXHUg+HHoDn0ypik1J1D3tf1D/g0dUCygz4SmUxG
	Q2ptTqfbU9hRdchInxj/pMDFVBw0MTEsLw8taNKKosMTSl7S9z5la1S1SPyFBTPYr1NcwST/BO9
	MqwD/8ShYuk+Qe2kxV5BzBAUEc0oR1tVDAOkyaV7jYDpshsYsWEjf5L7he5oRVAqsu3hDm2aDk/
	CGzMZdkfg9JgwyOVN09WDPhQIP0K12RUcWa3DDT69QiSQrUsHM80N1iTG7bB9DE75BIdAiXJISy
	2NUlwzQke7b7g70wMtJeBz6VANvwtAqNvqf0wQZnZRtPUraj5/usM+YpEdkQjDQORzKfSU4u9JD
	LXK1SD6zzAlZGzxn7v7x/m2LMf6axA==
X-Received: by 2002:adf:e198:0:b0:48e:28f2:64ea with SMTP id ffacd0b85a97d-48e28f26602mr3979833f8f.4.1792595939291;
        Wed, 21 Oct 2026 08:18:59 -0700 (PDT)
Received: from scheduler.schedules ([85.100.66.184])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e258213cesm6051960f8f.11.2026.10.21.08.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 08:18:58 -0700 (PDT)
Date: Wed, 21 Oct 2026 18:18:55 +0300
From: Kayra Cizmeci <kayracizmeci@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>, mingo@redhat.com, 
	juri.lelli@redhat.com, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, 
	linux-kernel@vger.kernel.org, jakub@okonski.org, longman@redhat.com, tj@kernel.org, 
	hannes@cmpxchg.org, mkoutny@suse.com, cgroups@vger.kernel.org, jstultz@google.com, 
	qyousef@layalina.io, joshdon@google.com
Subject: Re: [PATCH v2] sched/eevdf: Fix sched idle task group preemption
Message-ID: <atjTelN1fMPlUgZ6@scheduler.schedules>
References: <20261019182622.1584454-1-vincent.guittot@linaro.org>
 <20261021131313.GM2823843@noisy.programming.kicks-ass.net>
 <CAKfTPtDOZ0=nrQe1-WSTamgU0qqdJVvD3KZPtnsqwwnE53BSKA@mail.gmail.com>
 <ati_o5c-SoiOp529@scheduler.schedules>
 <20261021145042.GQ2823843@noisy.programming.kicks-ass.net>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261021145042.GQ2823843@noisy.programming.kicks-ass.net>

On Wed, Oct 21, 2026 at 04:50:42PM +0200, Peter Zijlstra wrote:
> On Wed, Oct 21, 2026 at 04:41:52PM +0300, Kayra Cizmeci wrote:
> > On Wed, Oct 21, 2026 at 03:32:59PM +0200, Vincent Guittot wrote:
> > > On Wed, 21 Oct 2026 at 15:13, Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > > > What is the actual semantics of cpu.idle nonsense? Why do we care about
> > > > this common ancestor?
> > > 
> > > AFAICT, cpu.idle applied to one level and against entities at the same level
> > >
> > 
> > Yeah. Like on here:
> > 
> >     ROOT
> >      /\
> >     /  \
> >    /    \
> >   GA*   GB
> >    |    /\
> >    V   /  \
> >   TA  GC*  GD
> >       |    |
> >       V    V
> >       TB   TC
> 
> (marked GA and GC with * to denote their 'idleness')
> 
> > If GA is idle and GB is not, while GC is idle and were looking to TA and
> > TB we gotta choose TB. But if we just look to GC and GA we would choose
> > neither. .idle just applies to one level as Vincent says.
> 
> Yeah, that's what we used to do, but the more I think about this, the
> less sense it makes! 
> 
> Josh added this (added to Cc now), but we have a number of Google folks
> on Cc already. It would be good to hear how this is actually used.

Yeah.

> 
> 
> So in your example TA and TB are both inside an idle group, and
> therefore one can argue their behaviour should be like !idle. But their
> common ancestor is root, and so the fact that they're contained in idle
> groups gets lost (which seems crazeh).
> 

Actually in that case TB wins over TA, since GA is idle while GB is
not. GC being idle only makes TB lose against TC.

Right now being idle only changes a groups status to its siblings.
Like right now GD being not idle is only a advantage for TC when
its TB vs TC.

> But worse I think is T{AB} vs TC. In that case none of the common
> ancestors (root,GB) resp. is idle. But T{AB} being inside idle should,
> IMO. definitely matter vs TC, which has no idle anywhere.

It does. In the case of TA vs TC, we look to GA and GB, and
TC wins. In TB vs TC we look to GC and GD and again TC wins.


> 
> So I think I would very much like to change the semantics here. The
> current stuff makes no sense.
> 
> Anybody, please chime in with how this idle crap is used and expected to
> work.
