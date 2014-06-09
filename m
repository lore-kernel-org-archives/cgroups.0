From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: blkio write controls
Date: Mon, 9 Jun 2014 14:29:16 -0400
Message-ID: <20140609182916.GC31499@redhat.com>
References: <B937BB93-F803-4DA1-AC31-F98DC3C52766@linkedin.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <B937BB93-F803-4DA1-AC31-F98DC3C52766-mkn/cI4rzrdWk0Htik3J/w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Travis Thompson <tthompson-mkn/cI4rzrdWk0Htik3J/w@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Jun 05, 2014 at 09:31:52PM +0000, Travis Thompson wrote:
> Hello,
>=20
> I=E2=80=99m currently working on blkio integration for Hadoop YARN an=
d I was wondering what the status of write throttling is?  My understan=
ding right now is it doesn=E2=80=99t work because of buffered writes an=
d so the kernel doesn=E2=80=99t know where the io is coming from and do=
esn=E2=80=99t throttle it.
>=20

Hi Travis,

You are right. Throttling for buffered writes still does not work becau=
se
we have not tracked the original writer who dirtied the pages in page
cache.

Thanks
Vivek
