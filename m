From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH] memcontrol: drop duplicate word and fix spello in
 <linux/memcontrol.h>
Date: Sat, 18 Jul 2020 09:16:51 +0200
Message-ID: <20200718071651.GA467892@chrisdown.name>
References: <b04aa2e4-7c95-12f0-599d-43d07fb28134@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xHVnQvxmbGU9Ko0uL8p4tnJQ0J1CLCT6xz7M4Ccg8MQ=;
        b=oKdcHxt3cYiLH9F6JeaENxb3L0suuIESYrWnz4LMdoxe18XhXLj8d43wOtim0uIAme
         zPJVkdIlbZiiY72xPKODgFXZOO4UxfjZJ2SUbMkjOAAS6ptdt4+ntKvReVn4Z2SDdm2B
         3yVGvFT9fXvAbYkt5QRFUB2AstxiC87gcclw4=
Content-Disposition: inline
In-Reply-To: <b04aa2e4-7c95-12f0-599d-43d07fb28134-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Randy Dunlap writes:
>From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>
>Drop the doubled word "for" in a comment.
>Fix spello of "incremented".
>
>Signed-off-by: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
>Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Acked-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
