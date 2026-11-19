Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795098969;
	b=E10y2Xp4P0N73PsOP1Bm0G73gW8uNoZ/ExLDVqqX8XTYbXFNijnAEvRZmwZk+VO8nSNt
	 g5NU0ZA/2GCaAOiyOsMOETfF6D1IjZYWPAV28f8et83UFm8ae1W3IQRi3BgLTUvoYHGMW
	 GPg8lNmNbTc7nyWNofPXoXHY9fKtm/7yXNYynFp7ha8Ee57/AchcjUZmHZfl2elsxmGDW
	 VRA43ExpaGAjASKecf/SFv+GmXD9t1YKNtN4XrOnACt9cxyrxdirYvnDY2yWLmhPRmi7h
	 E/ds8TTr+dBexemPNgfv5mSfW6ybpoOYigG/O+Rrm7h/497TfDGKh8sbmBV5c3oH/3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795098969;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=jq7QluxFWPHAuK60qLtOSJq6FvP6A976D+oHoxb50WU=;
	b=Jh1SJzy8OPnuShj7TgvBc+BsK+1P1VABkm5BH1770mYAFpZDao6o42qmw7Bx7IA12Wgf
	 yqcL2T3weEbK6tcZRvdkLpH8kXmpLgNPx3a4p8H1Vf2K5IMQEWuaL8PqjK8UKPZ2lJE+9
	 W0o3pc/QziXEMlS1grd0HrfzuIl3bSV0MlB5va1sCIokeZQI5XJP6UE+tgFGPFWv3Cu5M
	 5xqGq4i5i3WqfLwBRJNMmpx/zPuL0jUlu1ccwb5yEPxbuVwJTcHnOZPXAPFKAbsxUDspb
	 SQZ9ZPILSPnFzPkS57RRhuY1EciB2C78ZO9MisMDQnqjP0gXWxS/fsbszBrbTmmyS/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="dPiO6Bw/";
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=FiSXS6yC;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C328C606A320
	for <cgroups@vger.kernel.org>; Thu, 19 Nov 2026 14:36:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C328C606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dPiO6Bw/;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=FiSXS6yC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795098967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jq7QluxFWPHAuK60qLtOSJq6FvP6A976D+oHoxb50WU=;
	b=dPiO6Bw/gFXqG1AdJZ+P4oUboAz8qzDhWcfsBQ9m1B+pbrRjonZnlZGK2MebSnqc6zsp4B
	qSyMDpVGUnYPdD4SI3rr3M/i47q80Tf7eylAEb1ZZdwQvaaP7ffVnDdsIbo7w+O4FRSH2j
	DRku2vnzkKnhpPl7mQF5Q8DOhMU1S5s=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-42-7rI4UGF5PdqB7U-t23SZKg-1; Thu, 19 Nov 2026 14:36:06 +0000
X-MC-Unique: 7rI4UGF5PdqB7U-t23SZKg-1
X-Mimecast-MFC-AGG-ID: 7rI4UGF5PdqB7U-t23SZKg_1795098964
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-48df02b91f9so646796f8f.1
        for <cgroups@vger.kernel.org>; Thu, 19 Nov 2026 06:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795098964; x=1795703764; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jq7QluxFWPHAuK60qLtOSJq6FvP6A976D+oHoxb50WU=;
        b=FiSXS6yCOufYiTlGUvdZm74i00rEKHl5MKL78teZJdohSVEay22CNDKlce/cR70GHc
         QA31hrGFSayAUsCKbDCPeXOom52Iq3LeoJE7FuKnYcwwLhksgap6zoD0WdgpQlRSA97b
         rbmzHUEEoGn6J+PiPvXSaCX2JtkY7mb8oBGTkGtFyh2eWoIleVn/Uf7aPBfJWIe6EYet
         tT3fKCz0o6YQX87iNeuR/HnNSbLbIZ0YgTcIPjrG16KJfcQuhw9Y4zUE4mr0w0lMp9dC
         kqK1OU8/jCN0PQxEZAeSYqWUkBFBTBTVs0Ikh3YAHXDKf8hchB0edan9JXGLuYMPEX1z
         X07w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795098964; x=1795703764;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jq7QluxFWPHAuK60qLtOSJq6FvP6A976D+oHoxb50WU=;
        b=qThJR2jDjST8fvlI+uWSFDaBbpmTzMIARw4sH45wxzgouA2iWge87wrpg/c95V5TqK
         GByg8OWq5vDyjaPF4Btnd8QfBalCQDCt72ghNRvRacUItDTh0sLeFqLPML9JEAnQmLlE
         Xf7WwvoHtFOpfyqOL9QWwFf2sDXClM35h/enqYShGgZyBPQmRurcHCAYqFgxHwBvbFsc
         dnQNX/sOn5cFrmvbRolnJW8K1cB+GxN2dzEZAKk05S7hdgEG578Mq5STb3skqwgdLs5C
         4k4kiL0QghLXcqOe+9/RBhAgnhVpc3PmB67ynK0EochvD6VcETv5SaQeVxGztBB568SM
         glgg==
X-Forwarded-Encrypted: i=1; AL+hErFfwSX8JFY6apwK19Hcbbu5IzdTtwrTu2GWHUvePsPSd+J4qFV5zdexjByW8S9016lOWvYqrU5Q@vger.kernel.org
X-Gm-Message-State: APuU4Z+P9SQrErGxQ5hWDXYqAGQ5vxVmXHPUGs8DKn+v8MJ1HG+1C1OH
	bQiY/A8opaQg4DcbvBw7SyrhkXYV9GMAX7ylgIYOoUmp54N5npybX60DRy+Pw0yDCxEVmo8yr+0
	kZXcaT74L9oUqX2YfK8q2Zlaa1sYPb2oLPgkK9/WAs/3IfCVWJL7sxBbvLm0=
X-Gm-Gg: AYBFou1xNxUyNkaZzYrrTCGNi3MVR9HRazwWYnSle5/Oj3UKT6xOijUPv2C2G6Q9NhK
	ifdK7H7bDeYllgWZHnvd0RsQ1SRxfps94POUL/xPVY57Z54mNGsshWkffITrrOPfc+8qugchmN1
	g9RCVIZ1rjZovl6sikjF4A/0U6AZbNieszB9Vd6zVQeLZUFcm9rs9UB2r0PNgrNAfzOsGCg6qUV
	I2QFJxHSlnDfiwNjXe05qI+fkp0gP5NCf5UoDsbH0LZuvailfTuN/h0TSNPJE7OSE9/VOzcBpov
	vDw20QBypJToSkHiPcj4CK0Wa6WdbVV7+y6lQGzVx7PWV7LJie0hFPP0+MzZJU7CGfpWxmJp1Pd
	bg/Iom5kx58aV792EpFRHsduJM74enoGwPK7IbYb5QGPDkOyj3x4FH0YXrWPHu+zLcjIKkVPYnE
	SSec8=
X-Received: by 2002:a05:600c:4e86:b0:4a2:526b:d40f with SMTP id 5b1f17b1804b1-4bb8609ad6dmr30007555e9.0.1795098964155;
        Thu, 19 Nov 2026 06:36:04 -0800 (PST)
X-Received: by 2002:a05:600c:4e86:b0:4a2:526b:d40f with SMTP id 5b1f17b1804b1-4bb8609ad6dmr30007085e9.0.1795098963704;
        Thu, 19 Nov 2026 06:36:03 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884b8429sm1879735e9.14.2026.11.19.06.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 06:36:03 -0800 (PST)
Date: Thu, 19 Nov 2026 15:36:01 +0100
From: Juri Lelli <juri.lelli@redhat.com>
To: luca abeni <luca.abeni@santannapisa.it>
Cc: Tejun Heo <tj@kernel.org>, Yuri Andriaccio <yurand2000@gmail.com>,
	bsegall@google.com, cgroups@vger.kernel.org,
	dietmar.eggemann@arm.com, hannes@cmpxchg.org,
	kprateek.nayak@amd.com, linux-kernel@vger.kernel.org,
	mgorman@suse.de, mingo@redhat.com, mkoutny@suse.com,
	peterz@infradead.org, rostedt@goodmis.org,
	vincent.guittot@linaro.org, vschneid@redhat.com,
	yuri.andriaccio@santannapisa.it
Subject: Re: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
Message-ID: <av8JUXtjhd3PoWL7@jlelli-thinkpadt14gen4.remote.csb>
References: <20261109163616.195264-1-yurand2000@gmail.com>
 <212c244d534ee1fdb0538a980789e16c@kernel.org>
 <20261111175657.250354-1-yurand2000@gmail.com>
 <58cb2cbaf82c0f671213eaca46465cd5@kernel.org>
 <av7cRIyAMoiIR5k-@jlelli-thinkpadt14gen4.remote.csb>
 <20261119152744.3a2f7aed@linux.fritz.box>
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
In-Reply-To: <20261119152744.3a2f7aed@linux.fritz.box>

On 19/11/26 15:27, luca abeni wrote:
> Hi Juri,
> 
> On Thu, 19 Nov 2026 12:23:48 +0100
> Juri Lelli <juri.lelli@redhat.com> wrote:
> [...]
> > > On Wed, Nov 11, 2026 at 06:56:57PM +0100, Yuri Andriaccio wrote:  
> > > > - `cpu.rt.max` only accepts per-CPU settings, so the global
> > > > "default" is removed. Removing all overrides means the cgroup is
> > > > a "max" cgroup, while just a single override means that the
> > > > cgroup has its own budget.
> > > >   + This new interface disallows zero-runtime overrides, as a
> > > > zero override is equal to an empty override when there is at
> > > > least one non-zero override. As an example: [<CPU0 10ms 100ms>,
> > > > <CPU1 0ms 100ms>] is equal to just having [<CPU0 10ms 100ms>].
> > > > This seems a bit odd, how to make this better?  
> > > 
> > > It's odd because a missing entry means "max" when there are no
> > > entries and zero when there are some. Can a missing entry always
> > > mean "max", per CPU? On a CPU that a cgroup has no entry for, its
> > > tasks would be served by the nearest ancestor which has one. Zero
> > > then becomes a regular value which is shown on read, and the two
> > > configs in your example are different. The former can't run RT
> > > tasks on CPU1. The latter runs them on the ancestor's budget there.
> > > 
> > > This means that a cgroup can have its own budget on some CPUs and be
> > > "max" on the others. That is a fundamental part of the interface,
> > > so I think it's best to get it right from the get-go rather than
> > > starting with a restriction.
> > >   
> > 
> > Agree on making zero a regular value and on a missing entry always
> > meaning "max".
> 
> I think "0" as a regular value is agreed upon by everyone :)
> But I would avoid "missing entries meaning max"... See my previous
> email.
> Basically, I think a cgroup should either inherit from the parent for
> every core, or define a deadline entity (even one with 0 runtime) on
> every core. Mixing the two is, in my opinion, problematic (for example,
> it would change the serving reservation when a task migrates from one
> core to another)).
> I hope this "all-or-nothing" approach is acceptable...
> 
> 
> [...]
> > Making a missing entry mean zero at the top would bring back the
> > ambiguity you pointed out, so what about keeping your semantics and
> > adding a validity rule instead:
> > 
> >   A cgroup can be served by the root either on all of its CPUs or on
> >   none of them.
> 
> As mentioned above, I would be even more drastic:
>    A cgroup can be served by an ancestor either on all of its CPUs or on
>    none of them.
> 
> What do you think? Can this approach be acceptable?

Yes, works for me. The example I gave is just the extreme case of the
problem you describe (the "other reservation" being no reservation at
all), and your argument covers the nested case I still allowed.

Tejun, I think this still addresses the original concern: zero is a
regular value with a single meaning ("no RT on this CPU"), and no
entry only exists for a cgroup that is "max" as a whole. It's not a
restriction to relax later, though: a task changing reservation on
migration is what we want to rule out.

> > In practice, a cgroup whose parent is entirely root served (e.g. a
> > top level group) has entries for all possible CPUs or for none. A
> > write that would leave some CPUs served by a server (or zero) and
> > others by the root fails with -EINVAL, like the existing admission
> > checks. Further down, a missing entry is fine and means the parent's
> > context on that CPU, which is always a real server or an explicit
> > zero.
> > 
> > With that, per CPU:
> > 
> >   - no entry: served by the parent's context on that CPU
> >   - runtime=0: no RT on that CPU, shown on read
> >   - runtime=N period=P: own server on that CPU
> 
> If what I wrote above is OK, I would just avoid the "no entry" case,
> and I would define the interface so that missing entries are not
> possible (for example, see my previous email: we first set a (runtime,
> period) for all core, then we can override some of them... But not with
> "max").

OK.

> > > The root has no ancestor to fall back to, so a missing entry can't
> > > mean anything there. It has to always carry an entry for every
> > > possible CPU, which defaults to zero, and reject "max":
> > > 
> > >   0-127 runtime=0 period=1000000  
> > 
> > Also, related to the above: on the root these numbers mean something
> > else (how much DL bandwidth cgroups may reserve, not a server for the
> > root's tasks), and showing them in the same file and format is part of
> > what makes the example misleading. Would you be OK with dropping
> > cpu.rt.max on the root and exposing the parameters through a
> > separately named root-only file (or the existing sysctls)? That way,
> > having no entry all the way up consistently means unmanaged FIFO/RR,
> > and nothing on the root looks like a budget those tasks share.
> 
> Regardless of the filenames we decide, the defaults for these settings
> indicate the fraction of CPU time that can be consumed by all real-time
> tasks that are not in the root cgroup, right?

Not quite, I think? They cap the bandwidth that can be reserved for
cgroup servers, so they only cover RT tasks that are served by one.
RT tasks in a non-root "max" cgroup (with no configured ancestor) are
not in the root cgroup, but run in the root runqueue and aren't limited
by those values at all (sched_rt_can_attach() lets them in
unconditionally). Which is the kind of confusion I'd like the root
interface to avoid.

Thanks,
Juri

