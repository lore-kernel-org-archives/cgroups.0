Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795680136;
	b=npcjy0z/BIwpkItw+usTYE/rfDzmvNvNN+EU8MH/0xGFrmbLcc8ipjV3kBQQDxZk+hnk
	 xeDSN1bjLNUExUug2RCYLBpISvxuWg2r8o+3jTV14OEbMGxXz/gfg6wakKPw5Wlw2d8tN
	 ZM0CcQdT0f+jeo1AaJJzHgIxi+g5qPjcvEdPwpHSRtH5BjGONPRVpTAzRYhVHhoFOUd3U
	 E4lmqxtNMHdTtAJTvCa8e0e860Ek7L001HyuCEC9Dx6MC2JnhA4jR0zZdt1god7XMyjlh
	 9KxptOZXGo5+4vfMZ3S0MQAPMQ4/NG6XuV5BYl4S0otX/fp5Yw2YVI71agZD4AvneLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795680136;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=N3RaXFDKfQNwD/7rbK7e/V5RDra9/0I7oTxMyTIYUUA=;
	b=NqJ2RYI2JdQMorwPYeGdq1fqtjEuRxETDdZp7smrfhdMZthP5kDb38aD5SvZmBchkUvB
	 7qiJOmy+u0s4ywdIZpjmhJLdstCcIs0e+BewNtAbAKw76hBIpnrEAxoYWGXAXOu8QUyYn
	 s0xT3o/cLVbpcJUaQkMjGjaFNsJCQ/zCnNRGEVU+lxPhHpojdBssOgS6xlg91QPBICT1k
	 PSrqV/C35hqlAbRB/0m+IVAO+6fGDnJ51I6LTkWgKRLo9J9gIgEJq512Cf0RP2Y094zn1
	 489fJPXy9WsCxGB0OscGnp4rcSSJ/xa//tJaMp/c7xwJakfj6VUcQzHNibFeZsfcVbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=SDNRdONn;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=ezBu5bGc;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522B7606A31E
	for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 08:02:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 522B7606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=SDNRdONn;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=ezBu5bGc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795680135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N3RaXFDKfQNwD/7rbK7e/V5RDra9/0I7oTxMyTIYUUA=;
	b=SDNRdONnXdTJoejxtDqNI/PqhVPgmmWOVFZJWHD3A+tfdxEMnUHHtG+glh91TmPvOe3HXa
	m+WRzs68EQdotvMAX818YHg/pmD9SgB85lXT4jJe2372qh+p+zl9oMQqJ5fRDosrF/uY54
	IiN9NZ/Fgid5AzgYwePGyjdw8tR37DA=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-436-2pt9iQElPAue3Phn1IkxAg-1; Thu, 26 Nov 2026 08:02:12 +0000
X-MC-Unique: 2pt9iQElPAue3Phn1IkxAg-1
X-Mimecast-MFC-AGG-ID: 2pt9iQElPAue3Phn1IkxAg_1795680131
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-3ab3061668eso25690701fa.1
        for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 00:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795680131; x=1796284931; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=N3RaXFDKfQNwD/7rbK7e/V5RDra9/0I7oTxMyTIYUUA=;
        b=ezBu5bGckn2Zfeo5iSj+gcDkqvWzwrGguLO+ictELdz0+TQtAIXk/f2NgiicHDVy0M
         YVdPCQf7scFQHg4LwSXXRtkAtc51UdgK3go6/n5GFNYP6iAC4dWxBs0UvABDqtkTGm+l
         lw/S0ZQ4tCQaCc/ZdjYgFTkyM2ODWu1zGs5zEHEvc+FWOSO0/d8K+VfnrIqGdUMZKYwc
         bv1+MvSocLDR1ZTD+Z9SMX+c22yk68M2Jb7W8J7Hgz7qMfOhdx4Vrfrg3sgUHN620JdF
         HTt/Yk87/hMkf9fptbLZsR6Zc77dHr4jB8lLnFF+sOVUCMu7+o26J0aS8slXrjfgtQiu
         iu0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795680131; x=1796284931;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N3RaXFDKfQNwD/7rbK7e/V5RDra9/0I7oTxMyTIYUUA=;
        b=FJvP7kHUniwBMWOuulDqiYKa7X3xgN5Iouzu2FQ+IoEZ3R+zPynptDj3I06vqh/1HV
         WjpK+yUfNgnsWdM8khYGHaxPVU+wWhgT0fSaI7XrRbErzsRia9zcBt3/JJ0CPKQpxOs4
         VBsqTJNL6bVEDX4VsXTyfWoUIR14BFXm+erIKz4TcYPObM5HgTCXlT26S7RPi5f+fRl0
         BItsj/LE49OpW60RNbrPWIO5zY/Stop9mVzB+Jvh6nUVfdmbWk0HZPs1kZHFwLMNo+QP
         02RohfLBA38cJtBXTyRsCZcxWx2BlFZLtVxExMOYzoaqQ7PSF2JingNFA9iSFxYJd5sl
         nrxA==
X-Forwarded-Encrypted: i=1; AL+hErHtNBbYXJw4ww5Hb8ThVDIGVFo988tAr9EH4QETtn0HdWnJ1fCv1m6HIobm8c60p3V5/wMeAOGT@vger.kernel.org
X-Gm-Message-State: APuU4Z+kRJ/Ez2E3e1K+Q+r2Ta9ZzwyrAmGobnhg0/1YQzCmLDP4xFSL
	kwRLC0BUzIncUGAhNU4PJVIeNLwwk+FuLZ1RMAbLDwziHyAkBTGanLwVBqEZqTjmB7sOlewCU9Q
	8qQ3U/+U4JUcTwsRy1PEndXgbR+fLb+Ih2zfJru9FFr4UZ/Cd87Yu3lrkFuY=
X-Gm-Gg: AZFdTZdlnUukKfic/kKfhLC5poTCItqHfkoF6mdZfSuF8H3OWaZbzMnc4H/t6YgNKlq
	pXgUQGQbg0Johm9q89twutZWGrIh4amTIMlexE2Mr5Dty23JLUuqb3394WLSFMOE49egl0HWHMF
	X/z0isUK/kjPIUBow3rczj5k5HroT4jtc5+lprzMOIjidn7h9lAjg366fpioBr2ZJW8AGgXRFB9
	pBa+sN53cAqpLGIPhlMSMHcbSuc11xwKoqByj7usKbwIhaCc+X1DDb4fndwUCOgLUsAyqoloxUL
	o5OZTfoKN7ttvRNGjdhcNCVFwFoiv3A5Jl6OHm4GrA4OlE7cejvYi08q0uVELxH4HKgogulFzaO
	tX0/5DzXUATUm9Pt5lRcywuQZAb/ifNmGa38V30LJ1Cw06vQd7mIGamcmYIne0yuAiCI1z4ijM3
	HPzvEs
X-Received: by 2002:a05:651c:a16b:b0:3ad:fcf7:950f with SMTP id 38308e7fff4ca-3ae7b7ce4dbmr51174831fa.13.1795680131208;
        Thu, 26 Nov 2026 00:02:11 -0800 (PST)
X-Received: by 2002:a05:651c:a16b:b0:3ad:fcf7:950f with SMTP id 38308e7fff4ca-3ae7b7ce4dbmr51174351fa.13.1795680129693;
        Thu, 26 Nov 2026 00:02:09 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.146.153])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b10b5f6sm36660545f8f.34.2026.11.26.00.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 00:02:09 -0800 (PST)
Date: Thu, 26 Nov 2026 09:02:07 +0100
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
Message-ID: <awfnfwN41UWleO8e@jlelli-thinkpadt14gen4.remote.csb>
References: <6fef47e08a37079c08806b3c57994778@kernel.org>
 <20261120212418.10221f2e@linux.fritz.box>
 <06f4c157677f99fc5386dba4c9d68cd2@kernel.org>
 <20261123084345.4e24e3ca@luca64>
 <awQTy09VbrDn9RpA@jlelli-thinkpadt14gen4.remote.csb>
 <20261123151846.3fdcbf4e@linux.fritz.box>
 <awfe_r5McCTzr84x@jlelli-thinkpadt14gen4.remote.csb>
 <20261126084322.4abc6744@linux.fritz.box>
 <awfkczwhkLkXVEVz@jlelli-thinkpadt14gen4.remote.csb>
 <20261126085811.33e7f074@linux.fritz.box>
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
In-Reply-To: <20261126085811.33e7f074@linux.fritz.box>

On 26/11/26 08:58, luca abeni wrote:
> On Thu, 26 Nov 2026 08:49:07 +0100
> Juri Lelli <juri.lelli@redhat.com> wrote:
> 
> > On 26/11/26 08:43, luca abeni wrote:
> > > Hi Juri,
> > > 
> > > On Thu, 26 Nov 2026 08:25:50 +0100
> > > Juri Lelli <juri.lelli@redhat.com> wrote:
> > > [...]  
> > > > Just for my own (hopefully) better understanding, I tried to come
> > > > up with a setup that uses a cgroup with entries on some CPUs and
> > > > "max" on others, to reason about it more concretely. This is an
> > > > illustration, not a deployment I actually know of:  
> > > [...]
> > > 
> > > Thanks for the example, it really clarifies things a lot for me!
> > > I am going to look at it in more details, but, just to check if I
> > > understand correctly: the "trick" here is that "P" does not contain
> > > any RT thread, and all the RT threads are either in "P/noncrit" or
> > > "P/crit", right?  
> > 
> > It would make sense to me. Also, I seem to remember we said it was
> > actually a requirement at some point (threads only allowed in leaf
> > nodes), but I might be wrong.
> 
> Yes, this was the original design...
> But I think the removal of the "threads allowed only in leaf nodes"
> constraint was requested in previous discussion (I do not remember the
> details, so correct me if I am wrong)

OK, it would still sound like a sensible user decision to me (how to use
properly a flexible interface that also allows you to do not very sensible
things with it :).

