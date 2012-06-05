From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [Devel] Re: [PATCH] allow a task to join a pid namespace
Date: Tue, 05 Jun 2012 10:39:09 -0700
Message-ID: <87r4tt64le.fsf@xmission.com>
References: <1338816828-25312-1-git-send-email-glommer@parallels.com>
	<4FCDD315.502@free.fr> <4FCDD346.9090008@parallels.com>
	<4FCDD8A0.1070608@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FCDD8A0.1070608-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> (Glauber Costa's message of
	"Tue, 5 Jun 2012 14:00:00 +0400")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Daniel Lezcano <daniel.lezcano-GANU6spQydw@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, kir-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, Michael-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org


> Eric, what are your plans for merging the content of that tree ?

Hopefully this cycle.

The issue with the pid namespace is primarily that we need to fix
all of the life cycle issues with the pid namespace and make certain
that setns adding an additional pid in a pid namespace does not break
those pid namespace life cycle fixes.

So I have been working on the hard tricky fixes off and on with Oleg.

Eric
