From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v8 0/6] cgroup/cpuset: Add new cpuset partition type &
 empty effecitve cpus
Date: Wed, 10 Nov 2021 14:56:53 +0100
Message-ID: <20211110135653.GD20566@blackbody.suse.cz>
References: <20211018143619.205065-1-longman@redhat.com>
 <20211110111357.17617-1-felix.moessbauer@siemens.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1636552615; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jqt2z7sKN4l4GAdAXxs3m4wrEVKXKmm1Vj0eGW+xqyg=;
        b=n5XqFDRHYOL0PjFz0tieqrIrYuiBsvCzxNHnR2Mjn9qopJ7gtFZjaWjQRXjG5ELp5uBzyv
        5GXGsx3YQ0yqoBCEoJCqIVL2L42tgLG7f5wBqDp2iHHcYlo/rxG52qXctMY2uDVAsPH8xc
        ml+20N890xovCdvobm7CmkOkDTJhms0=
Content-Disposition: inline
In-Reply-To: <20211110111357.17617-1-felix.moessbauer@siemens.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Felix Moessbauer <felix.moessbauer@siemens.com>
Cc: longman@redhat.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, corbet@lwn.net, frederic@kernel.org, guro@fb.com, hannes@cmpxchg.org, juri.lelli@redhat.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, lizefan.x@bytedance.com, mtosatti@redhat.com, pauld@redhat.com, peterz@infradead.org, shuah@kernel.org, tj@kernel.org, jan.kiszka@siemens.com, henning.schild@siemens.com

Hello.

On Wed, Nov 10, 2021 at 12:13:57PM +0100, Felix Moessbauer <felix.moessbauer@siemens.com> wrote:
> However, I was not able to see any latency improvements when using
> cpuset.cpus.partition=isolated.

Interesting. What was the baseline against which you compared it
(isolcpus, no cpusets,...)?

> The test was performed with jitterdebugger on CPUs 1-3 and the following cmdline:
> rcu_nocbs=1-4 nohz_full=1-4 irqaffinity=0,5-6,11 intel_pstate=disable
> On the other cpus, stress-ng was executed to generate load.
> [...]

> This requires cgroup.type=threaded on both cgroups and changes to the application
> (threads have to be born in non-rt group and moved to rt-group).

But even with isolcpus the application would need to set affinity of
threads to the selected CPUs (cf cgroup migrating). Do I miss anything?

Thanks,
Michal
