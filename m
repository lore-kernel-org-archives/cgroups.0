From: Luiz Capitulino <luizcap-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATH v2] cgroup: add cgroup_favordynmods= command-line option
Date: Tue, 19 Sep 2023 09:42:21 -0400
Message-ID: <55e64e7a-5783-94ce-a9fc-1979587c755f@amazon.com>
References: <20230906005712.66461-1-luizcap@amazon.com>
 <29bdb453-c6e3-a047-1f27-e9656da92301@amazon.com>
 <ZQiNIWQe7spOwjil@slm.duckdns.org>
 <7zv7lqkondaacjhmc7oscyqzwugguxvjw2yhdhkv4axhhkts7a@upoxgl3qpunt>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1695130953; x=1726666953;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LIiuvlEVoOet9vLgXao/ZPcDivQLZo5gFmYPlTZNxJs=;
  b=GgttyW37o5FMspK0IG1bWyzuQaIH4OpVLD4XVpEUcp/NXWYuxxrcLoof
   GBMWJtt85jMfcmenYOKlGcLDhgz1+IUlG3mL7AnDLhxGYn2i2CMpV7Rgf
   O+2sJOG/BAO50oA6ca+EOxRkFpvqOe3K6H0CFVsZztaH5BgqLO8Jg8iGf
   Y=;
Content-Language: en-US
In-Reply-To: <7zv7lqkondaacjhmc7oscyqzwugguxvjw2yhdhkv4axhhkts7a@upoxgl3qpunt>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lcapitulino-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org



On 2023-09-19 07:00, Michal Koutn=C3=BD wrote:
> On Mon, Sep 18, 2023 at 07:47:13AM -1000, Tejun Heo <tj-DgEjT+Ai2ygdnm+yR=
OfE0A@public.gmane.org> wrote:
>> Michal raised some valid concerns. I don't really mind that it's not gre=
at
>> on the edges tho. Michal, what do you think?
>=20
> I'd have a few suggestions:
> - reset to have_dynmods value instead of false in cgroup_destroy_root()
>    (to the benefing of the users of this option, not the common default
>    users) or not touch the value in cgroup_destroy_root() at all
> - s/CONFIG_FAVOR_DYNMODS/CONFIG_CGROUP_FAVOR_DYNMODS/ in commit message

Thank you for the detailed suggestions, Michal. I'll on this for v3.

- Luiz
