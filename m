From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH 15/19] kernel: convert audit_tree.count from atomic_t to refcount_t
Date: Mon, 20 Feb 2017 17:07:25 -0500
Message-ID: <CAHC9VhQW7xFHBLNQOQRKMftStu_aHjbUmp96VJrcfWzxuzE_kw@mail.gmail.com>
References: <1487585948-6401-1-git-send-email-elena.reshetova@intel.com> <1487585948-6401-16-git-send-email-elena.reshetova@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=VZjLo6zRcggeWX4AjQJK4zTcw7T9S/3nyXcAivzhV0U=;
        b=2Qdg5fTQ/s2nxJmmT0oxUeCoUv+jsAddVcwBn0WEKYB+urP8T6yIBBkIl5krwasImk
         6qyaOi0M5420efbrHcqdISlfS4Yks1Ysubn9rqQQ9op0CtAS7hU3MsvRCwbpUwar/Gyb
         os9jZQ8bf3x9jpPgzbeVobuthoAuuGTKZyCUYsm0huxX8WT7PjPNk8mA97KEDWG8DMpS
         lCQJd+RTiJQc3L+DzLU4l+/TF52azW6SYC8ObszMHnjweDq/pCS80euMz5uspZRRr8q/
         FQNpI2hA+vGY9mfwrYfowJVP/YCmLNMBn2EsEg75kOyqyj2SuIiUnDtdoc4aW/hbBi23
         kYCA==
In-Reply-To: <1487585948-6401-16-git-send-email-elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Elena Reshetova <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Hans Liljestrand <ishkamiel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, David Windsor <dwindsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Mon, Feb 20, 2017 at 5:19 AM, Elena Reshetova
<elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> refcount_t type and corresponding API should be
> used instead of atomic_t when the variable is used as
> a reference counter. This allows to avoid accidental
> refcounter overflows that might lead to use-after-free
> situations.
>
> Signed-off-by: Elena Reshetova <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Hans Liljestrand <ishkamiel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Signed-off-by: David Windsor <dwindsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  kernel/audit_tree.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

No objection on my end, same for patch 16/19.

I have no problem merging both these patches into the audit/next
branch after the merge window, is that your goal or are you merging
these via a different tree?

> diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
> index 7b44195..7ed617b 100644
> --- a/kernel/audit_tree.c
> +++ b/kernel/audit_tree.c
> @@ -9,7 +9,7 @@ struct audit_tree;
>  struct audit_chunk;
>
>  struct audit_tree {
> -       atomic_t count;
> +       refcount_t count;
>         int goner;
>         struct audit_chunk *root;
>         struct list_head chunks;
> @@ -77,7 +77,7 @@ static struct audit_tree *alloc_tree(const char *s)
>
>         tree = kmalloc(sizeof(struct audit_tree) + strlen(s) + 1, GFP_KERNEL);
>         if (tree) {
> -               atomic_set(&tree->count, 1);
> +               refcount_set(&tree->count, 1);
>                 tree->goner = 0;
>                 INIT_LIST_HEAD(&tree->chunks);
>                 INIT_LIST_HEAD(&tree->rules);
> @@ -91,12 +91,12 @@ static struct audit_tree *alloc_tree(const char *s)
>
>  static inline void get_tree(struct audit_tree *tree)
>  {
> -       atomic_inc(&tree->count);
> +       refcount_inc(&tree->count);
>  }
>
>  static inline void put_tree(struct audit_tree *tree)
>  {
> -       if (atomic_dec_and_test(&tree->count))
> +       if (refcount_dec_and_test(&tree->count))
>                 kfree_rcu(tree, head);
>  }
>

-- 
paul moore
www.paul-moore.com
