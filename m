From: Paul Moore <paul@paul-moore.com>
Subject: Re: [RFC PATCH ghak32 V2 06/13] audit: add support for non-syscall
 auxiliary records
Date: Fri, 20 Apr 2018 12:21:33 -0400
Message-ID: <CAHC9VhRe2UMmwcdPfDs5wLdg8JjL7U+711LAR=URS=7rBGjw2A@mail.gmail.com>
References: <cover.1521179281.git.rgb@redhat.com> <ee2a945fb09a939b3c214f45e49dab6a770d83e6.1521179281.git.rgb@redhat.com>
 <CAHC9VhQbPbnrbxCD1fyTSxWgrXXXYnZw_=nbOhfMCO5Q5eSsWQ@mail.gmail.com> <20180420012346.udnga5pfdjoazcfc@madcap2.tricolour.ca>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=VEtmDJ4VprYGDhPNREGKeHgonuGj60dhpYZcSX9+Zw0=;
        b=HHUxz6Otd05ddJsYCfaDZWn4sVftwosXRw3gn03OAphj8NS/Z3NkbL7KoKhtltvQl9
         UR5jiNp8RO322TtVbezOaXJe7v6Af/OeMsOa3izA8w/46B+OYh5vI7U2O/VCaqP/hido
         /FGGvtmsqVoWJFXIMLvFvXxmV0kyGNsx9m4BGHQtzjJvRCLxDXVljV08nDn15Ffl33g2
         nsrEBkpPq2Y4LCCXvyFzAI+09lP55JhRpQyF9DX2TXJxZiYkHUHCaV3mh3LwltxVdMFo
         i06UHNaZ8kZ74PqJp6U9f0MYN7p5EeA+TfzfdCO7T+x5uapWyk6QljYEZ3iaGLR0Y/2b
         8LOg==
In-Reply-To: <20180420012346.udnga5pfdjoazcfc@madcap2.tricolour.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Richard Guy Briggs <rgb@redhat.com>
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, serge@hallyn.com

On Thu, Apr 19, 2018 at 9:23 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2018-04-18 20:39, Paul Moore wrote:
>> On Fri, Mar 16, 2018 at 5:00 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
>> > Standalone audit records have the timestamp and serial number generated
>> > on the fly and as such are unique, making them standalone.  This new
>> > function audit_alloc_local() generates a local audit context that will
>> > be used only for a standalone record and its auxiliary record(s).  The
>> > context is discarded immediately after the local associated records are
>> > produced.
>> >
>> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
>> > ---
>> >  include/linux/audit.h |  8 ++++++++
>> >  kernel/auditsc.c      | 20 +++++++++++++++++++-
>> >  2 files changed, 27 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/include/linux/audit.h b/include/linux/audit.h
>> > index ed16bb6..c0b83cb 100644
>> > --- a/include/linux/audit.h
>> > +++ b/include/linux/audit.h
>> > @@ -227,7 +227,9 @@ static inline int audit_log_container_info(struct audit_context *context,
>> >  /* These are defined in auditsc.c */
>> >                                 /* Public API */
>> >  extern int  audit_alloc(struct task_struct *task);
>> > +extern struct audit_context *audit_alloc_local(void);
>> >  extern void __audit_free(struct task_struct *task);
>> > +extern void audit_free_context(struct audit_context *context);
>> >  extern void __audit_syscall_entry(int major, unsigned long a0, unsigned long a1,
>> >                                   unsigned long a2, unsigned long a3);
>> >  extern void __audit_syscall_exit(int ret_success, long ret_value);
>> > @@ -472,6 +474,12 @@ static inline int audit_alloc(struct task_struct *task)
>> >  {
>> >         return 0;
>> >  }
>> > +static inline struct audit_context *audit_alloc_local(void)
>> > +{
>> > +       return NULL;
>> > +}
>> > +static inline void audit_free_context(struct audit_context *context)
>> > +{ }
>> >  static inline void audit_free(struct task_struct *task)
>> >  { }
>> >  static inline void audit_syscall_entry(int major, unsigned long a0,
>> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
>> > index 2932ef1..7103d23 100644
>> > --- a/kernel/auditsc.c
>> > +++ b/kernel/auditsc.c
>> > @@ -959,8 +959,26 @@ int audit_alloc(struct task_struct *tsk)
>> >         return 0;
>> >  }
>> >
>> > -static inline void audit_free_context(struct audit_context *context)
>> > +struct audit_context *audit_alloc_local(void)
>> >  {
>> > +       struct audit_context *context;
>> > +
>> > +       if (!audit_ever_enabled)
>> > +               return NULL; /* Return if not auditing. */
>> > +
>> > +       context = audit_alloc_context(AUDIT_RECORD_CONTEXT);
>> > +       if (!context)
>> > +               return NULL;
>> > +       context->serial = audit_serial();
>> > +       context->ctime = current_kernel_time64();
>> > +       context->in_syscall = 1;
>> > +       return context;
>> > +}
>> > +
>> > +inline void audit_free_context(struct audit_context *context)
>> > +{
>> > +       if (!context)
>> > +               return;
>> >         audit_free_names(context);
>> >         unroll_tree_refs(context, NULL, 0);
>> >         free_tree_refs(context);
>>
>> I'm reserving the option to comment on this idea further as I make my
>> way through the patchset, but audit_free_context() definitely
>> shouldn't be declared as an inline function.
>
> Ok, I think I follow.  When it wasn't exported, inline was fine, but now
> that it has been exported, it should no longer be inlined ...

Pretty much.  Based on a few comments I've seen by compiler folks over
the years, my current thinking is that we shouldn't worry about
explicit inlining static functions in C files (header files are a
different story).  The basic idea being that the compiler almost
always does a better job than us stupid developers.

> ... or should use
> an intermediate function name to export so that local uses of it can
> remain inline.

Possibly, but my guess is that the compiler could (will?) do that by
itself for code that lives in the same file.

-- 
paul moore
www.paul-moore.com
