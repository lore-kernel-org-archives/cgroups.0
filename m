From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH] security: selinux: allow per-file labeling for cgroupfs
Date: Fri, 10 Mar 2017 15:21:07 -0500
Message-ID: <CAHC9VhSL1dm9b7ZohYyCU0PjKbbtYLe7XX7Xv3CsQQx4CtG_Fw@mail.gmail.com>
References: <20170209155823.22148-1-runcom@redhat.com> <CAHC9VhSL3ZS3R2r39+qzYmvU1=8-jC2nzqkXNQ0Yk3+okKd7jw@mail.gmail.com>
 <1489177036.6824.57.camel@tycho.nsa.gov>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=FcjE4Mq/rr+KzwjxpuMT+Tg/gx+DRyoUVq6GSpfI7+c=;
        b=TbdCnjkdSrrdvrvYqE9FJY4MMk7PqLHWdnzRtdhzqGtueGlTBiP47vaHixvHEblBF5
         4Xpumydzfwgb9vcLz2vxA1su2D7anrfdv0KOUotSYg1Y/IX4GFEx69tL2aJ5PeMlUykl
         i+Lx1is0NsBfoO9dbP6CN4V3PbvG2unbd0df5nJWefll7ZKQ7C1Pzxcydu428Ux8oNJb
         VfzRw4XdHqy04Z5z/3R08+BmCHoAeX1GA+UUk4AP1siUj6g6KCqw6xihJF801f9qHYgu
         Y1lB98DhWnPuw12fvjkkT5uoWth0Ikfy4rV/1v42v04HbATG3cg0qSRLfQScgsQx7jga
         ShFg==
In-Reply-To: <1489177036.6824.57.camel-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Fri, Mar 10, 2017 at 3:17 PM, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org> wrote:
> On Fri, 2017-03-10 at 15:01 -0500, Paul Moore wrote:
>> On Thu, Feb 9, 2017 at 10:58 AM, Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
>> > wrote:
>> >
>> > This patch allows genfscon per-file labeling for cgroupfs. For
>> > instance,
>> > this allows to label the "release_agent" file within each
>> > cgroup mount and limit writes to it.
>> >
>> > Signed-off-by: Antonio Murdaca <runcom-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> > ---
>> >  security/selinux/hooks.c | 2 ++
>> >  1 file changed, 2 insertions(+)
>>
>> Now that the merge window is behind us, let's get this merged, but
>> could you update it to use the selinux_policycap_cgroupseclabel
>> policy
>> capability?  See 2651225b5ebcdde ("selinux: wrap cgroup seclabel
>> support with its own policy capability") for more information.
>
> I don't think that is necessary.  This change unlike the other one
> should not yield any difference in behavior with existing policy; it
> just allows one to specify fine-grained labeling for cgroup nodes in
> future policy.  It doesn't affect any userspace interface.

Yes, I thought about that, and if the policy capability was already
present in a released kernel then I wouldn't worry about it much, but
since the policy capability still only lives in the v4.11-rcX kernels
I'd prefer to see this code wrapped with the policy capability ...
even if all it really does is give me that warm fuzzy feeling.

>> Also, how goes the testing?
>>
>> >
>> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
>> > index 9a8f12f..5a3138e 100644
>> > --- a/security/selinux/hooks.c
>> > +++ b/security/selinux/hooks.c
>> > @@ -808,6 +808,8 @@ static int selinux_set_mnt_opts(struct
>> > super_block *sb,
>> >
>> >         if (!strcmp(sb->s_type->name, "debugfs") ||
>> >             !strcmp(sb->s_type->name, "sysfs") ||
>> > +           !strcmp(sb->s_type->name, "cgroup") ||
>> > +           !strcmp(sb->s_type->name, "cgroup2") ||
>> >             !strcmp(sb->s_type->name, "pstore"))
>> >                 sbsec->flags |= SE_SBGENFS;
>> >
>> > --
>> > 2.9.3
>> >
>> > _______________________________________________
>> > Selinux mailing list
>> > Selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
>> > To unsubscribe, send email to Selinux-leave-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
>> > To get help, send an email containing "help" to Selinux-request@tyc
>> > ho.nsa.gov.
>>



-- 
paul moore
www.paul-moore.com
