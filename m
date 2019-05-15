From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] signal: don't always leave task frozen after
 ptrace_stop()
Date: Wed, 15 May 2019 17:03:44 +0000
Message-ID: <20190515170336.GA9307@castle>
References: <20190513195517.2289671-1-guro@fb.com>
 <20190514160158.GB32459@redhat.com>
 <20190514174603.GB12629@tower.DHCP.thefacebook.com>
 <20190515144335.GC18892@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=WGtrpn4uBb9EGLpZDs5HrL/cIPxjfRCnE7KbGxNLiak=;
 b=Y+QCpPqB8o6uYbnoiFJNpLpVZRkzrQ/MocuIOxzcEFyFoCfdm5a97a1NE+aYNrvrCAJB
 G7jhIhLkRTGAaEHiiJ5ADGnUO+XRd11laIyycN/QtjwPWHUQT/5S97D1ak/8hV4o3gKr
 jNAyGPgK1l14OUmWHYlZCG5QOmL/4hIk9tE= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WGtrpn4uBb9EGLpZDs5HrL/cIPxjfRCnE7KbGxNLiak=;
 b=B71MrKUXCheweEspiBtwwaa1FZPqvcXkJfh4P4bR5ocrivkHWlu6reAyUaiAfgtRaLHWxvjOGY6LD95k6FkxRftVeuXX7wacWxwfIQakPaqZuwfP0Ykl+9cHbGNoNJEQVKWaqdqkFBsC/m69hmOUJMIWB4++lpMq5wBd5VtQhFA=
In-Reply-To: <20190515144335.GC18892@redhat.com>
Content-Language: en-US
Content-ID: <475D50D7C649E9479D82E7B9302981FF@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Alex Xu <alex_y_xu@yahoo.ca>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Wed, May 15, 2019 at 04:43:35PM +0200, Oleg Nesterov wrote:
> On 05/14, Roman Gushchin wrote:
> >
> > I agree that "may_remain_frozen" adds a lot of ugliness, so let's fix
> > the regression with the unconditional leave_frozen(true). The patch bel=
ow.
> > Please, let me know if it's not what you meant.
>=20
> Yes, thanks, this is what I meant. Feel free to add my ACK.

Thanks!

Tejun, can you, please, pull the patch?

Thank you!

Roman
