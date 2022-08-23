From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] cgroup: simplify cleanup in cgroup_css_set_fork()
Date: Tue, 23 Aug 2022 13:09:31 +0200
Message-ID: <20220823110931.GB1729@blackbody.suse.cz>
References: <20220823091147.846082-1-brauner@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661252973; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2XVveNc1dHKejESI2gGQJL+VnYAV4gj0L8ylbdECtpU=;
        b=FCeUQ724pTy5Ea3UaRF/6QIFB0gNQebplremp8YmoiQtbvkk3JFJpQTyZb4IDGzAmfzwYd
        glZ2/gyZ3iKvIwVJo0Wv4J2X8FqP6meHgI24VemtlvrP33XuPt/xJ+kWyynTYgAmgeJ80l
        AGmLH6z/HDaiEiVa8h7eN0q8URQU40U=
Content-Disposition: inline
In-Reply-To: <20220823091147.846082-1-brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>

Hello.

On Tue, Aug 23, 2022 at 11:11:47AM +0200, Christian Brauner <brauner-DgEjT+=
Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>  kernel/cgroup/cgroup.c | 2 --
>  1 file changed, 2 deletions(-)

Sensible cleanup,
Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
