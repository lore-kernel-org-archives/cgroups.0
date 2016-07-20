From: Sheng Yang <sheng@yasker.org>
Subject: Re: [PATCH v4 18/21] fuse: Add support for pid namespaces
Date: Tue, 19 Jul 2016 19:44:11 -0700
Message-ID: <CA+2rt426_pshAauQizcxkfAq16vmEpB4sJ4genW_ucosH3j=zQ@mail.gmail.com>
References: <1461699396-33000-1-git-send-email-seth.forshee@canonical.com> <1461699396-33000-19-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=yasker-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=FUJhCJ857GunsaBvfBeCsIcGFyBf5z8q0k/BU/chNo4=;
        b=zBTXFcR68bouv+X2CSKSqOCZK8nlj0asmA+kHkqnUnobxDNfjQ7I7Qfw5A181x5pPh
         k7/N3nbtQ4a1kfTrLr0I9UgH6iy6JJ0Y6g9y5Nx/98Gv7KgXrOhDf3NBQtb3Xy6P73Ow
         3XARoHN5cev7TS4BBrOh/n1ZnEJjhmqShzIjPh3LuwouRgO4C8mlerBEna8F/da88gbF
         Nn7IXv2nmk0eJum3oI/dD2NhguaLz3aAh7uQ8RRqwG4R45Y+moHQKrD0iqfO1a60SQp0
         lP6cenfhUT40jsChj7byxHE9f9II7S1f5umKYePXyVZS/P3QCtV7dSQcB5sVCFlwS0bF
         P9sQ==
In-Reply-To: <1461699396-33000-19-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, kernel list <linux-kernel@vger.kernel.org>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, cgroups@vger.kernel.org

On Tue, Apr 26, 2016 at 12:36 PM, Seth Forshee
<seth.forshee@canonical.com> wrote:
> When the userspace process servicing fuse requests is running in
> a pid namespace then pids passed via the fuse fd are not being
> translated into that process' namespace. Translation is necessary
> for the pid to be useful to that process.
>
> Since no use case currently exists for changing namespaces all
> translations can be done relative to the pid namespace in use
> when fuse_conn_init() is called. For fuse this translates to
> mount time, and for cuse this is when /dev/cuse is opened. IO for
> this connection from another namespace will return errors.
>
> Requests from processes whose pid cannot be translated into the
> target namespace are not permitted, except for requests
> allocated via fuse_get_req_nofail_nopages. For no-fail requests
> in.h.pid will be 0 if the pid translation fails.

Hi Seth,

This patch caused a regression in our major container use case with
FUSE in Ubuntu 16.04, as patch was checked in as Ubuntu Sauce in
Ubuntu 4.4.0-6.21 kernel.

The use case is:
1. Create a Docker container.
2. Inside the container, start the FUSE backend, and mounted fs.
3. Following step 2 in the container, create a loopback device to map
a file in the mounted fuse to create a block device, which will be
available to the whole system.

It works well before this commit.

The use case is broken because no matter which namespace losetup runs,
the real request from loopback device seems always come from init ns,
thus it will be in different ns running fuse backend. So the request
will got denied, because the ns running fuse won't able to see the
things from higher level(level 0 in fact) pid namespace.

I think since init pid ns has ability to access any process in the
system, it should able to access the fuse mounted by any pid namespace
process as well.

What you think?

--Sheng

>
> File locking changes based on previous work done by Eric
> Biederman.
>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> Acked-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/fuse/dev.c    | 19 +++++++++++++++----
>  fs/fuse/file.c   | 22 +++++++++++++++++-----
>  fs/fuse/fuse_i.h |  4 ++++
>  fs/fuse/inode.c  |  3 +++
>  4 files changed, 39 insertions(+), 9 deletions(-)
>
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index cbece1221417..4e91b2ac25a7 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -19,6 +19,7 @@
>  #include <linux/pipe_fs_i.h>
>  #include <linux/swap.h>
>  #include <linux/splice.h>
> +#include <linux/sched.h>
>
>  MODULE_ALIAS_MISCDEV(FUSE_MINOR);
>  MODULE_ALIAS("devname:fuse");
> @@ -124,11 +125,11 @@ static void __fuse_put_request(struct fuse_req *req)
>         atomic_dec(&req->count);
>  }
>
> -static void fuse_req_init_context(struct fuse_req *req)
> +static void fuse_req_init_context(struct fuse_conn *fc, struct fuse_req *req)
>  {
>         req->in.h.uid = from_kuid_munged(&init_user_ns, current_fsuid());
>         req->in.h.gid = from_kgid_munged(&init_user_ns, current_fsgid());
> -       req->in.h.pid = current->pid;
> +       req->in.h.pid = pid_nr_ns(task_pid(current), fc->pid_ns);
>  }
>
>  void fuse_set_initialized(struct fuse_conn *fc)
> @@ -181,10 +182,14 @@ static struct fuse_req *__fuse_get_req(struct fuse_conn *fc, unsigned npages,
>                 goto out;
>         }
>
> -       fuse_req_init_context(req);
> +       fuse_req_init_context(fc, req);
>         __set_bit(FR_WAITING, &req->flags);
>         if (for_background)
>                 __set_bit(FR_BACKGROUND, &req->flags);
> +       if (req->in.h.pid == 0) {
> +               fuse_put_request(fc, req);
> +               return ERR_PTR(-EOVERFLOW);
> +       }
>
>         return req;
>
> @@ -274,7 +279,7 @@ struct fuse_req *fuse_get_req_nofail_nopages(struct fuse_conn *fc,
>         if (!req)
>                 req = get_reserved_req(fc, file);
>
> -       fuse_req_init_context(req);
> +       fuse_req_init_context(fc, req);
>         __set_bit(FR_WAITING, &req->flags);
>         __clear_bit(FR_BACKGROUND, &req->flags);
>         return req;
> @@ -1243,6 +1248,9 @@ static ssize_t fuse_dev_do_read(struct fuse_dev *fud, struct file *file,
>         struct fuse_in *in;
>         unsigned reqsize;
>
> +       if (task_active_pid_ns(current) != fc->pid_ns)
> +               return -EIO;
> +
>   restart:
>         spin_lock(&fiq->waitq.lock);
>         err = -EAGAIN;
> @@ -1872,6 +1880,9 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
>         struct fuse_req *req;
>         struct fuse_out_header oh;
>
> +       if (task_active_pid_ns(current) != fc->pid_ns)
> +               return -EIO;
> +
>         if (nbytes < sizeof(struct fuse_out_header))
>                 return -EINVAL;
>
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 719924d6c706..b5c616c5ec98 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -2067,7 +2067,8 @@ static int fuse_direct_mmap(struct file *file, struct vm_area_struct *vma)
>         return generic_file_mmap(file, vma);
>  }
>
> -static int convert_fuse_file_lock(const struct fuse_file_lock *ffl,
> +static int convert_fuse_file_lock(struct fuse_conn *fc,
> +                                 const struct fuse_file_lock *ffl,
>                                   struct file_lock *fl)
>  {
>         switch (ffl->type) {
> @@ -2082,7 +2083,14 @@ static int convert_fuse_file_lock(const struct fuse_file_lock *ffl,
>
>                 fl->fl_start = ffl->start;
>                 fl->fl_end = ffl->end;
> -               fl->fl_pid = ffl->pid;
> +
> +               /*
> +                * Convert pid into the caller's pid namespace. If the pid
> +                * does not map into the namespace fl_pid will get set to 0.
> +                */
> +               rcu_read_lock();
> +               fl->fl_pid = pid_vnr(find_pid_ns(ffl->pid, fc->pid_ns));
> +               rcu_read_unlock();
>                 break;
>
>         default:
> @@ -2131,7 +2139,7 @@ static int fuse_getlk(struct file *file, struct file_lock *fl)
>         args.out.args[0].value = &outarg;
>         err = fuse_simple_request(fc, &args);
>         if (!err)
> -               err = convert_fuse_file_lock(&outarg.lk, fl);
> +               err = convert_fuse_file_lock(fc, &outarg.lk, fl);
>
>         return err;
>  }
> @@ -2143,7 +2151,8 @@ static int fuse_setlk(struct file *file, struct file_lock *fl, int flock)
>         FUSE_ARGS(args);
>         struct fuse_lk_in inarg;
>         int opcode = (fl->fl_flags & FL_SLEEP) ? FUSE_SETLKW : FUSE_SETLK;
> -       pid_t pid = fl->fl_type != F_UNLCK ? current->tgid : 0;
> +       struct pid *pid = fl->fl_type != F_UNLCK ? task_tgid(current) : NULL;
> +       pid_t pid_nr = pid_nr_ns(pid, fc->pid_ns);
>         int err;
>
>         if (fl->fl_lmops && fl->fl_lmops->lm_grant) {
> @@ -2155,7 +2164,10 @@ static int fuse_setlk(struct file *file, struct file_lock *fl, int flock)
>         if (fl->fl_flags & FL_CLOSE)
>                 return 0;
>
> -       fuse_lk_fill(&args, file, fl, opcode, pid, flock, &inarg);
> +       if (pid && pid_nr == 0)
> +               return -EOVERFLOW;
> +
> +       fuse_lk_fill(&args, file, fl, opcode, pid_nr, flock, &inarg);
>         err = fuse_simple_request(fc, &args);
>
>         /* locking is restartable */
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index eddbe02c4028..9145445a759a 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -23,6 +23,7 @@
>  #include <linux/poll.h>
>  #include <linux/workqueue.h>
>  #include <linux/kref.h>
> +#include <linux/pid_namespace.h>
>
>  /** Max number of pages that can be used in a single read request */
>  #define FUSE_MAX_PAGES_PER_REQ 32
> @@ -465,6 +466,9 @@ struct fuse_conn {
>         /** The group id for this mount */
>         kgid_t group_id;
>
> +       /** The pid namespace for this mount */
> +       struct pid_namespace *pid_ns;
> +
>         /** The fuse mount flags for this mount */
>         unsigned flags;
>
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index 1ce67668a8e1..eade0bfa4488 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -20,6 +20,7 @@
>  #include <linux/random.h>
>  #include <linux/sched.h>
>  #include <linux/exportfs.h>
> +#include <linux/pid_namespace.h>
>
>  MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
>  MODULE_DESCRIPTION("Filesystem in Userspace");
> @@ -609,6 +610,7 @@ void fuse_conn_init(struct fuse_conn *fc)
>         fc->connected = 1;
>         fc->attr_version = 1;
>         get_random_bytes(&fc->scramble_key, sizeof(fc->scramble_key));
> +       fc->pid_ns = get_pid_ns(task_active_pid_ns(current));
>  }
>  EXPORT_SYMBOL_GPL(fuse_conn_init);
>
> @@ -617,6 +619,7 @@ void fuse_conn_put(struct fuse_conn *fc)
>         if (atomic_dec_and_test(&fc->count)) {
>                 if (fc->destroy_req)
>                         fuse_request_free(fc->destroy_req);
> +               put_pid_ns(fc->pid_ns);
>                 fc->release(fc);
>         }
>  }
> --
> 2.7.4
>
