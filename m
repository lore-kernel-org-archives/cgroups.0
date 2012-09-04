From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2] memcg: first step towards hierarchical controller
Date: Tue, 4 Sep 2012 17:27:20 +0400
Message-ID: <504601B8.2050907@parallels.com>
References: <1346687211-31848-1-git-send-email-glommer@parallels.com> <20120903170806.GA21682@dhcp22.suse.cz> <5045BD25.10301@parallels.com> <20120904130905.GA15683@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120904130905.GA15683-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 09/04/2012 05:09 PM, Michal Hocko wrote:
> Not really. Do it slowly means that somebody actually _notices_ that
> something is about to change and they have a lot of time for that. This
> will be really hard with the config option saying N by default.  People
> will ignore that until it's too late.
> We are interested in those users who would keep the config default N and
> they are (ab)using use_hierarchy=0 in a way which is hard/impossible to
> fix. This is where distributions might help and they should IMHO but why
> to put an additional code into upstream? Isn't it sufficient that those
> who would like to help (and take the risk) would just take the patch?

At least Fedora, seem to frown upon heavily at non-upstream patches.
To follow up with what you say, what would you say if we would WARN_ON()
unconditionally even if this switch is turned off?

a warn on dmesg is almost impossible not to be seen by anyone who cares.
That warning would tell people to flip the Kconfig option for the
warning will disappear. But ultimately, we are still keeping the
behavior intact.
