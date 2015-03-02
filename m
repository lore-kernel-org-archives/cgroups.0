From: Mike Galbraith <umgwanakikbuti@gmail.com>
Subject: Re: [PATCH v4 2/2] cpusets,isolcpus: add file to show isolated cpus
 in cpuset
Date: Mon, 02 Mar 2015 13:44:50 +0100
Message-ID: <1425300290.5863.17.camel@gmail.com>
References: <1424882288-2910-1-git-send-email-riel@redhat.com>
	 <1424882288-2910-3-git-send-email-riel@redhat.com>
	 <54EEFE15.3010005@huawei.com>
	 <20150226121231.6fcba7e8@annuminas.surriel.com>
	 <20150302090933.GH21418@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:mime-version:content-transfer-encoding;
        bh=3mglPhc9yZwXbyr0GM0J2e4+7F1KdaUl0ag5Zva4Df0=;
        b=vDTt6m111iaiqwvuUqGDlNLIlGnF2IkdifNPod4w3ukz01+VRKu73S2c8A7JSCf7gb
         7dCT3ChneARcD0zJdlaqevlJEwYdfHLuRUShNTtlSlhxpRQRB1CBGP7xALeJVeuzA94h
         qOizKB+VODvnisSghUBk9i8PzehsvGPB/DTb0/bAPKFMYXqVagQf9ocw64DribuPjIsI
         cQcDJQmaWk/6mIgneJoZc1YA/mmrljrG9D4G4qztKwbnDX5GBHmQTia4mUZjOpgDH705
         03mBn60KyYyQfHXIINL7ZyRx9p1Qgufp4h7V7F5M6qL+IdzzqeqJqB/FrOcfFNQ5oFlM
         qCFg==
In-Reply-To: <20150302090933.GH21418@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, Zefan Li <lizefan@huawei.com>, linux-kernel@vger.kernel.org, Clark Williams <williams@redhat.com>, Ingo Molnar <mingo@redhat.com>, Luiz Capitulino <lcapitulino@redhat.com>, David Rientjes <rientjes@google.com>, cgroups@vger.kernel.org

On Mon, 2015-03-02 at 10:09 +0100, Peter Zijlstra wrote:
> On Thu, Feb 26, 2015 at 12:12:31PM -0500, Rik van Riel wrote:
> > Subject: cpusets,isolcpus: add file to show isolated cpus in cpuset
> > 
> > The previous patch makes it so the code skips over isolcpus when
> > building scheduler load balancing domains. This makes it hard to
> > see for a user which of the CPUs in a cpuset are participating in
> > load balancing, and which ones are isolated cpus.
> > 
> > Add a cpuset.isolcpus file with info on which cpus in a cpuset are
> > isolated CPUs.
> > 
> > This file is read-only for now. In the future we could extend things
> > so isolcpus can be changed at run time, for the root (system wide)
> > cpuset only.
> > 
> > Acked-by: David Rientjes <rientjes@google.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Clark Williams <williams@redhat.com>
> > Cc: Li Zefan <lizefan@huawei.com>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Luiz Capitulino <lcapitulino@redhat.com>
> > Cc: David Rientjes <rientjes@google.com>
> > Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
> > Cc: cgroups@vger.kernel.org
> > Signed-off-by: Rik van Riel <riel@redhat.com>
> 
> So let me start off by saying I hate isolcpus ;-)
> 
> Let me further state that I had hopes we could extend cpusets to
> natively provide the functionality isolcpus has, and kill isolcpus.

+1

That's where nohz_full goop belongs too.

> The 'normal' way would be to create 2 cgroups with disjoint cpus,
> disable sched_load_balance on root and one of the siblings, while moving
> everything into the other group.

That's what cset shield does, works fine.

> The 'problem' is that we cannot move everything that is affected by
> isolcpus, workqueues have grown a horrible 'new' interface outside of
> the regular task interfaces and things like kthreadd are non-movable for
> mostly good reasons.
> 
> Furthermore it appears that software like system-disease and libvirt
> hard assume they're lord and master of the cgroup hierarchy and do not
> expect things like this.
> 
> So while I mostly hate all of this it might be the best we can do :-(

Hm, I'm now all system-disease-ified now (still hate the bloody thing),
and have no problem isolating cpus via cpusets, modulo workqueues
wanting a bat upside the head.

	-Mike
