Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381CF3822A1
	for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 07:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787122842; cv=none; b=aYvo5qsEWgeB19pf6m6mduSbotBnEGoNDiickGhb+w0i9VlzV8crvBkdH1cdxxlWVBsO89DeezQsnVsYkbsG3JpiQY5JgppLkqMUnabENoIR7r+WKGB0IFUtlodw786BgCgMZOptZl6wQ0NtpONPDLK8fXJTTuiQeBWs1Y8x8aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787122842; c=relaxed/simple;
	bh=QxsdmTeVO7O8GHal5LqPZUvEcrNTI1+4VAxP+PPES3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UNVdM7capSmSyhyNp8xQ79OLIlFyHMrTKqeo6Fd3m1tw+SKZb0wZqG8bjBbuPOEH/Bgu9oBq28jVmSzdPmThU2xa2DBnOGsgwDN1Ozq7fktUu4IdIZ90Vf3luIOqHOmywiLscsNAHiLQZvyG5jRZmJRYVzkUgFE3qa5Ae0F1FY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fmnb7rr7; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fmnb7rr7"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-47f6609c657so263037f8f.2
        for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 00:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787122838; x=1787727638; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cwVITkOSrTqTzud3KhMHcX5dBYEfTruNyXr6qoqV70Q=;
        b=fmnb7rr7lZwjPUbDSOsJvQwMJDou7+3sXKNfjfh3hPVP1QV1HfGi1AlKt5kDaKwOgr
         YlPzMr1Kd56Mxs08S8MIFtxrYuLQ6xtxKDyf8zcTDRWC5Z4dhXMGvnwHi6fmq5rXbitv
         za1lfrVY6t2dgOeHSdPVVW6qYh/YIIbJl3s0YgOMVVxn7BEqgPwNWlP3l+i1bBOxA6dZ
         nLmeezsqgHKMiGYlloxqMQbbKDEIIGfY7c2h6zLy6u9zQ5zkmdkDueJ1HWyEGOKreaah
         oRfsicVntg5bo0HpmOGWFubGh4+4emZAHH1NeSCj5LnfMJaTK0XdsQPKvUJ/9GfdHmPx
         8MDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787122838; x=1787727638;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=cwVITkOSrTqTzud3KhMHcX5dBYEfTruNyXr6qoqV70Q=;
        b=QtWrwQCPog9A+VuBUEleObueRySsuXk//wHORQycanSCo3HJK2Sk0Gd2ieDixB2jP2
         oxKNgfDqzHrrdqMPGYKc7ISMq10XqMAE5CwFzZCj89YgVyWvQ8KYvFQfCSXxnlmOWEUt
         RGhbHQPOc+rRoQXpY6xCBvegKfRu/LPV9lr0lL4/MsZqlorGQ/UeMaII/js7U5NljnR1
         O+lg0a/iYRPKDhyay9/8yD/mSCUYZea1jqJveNhpbHfKflwIc8Dq3cIDbG0To3BxT7vV
         7DTR6cBnRklxb6hLWE6vZe8uvOtFGiAwBh5dyjrFR4nTrq7rXLtYeHBlSMajwagWKFTi
         ZoIg==
X-Forwarded-Encrypted: i=1; AHgh+RqiqF5aoafY0cntRM+mReKltNxaDD+9+Wi9MsatKTyacs64s9JBALkbqyjH8oIi4fGQe3mvAIDh@vger.kernel.org
X-Gm-Message-State: AOJu0YzCtHX2jbxjY24CmaX9XvJPPOLfwrwljb8dtXYdnwnfzkUu4L3q
	KA0YZV4y+ysWj+H/x/DUTq9XYPS5AOYhrbvrrs3+Rw7kU9FHcTP5TSX18fIv4bIyluo=
X-Gm-Gg: AR+sD113Q35OVLHUDYTT9DDQdkD540PZFpPzzZdXcMPcjuac9Nem3zXkM5jFWSg+Syi
	8ZO8lleTz5umFufJDDLYjUvn+gtj7yMEBISv3vjdXLWXel/j784V37Q318lA7ViJZc3rcSJQ6/r
	eIwJR7UOtb1wEY6muUzmfTQbH5w46gdn3a30OV4p/gV/r4pc4dJrrETqORtLkcXONMif9uh+JPc
	+EiFDxyB8Qq+T6pdzMyshKARiEj5iChIAeAvIz2turhpIEuHOmMOx0m7NUCCq2TuwerWHvKKNBy
	6wgWb/R+ggrF9OPuAZAA5NVPTNbLBkm6QE8aIMXmfZud+waH5ebnjQWpO4CEvkvlDOFkN9lk6Ju
	kWLpzLdnjXfYoNIedleYYzQhif+aThcj4C88+Qen+9NFrzvBVUWXuUbQ0y+/2HQji11AcZO6lyy
	tK5wYnk0AReyVi1M9l3flTOaO8Qu2IKURAInrm5lTiyzVOO+6LC9SD0bfR5XCC/JZgfUu0ic74r
	A==
X-Received: by 2002:a05:6000:2c10:b0:47f:cb39:10c4 with SMTP id ffacd0b85a97d-482b1fd9f1emr3054734f8f.12.1787122838407;
        Wed, 19 Aug 2026 00:00:38 -0700 (PDT)
Received: from localhost (109-81-87-166.rct.o2.cz. [109.81.87.166])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482b14d9783sm3392406f8f.37.2026.08.19.00.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 00:00:37 -0700 (PDT)
Date: Wed, 19 Aug 2026 09:00:36 +0200
From: Michal Hocko <mhocko@suse.com>
To: Tao Cui <cui.tao@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
	roman.gushchin@linux.dev, muchun.song@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH] mm: page_counter: reject empty string in
 page_counter_memparse()
Message-ID: <aoVUlFdZYLFn_gvJ@tiehlicka>
References: <20260817042652.74136-1-cui.tao@linux.dev>
 <aoMzchLCCz5hiFHp@linux.dev>
 <aoQNtIRvqXRh-x4u@tiehlicka>
 <aoRz72_zdMai_RNV@linux.dev>
 <aoSLxSBUPbEqimJq@tiehlicka>
 <9bd74181-2ce4-4d69-a353-614685559ceb@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9bd74181-2ce4-4d69-a353-614685559ceb@linux.dev>

On Wed 19-08-26 11:00:09, Tao Cui wrote:
> Hi, Michal, Shakeel
> 
> 在 2026/8/19 00:43, Michal Hocko 写道:
> > On Tue 18-08-26 08:06:22, Shakeel Butt wrote:
> >> On Tue, Aug 18, 2026 at 09:45:56AM +0200, Michal Hocko wrote:
> >>> On Mon 17-08-26 09:16:40, Shakeel Butt wrote:
> >>>> On Mon, Aug 17, 2026 at 12:26:52PM +0800, Tao Cui wrote:
> >>>>> From: Tao Cui <cuitao@kylinos.cn>
> >>>>>
> >>>>> memparse() consumes no characters on an empty input and leaves the
> >>>>> end pointer at the terminating NUL.  The only validation in
> >>>>> page_counter_memparse() checks for trailing characters, so an empty
> >>>>> input slips through and the limit becomes 0.
> >>>>>
> >>>>> All limit write callbacks of the memory controller strstrip() the
> >>>>> input before calling this helper, so a script that writes an unset
> >>>>> variable hits this path:
> >>>>>
> >>>>>   LIMIT=
> >>>>>   echo "$LIMIT" > $CG/memory.max
> >>>>>   echo $?
> >>>>>   0
> >>>>>   cat $CG/memory.max
> >>>>>   0
> >>>>>
> >>>>> Nothing reports the mistake: the limit is now 0 and the OOM killer
> >>>>> goes after every task in the cgroup.  The same happens for
> >>>>> memory.min, memory.low, memory.high, memory.swap.high,
> >>>>> memory.swap.max and memory.zswap.max, where 0 silently removes the
> >>>>> protection or disables swap and zswap.
> >>>>>
> >>>>> Reject the input when no characters were consumed, which is the one
> >>>>> case the trailing-character check cannot catch.
> >>>>>
> >>>>> Fixes: 3e32cb2e0a12 ("mm: memcontrol: lockless page counters")
> >>>>> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> >>>>> ---
> >>>>>  mm/page_counter.c | 2 +-
> >>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>>
> >>>>> diff --git a/mm/page_counter.c b/mm/page_counter.c
> >>>>> index 661e0f2a5127..d14db705b04f 100644
> >>>>> --- a/mm/page_counter.c
> >>>>> +++ b/mm/page_counter.c
> >>>>> @@ -281,7 +281,7 @@ int page_counter_memparse(const char *buf, const char *max,
> >>>>>  	}
> >>>>>  
> >>>>>  	bytes = memparse(buf, &end);
> >>>>> -	if (*end != '\0')
> >>>>> +	if (*end != '\0' || end == buf)
> >>>>>  		return -EINVAL;
> >>>>
> >>>> I wonder if someone started depending on this behavior. In that case it is
> >>>> better to return error instead of silently ignore, so we will hear complains
> >>>> loudly. This looks good to me.
> >>>
> >>> This is backward incompatible change and I am wondering why should we
> >>> even risk regression.
> >>
> >> Mainly I was wondering if this is intentional or unintentional. If this us
> >> unintentional, can we fix it without anyone noticing?
> > 
> > My guess would be this was just omission. Those happen and over years we
> > have learned that userspace is quite creative at using those.
> > 
> >> However if we are ok with this then let's make is formal and make this a
> >> documented behavior. I don't have any strong opinion either way but I think you
> >> are saying it safer to just assume this is intentional. Fine with me.
> > 
> > My main question is why should we even bother to change this in the
> > first place? Is that reason stronger than a theoretical breakage of
> > userspace that we might learn much later?
> 
> Since you asked "why bother", here's how I ran into it.
> 
> The patch actually came from a production incident rather than a code
> audit.
> 
> A maintenance script on a cluster accidentally wrote an unset variable
> into memory.max of a workload cgroup. The write succeeded, and the
> workload in the cgroup was subsequently OOM-killed. There was no
> indication that the successful write had caused it, so it took quite
> some time to trace the OOMs back to that script.

Understood.

> When I checked the documentation, I noticed that the cpuset controller
> explicitly documents the semantics of empty writes ("An empty value
> indicates that the cgroup is using the same setting as the nearest
> cgroup ancestor..."), while the memory controller documentation says
> nothing about empty input.

yes, this is really unfortunate and mistakes like that happen.

> I reproduced the same behavior in isolation on a Kubernetes cluster
> (v1.29, cgroup v2, two-container pod, 384M pod limit):
> 
>   # LIMIT=
>   # echo "$LIMIT" > $CG/memory.max
>   # echo $?
>   0
> 
>   m6demo   0/2     OOMKilled   0
> 
>   oom-kill: constraint=CONSTRAINT_MEMCG,
>             oom_memcg=/kubepods.slice/.../kubepods-burstable-pod....slice
>   Memory cgroup out of memory: Killed process 339529 (sleep) ...
>             anon-rss:32kB, file-rss:452kB
> 
> The process selected by the OOM killer had less than 1 MB resident
> under a 384M pod limit, but the empty write was accepted as 0,
> immediately triggering a memcg OOM. From the caller's perspective, the
> write simply succeeded.
> 
> One caveat is that kubelet reconciles the pod-level memory.max within
> seconds, so the window is short there, although container-level files
> are not reconciled.
> 
> So the patch came out of that incident and the documentation gap it
> exposed. My thinking was that rejecting an empty input would make such
> mistakes fail immediately instead of silently changing the limit to 0.

Thanks for sharing the story. Next time I would recommend to make that a
part of the changelog.

> Whether that benefit outweighs the compatibility risk is not mine to
> decide.

And I am still not convinced. I do understand your frustration from the
debugging the issue. In any way, if other maintainers decide this change
is worth I will not stand in the way.

> If it doesn't, then documenting the current empty-write
> behavior, similar to cpuset, would also address the ambiguity that led
> me to investigate this in the first place.

Agreed!
-- 
Michal Hocko
SUSE Labs
