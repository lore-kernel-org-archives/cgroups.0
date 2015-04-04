From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] Documentation/memcg: update memcg/kmem status
Date: Sat, 4 Apr 2015 15:29:34 +0200
Message-ID: <20150404152934.2db95051@lwn.net>
References: <1427898636-4505-1-git-send-email-vdavydov@parallels.com>
	<20150401164431.1e88220a@lwn.net>
	<20150401151717.GE21839@esperanza>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20150401151717.GE21839@esperanza>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 1 Apr 2015 18:17:17 +0300
Vladimir Davydov <vdavydov@parallels.com> wrote:

> > So the text you've removed says not to select kmem support "unless fo=
r
> > development purposes."  Do we now believe that this feature is ready =
for
> > use in a production setting?  If the answer is "yes," I'd be happy to
> > take this through the docs tree. =20
>=20
> I added this warning because of the following issues, which made
> memcg/kmem useless:
>=20
>  - no reclaim support
>  - lack of memcg slab caches auto destruction
>  - several obvious races/bugs
>=20
> They are all fixed now, so I think the answer is yes, it can be used in
> production. There might be bugs that I am not aware of, of course, but
> It must be safe to compile it in anyway, because memcg/kmem accounting
> is disabled by default and must be enabled explicitly at runtime by
> writing to cgroup/memory.kmem.limit_in_bytes.

So I believe you, but I'm still a bit nervous about taking this one
because I can't really judge whether we should be advising people to turn
on this feature at this point or not.  A well-placed ack or two would
help there; otherwise, Andrew, if you think it makes sense, you can just
grab it :)

Thanks,

jon

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
