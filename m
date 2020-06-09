From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Date: Tue, 9 Jun 2020 13:55:42 -0700
Message-ID: <202006091346.66B79E07@keescook>
References: <20200603011044.7972-1-sargun@sargun.me>
 <20200603011044.7972-2-sargun@sargun.me>
 <20200604012452.vh33nufblowuxfed@wittgenstein>
 <202006031845.F587F85A@keescook>
 <20200604125226.eztfrpvvuji7cbb2@wittgenstein>
 <20200605075435.GA3345@ircssh-2.c.rugged-nimbus-611.internal>
 <202006091235.930519F5B@keescook>
 <20200609200346.3fthqgfyw3bxat6l@wittgenstein>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lNYRWXDFOIEUX1YNrkuu2evKxT3eLlEeiZYQ/REgVvc=;
        b=NUHZ0GdZs74B9irVa6slDIfz4CCekIjp6DZqLAqnreAj0h9UZUn7D5AOr3YNHyVe3s
         aQUohghlZYvlK0GoSoIYSFZFxGBx5YgCWgvrlYA6dUVYGEgAGSwOJsXrQDZxG18s2gI2
         TTnlYBEqLQoMCTwNoW1jVeo7P1Oyp3C6b5pVs=
Content-Disposition: inline
In-Reply-To: <20200609200346.3fthqgfyw3bxat6l@wittgenstein>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Sargun Dhillon <sargun@sargun.me>, Giuseppe Scrivano <gscrivan@redhat.com>, Robert Sesek <rsesek@google.com>, Chris Palmer <palmer@google.com>, Jann Horn <jannh@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, containers@lists.linux-foundation.org, Daniel Wagner <daniel.wagner@bmw-carit.de>, linux-kernel@vger.kernel.org, Matt Denton <mpdenton@google.com>, John Fastabend <john.r.fastabend@intel.com>, linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, stable@vger.kernel.org, "David S . Miller" <davem@davemloft.net>

On Tue, Jun 09, 2020 at 10:03:46PM +0200, Christian Brauner wrote:
> I'm looking at __scm_install_fd() and I wonder what specifically you
> mean by that? The put_user() seems to be placed such that the install
> occurrs only if it succeeded. Sure, it only handles a single fd but
> whatever. Userspace knows that already. Just look at systemd when a msg
> fails:
> 
> void cmsg_close_all(struct msghdr *mh) {
>         struct cmsghdr *cmsg;
> 
>         assert(mh);
> 
>         CMSG_FOREACH(cmsg, mh)
>                 if (cmsg->cmsg_level == SOL_SOCKET && cmsg->cmsg_type == SCM_RIGHTS)
>                         close_many((int*) CMSG_DATA(cmsg), (cmsg->cmsg_len - CMSG_LEN(0)) / sizeof(int));
> }
> 
> The only reasonable scenario for this whole mess I can think of is sm like (pseudo code):
> 
> fd_install_received(int fd, struct file *file)
> {
>  	sock = sock_from_file(fd, &err);
>  	if (sock) {
>  		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
>  		sock_update_classid(&sock->sk->sk_cgrp_data);
>  	}
> 
> 	fd_install();
> }
> 
> error = 0;
> fdarray = malloc(fdmax);
> for (i = 0; i < fdmax; i++) {
> 	fdarray[i] = get_unused_fd_flags(o_flags);
> 	if (fdarray[i] < 0) {
> 		error = -EBADF;
> 		break;
> 	}
> 
> 	error = security_file_receive(file);
> 	if (error)
> 		break;
> 
> 	error = put_user(fd_array[i], ufd);
> 	if (error)
> 		break;
> }
> 
> for (i = 0; i < fdmax; i++) {
> 	if (error) {
> 		/* ignore errors */
> 		put_user(-EBADF, ufd); /* If this put_user() fails and the first one succeeded userspace might now close an fd it didn't intend to. */
> 		put_unused_fd(fdarray[i]);
> 	} else {
> 		fd_install_received(fdarray[i], file);
> 	}
> }

I see 4 cases of the same code pattern (get_unused_fd_flags(),
sock_update_*(), fd_install()), one of them has this difficult put_user()
in the middle, and one of them has a potential replace_fd() instead of
the get_used/fd_install. So, to me, it makes sense to have a helper that
encapsulates the common work that each of those call sites has to do,
which I keep cringing at all these suggestions that leave portions of it
outside the helper.

If it's too ugly to keep the put_user() in the helper, then we can try
what was suggested earlier, and just totally rework the failure path for
SCM_RIGHTS.

LOL. And while we were debating this, hch just went and cleaned stuff
up:

2618d530dd8b ("net/scm: cleanup scm_detach_fds")

So, um, yeah, now my proposal is actually even closer to what we already
have there. We just add the replace_fd() logic to __scm_install_fd() and
we're done with it.

-- 
Kees Cook
