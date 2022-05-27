From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: Use separate work structs on css release path
Date: Fri, 27 May 2022 07:23:47 -1000
Message-ID: <YpEJI7OZDVnxHRA8@slm.duckdns.org>
References: <20220525151517.8430-1-mkoutny@suse.com>
 <20220525151517.8430-3-mkoutny@suse.com>
 <20220525161455.GA16134@blackbody.suse.cz>
 <Yo7KfEOz92kS2z5Y@blackbook>
 <Yo/DtjEU/kYr190u@slm.duckdns.org>
 <904ef8af-13a5-e566-b760-74519f70fa62@linaro.org>
 <20220527165429.GJ11007@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=QNE+C9LvKf6o9OSSRIZZjYit2ACDgKSqp0cFlqRQUkA=;
        b=Ap9vNO/0kaxbQr1Vg/t3oTPnDrIe/ot0ObxfFazJtuLCid5VwVrE5SN+hTNy+tSwlh
         ul2W/6ur/9+D2cmH4pQfcdPOw8HEIpFq+6DC8s0G0qhWQzL4IWY5BXkLuFhKe6BFmS3C
         1Ap0CoVjGi5NXLGh3v/eT1h7/XpIxwL0ZiqL76/aXV2e0YJzrCd6ZlONbhgUgLs24Sn0
         vIJjto9cAaMbshQVQ+HqQyGs14NGdfPMLR9RXRipGkmLbnSX7HSHNJDHDlw4e6h9rKYw
         KbQkyb8s0k8mza2dkWOjnSYImUcQkkZsIGLtmPwEl9NLbDo0AR403M8wAZgYCW4yLrwb
         OaHw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220527165429.GJ11007-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tadeusz Struk <tadeusz.struk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Bui Quang Minh <minhquangbui99-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Fri, May 27, 2022 at 06:54:29PM +0200, Michal Koutn=FD wrote:
> Hello Tadeusz.
>=20
> On Fri, May 27, 2022 at 09:39:20AM -0700, Tadeusz Struk <tadeusz.struk-QS=
Ej5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> > As far as I can see we are trying to test the same thing suggested by T=
ejun.
> > I just sent a test request to try this:
> > https://github.com/tstruk/linux/commit/master
>=20
> Yup, I've added few more prints to get more fine-grained resolution.
> Also, I decided to use ftrace printk not to interfere with timing too
> much (due to the original race hypothesis).
>=20
> > Let me know if you have any more tests to run and I will hold off until
> > you are done.
>=20
> My latest attempt is [1] (tip 5500e05d82fd5b5db2203eedb3f786857d3ccbea).
>=20
> So far, I'm not convinced, I extract the complete ftrace buffer from the
> syzbot runs, so I'm not drawing any conclusions from the traces I've
> got. I'm not going to continue today. You may have more luck with your
> plain printk (if it's just imbalance and it avoids printk locking
> sensitive paths).

At least for triaging, it may be easier to use bpftrace to attach kprobes to
the get/put functions with the right filter and record the kstack counts.

Thanks.

--=20
tejun
