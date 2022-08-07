From: Jing-Ting Wu <jing-ting.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: Re: [Bug] race condition at rebind_subsystems()
Date: Sun, 7 Aug 2022 14:58:50 +0800
Message-ID: <d4f8e1c0dd0a323e5cd6c850083cb126f616bc78.camel@mediatek.com>
References: <1978e209e71905d89651e61abd07285912d412a1.camel@mediatek.com>
         <20220715115938.GA8646@blackbody.suse.cz>
         <YtGaP+e35DZYSQf0@slm.duckdns.org>
         <d8f0bc5e2fb6ed259f9334c83279b4c011283c41.camel@mediatek.com>
         <20220719133512.GD897@blackbody.suse.cz>
         <98d738ec5d7d32441f6e62278fff32201fd948de.camel@mediatek.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=M95TLiNkwsL0QeZAeys9UAP5FWDjNm0kDQVp7WcThws=;
        b=Flz3Q0i7aGu6lCgW8bJADz/8LXyU4dgAggJHbd18fbZAsbukKzOs25mm4c0RLAEQ9WfEGz59YC3roqCUqjl0XdhH0nRjnk9/cno5J8azRbDcrHlNhkrf6uDVyrQS+h8KMWvSo8t+p26YRhB/xShZTPQbEzutHGDAFsB18nRmwn0=;
In-Reply-To: <98d738ec5d7d32441f6e62278fff32201fd948de.camel-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Matthias Brugger <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, wsd_upstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, lixiong.liu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, wenju.xu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, jonathan.jmchen-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org

On Thu, 2022-07-21 at 14:46 +0800, Jing-Ting Wu wrote:
> On Tue, 2022-07-19 at 15:35 +0200, Michal Koutn=C3=BD wrote:
> > On Mon, Jul 18, 2022 at 03:44:21PM +0800, Jing-Ting Wu <
> > jing-ting.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org> wrote:
> > > Accroding your description, is the following patch corrent?
> >=20
> > Yes, this is what I meant (i.e. grace period before invalidating
> > the
> > removed rstat_css_node).
> >=20
> > > If the patch is correct, we will add this patch to our stability
> > > test.
> > > And we will continue to observe whether the problem is solved.
> >=20
> > It'd be great to have such confirmation.
>=20
> Thanks for confirm the patch.
> We already add patch to our stability test.
> We will reply mail if we have any update.
>=20
> >=20
> > Thanks,
> > Michal
>=20

Hi, Michal

Use the patch of previous mail, we pass the stability test at previous
two week and still testing.

I think the patch is helpful to the syndrome.
It passed stability test over two week so far. (as-is: < one week
failed)
Do you help to upstream this patch to mainline?

Thank you.


Best regards,
Jing-Ting Wu





>=20
> Best regards,
> Jing-Ting Wu

