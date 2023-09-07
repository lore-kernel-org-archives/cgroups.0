From: Luiz Capitulino <luizcap-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATH v2] cgroup: add cgroup_favordynmods= command-line option
Date: Thu, 7 Sep 2023 11:16:41 -0400
Message-ID: <236f84be-26b0-758d-3d3f-380e536f72c2@amazon.com>
References: <20230906005712.66461-1-luizcap@amazon.com>
 <lqcl5cblo3s45afvtgqjkbz2an3zwccsckglhpe3ufyffqavjk@ui45m6itz4ne>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1694103549; x=1725639549;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YauVF01CGBBHBYehJqzxf4f2JW+5DIf+1r8++cg5PLM=;
  b=P3QAX8zLOfeNlSVYnBk8O4LKH1ZDrrYYpF7e5PWyUIqFknEMHKC+gYga
   X84diM7Dk2gbtoCGXb6REJd4vyV+MHnc34nVKwcSA65wAwYGeBDizqPML
   1Vcv/VNfXx/WGrSyHxxdk9memcIdxNSV4jeJi4m2QchDIFctqwQm09Pkz
   4=;
Content-Language: en-US
In-Reply-To: <lqcl5cblo3s45afvtgqjkbz2an3zwccsckglhpe3ufyffqavjk@ui45m6itz4ne>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lcapitulino-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org



On 2023-09-07 11:06, Michal Koutn=C3=BD wrote:
> On Wed, Sep 06, 2023 at 12:57:12AM +0000, Luiz Capitulino <luizcap-vV1Otc=
yAfmbQT0dZR+AlfA@public.gmane.org> wrote:
>> We have a need of using favordynmods with cgroup v1, which doesn't suppo=
rt
>> changing mount flags during remount. Enabling CONFIG_FAVOR_DYNMODS at
>> build-time is not an option because we want to be able to selectively
>> enable it for certain systems.
>=20
> Could this be implemented by a utility that would read /proc/cmdline
> (while kernel ignores the arg) and remount respective hierarchies
> accordingly? Or what do I miss?

Yeah, this works for cgroup v2 but my understanding is that cgroup v1
doesn't support changing flags in remount, take a look at
cgroup1_reconfigure().

- Luiz
