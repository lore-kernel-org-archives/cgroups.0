Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE28935A933;
	Fri,  3 Jul 2026 20:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783111861; cv=none; b=rkxlCvKTJLGIB19vyc8KHHXr3z8+5zDRiDyETO6X9hqVXVkzJ/uKIPC3vxenQyNd6kQw3cWFec44EqB+S6WOezKSDYCNLCFx/zpaZTY9TnC0X2JJviUEQewiEAvPgPt24gejNdoVqCrhOchS3pWs27Onb0P53dwJd8V0ZNMx6BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783111861; c=relaxed/simple;
	bh=weZY7HlMfTb4wOu0gdj789moI4iJMedodF1+kHWiOFk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=U/trFZG4SDdBI+DdlD0sDZJkirfUUL6dRMiVUC/N+O89HcdoiL/Dl8RF/yWkQlcrqSPgS/QV/Q0B+gWCNbUbnK3F7rs/9y2aDGdOxH+SyNyhOnzSks3UkvadaeC+bXjbTnB0PZYgFLSY9w9Xp7N7jSeMXMObhsOrWQv/NSsCnlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=egdRKycx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="egdRKycx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5A81F000E9;
	Fri,  3 Jul 2026 20:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783111857;
	bh=/lOjK2FL3oGNR/QIiBPzt1DQTSujL52yPLoieoCLFFo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=egdRKycxMnUGGStVzARGFx66q2PrTpMAWUw+eryC9FI4OCxXIdxW+sDGqHX2tEXmX
	 5cDDUQarddlvtl9ckM77tctDY76Vcpu5y6rNBWGfR6+rvxCYO6GAG3Qr6JKMY6tc+9
	 r9/zcw0LWybyhV/GG/fIBF4qFrJlKvif9kXpAU4EnBHq7BVqlToCXSluaYon/ejg2Q
	 iW4j1oLCqD6rpS6WTc2x9b5W+dPxDgv8UCnIooeSVuwaY53S+uaRggK3xT6wgIqx3i
	 CmGrvDfbedMz0jGNhYfRiLLOOoFqW9hTav+Wxoyxn9k7qAJQONJrdmhCXEt/d5//+g
	 YIKBWF8qo4nXA==
From: Thomas Gleixner <tglx@kernel.org>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: Waiman Long <longman@redhat.com>, Jing Wu <realwujing@gmail.com>,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 cgroups@vger.kernel.org, Qiliang Yuan <yuanql9@chinatelecom.cn>
Subject: Re: [PATCH-next 00/23] cgroup/cpuset: Enable runtime update of
 nohz_full and managed_irq CPUs
In-Reply-To: <ake9D20lxx2Sncqm@localhost.localdomain>
References: <20260421030351.281436-1-longman@redhat.com>
 <20260624063404.2106807-1-realwujing@gmail.com>
 <4ad24488-9cc1-4f1c-8dc5-6830ae7420df@redhat.com>
 <akUii2CyEi7SRid7@localhost.localdomain> <871pdlphcc.ffs@fw13>
 <ake9D20lxx2Sncqm@localhost.localdomain>
Date: Fri, 03 Jul 2026 22:50:53 +0200
Message-ID: <87h5mflrv6.ffs@fw13>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 03 2026 at 15:45, Frederic Weisbecker wrote:
> Le Thu, Jul 02, 2026 at 05:00:03PM +0200, Thomas Gleixner a =C3=A9crit :
>> At #4 the half unplugged CPU is not in NOHZ full mode and the tick keeps
>> running so all GP processing work as before except that the CPU itself
>> is not handling any callbacks because all queued ones are drained and no
>> new ones can be queued. When it comes back up it turns into a fully
>> offloaded one.
>
> But interrupts can still fire and queue callbacks, right?

Sure, but because of

>>   2) rcutree_offline_cpu() removes the CPU from the fully functional CPU
>>      mask _AND_ marks the CPU as "lightweight offloaded", which means:
>>=20
>>         - no new callbacks can be queued on it anymore neither from the
>>           CPU itself nor from truly offloaded CPUs
>>=20
>>         - the CPU is still processing already queued callbacks and
>>           participates in the GP magic

the queuing sees "offloaded", so callbacks won't end up on the outgoing
CPU. No?

>> There are obviously a gazillion of details and cornercases to handle,
>> but I don't see why this can't be made work in principle.
>
> If we need to do something tricky anyway, how about this that would
> solve the initial problem of hotplug:stop_machine VS latency sensitive wo=
rkloads
> in general?

I'm all for that but there is way more than RCU and places which consult
cpu_online_mask.

Before you get to the point where you can remove stomp_machine() from
the CPU down machinery, you have to go through:

 - All architecture specific code in __cpu_disable()
=20
 - All existing (~60) AP callbacks in that section (former DYING
   notification)

and validate that none of that has assumptions about stomp_machine()
protecting them magically.

Back then when I was sanitizing CPU hotplug I looked into that deeply
and looked away pretty fast not only because of RCU. If it would have
been only RCU I surely would have pestered Paul enough to get it
fixed. :)

Let me give you some major pain points from my notes in complexity
order from back then:

   - All topology masks

     It's not only cpu_online_mask. There is numa_mask and all sibling,
     core, die, llc, l2c and whatever fancy masks we have and most of
     them are accessed in hotpaths all over the place and many of them
     implicitely rely on the stomp_machine() serialization (due to
     preempt/interrupt disable), unless they use an explicit
     cpuhp_read_lock() section.

   - RCU

     Plus the SMPCFD part, which has ordering constraints vs. RCU

   - Interrupt migration

     Sounds trivial but with the nastiness of the x86 APIC (w/o
     interrupt remapping) this becomes a nightmare pretty fast.

   - Tick

     Never dived deeply into it, but looking at the on the fly patches
     that's a solv[able|ed] problem.

   - Perf

     There were some truly nasty things in various perf implementations,
     but those got sorted out (at least on x86) due to RT by now. Still
     needs to be looked at.

That's x86 only. I've never looked at any other architecture and their=20
callbacks in the stomp_machine() section.

Just looking at your back then proposal:

    set_cpu_online(cpu, 0)
    synchronize_rcu()
    migrate things // call CPUHP_TEARDOWN_CPU -> CPUHP_AP_IDLE_DEAD

There is a hen and egg problem right there. synchronize_rcu() running on
the outgoing CPU requires a functional scheduler as synchronize_rcu()
can sleep on the completion. But you just pulled the rug under the
scheduler because you set the CPU offline. So how exactly is the wakeup,
which might be coming from a different CPU going to work?

I totally agree with the long term goal of removing stomp_machine() from
the hotplug machinery completely, but the various subsystems which
depend on it today need to be solved one by one upfront with that goal
in mind. Once we have them out of the way, removing stomp_machine()
becomes trivial. But starting with it to begin with is a guaranteed
recipe for disaster.

Thanks,

        tglx


