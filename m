From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] selftests: memcg: uninitialized variable in
 test_memcg_reclaim()
Date: Wed, 20 Jul 2022 12:29:19 +0300
Message-ID: <20220720092918.GD2316@kadam>
References: <YtZ9Yu6HSQ2sT+O/@kili>
 <CAJD7tkYCSY1C_iif4dxF9O3dAgZV4u8o9DFGsqeTyaq_FTT+mQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=oK1oHKWTe+ZVhSt1gQCnST549v6XO4qsHJB62fdEhl4=;
 b=QBzLv0LkmgR1tKRtnnHBiGo60NNKyR9iRPamURknYzMm3tMGsv02qoKMzaFw0WAF4K+9
 84QFDn68qLHWU5PvoSzxsbvadEhcb26BkzEe8Ff0sKLCzlB5UekDurv6W7wOTf0J1zzd
 eNOYhNwhPZzKEJ2KK7p5kzrRaPFuyHJmtbPcXZUWH7nSyG4Jm6n0KcHQusqnjKslXzpv
 IHwarWwnot575eQmToQjOatVOl1XP7fbk7HpP4v8LpGd3qetHS2//z/00YLwr7FGdftU
 69YTiTBoohY5r3B/A0bpGuoMLHK1vvpRvRB9YKMUIM0ci1M3JSqy6DmTDjlr/Q/UhGrD SQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oK1oHKWTe+ZVhSt1gQCnST549v6XO4qsHJB62fdEhl4=;
 b=MXx0H8GQN/g7O5Y1EK273Z+POYafO7eobASxK6A85OC+S+8It0fEquoVrMpHhDmfi4IUjhy+H1nx7gxyk2skIIe3fwnbn5HGUu9zkI7EdCvrR1OkgcjJRWaE8zsDgwpJyOJZ0p6nJWV/uGvcrKCwoFNJI2Ngf/3pgTxZLc5l8ws=
Content-Disposition: inline
In-Reply-To: <CAJD7tkYCSY1C_iif4dxF9O3dAgZV4u8o9DFGsqeTyaq_FTT+mQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jul 19, 2022 at 10:27:36AM -0700, Yosry Ahmed wrote:
> 
> Nit: keep the cleanup_* naming for labels to make it obvious and to be
> consistent with the rest of the file (e.g. cleanup_free,
> cleanup_memcg, cleanup_file/cleanup_all). See
> test_memcg_subtree_control().
> 
> I would honestly have one label to cleanup the memcg. Calling
> cg_destroy() on a non-existent memcg should be fine. rmdir() will just
> fail silently. All other tests do this and it's easier to read when we
> have fewer return paths. My advice would be cleanup_file and
> cleanup_memcg labels.

One error label handling is very bug prone.  You always end up freeing
things which have not been initialized/allocated.  Or dereferencing
pointers which are NULL.  Or, since most kernel functions clean up
after themselves, you end up double freeing things.

regards,
dan carpenter
