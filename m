From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 1/2] kernfs: add kernfs_ops.free operation to free
 resources tied to the file
Date: Mon, 26 Jun 2023 13:21:07 -0700
Message-ID: <CAJuCfpGM-yEoG0YsjA_3AQ9PZa=daC7eJHL7huXAzB8zV7AmKg@mail.gmail.com>
References: <20230626201713.1204982-1-surenb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687810878; x=1690402878;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NfWVz+A34dcRU8jVvD1uvLnBMJMnVmBYO+8hH+swTnI=;
        b=auOTUoCoLj8ulXOSurwSalH+VuiHVvQyIP0D6uN0eGXwvkBNl/WLBgXr5yjtB9hacj
         II7AOSuuj06hwAL4gt41/64RMS+bch7IHSNAL1C4zLRU0sNopNW/Q8KirQKa0K3jnFb2
         TGFz6U6BuaVX58KAN69EkFvN/7LzPl/DlaaQ559Dm3886dCgpLDoPws/tniO7DIewVQA
         klhNgV/peNBRwZJJx/9HLRDEkLHvp7Wh+yceEDZn+W/5/mFWuDFX3NnLXOJCm0oS3/8H
         Bsx8VblwwOvzuPXDRoGjZ+UUkPJysSqI0MNNUTIb+4gTI3gLNPXUcnbwO/NqYT470F1n
         4lrQ==
In-Reply-To: <20230626201713.1204982-1-surenb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: tj@kernel.org
Cc: gregkh@linuxfoundation.org, peterz@infradead.org, lujialin4@huawei.com, lizefan.x@bytedance.com, hannes@cmpxchg.org, mingo@redhat.com, ebiggers@kernel.org, oleg@redhat.com, akpm@linux-foundation.org, viro@zeniv.linux.org.uk, brauner@kernel.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, bristot@redhat.com, vschneid@redhat.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-team@android.com

On Mon, Jun 26, 2023 at 1:17=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> kernfs_ops.release operation can be called from kernfs_drain_open_files
> which is not tied to the file's real lifecycle. Introduce a new kernfs_op=
s
> free operation which is called only when the last fput() of the file is
> performed and therefore is strictly tied to the file's lifecycle. This
> operation will be used for freeing resources tied to the file, like
> waitqueues used for polling the file.

While this patchset touches kernfs, cgroups and psi areas (3 different
maintainers), I think cgroups are the most relevant area for it, so
IMHO Tejun's tree would be the right one to get them once reviewed and
acknowledged. Thanks!

>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  fs/kernfs/file.c       | 8 +++++---
>  include/linux/kernfs.h | 5 +++++
>  2 files changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
> index 40c4661f15b7..acc52d23d8f6 100644
> --- a/fs/kernfs/file.c
> +++ b/fs/kernfs/file.c
> @@ -766,7 +766,7 @@ static int kernfs_fop_open(struct inode *inode, struc=
t file *file)
>
>  /* used from release/drain to ensure that ->release() is called exactly =
once */
>  static void kernfs_release_file(struct kernfs_node *kn,
> -                               struct kernfs_open_file *of)
> +                               struct kernfs_open_file *of, bool final)
>  {
>         /*
>          * @of is guaranteed to have no other file operations in flight a=
nd
> @@ -787,6 +787,8 @@ static void kernfs_release_file(struct kernfs_node *k=
n,
>                 of->released =3D true;
>                 of_on(of)->nr_to_release--;
>         }
> +       if (final && kn->attr.ops->free)
> +               kn->attr.ops->free(of);
>  }
>
>  static int kernfs_fop_release(struct inode *inode, struct file *filp)
> @@ -798,7 +800,7 @@ static int kernfs_fop_release(struct inode *inode, st=
ruct file *filp)
>                 struct mutex *mutex;
>
>                 mutex =3D kernfs_open_file_mutex_lock(kn);
> -               kernfs_release_file(kn, of);
> +               kernfs_release_file(kn, of, true);
>                 mutex_unlock(mutex);
>         }
>
> @@ -852,7 +854,7 @@ void kernfs_drain_open_files(struct kernfs_node *kn)
>                 }
>
>                 if (kn->flags & KERNFS_HAS_RELEASE)
> -                       kernfs_release_file(kn, of);
> +                       kernfs_release_file(kn, of, false);
>         }
>
>         WARN_ON_ONCE(on->nr_mmapped || on->nr_to_release);
> diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
> index 73f5c120def8..a7e404ff31bb 100644
> --- a/include/linux/kernfs.h
> +++ b/include/linux/kernfs.h
> @@ -273,6 +273,11 @@ struct kernfs_ops {
>          */
>         int (*open)(struct kernfs_open_file *of);
>         void (*release)(struct kernfs_open_file *of);
> +       /*
> +        * Free resources tied to the lifecycle of the file, like a
> +        * waitqueue used for polling.
> +        */
> +       void (*free)(struct kernfs_open_file *of);
>
>         /*
>          * Read is handled by either seq_file or raw_read().
> --
> 2.41.0.162.gfafddb0af9-goog
>
