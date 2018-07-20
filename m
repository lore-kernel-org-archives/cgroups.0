From: Paul Moore <paul@paul-moore.com>
Subject: Re: [RFC PATCH ghak90 (was ghak32) V3 05/10] audit: add containerid
 support for tty_audit
Date: Fri, 20 Jul 2018 18:14:11 -0400
Message-ID: <CAHC9VhTTJVbFq_Cmu8E7EzQD-JXjkbDz7P1EY8ePVrXpQAqPdw@mail.gmail.com>
References: <cover.1528304203.git.rgb@redhat.com> <28ab8ad3c4e5de6f61b928eeb2af030b04a8820b.1528304204.git.rgb@redhat.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wHZ59XqSMuHADW+R57tBef8AdySR0zI+EV3OLndYQx0=;
        b=sqlJi1ci2aaQSjkcjVha0IfOpjP7OABHcNA9SQq12lA+85JBhnhPhsRxlnlnPhg/He
         nZAQDvIBvfECZzVmXqiBaeXsgq27Joa/i2WKZYG4gftAPMjZQyarLVQUmkiVz9VE7By2
         PCROwqTxqulGIhLkgLXbP5HWokY89MjsHREptyWoUiSr2+/bP8FIDQaFTuTx95FKWldP
         HgsEDbgZ/Cdpa0uBvlgrN+fk99te6QCFwVrD9mdDgK/ch+Vm9uEJRKk/PBoDdiimk5ld
         tFpHyDxCrgSwp6Stvf2e0h3CbPBwvg/QElyf1V6yUAxLUzoWgj5oq5vCyjMclL7+vGx9
         oeaA==
In-Reply-To: <28ab8ad3c4e5de6f61b928eeb2af030b04a8820b.1528304204.git.rgb@redhat.com>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: rgb@redhat.com
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, serge@hallyn.com

On Wed, Jun 6, 2018 at 1:04 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> Add audit container identifier auxiliary record to tty logging rule
> event standalone records.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  drivers/tty/tty_audit.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/tty/tty_audit.c b/drivers/tty/tty_audit.c
> index e30aa6b..66bd850 100644
> --- a/drivers/tty/tty_audit.c
> +++ b/drivers/tty/tty_audit.c
> @@ -66,8 +66,9 @@ static void tty_audit_log(const char *description, dev_t dev,
>         uid_t uid = from_kuid(&init_user_ns, task_uid(tsk));
>         uid_t loginuid = from_kuid(&init_user_ns, audit_get_loginuid(tsk));
>         unsigned int sessionid = audit_get_sessionid(tsk);
> +       struct audit_context *context = audit_alloc_local();

We should be using current's audit_context in tty_audit_log().
Actually, we should probably just get rid of the tsk variable in
tty_audit_log() and use current directly to make things a bit more
obvious.

<time passes>

I did some digging and I have a two year old, half-baked patch that
cleans up this tsk/current usage as well as a few others.  I just
rebased it against audit/next and surprisingly it seems to pass a
basic smoke test (kernel boots and audit-testsuite passes); I'll post
it to the list as a RFC once I'm done reviewing these patches.

> -       ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_TTY);
> +       ab = audit_log_start(context, GFP_KERNEL, AUDIT_TTY);
>         if (ab) {
>                 char name[sizeof(tsk->comm)];
>
> @@ -80,6 +81,8 @@ static void tty_audit_log(const char *description, dev_t dev,
>                 audit_log_n_hex(ab, data, size);
>                 audit_log_end(ab);
>         }
> +       audit_log_contid(context, "tty", audit_get_contid(tsk));
> +       audit_free_context(context);
>  }
