From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Date: Wed, 10 Jun 2020 08:48:45 +0000
Message-ID: <40d76a9a4525414a8c9809cd29a7ba8e@AcuMS.aculab.com>
References: <20200603011044.7972-2-sargun@sargun.me>
 <20200604012452.vh33nufblowuxfed@wittgenstein>
 <202006031845.F587F85A@keescook>
 <20200604125226.eztfrpvvuji7cbb2@wittgenstein>
 <20200605075435.GA3345@ircssh-2.c.rugged-nimbus-611.internal>
 <202006091235.930519F5B@keescook>
 <20200609200346.3fthqgfyw3bxat6l@wittgenstein>
 <202006091346.66B79E07@keescook>
 <037A305F-B3F8-4CFA-B9F8-CD4C9EF9090B@ubuntu.com>
 <202006092227.D2D0E1F8F@keescook>
 <20200610081237.GA23425@ircssh-2.c.rugged-nimbus-611.internal>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20200610081237.GA23425@ircssh-2.c.rugged-nimbus-611.internal>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 'Sargun Dhillon' <sargun@sargun.me>, Kees Cook <keescook@chromium.org>
Cc: Christian Brauner <christian.brauner@ubuntu.com>, "containers@lists.linux-foundation.org" <containers@lists.linux-foundation.org>, Giuseppe Scrivano <gscrivan@redhat.com>, Robert Sesek <rsesek@google.com>, Chris Palmer <palmer@google.com>, Jann Horn <jannh@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Wagner <daniel.wagner@bmw-carit.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Matt Denton <mpdenton@google.com>, John Fastabend <john.r.fastabend@intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "David S . Miller" <davem@davemloft.ne>

From: Sargun Dhillon
> Sent: 10 June 2020 09:13
> 
> On Tue, Jun 09, 2020 at 10:27:54PM -0700, Kees Cook wrote:
> > On Tue, Jun 09, 2020 at 11:27:30PM +0200, Christian Brauner wrote:
> > > On June 9, 2020 10:55:42 PM GMT+02:00, Kees Cook <keescook@chromium.org> wrote:
> > > >LOL. And while we were debating this, hch just went and cleaned stuff up:
> > > >
> > > >2618d530dd8b ("net/scm: cleanup scm_detach_fds")
> > > >
> > > >So, um, yeah, now my proposal is actually even closer to what we already
> > > >have there. We just add the replace_fd() logic to __scm_install_fd() and
> > > >we're done with it.
> > >
> > > Cool, you have a link? :)
> >
> > How about this:
> >
> Thank you.
> >
> https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/commit/?h=devel/seccomp/addfd/v3.1&id=b
> b94586b9e7cc88e915536c2e9fb991a97b62416
> >
> > --
> > Kees Cook
> 
> +		if (ufd) {
> +			error = put_user(new_fd, ufd);
> +			if (error) {
> +				put_unused_fd(new_fd);
> +				return error;
> +			}
> + 		}
> I'm fairly sure this introduces a bug[1] if the user does:
> 
> struct msghdr msg = {};
> struct cmsghdr *cmsg;
> struct iovec io = {
> 	.iov_base = &c,
> 	.iov_len = 1,
> };
> 
> msg.msg_iov = &io;
> msg.msg_iovlen = 1;
> msg.msg_control = NULL;
> msg.msg_controllen = sizeof(buf);
> 
> recvmsg(sock, &msg, 0);
> 
> They will have the FD installed, no error message, but FD number wont be written
> to memory AFAICT. If two FDs are passed, you will get an efault. They will both
> be installed, but memory wont be written to. Maybe instead of 0, make it a
> poison pointer, or -1 instead?

IMHO if the buffer isn't big enough the nothing should happen.
(or maybe a few of the fds be returned and the others left for later.)

OTOH if the user passed an invalid address then installing the fd
and returning EFAULT (and hence SIGSEGV) seems reasonable.
Properly written apps just don't do that.

In essence the 'copy_to_user' is done by the wrapper code.
The code filling in the CMSG buffer can be considered to be
writing a kernel buffer.

IIRC other kernels (eg NetBSD) do the copies for ioctl() requests
in the ioctl syscall wrapper.
The IOW/IOR/IOWR flags have to be right.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

