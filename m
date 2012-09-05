From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [RFC 0/5] forced comounts for cgroups.
Date: Wed, 5 Sep 2012 12:03:25 +0400
Message-ID: <5047074D.1030104@parallels.com>
References: <1346768300-10282-1-git-send-email-glommer@parallels.com> <20120904214602.GA9092@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120904214602.GA9092-RcKxWJ4Cfj1J2suj2OqeGauc2jM2gXBXkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org, kay.sievers-tD+1rO4QERM@public.gmane.org

On 09/05/2012 01:46 AM, Tejun Heo wrote:
> Hello, Glauber.
> 
> On Tue, Sep 04, 2012 at 06:18:15PM +0400, Glauber Costa wrote:
>> As we have been extensively discussing, the cost and pain points for cgroups
>> come from many places. But at least one of those is the arbitrary nature of
>> hierarchies. Many people, including at least Tejun and me would like this to go
>> away altogether. Problem so far, is breaking compatiblity with existing setups
>>
>> I am proposing here a default-n Kconfig option that will guarantee that the cpu
>> cgroups (for now) will be comounted. I started with them because the
>> cpu/cpuacct division is clearly the worst offender. Also, the default-n is here
>> so distributions will have time to adapt: Forcing this flag to be on without
>> userspace changes will just lead to cgroups failing to mount, which we don't
>> want.
>>
>> Although I've tested it and it works, I haven't compile-tested all possible
>> config combinations. So this is mostly for your eyes. If this gets traction,
>> I'll submit it properly, along with any changes that you might require.
> 
> As I said during the discussion, I'm skeptical about how useful this
> is.  This can't nudge existing users in any meaningfully gradual way.
> Kconfig doesn't make it any better.  It's still an abrupt behavior
> change when seen from userland.
>

The goal here is to have distributions to do it, because they tend to
have a well defined lifecycle management, much more than upstream. Whoever
sets this option, can coordinate with upstream.

Aside from enforcing it, we can pretty much warn() as well, to direct
people towards flipping the switch.

> Also, I really don't see much point in enforcing this almost arbitrary
> grouping of controllers.  It doesn't simplify anything and using
> cpuacct in more granular way than cpu actually is one of the better
> justified use of multiple hierarchies.  Also, what about memcg and
> blkcg?  Do they *really* coincide?  Note that both blkcg and memcg
> involve non-trivial overhead and blkcg is essentially broken
> hierarchy-wise.
> 

Where did I mention memcg or blkcg in this patch ?
