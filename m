From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: get a ref to source csses when migrating
Date: Tue, 25 Aug 2015 12:00:54 +1000
Message-ID: <CAOviyagYytw2t20c4a-GaFJDRArtF67CHFPN127CRpnzr0Y9kA@mail.gmail.com>
References: <CAOviyag1ZOgjtNWmnpfMm=fDgkhDn9UGKoJXy6HLWQMGb-tQAg@mail.gmail.com>
	<1440335432-4202-1-git-send-email-cyphar@cyphar.com>
	<1440335432-4202-2-git-send-email-cyphar@cyphar.com>
	<20150824184507.GB28944@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150824184507.GB28944-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> Have you verified that the scenario you're describing can actually
> happen?  AFAICS, cgroup_migrate_add_src() already does the pinning.

Hmmm. Looking at it, group_migrate_add_src() does grab a ref on the
css_set which contains the css, and the comments mention that grabbing
a ref on the css_set will stop the css from being dropped. I must've
misunderstood one of your previous emails (where you said that such
code was not safe in the ->can_fork(), ->cancel_fork() and ->fork())
path.

You also mentioned that depending on the css_set's ref being bumped to
protect the contained csses is "sort of implementation detail.  It can
be implemented in different ways." Which made me think that depending
on that is not a good idea.

But if it's safe to depend on the cgroup_migrate_add_src() pinning the
ref on the css_set, I'll drop this patch and fix up the other one
accordingly.

-- 
Aleksa Sarai (cyphar)
www.cyphar.com
