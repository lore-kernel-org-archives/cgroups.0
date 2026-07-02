Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C337433E8E;
	Thu,  2 Jul 2026 15:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783004408; cv=none; b=GNAJJmQNVzDPYrj8Ne/sJLBoOe+QYKFYVYwkCVfCYRZtfYUlHFpTeqhw/r97wuq87aojWEBiQrqoZ50hJ4E8fwD+gb0xz2iskGKEjQIX0Jb+gKKeQZqQxy8npvbjvHXG9HkfX8HqTc/cDb/8eyCwB1c9v4OFciqzWd/skqcQe6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783004408; c=relaxed/simple;
	bh=hPC1d17Pm91ef5jisgFCPpY7b+2HYaO+kLSAqjerQqw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=SYUt9QLbEzH4XYZLGuCsxJfviAuuYBd3Cc83pPDuy1w0feq+VuvzUu7G2FWcDIWFJvpUXqngePYVK5A376DeLSL/+A9DoRxr5oa+kjt+J9r4OTUzimvLulbXCx4aIxcaRy1XHPgoEHi218fwjVLkDJVWb1pygafTYNakCNHOnvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GpB3h3Zr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GpB3h3Zr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84991F000E9;
	Thu,  2 Jul 2026 15:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783004406;
	bh=9UsSLsOFrTKTYYu1bP5O8gdG6Ad+9Ku55xym1ohwY3g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=GpB3h3ZrEpTU9FF0KGzdNzXUKImbL2riZrwADZ7VZDzkQ1F5dKhpNQDSMjH43RJ2h
	 JjhJTrdEa+iXhl0LgSfCY9xAcY/maK5t7B911QvOOvlztnSk3ICTWAh+aMXOXT59ty
	 gR3nD1nGgPsTRDLnfMZoL/w23xCOLc6gc25l7aInMZ2A/NWkvSAzG3HZDz+Qp8qkxe
	 uPKPJs/isZ9TO97RdEIqBOmacfTZ5FbPdYKvLincda0xsmPYgLpyWlBLafEuXscpbE
	 vCBXzs6uC+u+3UDPw3miivkGnMet1rzKME+kvORLGUmhOjlWZXpnF7hODMomyYjEaP
	 3LcRZDZLCxhlw==
From: Thomas Gleixner <tglx@kernel.org>
To: Frederic Weisbecker <frederic@kernel.org>, Waiman Long <longman@redhat.com>
Cc: Jing Wu <realwujing@gmail.com>, linux-kernel@vger.kernel.org,
 rcu@vger.kernel.org, cgroups@vger.kernel.org, Qiliang Yuan
 <yuanql9@chinatelecom.cn>
Subject: Re: [PATCH-next 00/23] cgroup/cpuset: Enable runtime update of
 nohz_full and managed_irq CPUs
In-Reply-To: <akUii2CyEi7SRid7@localhost.localdomain>
References: <20260421030351.281436-1-longman@redhat.com>
 <20260624063404.2106807-1-realwujing@gmail.com>
 <4ad24488-9cc1-4f1c-8dc5-6830ae7420df@redhat.com>
 <akUii2CyEi7SRid7@localhost.localdomain>
Date: Thu, 02 Jul 2026 17:00:03 +0200
Message-ID: <871pdlphcc.ffs@fw13>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 01 2026 at 16:22, Frederic Weisbecker wrote:
> Le Thu, Jun 25, 2026 at 01:27:54AM -0400, Waiman Long a =C3=A9crit :
>> That will require some adjustments to the nohz_full related hotplug
>> functions. I have some ideas of what needs to be done. However, I haven't
>> looked into RCU yet. I know RCU support changing the nocb mask for fully
>> offline CPUs, I will need to find out if it possible to do that for
>> partially offline CPUs.
>
> No because callbacks can still be enqueued at this stage. But we could
> manage to make it work with CPUHP_AP_IDLE_DEAD.

Well, if you go down to CPUHP_AP_IDLE_DEAD then that's not any different
from going down all the way because the latency spike of stomp_machine()
for bringing it down is the same.

You are right that with the current code this is not possible, but it
should be possible to avoid that alltogether.

The only critical path is when a CPU switches to offload mode. Switching
to 'yes queue callbacks here' mode is not really interesting.

Let's look how RCU hot-unplug works:

  1) CPU is marked !active

  2) rcutree_offline_cpu() removes the CPU from the fully functional CPU
     mask
=20=20
  3) stomp_machine()

  4) rcutree_cpu_dying() just traces that the CPU is about to vanish

  5) Wait for the CPU to report DEAD

  6) rcutree_migrate_callbacks() mops up the leftover callbacks on the
     dead CPU

So if the whole machinery changes to:

  1) CPU is marked !active

  2) rcutree_offline_cpu() removes the CPU from the fully functional CPU
     mask _AND_ marks the CPU as "lightweight offloaded", which means:

        - no new callbacks can be queued on it anymore neither from the
          CPU itself nor from truly offloaded CPUs

        - the CPU is still processing already queued callbacks and
          participates in the GP magic

  3) Before CPUHP_AP_SCHED_WAIT_EMPTY add a new CPUHP_AP_RCU_SYNC state,
     which does:

       - a full RCU synchronization to end all outstanding read side
         critical sections

       - drain the now ready callbacks on this CPU

  4) Proceed to CPUHP_TEARDOWN_CPU, where the operation stops

  5) Do the magic cpuset changes for the CPU

  6) Bring CPU back up

At #4 the half unplugged CPU is not in NOHZ full mode and the tick keeps
running so all GP processing work as before except that the CPU itself
is not handling any callbacks because all queued ones are drained and no
new ones can be queued. When it comes back up it turns into a fully
offloaded one.

There are obviously a gazillion of details and cornercases to handle,
but I don't see why this can't be made work in principle.

Thanks,

        tglx


=20=20=20=20=20
