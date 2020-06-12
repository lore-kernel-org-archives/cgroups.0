From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Date: Fri, 12 Jun 2020 11:38:33 -0700
Message-ID: <202006121135.F04D66DFA@keescook>
References: <20200610081237.GA23425@ircssh-2.c.rugged-nimbus-611.internal>
 <202006101953.899EFB53@keescook>
 <20200611100114.awdjswsd7fdm2uzr@wittgenstein>
 <20200611110630.GB30103@ircssh-2.c.rugged-nimbus-611.internal>
 <067f494d55c14753a31657f958cb0a6e@AcuMS.aculab.com>
 <202006111634.8237E6A5C6@keescook>
 <94407449bedd4ba58d85446401ff0a42@AcuMS.aculab.com>
 <20200612104629.GA15814@ircssh-2.c.rugged-nimbus-611.internal>
 <202006120806.E770867EF@keescook>
 <20200612182816.okwylihs6u6wkgxd@wittgenstein>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JT8oJD0kpQknzBVSZP3Z/2D3ZlbgWd1By/OrwYLAa6A=;
        b=U10uEEViSocGeq7huvYZniWsLdXbFGNHeYYlLoO3+rCSFg9w1WEquFmb4W0zY7AZRD
         E7CNqC0dJexgTuH0Pvbo+SiLE0vHNH+ueUP892gN+69vPCV8rxhH63Lt+KnEyoie9TcW
         vdeYY9cIoIja/EdttRdHl0Rn+8mzjxjoaLVdA=
Content-Disposition: inline
In-Reply-To: <20200612182816.okwylihs6u6wkgxd@wittgenstein>
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Sargun Dhillon <sargun@sargun.me>, Giuseppe Scrivano <gscrivan@redhat.com>, Robert Sesek <rsesek@google.com>, Chris Palmer <palmer@google.com>, Jann Horn <jannh@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "containers@lists.linux-foundation.org" <containers@lists.linux-foundation.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Matt Denton <mpdenton@google.com>, Tejun Heo <tj@kernel.org>, David Laight <David.Laight@ACULAB.COM>, Al Viro <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>

On Fri, Jun 12, 2020 at 08:28:16PM +0200, Christian Brauner wrote:
> Al didn't want the PAGE_SIZE limit in there because there's nothing
> inherently wrong with copying insane amounts of memory.

Right, ok.

> (Another tangent. I've asked this on Twitter not too long ago: do we
> have stats how long copy_from_user()/copy_struct_from_user() takes with
> growing struct/memory size? I'd be really interested in this. I have a
> feeling that clone3()'s and - having had a chat with David Howells -
> openat2()'s structs will continue to grow for a while... and I'd really
> like to have some numbers on when copy_struct_from_user() becomes
> costly or how costly it becomes.)

How long it takes? It should be basically the same, the costs should be
mostly in switching memory protections, etc. I wouldn't imagine how many
bytes being copied would matter much here, given the sub-page sizes.

> > Ah yeah, I like this because of what you mention below: it's forward
> > compat too. (I'd just use the ioctl masks directly...)
> > 
> > 	switch (cmd & ~(_IOC_SIZEMASK | _IOC_DIRMASK))
> > 
> > > 		return seccomp_notify_addfd(filter, buf, _IOC_SIZE(cmd));
> > 
> > I really like that this ends up having the same construction as a
> > standard EA syscall: the size is part of the syscall arguments.
> 
> This is basically what I had proposed in my previous mail, right?

I guess I missed it! Well, then I think we're all in agreement? :)

-- 
Kees Cook
