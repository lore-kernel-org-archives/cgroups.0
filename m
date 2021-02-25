From: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC 0/2] cgroup: New misc cgroup controller
Date: Wed, 24 Feb 2021 16:06:44 -0800
Message-ID: <YDbqFE21UsEaFDuU@google.com>
References: <20210218195549.1696769-1-vipinsh@google.com>
 <YDVIYQhZ6ArGsr3n@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=dwsRL0iFuNLsIwlduzLk8A4HpuT+349o+yzvI+GvJGg=;
        b=FNfLLnAZf2wdLfsTREG5f4CUE90hhdj+9efnR0CcEASFvTBlIxbq2WH8aD66ed0cWP
         u9dRyt1Oj6/lfDKABYmqQbAGmMmI/X9cRN3qMQgoex1+4N5PBvszos8ZfcL7YE+BQnHc
         Dh/Dnaa1VnZhDlc8qYhgJFZnCdUpC03FVrogZi77qKJApoq49AGkV+XAN8eOJPhW6uyf
         Df3zBYK1751kzdlFraymh+st+EgK1j7iViJWlOfxzrePopY3x+EOvXWqZvKzf6XfjChS
         CLcqOiLshfzlIREJlcF+0l01oRXxU2HSvPTaQejPlLR4yh+2oehsS7SPhi7bE20wq4ax
         IcIA==
Content-Disposition: inline
In-Reply-To: <YDVIYQhZ6ArGsr3n@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, thomas.lendacky-5C7GfCeVMHo@public.gmane.org, brijesh.singh-5C7GfCeVMHo@public.gmane.org, jon.grimm-5C7GfCeVMHo@public.gmane.org, eric.vantassell-5C7GfCeVMHo@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, frankja-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dionnaglaze-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Feb 23, 2021 at 07:24:33PM +0100, Michal Koutn=FD wrote:
> Hello.
>=20
> On Thu, Feb 18, 2021 at 11:55:47AM -0800, Vipin Sharma <vipinsh-hpIqsD4AK=
lfQT0dZR+AlfA@public.gmane.org> wrote:
> > This patch is creating a new misc cgroup controller for allocation and
> > tracking of resources which are not abstract like other cgroup
> > controllers.
> Please don't refer to this as "allocation" anywhere, that has a specific
> meaning (see Resource Distribution Models in
> Documentation/admin-gruide/cgroup-v2.rst).

Yeah, it should be "Limits". I will update the text.

>=20
> > This controller was initially proposed as encryption_id but after
> > the feedbacks, it is now changed to misc cgroup.
> > https://lore.kernel.org/lkml/20210108012846.4134815-2-vipinsh-hpIqsD4AK=
lfQT0dZR+AlfA@public.gmane.org/
> Interesting generalization. I wonder what else could fit under this as
> well. (It resembles pids controller on the cover.)
>=20
> > Please provide any feedback for this RFC or if it is good for
> > merging then I can send a patch for merging.
> A new controller is added exposed with v1 attributes. I'm not convinced
> it is desirable to change the frozen v1 controllers' API? (And therefore
> promote it as well.)

This is a very trivial controller. I believe once it becomes public it
can be helpful down the line to the v1 users, who cannot use v2 yet, for
some simple resource accounting, like us, we have the need for ASIDs
accounting in v1 until we move to v2. If the community has strong
objection then I can remove v1 support.

>=20
> Beware, bikeshedding. The name is very non-descriptive, potentially
> suggesting catch-all semantics. It'd deserve a further thought. My idea
> would be limit(s) or counter controller.

Limit and counter are kind of suggesting the underlying technique for
accounting instead of a generic name to denote resource types managed by
this controller. One can argue that if top level names are similar to
Resource Destribution Model then may be it makes sense to combine
resources with similar accounting technique under one controller.

I am looking at misc as a controller which is for resources not having
proper home in other controllers or not big enough to deserve their own
controller.

I agree with you coming up with a name which check all boxes of
requirements won't be possible. We have discussed name sev cgroup,
kvm cgroup, encryption_id cgroup before reaching to an agreement on misc
cgroup. I am open to other names if they are better suited for this
controller and makes more sense.

Thanks
Vipin
