From: Paul Moore <paul@paul-moore.com>
Subject: Re: [RFC PATCH ghak90 (was ghak32) V3 04/10] audit: add support for
 non-syscall auxiliary records
Date: Fri, 20 Jul 2018 18:14:02 -0400
Message-ID: <CAHC9VhRkH+UaZXfbsmfMsuCO7rQ48R5cBPU__00eG=pyO7AyCw@mail.gmail.com>
References: <cover.1528304203.git.rgb@redhat.com> <dcd3d6e27c4beb8aec11805faeb4de7013132bd7.1528304204.git.rgb@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qa4APjDRHRycatDRfTIp3UruAUXrMK5UpldtNCmP2Mg=;
        b=LKyVFlt+U2g3GRxRr6z/XJfb/0pcgglOyNkNL2EE9V6p7sGs0Xihp4MsNyMuSl4J2h
         X4XKq8fDLKMFOqBVONATXa6wg9rR9v9gcHA7ONUbqIqKKvR5f2i3682hB24aX6cUxnQ0
         aguvwSWzbM/a8Aoab9EkG0GW6DCk3RcgklvO3LByMDHmWfKkZ4lytcAcy80n4We7u/0c
         MzMa7nklDRuLFYAhimoVKyZYAenuWB/WtgUDilt9pHfT5QBbdCY5rvcDKYdlBIFMLgAf
         CzaHUcycX8G7epoKSTeB6IvaIT9M2kRENymTkEdKZW9xFOPjdClo5N/4Hbh5NK8xiIiz
         Bosw==
In-Reply-To: <dcd3d6e27c4beb8aec11805faeb4de7013132bd7.1528304204.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: rgb@redhat.com
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, serge@hallyn.com

On Wed, Jun 6, 2018 at 1:01 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> Standalone audit records have the timestamp and serial number generated
> on the fly and as such are unique, making them standalone.  This new
> function audit_alloc_local() generates a local audit context that will
> be used only for a standalone record and its auxiliary record(s).  The
> context is discarded immediately after the local associated records are
> produced.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/linux/audit.h |  8 ++++++++
>  kernel/auditsc.c      | 25 +++++++++++++++++++++++--
>  2 files changed, 31 insertions(+), 2 deletions(-)

...

> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -916,8 +916,11 @@ static inline void audit_free_aux(struct audit_context *context)
>  static inline struct audit_context *audit_alloc_context(enum audit_state state)
>  {
>         struct audit_context *context;
> +       gfp_t gfpflags;
>
> -       context = kzalloc(sizeof(*context), GFP_KERNEL);
> +       /* We can be called in atomic context via audit_tg() */
> +       gfpflags = (in_atomic() || irqs_disabled()) ? GFP_ATOMIC : GFP_KERNEL;

Instead of trying to guess the proper gfp flags, and likely getting it
wrong at some point (the in_atomic() comment in preempt.h don't give
me the warm fuzzies), why not pass the gfp flags as an argument?

Right now it looks like we would only have two callers: audit_alloc()
and audit_audit_local().  The audit_alloc() invocation would simply
pass GFP_KERNEL and we could allow the audit_alloc_local() callers to
specify the gfp flags when calling audit_alloc_local() (although I
suspect that will always be GFP_ATOMIC since we should only be calling
audit_alloc_local() from interrupt-like context, in all other cases we
should use the audit_context from the current task_struct.

> +       context = kzalloc(sizeof(*context), gfpflags);
>         if (!context)
>                 return NULL;
>         context->state = state;
> @@ -993,8 +996,26 @@ struct audit_task_info init_struct_audit = {
>         .ctx = NULL,
>  };
>
> -static inline void audit_free_context(struct audit_context *context)
> +struct audit_context *audit_alloc_local(void)
>  {

Let's see where this goes, but we may want to rename this slightly to
indicate that this should only be called from interrupt context when
we can't rely on current's audit_context.  Bonus points if we can find
a way to enforce this with a WARN() assertion so we can better catch
abuse.

> +       struct audit_context *context;
> +
> +       if (!audit_ever_enabled)
> +               return NULL; /* Return if not auditing. */
> +
> +       context = audit_alloc_context(AUDIT_RECORD_CONTEXT);
> +       if (!context)
> +               return NULL;
> +       context->serial = audit_serial();
> +       context->ctime = current_kernel_time64();
> +       context->in_syscall = 1;

Setting in_syscall is both interesting and a bit troubling, if for no
other reason than I expect most (all?) callers to be in an interrupt
context when audit_alloc_local() is called.  Setting in_syscall would
appear to be conceptually in this case.  Can you help explain why this
is the right thing to do, or necessary to ensure things are handled
correctly?

Looking quickly at the audit code, it seems to only be used on record
and/or syscall termination to end things properly as well as in some
of the PATH record code paths to limit filename collection to actual
syscalls.  However, this was just a quick look so I could be missing
some important points.

> +       return context;
> +}
> +
> +void audit_free_context(struct audit_context *context)
> +{
> +       if (!context)
> +               return;
>         audit_free_names(context);
>         unroll_tree_refs(context, NULL, 0);
>         free_tree_refs(context);
> --
> 1.8.3.1
>
> --
> Linux-audit mailing list
> Linux-audit@redhat.com
> https://www.redhat.com/mailman/listinfo/linux-audit

--
paul moore
www.paul-moore.com
