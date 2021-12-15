From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v9 2/7] cgroup/cpuset: Allow no-task partition to have
 empty cpuset.cpus.effective
Date: Wed, 15 Dec 2021 11:36:29 +0100
Message-ID: <20211215103629.GA25459@blackbody.suse.cz>
References: <20211205183220.818872-1-longman@redhat.com>
 <20211205183220.818872-3-longman@redhat.com>
 <Ybew7d2oE2gLcLNO@slm.duckdns.org>
 <810204ce-7967-e470-1267-7c3cfb521c89@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639564591; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/aPaR9Uw4ulAkIgHecWl2en5QXeWEK3aOB4cy3NVwDI=;
        b=N0Oi6iG4jR1Ii/2w8VZGdDCkCls7BxgRGgpITtz5WTEMqIEVtEn64XU5QoylIR/K2x/31p
        dRUkaE8ntIn9pTwzN1kEQ9S+rdhVnK7upRk8kdKOg/KeAaBeb/daspbclQWbET4VvGyatI
        iuTmVTTFyDVEZ/YCPSS9aAkJG5W4m/0=
Content-Disposition: inline
In-Reply-To: <810204ce-7967-e470-1267-7c3cfb521c89@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>

On Tue, Dec 14, 2021 at 10:24:22PM -0500, Waiman Long <longman@redhat.com> wrote:
> AFAICS, there are code in cpuset.c that disallows the an non-child node to
> hold tasks, but the check doesn't cover all the possible cases.
> I remembered that I was able to create such a scenario without using
> threaded domains.

On the default hierarchy (with controller(s) enabled)? That sounds like a bug.

> That is why I put in this conditional check. It has nothing to do with the
> use of threaded domains.

But threaded domains are important nevertheless.
I think that a structure like

	app-cgroup	cgroup.type=threaded domain	cpuset.partition=root
	`- rt		cgroup.type=threaded		cpuset.partition=isolated
	`- normal	cgroup.type=threaded

is a valid use case. Therefore I would not disallow partitioning inside
threaded subtrees (as suggested).


Michal
