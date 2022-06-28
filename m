From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH cgroup] cgroup: set the correct return code if hierarchy
 limits are reached
Date: Tue, 28 Jun 2022 11:16:48 +0200
Message-ID: <20220628091648.GA12249@blackbody.suse.cz>
References: <186d5b5b-a082-3814-9963-bf57dfe08511@openvz.org>
 <d8a9e9c6-856e-1502-95ac-abf9700ff568@openvz.org>
 <YrpO9CUDt8hpUprr@castle>
 <17916824-ba97-68ba-8166-9402d5f4440c@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1656407810; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=23v656EJZgZ2B3RKrxYupmYVBHtGwcHmW+F/2IUSaFE=;
        b=O5kYOGNEuWcGqJsOSHgLzYULiCCU0PUt++61xI0DIuCuCUtRWjJEKfxOKzyFWoxdBB0XJu
        7NkDIhBZwwj1lpQ1NmhL/PBQ6RhDgr4rjeikGdfq+oJAVz76W6bNJMKoFaY6DHgUhwwfjV
        pANFO/pJwqXmHAQJ4E1yl2rFcInDtws=
Content-Disposition: inline
In-Reply-To: <17916824-ba97-68ba-8166-9402d5f4440c-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jun 28, 2022 at 06:59:06AM +0300, Vasily Averin <vvs-GEFAQzZX7r8dnm=
+yROfE0A@public.gmane.org> wrote:
> I would agree with you, however in my opinion EAGAIN is used to restart an
> interrupted system call. Thus, I worry its return can loop the user space=
 without
> any chance of continuation.
>=20
> However, maybe I'm confusing something?

The mkdir(2) manpage doesn't list EAGAIN at all. ENOSPC makes better
sense here. (And I suspect the dependency on this particular value won't
be very wide spread.)

0.02=E2=82=AC
Michal
