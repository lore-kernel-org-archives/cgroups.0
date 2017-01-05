From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: control groups and /proc/meminfo, /proc/cpuinfo etc
Date: Thu, 5 Jan 2017 16:25:58 +0100
Message-ID: <20170105152558.GA29811@dhcp22.suse.cz>
References: <4636e5b6-b769-c14a-75cb-909403803498@poczta.onet.pl>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4636e5b6-b769-c14a-75cb-909403803498-wo4oW1Pw1HF3vZ0LZ0W7Rg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: =?utf-8?Q?Micha=C5=82?= Zegan <webczat_200-wo4oW1Pw1HF3vZ0LZ0W7Rg@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 05-01-17 11:59:28, Micha=C5=82 Zegan wrote:
> Hello.
>=20
> Are there any plans to virtualize /proc/cpuinfo and /proc/meminfo and
> all other things? Don't cgroup namespaces give an opportunity to do that?

There are no plans AFAICT - at least for the meminfo part. There simply
is no 1:1 mapping between memcg and global counters.
--=20
Michal Hocko
SUSE Labs
