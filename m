From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroup: status-quo and userland efforts
Date: Thu, 27 Jun 2013 22:01:38 -0700
Message-ID: <20130628050138.GD2500@htj.dyndns.org>
References: <CAAAKZwuXJwwyj7KSqb7rZ+nrTwBWEaUCWfa7kWecTBnHL8koGw@mail.gmail.com>
 <CAAAKZwvP_7wBBYMmtFuiE2hZt=ByaLrnTyiR83CZr3OMip63Gg@mail.gmail.com>
 <20130625000118.GT1918@mtj.dyndns.org>
 <CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com>
 <20130626212047.GB4536@htj.dyndns.org>
 <1372311907.5871.78.camel@marge.simpson.net>
 <20130627180143.GD5599@mtj.dyndns.org>
 <1372391198.5989.110.camel@marge.simpson.net>
 <20130628040930.GC2500@htj.dyndns.org>
 <1372394950.5989.128.camel@marge.simpson.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=uJpajZvb/bSIKxdjS6aRsnrLbAngyobHNH2e3Lpyq/E=;
        b=X9sIvDtU9cPP2UZDqKfA+krQd2Ryx7x4jRqWGtnJFwDDffqK9YwTeK8USaXL7RfdEj
         VT96kGw4A5usU21jiejfGP30uPyChVVBuqGZAZvxN7ha37KQR2agbNIr0h3zx0UeHxos
         MJPKwlxVZbaBAPPMP9EuYL51xfu8YbVQhV6cOu4GH7mMT8fhdy0+YWb8+GnaTTpn4xi8
         CJInLqYI3d6vjhUSd97g7AtB+tpqPaMprsNba63zr/WXc7F2k/ozBXTboNWCKiwCM8kS
         UN93rHXBNexM2snzIY304ZAY381WXvuSGpmf/NbqwXXAeSGcK1pY6uyyl4KqU8SCPEMo
         yhkg==
Content-Disposition: inline
In-Reply-To: <1372394950.5989.128.camel-YqMYhexLQo31wTEvPJ5Q0F6hYfS7NtTn@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Galbraith <bitbucket-BGeptl67XyCzQB+pC5nmwQ@public.gmane.org>
Cc: Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bsingharora <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "dhaval.giani" <dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, jpoimboe <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lpoetter <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, workman-devel <workman-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Mike.

On Fri, Jun 28, 2013 at 06:49:10AM +0200, Mike Galbraith wrote:
> I always thought that was a very cool feature, mkdir+echo, poof done.
> Now maybe that interface is suboptimal for serious usage, but it makes
> the things usable via dirt simple scripts, very flexible, nice.

Oh, that in itself is not bad.  I mean, if you're root, it's pretty
easy to play with and that part is fine.  But combined with the
hierarchical nature of cgroup and file permissions, it encourages
people to "deligate" subdirectories to less previledged domains, which
in turn leads to normal binaries to manipulate them directly, which is
where the horror begins.  We end up exposing control knobs which are
tightly coupled to kernel implementation details right into lay
binaries and scripts directly used by end users.

I think this is the first time this happened, which is probably why
nobody really noticed the mess earlier.

Anyways, if you're root, you can keep doing whatever you want.  You
could be stepping on the centralized agent's toes a bit and vice-versa
but I don't think that's gonna be disastrous.  What I'm trying to
stamp out is direct usages from !root domains and !system-management
binaries / scripts.  They absolutely have to go.  There's no question
about it and I'll take totalitarian userland agent anyday over the
current mess.

Eventually, I think we'll be able to reach an equilibrium where most
things are reasonable and we'll be exploring the acceptable limits of
flexibility again, but right now, please bear with the brutality.
We're way over the line and I can't see a way back which isn't gonna
sting a bit.  I'm and will keep trying to make it as painless as
possible.

Thanks!

-- 
tejun
