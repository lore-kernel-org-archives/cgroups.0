Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795790162;
	b=gqJ82YfswbHhg0w37Dq7HsBwJzt5O94SI3FJ6UsXP+qPQYAkoi2Q7C2j5oD0xmoZQGQi
	 rZTS44D0+nXwd02O+FpHDg3fu5ckQXzjLCfb6wKgdWMWDKnhKVcMtuWYk4nBC1RvnJxFO
	 ChpSAX89YRcPe6Xx+D2v4jDquXIFNXsB28tw8P1b1NVTt5V6R9wsENl8dGNIyO53ndLOu
	 dTlJ9ncrK+JJuInKcbUJeodjpY7kKJfKXTWiVSvuNOdEOH2kbE5L4cB+Hl1TZExrUoW52
	 LofRAODcOBY6il83s3WOna0O0uHsBpeiz4a0sRM56UUu0XI9drxD2Tai83Tv3rj/m3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795790162;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=h1AojE61+j7Hu8c46cBtAoEcmrt58ic58oLtqQYdsTE=;
	b=UXKMWH2fmYuEOlnVHPKg3WqnDcMlB7nBgP4A/WDXGoUF+bOCsDyhwz6FS4tbyc1uZ/sz
	 mX9ybteabuFFnBneU6tW0jyF+caOieR+JwJ8j/5iAvABdIO81/1ekKs+CQ9DjDULXq+Zm
	 18Db5CUP9YS7dIV18Ej4zFzCZDbF7+s8JC6Ie2MWmIiqkXXh8iTJTs6+3KKbr6z4UCvb8
	 derh7cunmbiT8OotyEkJ7gKB1lt/Y4hkIkJMBwN5B8MPbwRZhtos4DbIy3wivJU0Rdv8I
	 wIE+dvM+sqQMSN9FRybjF7+UrYABhDfm5VhsdMiRuK1QfpGe0AOo9X2bh/PuV1o/HMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iebjECQz;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b="YUi2NU/r";
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF72606A31C
	for <cgroups@vger.kernel.org>; Fri, 27 Nov 2026 14:36:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2FF72606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iebjECQz;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=YUi2NU/r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795790161;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h1AojE61+j7Hu8c46cBtAoEcmrt58ic58oLtqQYdsTE=;
	b=iebjECQzhZRy2OVSvJ3nvWXQIqagHLRu8C4LeWag41iAgzR+sFw6AV/Q8iRtW8vbaXTAYK
	nb4y8Jv9ZhOPj0PLob7lmT5u5Gy88krbZHhkCPwi2cxWsFETOBHxCMxOSTFwf1VDKRTVqL
	nYT6YoQxzB/tZqvVX1s5b2NCZoIm648=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-227-skBNWB_dOZO2KLf-EBWesQ-1; Fri, 27 Nov 2026 14:35:59 +0000
X-MC-Unique: skBNWB_dOZO2KLf-EBWesQ-1
X-Mimecast-MFC-AGG-ID: skBNWB_dOZO2KLf-EBWesQ_1795790157
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48e00f3929bso4693983f8f.0
        for <cgroups@vger.kernel.org>; Fri, 27 Nov 2026 06:35:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795790157; x=1796394957; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h1AojE61+j7Hu8c46cBtAoEcmrt58ic58oLtqQYdsTE=;
        b=YUi2NU/riWu8dJ1Bpb9ibOz1HKYRepeefZNbTqZkw8vDiy6XaYE0Aemfn8zi2tPb4I
         HKSZXwV8pLIQHNg+DDKI7yB3EzsP8tbFpydJJK3L2Kelosy+B3420ZACUkk5pCqkuyi7
         pN0MwNCfmS9LMgDmcAS8FUN0DDMOmUgQyVPqpM10dksunSa9z64wCpFon54YGzz1CTxa
         BsvCFijnBaGuXRTAY5587K1IWVL1Bi51xdJ2RjUxf5AGBHyGHTHHcTpcsuUt35IvCrcJ
         +e9zVnUjYxI10oTvOeranSXfE3nMQXPN57y+fubkQfmIomQIh9iXk+74a65MVeXJQIlN
         6+Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795790157; x=1796394957;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h1AojE61+j7Hu8c46cBtAoEcmrt58ic58oLtqQYdsTE=;
        b=VcQ5kFGysv07MsuubLW7Oapcs+DK3t5aoyZwMXn6z60VzRQpXLq7KXESpfnJ2hA1gk
         sKrZkhl+U28QXJ57WoWk9B4V1ddRqaWiLAnFkY/MEHv/BwQFMRe9GomY5wqB34hHWXLX
         zcc4mbxvG2oOdb+7eJnjm19Hgv9NHrU+/pJnKg2qrHU15O7VgNynHNbKCdTHKLdBBeOn
         2kOlQngFRs49KKeotl2eCY6k1P/lPU/JNpTLNt0mEmsSuXsI+QQRaDhBf+yVDs5M4fKw
         2VKO0Scsd01pEUibSETtBf/dc389h5EaB+nuQixDk11W790CZ4Gam5LitBcIswU5pukg
         Jj2g==
X-Forwarded-Encrypted: i=1; AL+hErGbyAOq27nl7gzOwSDLdeGHidsTg/G9L43z5tVSflEtlwAtWlJx5O5e0m/AwU4fVa4pcGDXrCy0@vger.kernel.org
X-Gm-Message-State: APuU4Z+ArYJVXR0LEN9UfezIjtcXyevdSWYRhf1KecQ6ThYZCOiNrDDM
	LrKwE3ewGkjCnbaKZVvGcxJ8eLUGEve2KsFxteIUP5+lvQvfQpQu8dSl0YCfE88IYcPCF8HyCKN
	/9YuULP0pSteEjYSPWSnOQqlRQMwGed5feJeHQozqksUHhszazAi13CbJfd8=
X-Gm-Gg: AZFdTZeSjbLso1cbVFINiJCI+1078xwyjbaWm9qpVY6N5zj2vDjzKDq0qrHiPsitxyN
	tGj2M9eQZzqkg8gEmVRmHWBFtZEEoS7/v+8mp8MfTFC3M87Emon+uhgDj8DEyYvvESaH1F5O6Et
	3yJtsIDglbwnwoLGTCj2tXpC01OnwbSMBshSatQPmtz+mRH6WZ+xQnl9z+6lUN3yjGvFsAyZ+Cp
	FFfU/jUG2Jal7lHrsRZi2zXftqPOrvIQMFlmlfwwyobADLsMs8l+D029oCoeq4Id2Fr0UiOb8Hr
	ajugFMTlE0lMK/foTOYI/CAGJit6WM3avccTle9onoA/lg4hyrD4nRD9T/lujUz4MG3e0MStIzs
	9YPP402oVuexW2FrCvj9HXjuX+bLaM2hlCeEt3Br7MCau/ID2Ct3nEiXAuEVAj8c+aYjG5IIUu5
	ypXisO
X-Received: by 2002:a05:600c:4f81:b0:4bb:5e8c:13bc with SMTP id 5b1f17b1804b1-4bb88805902mr478907745e9.7.1795790157278;
        Fri, 27 Nov 2026 06:35:57 -0800 (PST)
X-Received: by 2002:a05:600c:4f81:b0:4bb:5e8c:13bc with SMTP id 5b1f17b1804b1-4bb88805902mr478906835e9.7.1795790156736;
        Fri, 27 Nov 2026 06:35:56 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.146.153])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8526cbd0sm924349095e9.0.2026.11.27.06.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 06:35:56 -0800 (PST)
Date: Fri, 27 Nov 2026 15:35:54 +0100
From: Juri Lelli <juri.lelli@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: luca abeni <luca.abeni@santannapisa.it>, Tejun Heo <tj@kernel.org>,
	Yuri Andriaccio <yurand2000@gmail.com>, bsegall@google.com,
	cgroups@vger.kernel.org, dietmar.eggemann@arm.com,
	hannes@cmpxchg.org, kprateek.nayak@amd.com,
	linux-kernel@vger.kernel.org, mgorman@suse.de, mingo@redhat.com,
	mkoutny@suse.com, rostedt@goodmis.org, vincent.guittot@linaro.org,
	vschneid@redhat.com, yuri.andriaccio@santannapisa.it
Subject: Re: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
Message-ID: <awmVSkc4T0AuFntw@jlelli-thinkpadt14gen4.remote.csb>
References: <58cb2cbaf82c0f671213eaca46465cd5@kernel.org>
 <20261119151416.33f90a64@linux.fritz.box>
 <471bf8d446becabfca00041fb2a78067@kernel.org>
 <20261120120659.2e902463@linux.fritz.box>
 <6fef47e08a37079c08806b3c57994778@kernel.org>
 <20261120212418.10221f2e@linux.fritz.box>
 <06f4c157677f99fc5386dba4c9d68cd2@kernel.org>
 <20261123084345.4e24e3ca@luca64>
 <awQTy09VbrDn9RpA@jlelli-thinkpadt14gen4.remote.csb>
 <20261127114828.GS49833@noisy.programming.kicks-ass.net>
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
In-Reply-To: <20261127114828.GS49833@noisy.programming.kicks-ass.net>

Hello,

On 27/11/26 12:48, Peter Zijlstra wrote:
> On Mon, Nov 23, 2026 at 11:22:03AM +0100, Juri Lelli wrote:
> > IIUC reading your RTNS'21 paper with Stephen and Jim [1] right, those
> > are its conditions (1) and (2) for semi-partitioned systems, and
> > together they keep the system feasible. Did I get that right? The catch
> > is that the paper also needs changes to the migration logic (no throttle
> > bypass for tardy tasks, and the pushed task not counted in cpudl when
> > looking for a target) for tardiness to stay bounded, and AFAIK we don't
> > yet have that in mainline.
> > 
> > So today's DL isn't "pinned aware", but we already live with that:
> > fair/ext servers are pinned and simply added to total_bw. I don't think
> > this series should fix that too. What I'd suggest instead is:
> > 
> >  1. keep the interface per-CPU as Tejun proposed, and do admission as
> >     above (sum into total_bw plus per-CPU check). When a config is
> >     symmetric across the CPUs of a root domain, this is the same as
> >     today's uniform reservation, so it works with the current DL
> >     implementation with the same guarantees we have now;
> > 
> >  2. accept asymmetric configs too, but document that, until DL becomes
> >     aware of pinned bandwidth, they come with no tardiness guarantees
> >     for DL tasks (as with non-default fair server settings today).
> >     Once the migration side is fixed (the paper's changes, or
> >     something similar), they get the guarantees without any interface
> >     change.
> > 
> > This also avoids the cost of the max approach, where 50% on one CPU
> > takes 50% of DL capacity on all CPUs of the root domain, and it should
> > be less code, since cgroup servers would just follow the dl_server
> > accounting paths (dl_server_apply_params(), dl_server_add_bw() on
> > root domain rebuilds), but Yuri should keep me honest here. :)
> > 
> > The root entry would then just limit what cgroups can reserve per CPU,
> > on top of the above, which I think is what Tejun described.
> > 
> > Thoughts?
> 
> Still slowly working my way through all this email :/ So bear with me if
> I missed things already discussed elsewhere.
> 
> 
> So my suggestion to make all this cgroup-v2 only and couple with cpuset
> is exactly because of the bandwidth accounting. Specifically, cgroup-v2
> makes it possible to map a cgroup to a cpumask (exactly like we do in
> tg_cpus()). This in turn means we have a natural limit on the bandwidth
> consumption -- a cgroup's deadline servers will never run outside this
> mask and will thus never consume bandwidth outside of it.
> 
> Without this, you get to account every cgroup to all CPUs, which is
> incredibly pessimistic; to the point of not actually being worth it.

With entries keyed by CPU (as Tejun proposed), I think we get the same
limit without coupling: a cgroup claims bandwidth only on the CPUs it
has an entry for, so nothing is accounted on CPUs it doesn't ask for.
Coupling seems to be needed only for the form that doesn't name CPUs
(your runtime/nr_cpus), where the CPUs come from the cpuset.

> As to bandwidth accounting; I once started adding per-cpu reservations.
> Sadly I never finished it and I seem to have misplaced those patches.
> But yes, that is something that wants to be done.
> 
> I'm not sure I see how all this can function without having that TBH.
> All this runs on a giant pile of per-cpu servers; without strict per-cpu
> accounting much goes out the window.
> 
> The basic idea isn't hard either, give each CPU 100%, subtract the
> per-cpu demands and hand out the rest to the global pool. When demand
> exceeds supply, reject. The only somewhat tricky bit was that adding a
> local claim means you first have to try and lower the global supply --
> if that fails the whole thing fails.

I think that's what I was trying to describe: servers accounted in
total_bw (lowering the global supply) plus a per-CPU check on what's
pinned on each CPU. Fair/ext servers would become local claims as well,
as they are pinned too and today they are only checked against the root
domain total.

> A cgroup setting bandwidth for CPUs it cannot reach -- fine; the value
> will not be used. If the cgroup is grown (through cpusets) to include
> such a CPU, it will enact such a value, and if bandwidth reservation
> so demands, block the cpuset mask extension.

IIUC this is close to what Tejun suggested for offline CPUs (the entry
stays configured and takes effect again when the CPU comes back). The
question I see is what happens when the cpuset changes under existing
entries (cpuset is often managed by someone else, and a sibling
partition or hotplug can move CPUs too). Either the entry's bandwidth
stays claimed while its CPU is unreachable, so cpuset changes never
fail but that bandwidth sits unused, or it's released and claimed again
when the CPU becomes reachable, which means growing a cpuset can fail
because of the cpu controller. Tejun, Peter, does either work for both
of you?

> As to the whole max thing; am I understanding things right if I say this
> means the cgroup itself will not have a constraint? I saw talk about one
> cgroup having mixed constaint and no constraint CPUs? That's crazy talk
> and makes absolutely no sense. Please don't support this.
> 
> Either a cgroup has a constraint or it does not.

AFAIU, "max" means the cgroup has no servers of its own on that CPU, and
its tasks are served by the nearest ancestor that has an entry there
(or run as plain FIFO/RR if none has).

I tried to come up with (forge :) an example where mixing is useful in
[1]. The gist is delegation: a container P runs a single RT process,
with critical threads in P/crit (cpuset 4-10) and other FIFO threads in
P/noncrit (cpuset 0-3). The admin wants to cap what the container can
reserve, so the cap goes on P (P/crit's file is the container's to
write). The cap needs to cover CPUs 4-10 only: with entries on 0-3 as
well, P/noncrit would be served by P there, and its threads would either
not run at all (zero) or use a reservation they don't need. cpuset keeps
the two sets apart, so no task moves between a server and the root
runqueue. Luca's follow-up [2] is about doing it without mixing (budget
only on P/crit), which works if the admin configures the whole tree, but
not when P is delegated [3]. Admittedly, I'm still not sure why one
would want to run noncrit w/o a cap, as crit stuff might depend on
noncrit, so happy to be convinced this is actually useful for real. :)

1 - https://lore.kernel.org/all/awfe_r5McCTzr84x@jlelli-thinkpadt14gen4.remote.csb/
2 - https://lore.kernel.org/all/20261126155736.20e64e65@linux.fritz.box/
3 - https://lore.kernel.org/all/awhfdTbfDhpklaTN@jlelli-thinkpadt14gen4.remote.csb/
