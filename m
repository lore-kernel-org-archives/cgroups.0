From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Date: Thu, 4 Jun 2020 03:24:52 +0200
Message-ID: <20200604012452.vh33nufblowuxfed@wittgenstein>
References: <20200603011044.7972-1-sargun@sargun.me>
 <20200603011044.7972-2-sargun@sargun.me>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200603011044.7972-2-sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sargun Dhillon <sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tycho Andersen <tycho-E0fblnxP3wo@public.gmane.org>, Matt Denton <mpdenton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Palmer <palmer-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Robert Sesek <rsesek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Giuseppe Scrivano <gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, John Fastabend <john.r.fastabend-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jun 02, 2020 at 06:10:41PM -0700, Sargun Dhillon wrote:
> Previously there were two chunks of code where the logic to receive file
> descriptors was duplicated in net. The compat version of copying
> file descriptors via SCM_RIGHTS did not have logic to update cgroups.
> Logic to change the cgroup data was added in:
> commit 48a87cc26c13 ("net: netprio: fd passed in SCM_RIGHTS datagram not set correctly")
> commit d84295067fc7 ("net: net_cls: fd passed in SCM_RIGHTS datagram not set correctly")
> 
> This was not copied to the compat path. This commit fixes that, and thus
> should be cherry-picked into stable.
> 
> This introduces a helper (file_receive) which encapsulates the logic for
> handling calling security hooks as well as manipulating cgroup information.
> This helper can then be used other places in the kernel where file
> descriptors are copied between processes
> 
> I tested cgroup classid setting on both the compat (x32) path, and the
> native path to ensure that when moving the file descriptor the classid
> is set.
> 
> Signed-off-by: Sargun Dhillon <sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org>
> Suggested-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> Cc: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> Cc: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
> Cc: David S. Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
> Cc: Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>,
> Cc: John Fastabend <john.r.fastabend-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Tycho Andersen <tycho-E0fblnxP3wo@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  fs/file.c            | 35 +++++++++++++++++++++++++++++++++++
>  include/linux/file.h |  1 +
>  net/compat.c         | 10 +++++-----
>  net/core/scm.c       | 14 ++++----------
>  4 files changed, 45 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/file.c b/fs/file.c
> index abb8b7081d7a..5afd76fca8c2 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -18,6 +18,9 @@
>  #include <linux/bitops.h>
>  #include <linux/spinlock.h>
>  #include <linux/rcupdate.h>
> +#include <net/sock.h>
> +#include <net/netprio_cgroup.h>
> +#include <net/cls_cgroup.h>
>  
>  unsigned int sysctl_nr_open __read_mostly = 1024*1024;
>  unsigned int sysctl_nr_open_min = BITS_PER_LONG;
> @@ -931,6 +934,38 @@ int replace_fd(unsigned fd, struct file *file, unsigned flags)
>  	return err;
>  }
>  
> +/*
> + * File Receive - Receive a file from another process
> + *
> + * This function is designed to receive files from other tasks. It encapsulates
> + * logic around security and cgroups. The file descriptor provided must be a
> + * freshly allocated (unused) file descriptor.
> + *
> + * This helper does not consume a reference to the file, so the caller must put
> + * their reference.
> + *
> + * Returns 0 upon success.
> + */
> +int file_receive(int fd, struct file *file)

This is all just a remote version of fd_install(), yet it deviates from
fd_install()'s semantics and naming. That's not great imho. What about
naming this something like:

fd_install_received()

and move the get_file() out of there so it has the same semantics as
fd_install(). It seems rather dangerous to have a function like
fd_install() that consumes a reference once it returned and another
version of this that is basically the same thing but doesn't consume a
reference because it takes its own. Seems an invitation for confusion.
Does that make sense?

> +{
> +	struct socket *sock;
> +	int err;
> +
> +	err = security_file_receive(file);
> +	if (err)
> +		return err;
> +
> +	fd_install(fd, get_file(file));
> +
> +	sock = sock_from_file(file, &err);
> +	if (sock) {
> +		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
> +		sock_update_classid(&sock->sk->sk_cgrp_data);
> +	}
> +
> +	return 0;
> +}
> +
>  static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
>  {
>  	int err = -EBADF;
> diff --git a/include/linux/file.h b/include/linux/file.h
> index 142d102f285e..7b56dc23e560 100644
> --- a/include/linux/file.h
> +++ b/include/linux/file.h
> @@ -94,4 +94,5 @@ extern void fd_install(unsigned int fd, struct file *file);
>  extern void flush_delayed_fput(void);
>  extern void __fput_sync(struct file *);
>  
> +extern int file_receive(int fd, struct file *file);
>  #endif /* __LINUX_FILE_H */
> diff --git a/net/compat.c b/net/compat.c
> index 4bed96e84d9a..8ac0e7e09208 100644
> --- a/net/compat.c
> +++ b/net/compat.c
> @@ -293,9 +293,6 @@ void scm_detach_fds_compat(struct msghdr *kmsg, struct scm_cookie *scm)
>  
>  	for (i = 0, cmfptr = (int __user *) CMSG_COMPAT_DATA(cm); i < fdmax; i++, cmfptr++) {
>  		int new_fd;
> -		err = security_file_receive(fp[i]);
> -		if (err)
> -			break;
>  		err = get_unused_fd_flags(MSG_CMSG_CLOEXEC & kmsg->msg_flags
>  					  ? O_CLOEXEC : 0);
>  		if (err < 0)
> @@ -306,8 +303,11 @@ void scm_detach_fds_compat(struct msghdr *kmsg, struct scm_cookie *scm)
>  			put_unused_fd(new_fd);
>  			break;
>  		}
> -		/* Bump the usage count and install the file. */
> -		fd_install(new_fd, get_file(fp[i]));
> +		err = file_receive(new_fd, fp[i]);
> +		if (err) {
> +			put_unused_fd(new_fd);
> +			break;
> +		}
>  	}
>  
>  	if (i > 0) {
> diff --git a/net/core/scm.c b/net/core/scm.c
> index dc6fed1f221c..ba93abf2881b 100644
> --- a/net/core/scm.c
> +++ b/net/core/scm.c
> @@ -303,11 +303,7 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
>  	for (i=0, cmfptr=(__force int __user *)CMSG_DATA(cm); i<fdmax;
>  	     i++, cmfptr++)
>  	{
> -		struct socket *sock;
>  		int new_fd;
> -		err = security_file_receive(fp[i]);
> -		if (err)
> -			break;
>  		err = get_unused_fd_flags(MSG_CMSG_CLOEXEC & msg->msg_flags
>  					  ? O_CLOEXEC : 0);
>  		if (err < 0)
> @@ -318,13 +314,11 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
>  			put_unused_fd(new_fd);
>  			break;
>  		}
> -		/* Bump the usage count and install the file. */
> -		sock = sock_from_file(fp[i], &err);
> -		if (sock) {
> -			sock_update_netprioidx(&sock->sk->sk_cgrp_data);
> -			sock_update_classid(&sock->sk->sk_cgrp_data);
> +		err = file_receive(new_fd, fp[i]);
> +		if (err) {
> +			put_unused_fd(new_fd);
> +			break;
>  		}
> -		fd_install(new_fd, get_file(fp[i]));
>  	}
>  
>  	if (i > 0)
> -- 
> 2.25.1
> 
