From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: remove the superfluous judgment
Date: Thu, 19 May 2022 14:33:53 +0200
Message-ID: <20220519123353.GF16096@blackbody.suse.cz>
References: <20220518013647.1749568-1-zhangshida@kylinos.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652963635; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DUkWJZld5VluRI22uW9l8XCJNukHzEbwh8pHQV1m64o=;
        b=ilFTuOmSs8usXtJOYAHg0dTo3pKq3irYc+DYgWtk7Ec18he1Qz+Vf2mp8P9oJTyqCCQA4V
        0Q4FGLqAVvemfhBkAC9PgK4oH/uN/S+Y7ML4mQQZyiy6t10biz5l55zL6atKB/Fk4m7O5X
        uZ35ZbFFrxrV4Asfjf6W4T6pVw3I8Lo=
Content-Disposition: inline
In-Reply-To: <20220518013647.1749568-1-zhangshida-UOlijcLmZ/InDS1+zs4M5A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Shida Zhang <starzhangzsd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, zhangshida-UOlijcLmZ/InDS1+zs4M5A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, May 18, 2022 at 09:36:47AM +0800, Shida Zhang <starzhangzsd-Re5JQEe=
Qqe8AvxtiuMwx3w@public.gmane.org> wrote:
>  kernel/cgroup/cgroup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

(Note to self, css_clear_dir() on root cgroup is not needed thanks to
kernfs_destroy_root()->kernfs_remove().)
