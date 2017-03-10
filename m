From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH] security: selinux: allow per-file labeling for cgroupfs
Date: Fri, 10 Mar 2017 15:17:16 -0500
Message-ID: <1489177036.6824.57.camel@tycho.nsa.gov>
References: <20170209155823.22148-1-runcom@redhat.com>
         <CAHC9VhSL3ZS3R2r39+qzYmvU1=8-jC2nzqkXNQ0Yk3+okKd7jw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHC9VhSL3ZS3R2r39+qzYmvU1=8-jC2nzqkXNQ0Yk3+okKd7jw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Paul Moore <paul@paul-moore.com>, Antonio Murdaca <amurdaca@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov, vgoyal@redhat.com

On Fri, 2017-03-10 at 15:01 -0500, Paul Moore wrote:
> On Thu, Feb 9, 2017 at 10:58 AM, Antonio Murdaca <amurdaca@redhat.com
> > wrote:
> > 
> > This patch allows genfscon per-file labeling for cgroupfs. For
> > instance,
> > this allows to label the "release_agent" file within each
> > cgroup mount and limit writes to it.
> > 
> > Signed-off-by: Antonio Murdaca <runcom@redhat.com>
> > ---
> >  security/selinux/hooks.c | 2 ++
> >  1 file changed, 2 insertions(+)
> 
> Now that the merge window is behind us, let's get this merged, but
> could you update it to use the selinux_policycap_cgroupseclabel
> policy
> capability?  See 2651225b5ebcdde ("selinux: wrap cgroup seclabel
> support with its own policy capability") for more information.

I don't think that is necessary.  This change unlike the other one
should not yield any difference in behavior with existing policy; it
just allows one to specify fine-grained labeling for cgroup nodes in
future policy.  It doesn't affect any userspace interface.


> Also, how goes the testing?
> 
> > 
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index 9a8f12f..5a3138e 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -808,6 +808,8 @@ static int selinux_set_mnt_opts(struct
> > super_block *sb,
> > 
> >         if (!strcmp(sb->s_type->name, "debugfs") ||
> >             !strcmp(sb->s_type->name, "sysfs") ||
> > +           !strcmp(sb->s_type->name, "cgroup") ||
> > +           !strcmp(sb->s_type->name, "cgroup2") ||
> >             !strcmp(sb->s_type->name, "pstore"))
> >                 sbsec->flags |= SE_SBGENFS;
> > 
> > --
> > 2.9.3
> > 
> > _______________________________________________
> > Selinux mailing list
> > Selinux@tycho.nsa.gov
> > To unsubscribe, send email to Selinux-leave@tycho.nsa.gov.
> > To get help, send an email containing "help" to Selinux-request@tyc
> > ho.nsa.gov.
> 
