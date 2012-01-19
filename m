From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH] introduce res_counter_charge_nofail() for socket
 allocations
Date: Thu, 19 Jan 2012 15:57:09 -0500
Message-ID: <1327006629.3025.17.camel@dabdike>
References: <1326899758-9013-1-git-send-email-glommer@parallels.com>
	 <20120119143607.GF13932@tiehlicka.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120119143607.GF13932-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

On Thu, 2012-01-19 at 15:36 +0100, Michal Hocko wrote:
> I guess you should have CCed cgroups maintainers as well.
> Let's do that now

So this is just my preference in SCSI and cgroup maintainers get to
specify their own preferences, but as a maintainer, I subscribe to the
mailing lists, so there's no need to cc me directly.  In fact, I prefer
that you don't cc me directly since it would just clutter up my inbox
and wouldn't be really helpful because all my scripts operate on my
linux-scsi folder (however, I also have a procmail rule that trashes an
email directly to me that also went to linux-scsi, so cc'ing me directly
is usually harmless).

James

