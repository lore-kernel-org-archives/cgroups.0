From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v2 3/6] cgroup: cgroup v2 freezer
Date: Wed, 14 Nov 2018 17:39:11 +0000
Message-ID: <20181114173905.GA25468@castle.DHCP.thefacebook.com>
References: <20181112230422.5911-1-guro@fb.com>
 <20181112230422.5911-5-guro@fb.com> <20181113154825.GC30990@redhat.com>
 <20181113215919.GC15590@tower.DHCP.thefacebook.com>
 <20181114165631.GE13885@redhat.com>
 <20181114170558.GA24889@castle.DHCP.thefacebook.com>
 <20181114173610.GF13885@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=qxE2EWSO2LFKcNvT1y0Ar90xn7vcfr4GEv5rPegnhEM=;
 b=LGNoBf/vCR6XIbTch+bY1nECZaqmKVQFZqe0HlwGmjlp2qpNdjxfMQnTpLiOqAZGoHHn
 vmV0mAniFSUq1Fv6YKldFPhCXPKc7nFGqmtHrl8DHs+UnRVEhw4It3gat6KE6SHmsEN6
 OwCuw1EDP2CRpPRrT86IP+85X7gRpagg4Aw= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qxE2EWSO2LFKcNvT1y0Ar90xn7vcfr4GEv5rPegnhEM=;
 b=gNrh9iwmGJvFkTniZkPEogOZJHmXBTTpt73Y77DDC0uQ7XmpSgwQLqEhTdTrQ2EDBw3gyIVIe4pdrgWLKk7RCKTjgqx1MSo3w1XXg3Xz4YT1k4wehcUd0dMz6gKsfOyAoIWqBqt4K62Z+X1W/BTBLXrTdqY/CnIwXhW026G+kxw=
In-Reply-To: <20181114173610.GF13885@redhat.com>
Content-Language: en-US
Content-ID: <A19B4D783DCCE841BA38DDFD6C65A7A3@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Wed, Nov 14, 2018 at 06:36:11PM +0100, Oleg Nesterov wrote:
> On 11/14, Roman Gushchin wrote:
> >
> > > No, this is very wrong. Just suppose the caller is killed right befor=
e
> > > clear_thread_flag(TIF_SIGPENDING).
> >
> > So, I had TASK_KILLABLE before, but had some issues with ptrace/gdb.
> > I'll revisit this option.
>=20
> Yes, ptrace_signal_wake_up() won't wake a TASK_KILLABLE tracee up...
>=20
> BTW. Could you explain in the changelog how should a frozen task interact
> with ptrace? 0/6 says "ptrace works" but that is all. It is not clear to =
me
> what do we actually want wrt ptrace...

Sure, will add.
Basically, I want some minimal functionality to work properly.
E.g. attach to a frozen task, get some info, detach.
