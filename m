From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [RESEND PATCH v2 09/12] mm: memcontrol: convert vmstat slab
 counters to bytes
Date: Mon, 7 Dec 2020 12:01:55 -0800
Message-ID: <20201207200155.GC2238414@carbon.dhcp.thefacebook.com>
References: <20201206101451.14706-1-songmuchun@bytedance.com>
 <20201206101451.14706-10-songmuchun@bytedance.com>
 <20201207194622.GA2238414@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=m+GbydYCsM+9Eqs+kHgUyqtbdjf9kuBWw0UOILhR8fc=;
 b=TEBJ3xKrcYDEr0oA3UehSzwxZwE7hNLl39NK47qcZTXBSjx2RtVKXAdONUccFnRinN1Y
 Ae+LqnRKwtRT5tSdCeYoBSeA30+rTONFofjKW9F8/cjQ/ymqhhcqbcaVL44+LJa1zqpK
 p00qN4XZR0jc5y+4xSKV8wMtbBFK3SDyqCc= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+GbydYCsM+9Eqs+kHgUyqtbdjf9kuBWw0UOILhR8fc=;
 b=KUkOVynAWJVo3RLc+0/MA3Q3fXoTMtT+BrhpJNlS/F75eo3MIytp1CZxJ2A9Ru0oJmyCunYgKVQ3vOo6wZjEDRqdZLYJBg33v0Y6ohiPIbO3CdlDrdthPzjVgw1UM7FPI4ZlFLkUD5svN6RS3UkN8fgESx0QiFlTJVdw0Ox7yQg=
Content-Disposition: inline
In-Reply-To: <20201207194622.GA2238414-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Dec 07, 2020 at 11:46:22AM -0800, Roman Gushchin wrote:
> On Sun, Dec 06, 2020 at 06:14:48PM +0800, Muchun Song wrote:
> > the global and per-node counters are stored in pages, however memcg
> > and lruvec counters are stored in bytes. This scheme looks weird.
> > So convert all vmstat slab counters to bytes.
> 
> There is a reason for this weird scheme:
> percpu caches (see struct per_cpu_nodestat) are s8, so counting in bytes
> will lead to overfills. Switching to s32 can lead to an increase in
> the cache thrashing, especially on small machines.

JFYI:
I've tried to convert all slab counters to bytes and change those s8 percpu batches to s32
about a year ago. Here is a link to that thread:
https://patchwork.kernel.org/project/linux-mm/patch/20191018002820.307763-3-guro-b10kYP2dOMg@public.gmane.org/

Thanks!
