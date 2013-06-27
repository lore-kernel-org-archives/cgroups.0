From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroup: status-quo and userland efforts
Date: Thu, 27 Jun 2013 10:48:50 -0700
Message-ID: <20130627174850.GC5599@mtj.dyndns.org>
References: <20130406012159.GA17159@mtj.dyndns.org>
	<CAAAKZwvh_R2Xz--bmSLiN33fsqKanOJMq_6+6hoFWFRx38O4gA@mail.gmail.com>
	<20130422214159.GG12543@htj.dyndns.org>
	<CAAAKZwuXJwwyj7KSqb7rZ+nrTwBWEaUCWfa7kWecTBnHL8koGw@mail.gmail.com>
	<CAAAKZwvP_7wBBYMmtFuiE2hZt=ByaLrnTyiR83CZr3OMip63Gg@mail.gmail.com>
	<20130625000118.GT1918@mtj.dyndns.org>
	<CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com>
	<20130626212047.GB4536@htj.dyndns.org>
	<1372311907.5871.78.camel@marge.simpson.net>
	<20130627132206.GE4003@sergelap>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=NjKuaD/0Oclgc/7BxLK06DGZ4aMrjjaVsMtbh2fjjic=;
	b=oYNitaPJHCSoXnYcW6Wyghm0avzep01rwxZ/Pzywr32nUytRuXXKt44oorJd2pWpPB
	7ANWI91t5wDbIAJjRPl/IqRMT6XkEZ3hZ+AzqsYKgyE6MYP9kMoX3N9QPCCRHfQdpRue
	7nXHMpObrWYkOkXvrIYRdevaquIEpwt3GNvsA3+UA6Msxv2Cybanv3c/KuIo+vhG4Reb
	Aq/GIB8Khpq+28RWMYNxNyorEOkcY2Tt/At1S7uKi6juCsAxnhKAE2DVPjurcFLTAGhm
	FdFLWDJgQboNMwPAnuqg+JlliRNrcx8x0JW2sgEOtTkPwy7jCf0uDRppNqBxpZsEQjh+
	4qNg==
Content-Disposition: inline
In-Reply-To: <20130627132206.GE4003@sergelap>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>, Mike Galbraith <bitbucket-BGeptl67XyCzQB+pC5nmwQ@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lpoetter <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, jpoimboe <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dhaval.giani" <dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, workman-devel <workman-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello, Serge.

On Thu, Jun 27, 2013 at 08:22:06AM -0500, Serge Hallyn wrote:
> At some point (probably soon) we might want to talk about a standard API
> for these things.  However I think it will have to come in the form of
> a standard library, which knows to either send requests over dbus to
> systemd, or over /dev/cgroup sock to the manager.

Yeah, eventually, I think we'll have a standardized way to configure
resource distribution in the system.  Maybe we'll agree on a
standardized dbus protocol or there will be library, I don't know;
however, whatever form it may be in, it abstraction level should be
way higher than that of direct cgroupfs access.  It's way too low
level and very easy to end up in a complete nonsense configuration.

e.g. enabling "cpu" on a cgroup whlie leaving other cgroups alone
wouldn't enable fair scheduling on that cgroup but drastically reduce
the amount of cpu share it gets as it now gets treated as single
entity competing with all tasks at the parent level.

At the moment, I'm not sure what the eventual abstraction would look
like.  systemd is extending its basic constructs by adding slices and
scopes and it does make sense to integrate the general organization of
the system (services, user sessions, VMs and so on) with resource
management.  Given some time, I'm hoping we'll be able to come up with
and agree on some common constructs so that each workload can indicate
its resource requirements in a unified way.

That said, I really think we should experiment for a while before
trying to settle down on things.  We've now just started exploring how
system-wide resource managment can be made widely available to systems
without requiring extremely specialized hand-crafted configurations
and I'm pretty sure we're getting and gonna get quite a few details
wrong, so I don't think it'd be a good idea to try to agree on things
right now.  As far as such integration goes, I think it's time to play
with things and observe the results.

Thanks.

-- 
tejun
