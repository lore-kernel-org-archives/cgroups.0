From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: minor optimization around the usage of
 cur_tasks_head
Date: Wed, 26 Jan 2022 06:47:11 -1000
Message-ID: <YfF7DwvzzTxY+2Io@slm.duckdns.org>
References: <20220126141705.6497-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=7tjkVWkeJikq0MYiRHHkM9K0li9PU6oyj23BwxkVz/4=;
        b=L6uQCEsWfha23cY9vLp5bDKfNpb0ng8apf1wuq0/YmnUr11q04UbSGTzyeyoJUVejD
         zvk/aAn6lhfj0MHMQ4Aby1rlHO7LC4ODl6PeH9SVGtxLw2z3VVA+7j9hYiE3X1bpCSml
         6HmwFidqgQBnqsbmRFqxuXFTqgiaOMUso5OtBqA1iICkeHQScbO7c6WOY8Qnk6FHG3cQ
         jfpqL7P+opQXXJs00VuIC5KzbfFknG6knrHs1tP6iG/1gUm10CwaKAJAmlJexXXqTGaF
         7na+gzbI40WGd0AieBd269viVnWp6arPOG6lnrL4vtrJ6woPhRwkE2igLLm7TuYV9Y1a
         g9aQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220126141705.6497-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On Wed, Jan 26, 2022 at 02:17:05PM +0000, Yafang Shao wrote:
> Recently there was an issue occurred on our production envrionment with a
> very old kernel version 4.19. That issue can be fixed by upstream
> commit 9c974c772464 ("cgroup: Iterate tasks that did not finish do_exit()=
")
>=20
> When I was trying to fix that issue on our production environment, I found
> we can create a hotfix with a simplified version of the commit -
>=20
> As the usage of cur_tasks_head is within the function
> css_task_iter_advance(), we can make it as a local variable. That could
> make it more clear and easier to understand. Another benefit is we don't
> need to carry it in css_task_iter.
>=20
> Signed-off-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gman=
e.org>
> Cc: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

I can't tell whether this is better or not. Sure, it loses one pointer from
the struct but that doesn't really gain anything practical. On the other
hand, before, we could understand where the iteration was by just dumping
the struct. After, we can't. At best, maybe this change is a wash.

Thanks.

--=20
tejun
