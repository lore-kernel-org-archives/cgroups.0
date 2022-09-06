From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2 cgroup/for-6.1] cgroup: Improve cftype add/rm error
 handling
Date: Tue, 6 Sep 2022 07:25:08 -1000
Message-ID: <YxeCdHfk2nOUISDw@slm.duckdns.org>
References: <YxUUISLVLEIRBwEY@slm.duckdns.org>
 <20220905131435.GA1765@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date;
        bh=zWAJTTb4Ht+/f+u5PAb/NzBa3bogC53Qfzs/V7CfjcI=;
        b=LmO3p85rWzLbzcMnWUQIBLbyWng/AirZyu2ifyuGAiZqbua5cbbBQDvXkJ+A64GmI2
         yD1jU/IhJjT5pVfJPzVuqDr8wuxFsxFJnduvCqiZRSjlG2v8wdBeA4xBe93grksxbxg2
         dWzhwzKZHHI0DJ3pjOJbDXQRsAYx9ZU0KuJSe8X+1onNp+X2226cPiYRNAX49wY/f5MX
         lZSrIE/u+1N5XBDn2qF6ydjGeiz0dMyrPpI1qGDd06BbfO7Zbry9KJfBiYzu0I6QnMkM
         OIN1VqJT3OLEc+vamDl8qG4bvzDOC1zGa0rfoYoSGxVc1DpMiMmVSccGeey4fmO/thyk
         CTBQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220905131435.GA1765-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

On Mon, Sep 05, 2022 at 03:14:35PM +0200, Michal Koutn=FD wrote:
> IIUC, the flag is equal to (cft->ss || cft->kf_ops), particularly the
> information is carried in cfs->kf_ops too.

->ss will be NULL for core files even after added. ->kf_ops can be used
instead of the flag.

> Is the effect of cgroup_init_cftypes proper setup of cft->kf_ops?
> I.e. isn't it simpler to just check that field (without the new flag)?
>=20
> (No objection to current form, just asking whether I understand the
> impact.)

I prefer having it as a separate flag because it's explicit and can be
tested together with other flags. It's a weak preference tho and I can go
either way if it bothers you much.

Thanks.

--=20
tejun
