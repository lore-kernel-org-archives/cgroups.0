From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 9/9] devcg: propagate local changes down the hierarchy
Date: Mon, 11 Feb 2013 13:38:48 -0500
Message-ID: <20130211183847.GG30962@redhat.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171102.390708521@napanee.usersys.redhat.com>
 <20130131043839.GA14726@mail.hallyn.com>
 <20130205183646.GT17632@redhat.com>
 <20130209040402.GA31942@mail.hallyn.com>
 <20130211143241.GF30962@redhat.com>
 <20130211174259.GA18179@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130211174259.GA18179-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Mon, Feb 11, 2013 at 05:42:59PM +0000, Serge E. Hallyn wrote:
> Note I said only forbid behavior changes - not exception changes - to
> cgroups with children.

that won't do much. behavior change is the simplest: if you change a
behavior, you wipe the local exceptions unless the special (deny, deny)
-> (allow, deny) case.
exception propagation is harder
getting rid of local settings would buy more simplicity

-- 
Aristeu
