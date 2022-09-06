From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2 cgroup/for-6.1] cgroup: Improve cftype add/rm error
 handling
Date: Tue, 6 Sep 2022 09:37:16 -1000
Message-ID: <YxehbNMr998iITHi@slm.duckdns.org>
References: <YxUUISLVLEIRBwEY@slm.duckdns.org>
 <20220905131435.GA1765@blackbody.suse.cz>
 <YxeCdHfk2nOUISDw@slm.duckdns.org>
 <20220906191112.GF30763@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date;
        bh=XJcSopcn6kgTqhrI+8/s9+7y1PjjuR0jL1WX7rSqHbk=;
        b=fTqAmgzRhEwcGwkE0UoFGilloqSV9UoPG09wyE7gsvAfrtF+KGwZme1wLJf7vcAFwq
         pdeZnMkgDyIN2YVg+xwRZ5j0O2ii9gLe/p/fyuPKxB8tmy9YI+phLxVrIQLr73PkM4R7
         LjjciXRzs3h9cLvAymNkHOXHBNIkyPvbo+jPIgOhvrIrsBsICuJgL9d/WLkCm7Li+eZq
         JxmNx/rGn79jjmWZwhu5wwlOcLLZh3LMB45d6JkDvCdgcuD8+Uncrok3HJDImZs+mTCB
         UINHhbrq203isIaXOcNHpLmXi74vg4UPOAdxAz+YJu3cLOGxswTfqOrWZHcE18DxrzEu
         BFxw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220906191112.GF30763-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

On Tue, Sep 06, 2022 at 09:11:12PM +0200, Michal Koutn=FD wrote:
> Before the return here, the function should revert the base files first (=
or
> silence the return value to 0 if such a partial population is acceptable).
>=20
> (Actually, it looks like the revert in the subsys branch is unnecessary as
> callers of css_populate_dir() would issue css_clear_dir() upon failure
> eventually.)

Yeah, so, the contract there is a bit unusual in that on failure the helpers
don't need to cleanup after themselves as they'll get cleaned up together by
the caller when it nukes the cgroup which was being created. While a bit
unusual, it's simpler / safer this way, so...

Thanks.

--=20
tejun
