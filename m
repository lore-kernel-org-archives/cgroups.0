From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH v4 0/2] cgroup: allow management of subtrees by new
 cgroup namespaces
Date: Fri, 20 May 2016 11:30:58 -0400
Message-ID: <1463758258.8091.3.camel@HansenPartnership.com>
References: <1463196000-13900-1-git-send-email-asarai@suse.de>
	 <573F23D0.2030500@suse.de> <20160520152244.GB5632@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
	s=20151216; t=1463758261;
	bh=JS8y7Lm2LpNZc+rHNwQmM/GNYTQJluP8tpHvxp3vER0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=x75U6Nn/hLJ2qzcFmRw3gokKx38hhE9A2vGBzze3sPCLPrSKpCeh9RWN3OeX5QUKS
	 dqGf5dDlcOhLNTi6rlwHxaZbkvITKxw8OlVjdIYmHBZ3m1a/J4lKmnXJSwzA7IRp8O
	 MoQqqXSnamlutkCI8UgUDZRVZTmXegcKK0tZUlsE=
In-Reply-To: <20160520152244.GB5632-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org

On Fri, 2016-05-20 at 08:22 -0700, Tejun Heo wrote:
> On Sat, May 21, 2016 at 12:48:48AM +1000, Aleksa Sarai wrote:
> > Are there any comments on this version of the patchset? I thought 
> > we had reached an agreement that the underlying feature (allowing a
> > process to manage its own cgroups) was useful. Is there a better 
> > way of solving this problem, that I don't know of?
> 
> I still don't see why this is necessary.  Delegation is done through
> chmodding.  There's no reason to deviate for namespaces.

Given it's merge window time, I haven't yet had time to look at the
patch, but I can tell you why it (or something like it) is necessary:
unprivileged containers need to be able to set up cgroups as well as
namespaces, so we do need a way for the user ns owner to modify cgroups
in their default configuration otherwise cgroups just won't fit into
the unprivileged model.  Whether this should be through the cgroup ns
is up for debate, as is how we should actually allow this to happen and
what we should present to the user ns owner, but we do need a way to do
this.

Delegation can't be through chmodding in this case because the user ns
owner can't chmod something owned by init_user_ns root.

James

