From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH v4 0/2] cgroup: allow management of subtrees by new
 cgroup namespaces
Date: Fri, 20 May 2016 12:25:09 -0400
Message-ID: <1463761509.8091.19.camel@HansenPartnership.com>
References: <1463196000-13900-1-git-send-email-asarai@suse.de>
	 <573F23D0.2030500@suse.de> <20160520152244.GB5632@htj.duckdns.org>
	 <1463758258.8091.3.camel@HansenPartnership.com>
	 <20160520160352.GC5632@htj.duckdns.org>
	 <1463760550.8091.13.camel@HansenPartnership.com>
	 <20160520161759.GD5632@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
	s=20151216; t=1463761511;
	bh=9KMfdqKwQr8DeJ4Yzw9qDFf0qVaU+8CpFsLCqSZ3wqQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=bmDdbh8/gwhiEswHSuN7DN5niPYpOcoo0fT8jKSnfaeKLkVKejgw84gwLZIFN/wjz
	 gHOM2FOmxrMyC2Woxw9ozENeHYdxPMOCTrJTLGuAActiuBhhW8LfnADZMFAS8fLQ55
	 2tigH5I+kQfzsnxoeGf75O8rZfApSCrV7BtEVLqA=
In-Reply-To: <20160520161759.GD5632-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org

On Fri, 2016-05-20 at 09:17 -0700, Tejun Heo wrote:
> Hello, James.
> 
> On Fri, May 20, 2016 at 12:09:10PM -0400, James Bottomley wrote:
> > I think it's just different definitions.  If you take on our 
> > definition of being able to set up a container without any admin 
> > intervention, do you see our problem: we can't get the initial 
> > delegation of the hierarchy.
> 
> Yeah, I can see the difference but we can't solve that by special
> casing NS case.

Great, we agree on the problem definition ... as I said, I'm not saying
this patch is the solution, but it gives us a starting point for
exploring whether there is a solution.

>   This is stemming from the fact that an unpriv application can't 
> create its sub-cgroups without explicit delegation from the root and
> that has always been an explicit design choice.
> It's tied to who's responsible for cleanup afterwards and what 
> happens when the process gets migrated to a different cgroup.  The 
> latter is an important issue on v1 hierarchies because migrating 
> tasks sometimes is used as a way to control resource distribution.

OK, so is the only problem cleanup?  If so, what if I proposed that a
cgroup directory could only be created by the owner of the userns
(which would be any old unprivileged user) iff they create a cgroup ns
and the cgroup ns would be responsible for removing it again, so the
cgroup subdirectory would be tied to the cgroup namespace as its holder
and we'd use release of the cgroup to remove all the directories?

James
