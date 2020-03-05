From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Memory reclaim protection and cgroup nesting (desktop use)
Date: Thu, 5 Mar 2020 10:12:28 -0500
Message-ID: <CAOS58YM-HtmxwD7Q7g6ZzGsOJ_vWjHwb=7qpUwuZQEdeRrBifw@mail.gmail.com>
References: <d4826b9e568f1ab7df19f94c409df11956a8e262.camel@sipsolutions.net>
 <20200304163044.GF189690@mtj.thefacebook.com> <4d3e00457bba40b25f3ac4fd376ba7306ffc4e68.camel@sipsolutions.net>
 <20200305145554.GA5897@mtj.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200305145554.GA5897-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Benjamin Berg <benjamin-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Thu, Mar 05, 2020 at 09:55:54AM -0500, Tejun Heo wrote:
> Changing memory limits dynamically can lead to pretty abrupt system
> behaviors depending on how big the swing is but memory.low and io/cpu
> weights should behave fine.

A couple more things which might be helpful.

* memory.min/low are pretty forgiving. Semantically what it tells the
  kernel is "reclaim this guy as if the protected amount isn't being
  consumed" - if a cgroup consumes 8G and has 4G protection, it'd get
  the same reclaim pressure as a sibling whose consuming 4G without
  protection. While the range of "good" configuration is pretty wide,
  you can definitely push it too far to the point the rest of the
  system has to compete too hard for memory. In practice, setting
  memory protection to something like 50-75% of expected allocation
  seems to work well - it provides ample protection while allowing the
  system to be flexible when it needs to be. One important thing that
  we learned is that as resource configuration gets more rigid, it can
  also become more brittle.

* As for io.weight (and cpu.weight too), while prioritization is
  meaningful, what matters the most is avoiding situations where one
  consumer overwhelms the device. Simply configuring io.cost correctly
  and enabling it with default weights may achieve majority of the
  benefits even without specific weight configurations. Please note
  that IO control has quite a bit of requirements to function
  correctly - it currently works well only on btrfs on physical (not
  md or dm) devices with all other IO controllers and wbt disabled.
  Hopefully, we'll be able to relax the requirements in the future but
  we aren't there yet.

With both memory and IO set up and oomd watching out for swap
depletion, our configurations show almost complete resource isolation
where no matter what we do in unprotected portion of the system it
doesn't affect the performance of the protected portion much even when
the protected portion is running resource hungry latency sensitive
workloads.

Thanks.

