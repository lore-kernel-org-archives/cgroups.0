From: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH 01/40] lib/string_helpers: Drop space in
 string_get_size's output
Date: Mon, 1 May 2023 11:13:15 -0700
Message-ID: <ouuidemyregstrijempvhv357ggp4tgnv6cijhasnungsovokm@jkgvyuyw2fti>
References: <20230501165450.15352-1-surenb@google.com>
 <20230501165450.15352-2-surenb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
        s=dreamhost; t=1682966731;
        bh=cQvIokD2K+NzYNjjiFicwOdl/ld8t+K11AzJBztMv5w=;
        h=Date:From:To:Cc:Subject:Content-Type;
        b=M4zg8dWD7JrhTAPu66mAaTSowPpbRrHZy5vX69tq81nfwkxu5ABcZTvdEitOi/pao
         /F7Zvy8qWg1uHLSHLIy71BfECCRDVEwVkTwGKV4enAwitbWyAX7zQqIxmgy5Ekd/3X
         eBwxyFJiNCc7dhGh2bz9gA9ZTYm8wnwYJYcxvjmWmZlG9vFDjd6eLcRSIDYUNogSq+
         oVjfYOIiAkLFcvJXiR+WaIO0m3OLgmSHgWG9uIJmSrQfiv/1IAVWlVBaPb3a4MC4bW
         0zy1Hp6lJ5g/95zoBLuM69MBh/dir7fkKAaiZvBE5LBTcfUuT5xk1lKoWeUIQ/grrx
         vT+3O4+ucwzGA==
Content-Disposition: inline
In-Reply-To: <20230501165450.15352-2-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, keescook@chrom

On Mon, 01 May 2023, Suren Baghdasaryan wrote:

>From: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
>
>Previously, string_get_size() outputted a space between the number and
>the units, i.e.
>  9.88 MiB
>
>This changes it to
>  9.88MiB
>
>which allows it to be parsed correctly by the 'sort -h' command.

Wouldn't this break users that already parse it the current way?

Thanks,
Davidlohr
