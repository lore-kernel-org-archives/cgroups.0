From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: move a check to parse_cgroupfs_options()
Date: Fri, 23 Dec 2011 14:52:40 -0800
Message-ID: <CAOS58YMffJ4uH02H0TH_DmhtjQOVgz2_u_6HJqsGnR6PQ3ZGzw@mail.gmail.com>
References: <4EF2EDA7.4010004@cn.fujitsu.com>
	<20111222152011.GA17084@google.com>
	<4EF3F834.0@cn.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        bh=iiidpxczS9LXf8u5GufC4mCMrGerr2JidlLDLW5vhGM=;
        b=dlw463KIQKaAYFFD9/sx86rsFXIAoqDJHzozvxcEhiUbbXpn0rR4lWROHt44i7ktDb
         j+l+emKswrrZ575v4Z4DiwnV+e15/lk22aiPVUlbSnV8A2TQXdtgxpUdfBFiDvFV7ya4
         oy74/z/x8LUfLuzN9pT40w0Gg7EwrkjPbsoyg=
In-Reply-To: <4EF3F834.0-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Thu, Dec 22, 2011 at 7:40 PM, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org> wrote:
>> And where did this one go?
>
> The other one I removed sets opts->new_root to NULL, and this one det=
ects
> the NULL ptr:
>
> if (!opts->subsys_bits && !opts->none)
> =A0 =A0 =A0 =A0return NULL;
> ...
> opts->new_root =3D NULL;
> ...
> if (!opts->new_root)
> =A0 =A0 =A0 =A0return -EINVAL;
>
> shortcut to:
>
> if (!opts->subsys_bits && !opts->none)
> =A0 =A0 =A0 =A0return -EINVAL;

Thanks for the explanation. Maybe explaining it briefly in the commit
message would be nice?

--=20
tejun
