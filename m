From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] selftests: memcg: uninitialized variable in test_memcg_reclaim()
Date: Wed, 20 Jul 2022 10:35:29 -0700
Message-ID: <CAJD7tkYV60TkgfL2NF2HspJ_j+MB4CuqKNzugrAZ9jtfhicmog@mail.gmail.com>
References: <YtZ9Yu6HSQ2sT+O/@kili> <CAJD7tkYCSY1C_iif4dxF9O3dAgZV4u8o9DFGsqeTyaq_FTT+mQ@mail.gmail.com>
 <20220720092918.GD2316@kadam>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=02lsKOmjymw0+voRSiZssITm3QnQDwCZm++EAm96eVk=;
        b=AXz4zLK1VM061H4lcJHGjYLvRNfx+YUTCIfw8oq3KgqGXfJomypHgHt+ZjUVjSpkw7
         ygfdWOTJN6EKqQPYnyG97Yc9pSYo4apVrs685dRj2Lis1r313+yLrAE4zAnyES49TN3Q
         lNcDBCtRLJFxz8TyiWl0yMv1RoxKjDusQIC6P579ng+zMKgK2gaZPeAdN3puFuuwlnS7
         HKHcJLtVxhvMvaIqoeeHrzwsR8KA6ih1ZB56OPQc98CikP+vqXQgFD/VuEH63RuvK/sa
         8WBl+IeOZ4d3hEpU00LbcHvGxvYwKYjFAuzwqdsEXJFfTblyeJv0cGW13ou6DV33hOXv
         Sw4g==
In-Reply-To: <20220720092918.GD2316@kadam>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jul 20, 2022 at 2:29 AM Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Tue, Jul 19, 2022 at 10:27:36AM -0700, Yosry Ahmed wrote:
> >
> > Nit: keep the cleanup_* naming for labels to make it obvious and to be
> > consistent with the rest of the file (e.g. cleanup_free,
> > cleanup_memcg, cleanup_file/cleanup_all). See
> > test_memcg_subtree_control().
> >
> > I would honestly have one label to cleanup the memcg. Calling
> > cg_destroy() on a non-existent memcg should be fine. rmdir() will just
> > fail silently. All other tests do this and it's easier to read when we
> > have fewer return paths. My advice would be cleanup_file and
> > cleanup_memcg labels.
>
> One error label handling is very bug prone.  You always end up freeing
> things which have not been initialized/allocated.  Or dereferencing
> pointers which are NULL.  Or, since most kernel functions clean up
> after themselves, you end up double freeing things.

I am not suggesting a single cleanup label, I said "one label to
cleanup the memcg", which is separate from cleaning up the file.
Basically just merging the destroy_memcg and free_memcg labels to be
consistent with other tests. I don't feel strongly about this anyway
:)

>
> regards,
> dan carpenter
