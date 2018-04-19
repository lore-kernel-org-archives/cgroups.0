From: Paul Moore <paul@paul-moore.com>
Subject: Re: [RFC PATCH ghak32 V2 10/13] audit: add containerid support for
 seccomp and anom_abend records
Date: Wed, 18 Apr 2018 21:31:50 -0400
Message-ID: <CAHC9VhS6MKoLkzpfcmYBSNnvrtbL2FOF5PX9uOfivSVEWykkQg@mail.gmail.com>
References: <cover.1521179281.git.rgb@redhat.com> <11174597083f89352f1d6491ec94e27f882625d9.1521179281.git.rgb@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=hFnTgqsRJKL6Dng+FS5/SZHOeFFcayKGQiaq1E2R3Yg=;
        b=RWILuyGjZCRMJKvckQL2f7994SqaJI49bbd9mBJeAkA/emTLMG4fNlpSJEvAXa3KeD
         0lhz7NREN1DZ7Zbm7F+t3SA6C3uKCYTaYVt/+XTRPXToIJDqMtjQ1K6cvS5/rKuG3Fhu
         ifXI0SGdpE6n5QfnCwrqz7n2FseX6q0DzNb+eZiq/i8BnpdjRkaIe9cg77PzZqlI3x4X
         D1unvLuApYF9uN3ZtBKfrTsmLs3NlXAF67hkABK34/kQ9g+vX56YtKh66W8wdNlE39he
         99uwtZ+Z8Xg8r5mprFZezauSYEQ0r11D3YuuPQnPRnviCYv0k2IkXSleGqmbzP1xqVfP
         rQ+A==
In-Reply-To: <11174597083f89352f1d6491ec94e27f882625d9.1521179281.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Richard Guy Briggs <rgb@redhat.com>
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, serge@hallyn.com

On Fri, Mar 16, 2018 at 5:00 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
> Add container ID auxiliary records to secure computing and abnormal end
> standalone records.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  kernel/auditsc.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 7103d23..2f02ed9 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -2571,6 +2571,7 @@ static void audit_log_task(struct audit_buffer *ab)
>  void audit_core_dumps(long signr)
>  {
>         struct audit_buffer *ab;
> +       struct audit_context *context = audit_alloc_local();

Looking quickly at do_coredump() I *believe* we can use current here.

>         if (!audit_enabled)
>                 return;
> @@ -2578,19 +2579,22 @@ void audit_core_dumps(long signr)
>         if (signr == SIGQUIT)   /* don't care for those */
>                 return;
>
> -       ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_ANOM_ABEND);
> +       ab = audit_log_start(context, GFP_KERNEL, AUDIT_ANOM_ABEND);
>         if (unlikely(!ab))
>                 return;
>         audit_log_task(ab);
>         audit_log_format(ab, " sig=%ld res=1", signr);
>         audit_log_end(ab);
> +       audit_log_container_info(context, "abend", audit_get_containerid(current));
> +       audit_free_context(context);
>  }
>
>  void __audit_seccomp(unsigned long syscall, long signr, int code)
>  {
>         struct audit_buffer *ab;
> +       struct audit_context *context = audit_alloc_local();

We can definitely use current here.

> -       ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_SECCOMP);
> +       ab = audit_log_start(context, GFP_KERNEL, AUDIT_SECCOMP);
>         if (unlikely(!ab))
>                 return;
>         audit_log_task(ab);
> @@ -2598,6 +2602,8 @@ void __audit_seccomp(unsigned long syscall, long signr, int code)
>                          signr, syscall_get_arch(), syscall,
>                          in_compat_syscall(), KSTK_EIP(current), code);
>         audit_log_end(ab);
> +       audit_log_container_info(context, "seccomp", audit_get_containerid(current));
> +       audit_free_context(context);
>  }
>
>  struct list_head *audit_killed_trees(void)

-- 
paul moore
www.paul-moore.com
